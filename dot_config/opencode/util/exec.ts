import { spawn, SpawnOptions } from "node:child_process";

/**
 * Allowlisted binaries for secure command execution.
 * Only these commands can be executed via executeCommand.
 */
const ALLOWED_BINARIES = new Set([
    // Version control
    "git", "gh",
    // Package managers
    "npm", "npx", "yarn", "pnpm", "bun",
    // Build tools
    "node", "tsc", "esbuild", "vite", "webpack",
    // Testing
    "jest", "vitest", "mocha", "pytest",
    // Linting
    "eslint", "prettier", "biome",
    // System utilities (read-only)
    "ls", "pwd", "which", "whoami", "date", "echo",
    "find", "grep", "rg", "fd", "ag",
    // Project tools
    "bd", "bv", "ubs", "cass",
    // Docker (read operations)
    "docker",
]);

/**
 * Security configuration for command execution
 */
const EXEC_CONFIG = {
    DEFAULT_TIMEOUT_MS: 30000,      // 30 seconds
    MAX_TIMEOUT_MS: 600000,         // 10 minutes
    MAX_BUFFER_BYTES: 1024 * 1024,  // 1MB
};

/**
 * Secure command execution with allowlist validation.
 * 
 * @param binary - The command to execute (must be in allowlist)
 * @param args - Array of arguments (NOT a command string)
 * @param options - SpawnOptions plus timeout configuration
 * @returns Promise with stdout, stderr, and exitCode
 * @throws Error if binary is not in allowlist
 * 
 * @example
 * // Good: Arguments as array
 * await executeCommand("git", ["status", "--short"]);
 * 
 * // Bad: Never use shell strings
 * await executeCommand("git status --short"); // WRONG
 */
export async function executeCommand(
    binary: string,
    args: string[] = [],
    options?: SpawnOptions & { timeout?: number }
): Promise<{ stdout: string; stderr: string; exitCode: number }> {
    // Validate binary against allowlist
    if (!ALLOWED_BINARIES.has(binary)) {
        throw new Error(
            `[EXEC_SECURITY] Binary not in allowlist: ${binary}\n` +
            `Allowed: ${Array.from(ALLOWED_BINARIES).join(", ")}`
        );
    }

    // Sanitize timeout
    const timeout = Math.min(
        options?.timeout ?? EXEC_CONFIG.DEFAULT_TIMEOUT_MS,
        EXEC_CONFIG.MAX_TIMEOUT_MS
    );

    return new Promise((resolve, reject) => {
        const proc = spawn(binary, args, {
            ...options,
            stdio: ["pipe", "pipe", "pipe"],
            // CRITICAL: Never use shell - prevents injection
            shell: false,
        });

        let stdout = "";
        let stderr = "";
        let stdoutBytes = 0;
        let stderrBytes = 0;
        let killed = false;

        // Timeout handler
        const timeoutId = setTimeout(() => {
            killed = true;
            proc.kill("SIGTERM");
            reject(new Error(`[EXEC_SECURITY] Command timed out after ${timeout}ms: ${binary}`));
        }, timeout);

        proc.stdout?.on("data", (data: Buffer) => {
            stdoutBytes += data.length;
            if (stdoutBytes <= EXEC_CONFIG.MAX_BUFFER_BYTES) {
                stdout += data.toString();
            }
        });

        proc.stderr?.on("data", (data: Buffer) => {
            stderrBytes += data.length;
            if (stderrBytes <= EXEC_CONFIG.MAX_BUFFER_BYTES) {
                stderr += data.toString();
            }
        });

        proc.on("close", (code) => {
            clearTimeout(timeoutId);
            if (!killed) {
                // Warn if output was truncated
                if (stdoutBytes > EXEC_CONFIG.MAX_BUFFER_BYTES) {
                    stderr += `\n[EXEC_SECURITY] stdout truncated: ${stdoutBytes} bytes > ${EXEC_CONFIG.MAX_BUFFER_BYTES} limit`;
                }
                if (stderrBytes > EXEC_CONFIG.MAX_BUFFER_BYTES) {
                    stderr += `\n[EXEC_SECURITY] stderr truncated: ${stderrBytes} bytes > ${EXEC_CONFIG.MAX_BUFFER_BYTES} limit`;
                }
                resolve({ stdout, stderr, exitCode: code ?? 0 });
            }
        });

        proc.on("error", (err) => {
            clearTimeout(timeoutId);
            reject(err);
        });
    });
}


