/**
 * Enhanced Protection Plugin
 *
 * Provides security controls and unified audit logging for OpenCode operations:
 * - Prevents reading sensitive files (.env, secrets, SSH keys, credentials)
 * - Warns on large file operations
 * - Blocks dangerous bash commands
 * - Unified JSONL audit logging for all tool executions
 */
export const EnvProtection = async ({ client, $ }) => {
  const auditLog = `${process.env.HOME}/.config/opencode/audit.jsonl`;

  // Ensure log directory exists
  await $`mkdir -p ${process.env.HOME}/.config/opencode`.quiet();

  /**
   * Sanitize sensitive data from args for logging
   */
  const sanitizeArgs = (args) => {
    if (!args) return args;

    const sanitized = { ...args };

    // Truncate large content
    if (sanitized.content && sanitized.content.length > 1000) {
      sanitized.content = `<truncated ${sanitized.content.length} chars>`;
    }

    // Sanitize file paths containing secrets
    if (
      sanitized.filePath &&
      (sanitized.filePath.includes(".env") ||
        sanitized.filePath.includes("secret") ||
        sanitized.filePath.includes("password") ||
        sanitized.filePath.includes(".ssh") ||
        sanitized.filePath.includes(".aws"))
    ) {
      sanitized.filePath = "<sensitive path>";
    }

    // Mark commands containing sensitive patterns
    if (sanitized.command) {
      if (sanitized.command.match(/password|token|secret|key|credential/i)) {
        sanitized.command_contains_secrets = true;
      }
    }

    return sanitized;
  };

  /**
   * Append entry to JSONL audit log
   */
  const log = async (entry) => {
    const jsonLine = JSON.stringify(entry);
    await $`echo ${jsonLine} >> ${auditLog}`.quiet();
  };

  return {
    /**
     * Before tool execution - validation and blocking
     */
    "tool.execute.before": async (input, output) => {
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
              `🔒 Security: Dangerous command blocked: ${command.substring(0, 50)}...`,
            );
          }
        }
      }
    },

    /**
     * After tool execution - unified JSONL logging
     */
    "tool.execute.after": async (input, output, result) => {
      const entry = {
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
