// KaamChalu - Google Sheets Sync Edge Function
// Fetches and updates data from Google Sheets

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

interface SheetPayload {
    organization_id: string;
    action: "read" | "write" | "append" | "cleanup";
    sheet_url: string;
    range?: string;
    data?: any[][];
    cleanup_options?: {
        remove_duplicates?: boolean;
        fix_phone_format?: boolean;
    };
}

serve(async (req) => {
    try {
        const payload: SheetPayload = await req.json();
        const { organization_id, action, sheet_url, range, data, cleanup_options } =
            payload;

        if (!organization_id || !action || !sheet_url) {
            return new Response(
                JSON.stringify({
                    error: "organization_id, action, and sheet_url are required",
                }),
                { status: 400, headers: { "Content-Type": "application/json" } }
            );
        }

        // Initialize Supabase client with service role
        const supabase = createClient(
            Deno.env.get("SUPABASE_URL") ?? "",
            Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
        );

        // Get Google Sheets integration credentials
        const { data: integration, error: intError } = await supabase
            .from("integrations")
            .select("credentials_encrypted")
            .eq("organization_id", organization_id)
            .eq("type", "google_sheets")
            .eq("status", "active")
            .single();

        if (intError || !integration) {
            throw new Error("Google Sheets integration not found or not active");
        }

        // Parse service account credentials
        const serviceAccount = JSON.parse(
            new TextDecoder().decode(integration.credentials_encrypted)
        );

        // Extract sheet ID from URL
        const sheetIdMatch = sheet_url.match(/\/d\/([a-zA-Z0-9-_]+)/);
        if (!sheetIdMatch) {
            throw new Error("Invalid Google Sheet URL");
        }
        const sheetId = sheetIdMatch[1];

        // Get access token using service account
        const accessToken = await getAccessToken(serviceAccount);

        let result: any;

        switch (action) {
            case "read":
                result = await readSheet(accessToken, sheetId, range || "A:Z");
                break;

            case "write":
                if (!data) throw new Error("data is required for write action");
                result = await writeSheet(
                    accessToken,
                    sheetId,
                    range || "A1",
                    data
                );
                break;

            case "append":
                if (!data) throw new Error("data is required for append action");
                result = await appendSheet(accessToken, sheetId, range || "A:Z", data);
                break;

            case "cleanup":
                result = await cleanupSheet(
                    accessToken,
                    sheetId,
                    range || "A:Z",
                    cleanup_options
                );
                break;

            default:
                throw new Error(`Unknown action: ${action}`);
        }

        // Update last_used_at
        await supabase
            .from("integrations")
            .update({ last_used_at: new Date().toISOString() })
            .eq("organization_id", organization_id)
            .eq("type", "google_sheets");

        return new Response(
            JSON.stringify({ success: true, result }),
            { status: 200, headers: { "Content-Type": "application/json" } }
        );
    } catch (error) {
        console.error("Sheets sync error:", error);
        return new Response(
            JSON.stringify({ success: false, error: error.message }),
            { status: 500, headers: { "Content-Type": "application/json" } }
        );
    }
});

async function getAccessToken(serviceAccount: any): Promise<string> {
    // Create JWT for Google OAuth
    const now = Math.floor(Date.now() / 1000);
    const header = { alg: "RS256", typ: "JWT" };
    const payload = {
        iss: serviceAccount.client_email,
        scope: "https://www.googleapis.com/auth/spreadsheets",
        aud: "https://oauth2.googleapis.com/token",
        iat: now,
        exp: now + 3600,
    };

    // Note: In production, implement proper JWT signing with RS256
    // For now, this is a placeholder
    const jwt = btoa(JSON.stringify(header)) + "." + btoa(JSON.stringify(payload));

    const response = await fetch("https://oauth2.googleapis.com/token", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
            grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
            assertion: jwt + "." + "signature_placeholder",
        }),
    });

    const data = await response.json();
    return data.access_token || "";
}

async function readSheet(
    accessToken: string,
    sheetId: string,
    range: string
): Promise<any[][]> {
    const response = await fetch(
        `https://sheets.googleapis.com/v4/spreadsheets/${sheetId}/values/${encodeURIComponent(
            range
        )}`,
        {
            headers: { Authorization: `Bearer ${accessToken}` },
        }
    );

    const data = await response.json();
    return data.values || [];
}

async function writeSheet(
    accessToken: string,
    sheetId: string,
    range: string,
    values: any[][]
): Promise<any> {
    const response = await fetch(
        `https://sheets.googleapis.com/v4/spreadsheets/${sheetId}/values/${encodeURIComponent(
            range
        )}?valueInputOption=USER_ENTERED`,
        {
            method: "PUT",
            headers: {
                Authorization: `Bearer ${accessToken}`,
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ values }),
        }
    );

    return response.json();
}

async function appendSheet(
    accessToken: string,
    sheetId: string,
    range: string,
    values: any[][]
): Promise<any> {
    const response = await fetch(
        `https://sheets.googleapis.com/v4/spreadsheets/${sheetId}/values/${encodeURIComponent(
            range
        )}:append?valueInputOption=USER_ENTERED`,
        {
            method: "POST",
            headers: {
                Authorization: `Bearer ${accessToken}`,
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ values }),
        }
    );

    return response.json();
}

async function cleanupSheet(
    accessToken: string,
    sheetId: string,
    range: string,
    options?: { remove_duplicates?: boolean; fix_phone_format?: boolean }
): Promise<any> {
    // Read current data
    const data = await readSheet(accessToken, sheetId, range);

    if (data.length === 0) {
        return { rows_processed: 0 };
    }

    let processedData = [...data];
    let removedDuplicates = 0;
    let fixedPhones = 0;

    // Remove duplicates (based on all columns)
    if (options?.remove_duplicates) {
        const seen = new Set<string>();
        processedData = processedData.filter((row) => {
            const key = JSON.stringify(row);
            if (seen.has(key)) {
                removedDuplicates++;
                return false;
            }
            seen.add(key);
            return true;
        });
    }

    // Fix phone format (assumes phone is in first column that looks like a phone)
    if (options?.fix_phone_format) {
        processedData = processedData.map((row) => {
            return row.map((cell) => {
                if (typeof cell === "string" && /^[\d\s\-\+\(\)]{10,}$/.test(cell)) {
                    // Format as 10-digit Indian number
                    const digits = cell.replace(/\D/g, "");
                    if (digits.length === 10) {
                        fixedPhones++;
                        return `+91${digits}`;
                    } else if (digits.length === 12 && digits.startsWith("91")) {
                        fixedPhones++;
                        return `+${digits}`;
                    }
                }
                return cell;
            });
        });
    }

    // Write cleaned data back
    if (removedDuplicates > 0 || fixedPhones > 0) {
        await writeSheet(accessToken, sheetId, range, processedData);
    }

    return {
        rows_processed: data.length,
        duplicates_removed: removedDuplicates,
        phones_fixed: fixedPhones,
    };
}
