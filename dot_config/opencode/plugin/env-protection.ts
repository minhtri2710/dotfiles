/**
 * Enhanced Protection Plugin
 *
 * Provides security controls and unified audit logging for OpenCode operations:
 * - Prevents reading sensitive files (.env, secrets, SSH keys, credentials)
 * - Warns on large file operations
 * - Blocks dangerous bash commands
 * - Unified JSONL audit logging for all tool executions
 */
import { appendFile, mkdir } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";

interface PluginContext {
    client: unknown;
    $: unknown;
}

interface ToolInput {
    tool: string;
    args?: {
        filePath?: string;
        content?: string;
        command?: string;
    };
}

interface ToolResult {
    error?: string;
    duration?: number;
}

interface AuditEntry {
    timestamp: string;
    tool?: string;
    args?: Record<string, unknown>;
    success?: boolean;
    error?: string | null;
    duration_ms?: number | null;
    cwd?: string;
    event?: string;
}

export const EnvProtection = async (_ctx: PluginContext) => {
    const configDir = join(homedir(), ".config", "opencode");
    const auditLog = join(configDir, "audit.jsonl");

    // Ensure log directory exists
    await mkdir(configDir, { recursive: true });

    /**
     * Sanitize sensitive data from args for logging
     */
    const sanitizeArgs = (args?: Record<string, unknown>): Record<string, unknown> | undefined => {
        if (!args) return args;

        const sanitized = { ...args };

        // Truncate large content
        if (typeof sanitized.content === "string" && sanitized.content.length > 1000) {
            sanitized.content = `<truncated ${sanitized.content.length} chars>`;
        }

        // Sanitize file paths containing secrets
        if (
            typeof sanitized.filePath === "string" &&
            (sanitized.filePath.includes(".env") ||
                sanitized.filePath.includes("secret") ||
                sanitized.filePath.includes("password") ||
                sanitized.filePath.includes(".ssh") ||
                sanitized.filePath.includes(".aws"))
        ) {
            sanitized.filePath = "<sensitive path>";
        }

        // Mark commands containing sensitive patterns
        if (typeof sanitized.command === "string") {
            if (sanitized.command.match(/password|token|secret|key|credential/i)) {
                sanitized.command_contains_secrets = true;
            }
        }

        return sanitized;
    };

    /**
     * Append entry to JSONL audit log
     */
    const log = async (entry: AuditEntry): Promise<void> => {
        const jsonLine = JSON.stringify(entry) + "\n";
        await appendFile(auditLog, jsonLine, "utf-8");
    };

    return {
        /**
         * Before tool execution - validation and blocking
         */
        "tool.execute.before": async (input: ToolInput, _output: unknown) => {
            // Block reading sensitive files
            if (input.tool === "read" || input.tool === "edit") {
                const filePath = input.args?.filePath || "";

                // .env files
                if (filePath.includes(".env")) {
                    throw new Error("🔒 Security: Do not read .env files");
                }

                // Secret/credential files by name
                if (filePath.match(/\/(secret|password|credential|token|key)\./i)) {
                    throw new Error("🔒 Security: Access to sensitive files is blocked");
                }

                // SSH keys and config
                if (filePath.match(/\/\.ssh\/(id_|known_hosts|authorized_keys|config)/)) {
                    throw new Error("🔒 Security: Access to SSH keys/config is blocked");
                }

                // Certificate and key files
                if (filePath.match(/\.(pem|p12|pfx|key|crt|cer)$/i)) {
                    throw new Error("🔒 Security: Access to certificate/key files is blocked");
                }

                // AWS credentials
                if (filePath.match(/\/\.aws\/(credentials|config)/)) {
                    throw new Error("🔒 Security: Access to AWS credentials is blocked");
                }

                // GCP/Azure credentials
                if (filePath.match(/application_default_credentials\.json|\.azure\/credentials/)) {
                    throw new Error("🔒 Security: Access to cloud credentials is blocked");
                }
            }

            // Warn on large write operations
            if (input.tool === "write") {
                const content = input.args?.content || "";
                if (content.length > 100000) {
                    console.warn("⚠️  Warning: Writing large file (>100KB)");
                }
            }

            // Block dangerous bash commands
            if (input.tool === "bash") {
                const command = input.args?.command || "";
                const dangerousPatterns = [
                    /rm\s+-rf\s+\//, // rm -rf /
                    /rm\s+-rf\s+~/, // rm -rf ~
                    /:\(\)\{\s*:\|:&\s*\};:/, // fork bomb
                    /chmod\s+777/, // overly permissive
                    /curl.*\|\s*(ba)?sh/, // pipe to bash/sh
                    /wget.*\|\s*(ba)?sh/, // pipe to bash/sh
                    /eval\s*\(/, // eval execution
                    />\s*\/dev\/sd[a-z]/, // disk write
                    /dd\s+.*of=\/dev\//, // dd disk overwrite
                    /mkfs\./, // filesystem format
                    /mv\s+.*\s+\/dev\/null/, // move to null
                ];

                for (const pattern of dangerousPatterns) {
                    if (pattern.test(command)) {
                        throw new Error(
                            `🔒 Security: Dangerous command blocked: ${command.substring(0, 50)}...`
                        );
                    }
                }
            }
        },

        /**
         * After tool execution - unified JSONL logging
         */
        "tool.execute.after": async (input: ToolInput, _output: unknown, result?: ToolResult) => {
            const entry: AuditEntry = {
                timestamp: new Date().toISOString(),
                tool: input.tool,
                args: sanitizeArgs(input.args),
                success: !result?.error,
                error: result?.error || null,
                duration_ms: result?.duration || null,
                cwd: process.cwd(),
            };

            await log(entry);

            // Warn if bash command contains passwords/tokens
            if (input.tool === "bash") {
                const command = input.args?.command || "";
                if (command.match(/password|token|secret|key|credential/i)) {
                    console.warn("⚠️  Warning: Bash command may contain sensitive data");
                }
            }
        },

        /**
         * Session lifecycle hooks
         */
        "session.start": async () => {
            await log({
                timestamp: new Date().toISOString(),
                event: "session_start",
                cwd: process.cwd(),
            });
        },

        "session.end": async () => {
            await log({
                timestamp: new Date().toISOString(),
                event: "session_end",
            });
        },
    };
};
