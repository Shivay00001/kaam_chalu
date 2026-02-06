// KaamChalu - Execute Workflow Edge Function
// Handles workflow execution with retry logic and failure handling

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const MAX_RETRIES = 2;
const RETRY_DELAY_MS = 30000;

interface WorkflowRun {
  id: string;
  workflow_id: string;
  status: string;
  attempt_count: number;
}

interface Workflow {
  id: string;
  organization_id: string;
  template_id: string;
  config: Record<string, any>;
}

interface WorkflowStep {
  id: string;
  step_order: number;
  action_type: string;
  action_config: Record<string, any>;
}

serve(async (req) => {
  try {
    const { run_id } = await req.json();

    if (!run_id) {
      return new Response(
        JSON.stringify({ error: "run_id is required" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Initialize Supabase client with service role
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Get the run
    const { data: run, error: runError } = await supabase
      .from("workflow_runs")
      .select("*")
      .eq("id", run_id)
      .single();

    if (runError || !run) {
      throw new Error(`Run not found: ${runError?.message}`);
    }

    // Get the workflow
    const { data: workflow, error: workflowError } = await supabase
      .from("workflows")
      .select("*")
      .eq("id", run.workflow_id)
      .single();

    if (workflowError || !workflow) {
      throw new Error(`Workflow not found: ${workflowError?.message}`);
    }

    // Check organization billing status
    const { data: org, error: orgError } = await supabase
      .from("organizations")
      .select("billing_plan, billing_status")
      .eq("id", workflow.organization_id)
      .single();

    if (orgError || !org) {
      throw new Error(`Organization not found: ${orgError?.message}`);
    }

    if (org.billing_plan === "free" || org.billing_status !== "active") {
      await updateRunStatus(supabase, run_id, "failed", "Billing not active. Please upgrade to Pro or Business plan.");
      return new Response(
        JSON.stringify({ success: false, error: "Billing not active" }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    }

    // Update run to running
    await updateRunStatus(supabase, run_id, "running");

    // Log start
    await logMessage(supabase, run_id, null, "info", `Starting workflow: ${workflow.template_id}`);

    // Get workflow steps
    const { data: steps, error: stepsError } = await supabase
      .from("workflow_steps")
      .select("*")
      .eq("workflow_id", workflow.id)
      .order("step_order", { ascending: true });

    if (stepsError) {
      throw new Error(`Failed to get steps: ${stepsError.message}`);
    }

    // Execute each step
    for (const step of steps || []) {
      try {
        // Check if step has a conditional
        if (step.action_config?.conditional) {
          const conditionKey = step.action_config.conditional;
          if (!workflow.config[conditionKey]) {
            await logMessage(supabase, run_id, step.id, "info", `Skipping step ${step.step_order}: ${conditionKey} is disabled`);
            continue;
          }
        }

        await logMessage(supabase, run_id, step.id, "info", `Executing step ${step.step_order}: ${step.action_type}`);

        // Execute the action
        await executeAction(supabase, workflow, step);

        await logMessage(supabase, run_id, step.id, "info", `Step ${step.step_order} completed ✅`);

      } catch (stepError) {
        await logMessage(supabase, run_id, step.id, "error", `Step ${step.step_order} failed: ${stepError.message}`);
        throw stepError;
      }
    }

    // Mark as success
    await updateRunStatus(supabase, run_id, "success");
    await logMessage(supabase, run_id, null, "info", "Workflow completed successfully ✅");

    // Update workflow last_run_at
    await supabase
      .from("workflows")
      .update({ last_run_at: new Date().toISOString() })
      .eq("id", workflow.id);

    return new Response(
      JSON.stringify({ success: true }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );

  } catch (error) {
    console.error("Workflow execution error:", error);

    // Handle retry logic
    try {
      const { run_id } = await req.json();
      const supabase = createClient(
        Deno.env.get("SUPABASE_URL") ?? "",
        Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
      );

      const { data: run } = await supabase
        .from("workflow_runs")
        .select("attempt_count")
        .eq("id", run_id)
        .single();

      if (run && run.attempt_count < MAX_RETRIES) {
        // Schedule retry
        await supabase
          .from("workflow_runs")
          .update({ 
            attempt_count: run.attempt_count + 1,
            status: "pending"
          })
          .eq("id", run_id);

        await logMessage(supabase, run_id, null, "warn", `Retrying... Attempt ${run.attempt_count + 1} of ${MAX_RETRIES}`);
      } else {
        await updateRunStatus(supabase, run_id, "failed", error.message);
        await logMessage(supabase, run_id, null, "error", `Workflow failed after ${MAX_RETRIES} attempts: ${error.message}`);
      }
    } catch (_) {
      // Ignore cleanup errors
    }

    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});

async function updateRunStatus(
  supabase: any,
  runId: string,
  status: string,
  errorMessage?: string
) {
  const update: Record<string, any> = { status };
  if (status === "success" || status === "failed") {
    update.completed_at = new Date().toISOString();
  }
  if (errorMessage) {
    update.error_message = errorMessage;
  }

  await supabase
    .from("workflow_runs")
    .update(update)
    .eq("id", runId);
}

async function logMessage(
  supabase: any,
  runId: string,
  stepId: string | null,
  level: string,
  message: string
) {
  await supabase.from("workflow_logs").insert({
    run_id: runId,
    step_id: stepId,
    level,
    message,
    created_at: new Date().toISOString(),
  });
}

async function executeAction(
  supabase: any,
  workflow: Workflow,
  step: WorkflowStep
) {
  const { action_type, action_config } = step;

  switch (action_type) {
    case "fetch_sheet_data":
      // TODO: Implement Google Sheets fetch
      console.log("Fetching sheet data...");
      break;

    case "send_whatsapp":
      // TODO: Implement WhatsApp send
      console.log("Sending WhatsApp message...");
      break;

    case "send_email":
      // TODO: Implement email send
      console.log("Sending email...");
      break;

    case "generate_pdf":
      // TODO: Implement PDF generation
      console.log("Generating PDF...");
      break;

    case "calculate_summary":
    case "calculate_counts":
    case "calculate_comparison":
      // TODO: Implement calculations
      console.log("Calculating...");
      break;

    case "remove_duplicates":
    case "format_phones":
    case "update_sheet":
      // TODO: Implement data cleanup actions
      console.log("Processing data...");
      break;

    case "send_reminders":
    case "notify_owner":
    case "send_daily_summary":
      // TODO: Implement notification actions
      console.log("Sending notifications...");
      break;

    default:
      console.log(`Unknown action: ${action_type}`);
  }

  // Simulate action execution
  await new Promise((resolve) => setTimeout(resolve, 500));
}
