// KaamChalu - Send WhatsApp Edge Function
// Uses WhatsApp Business Cloud API

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

interface WhatsAppMessage {
    organization_id: string;
    to: string;
    template_name?: string;
    template_params?: string[];
    message?: string;
}

serve(async (req) => {
    try {
        const payload: WhatsAppMessage = await req.json();
        const { organization_id, to, template_name, template_params, message } = payload;

        if (!organization_id || !to) {
            return new Response(
                JSON.stringify({ error: "organization_id and to are required" }),
                { status: 400, headers: { "Content-Type": "application/json" } }
            );
        }

        // Initialize Supabase client with service role
        const supabase = createClient(
            Deno.env.get("SUPABASE_URL") ?? "",
            Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
        );

        // Get WhatsApp integration credentials
        const { data: integration, error: intError } = await supabase
            .from("integrations")
            .select("credentials_encrypted")
            .eq("organization_id", organization_id)
            .eq("type", "whatsapp")
            .eq("status", "active")
            .single();

        if (intError || !integration) {
            throw new Error("WhatsApp integration not found or not active");
        }

        // Decrypt credentials (in production, use proper decryption)
        // For now, assuming credentials are stored as JSON
        const credentials = JSON.parse(
            new TextDecoder().decode(integration.credentials_encrypted)
        );

        const { phone_number_id, access_token } = credentials;

        if (!phone_number_id || !access_token) {
            throw new Error("Invalid WhatsApp credentials");
        }

        // Format phone number (remove +, spaces, etc.)
        const formattedPhone = to.replace(/[^0-9]/g, "");

        // Build message payload
        let messagePayload: any;

        if (template_name) {
            // Template message
            messagePayload = {
                messaging_product: "whatsapp",
                to: formattedPhone,
                type: "template",
                template: {
                    name: template_name,
                    language: { code: "en" },
                    components: template_params
                        ? [
                            {
                                type: "body",
                                parameters: template_params.map((p) => ({
                                    type: "text",
                                    text: p,
                                })),
                            },
                        ]
                        : [],
                },
            };
        } else if (message) {
            // Text message
            messagePayload = {
                messaging_product: "whatsapp",
                to: formattedPhone,
                type: "text",
                text: { body: message },
            };
        } else {
            throw new Error("Either template_name or message is required");
        }

        // Send via WhatsApp Business API
        const response = await fetch(
            `https://graph.facebook.com/v17.0/${phone_number_id}/messages`,
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${access_token}`,
                },
                body: JSON.stringify(messagePayload),
            }
        );

        const result = await response.json();

        if (!response.ok) {
            throw new Error(
                `WhatsApp API error: ${result.error?.message || "Unknown error"}`
            );
        }

        // Update last_used_at
        await supabase
            .from("integrations")
            .update({ last_used_at: new Date().toISOString() })
            .eq("organization_id", organization_id)
            .eq("type", "whatsapp");

        return new Response(
            JSON.stringify({
                success: true,
                message_id: result.messages?.[0]?.id,
            }),
            { status: 200, headers: { "Content-Type": "application/json" } }
        );
    } catch (error) {
        console.error("WhatsApp send error:", error);
        return new Response(
            JSON.stringify({ success: false, error: error.message }),
            { status: 500, headers: { "Content-Type": "application/json" } }
        );
    }
});
