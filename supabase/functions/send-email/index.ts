// KaamChalu - Send Email Edge Function
// Uses SMTP for email delivery

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { SMTPClient } from "https://deno.land/x/denomailer@1.6.0/mod.ts";

interface EmailPayload {
    organization_id: string;
    to: string | string[];
    subject: string;
    body: string;
    html?: boolean;
    attachments?: Array<{
        filename: string;
        content: string; // Base64 encoded
        contentType: string;
    }>;
}

serve(async (req) => {
    try {
        const payload: EmailPayload = await req.json();
        const { organization_id, to, subject, body, html, attachments } = payload;

        if (!organization_id || !to || !subject || !body) {
            return new Response(
                JSON.stringify({
                    error: "organization_id, to, subject, and body are required",
                }),
                { status: 400, headers: { "Content-Type": "application/json" } }
            );
        }

        // Initialize Supabase client with service role
        const supabase = createClient(
            Deno.env.get("SUPABASE_URL") ?? "",
            Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
        );

        // Get Email integration credentials
        const { data: integration, error: intError } = await supabase
            .from("integrations")
            .select("credentials_encrypted")
            .eq("organization_id", organization_id)
            .eq("type", "email")
            .eq("status", "active")
            .single();

        if (intError || !integration) {
            throw new Error("Email integration not found or not active");
        }

        // Decrypt credentials
        const credentials = JSON.parse(
            new TextDecoder().decode(integration.credentials_encrypted)
        );

        const { smtp_host, smtp_port, smtp_username, smtp_password } = credentials;

        if (!smtp_host || !smtp_port || !smtp_username || !smtp_password) {
            throw new Error("Invalid email credentials");
        }

        // Create SMTP client
        const client = new SMTPClient({
            connection: {
                hostname: smtp_host,
                port: parseInt(smtp_port),
                tls: true,
                auth: {
                    username: smtp_username,
                    password: smtp_password,
                },
            },
        });

        // Send email
        const recipients = Array.isArray(to) ? to : [to];

        await client.send({
            from: smtp_username,
            to: recipients,
            subject: subject,
            content: html ? undefined : body,
            html: html ? body : undefined,
            // Note: Attachments would need additional handling
        });

        await client.close();

        // Update last_used_at
        await supabase
            .from("integrations")
            .update({ last_used_at: new Date().toISOString() })
            .eq("organization_id", organization_id)
            .eq("type", "email");

        return new Response(
            JSON.stringify({ success: true, recipients: recipients.length }),
            { status: 200, headers: { "Content-Type": "application/json" } }
        );
    } catch (error) {
        console.error("Email send error:", error);
        return new Response(
            JSON.stringify({ success: false, error: error.message }),
            { status: 500, headers: { "Content-Type": "application/json" } }
        );
    }
});
