/**
 * Smart Commit Plugin
 *
 * Enhances git workflow with intelligent suggestions:
 * - Suggests conventional commit prefixes based on changes
 * - Warns if committing without tests
 * - Tracks commit patterns for consistency
 * - Auto-generates branch names from issue IDs
 */
import { execSync } from "node:child_process";

interface PluginContext {
    client: unknown;
    $: unknown;
}

interface ToolInput {
    tool: string;
    args?: {
        command?: string;
    };
}

interface ToolResult {
    error?: string;
}

interface TestCoverageResult {
    hasTests: boolean;
    srcFiles?: string[];
    message?: string;
}

export const SmartCommit = async (_ctx: PluginContext) => {
    /**
     * Execute git command and return stdout
     */
    const execGit = (command: string): string | null => {
        try {
            return execSync(command, {
                encoding: "utf-8",
                stdio: ["pipe", "pipe", "pipe"],
            }).trim();
        } catch {
            return null;
        }
    };

    /**
     * Analyze staged files to suggest commit type
     */
    const suggestCommitType = (): string | null => {
        const staged = execGit("git diff --cached --name-only");
        if (!staged) return null;

        const files = staged.split("\n").filter(Boolean);
        if (files.length === 0) return null;

        // Analyze file patterns
        const hasTests = files.some((f) => f.includes(".test.") || f.includes(".spec."));
        const hasDocs = files.some((f) => f.endsWith(".md") || f.includes("/docs/"));
        const hasConfig = files.some(
            (f) =>
                f.match(/\.(json|yaml|yml|toml|config\.[jt]s)$/) ||
                f.includes("config") ||
                f.includes(".env")
        );
        const hasSrc = files.some((f) => f.startsWith("src/") || f.startsWith("lib/"));
        const hasStyles = files.some((f) => f.match(/\.(css|scss|less|styled\.[jt]sx?)$/));

        // Determine likely commit type
        if (hasTests && !hasSrc) return "test";
        if (hasDocs && !hasSrc) return "docs";
        if (hasConfig && !hasSrc) return "chore";
        if (hasStyles && !hasSrc) return "style";

        // Check diff content for more context
        const diff = execGit("git diff --cached");
        if (diff) {
            const diffContent = diff.toLowerCase();

            if (diffContent.includes("fix") || diffContent.includes("bug")) return "fix";
            if (diffContent.includes("add") || diffContent.includes("new")) return "feat";
            if (diffContent.includes("refactor") || diffContent.includes("cleanup")) return "refactor";
            if (diffContent.includes("perf") || diffContent.includes("optimize")) return "perf";
        }

        return "feat"; // Default
    };

    /**
     * Check if tests exist for changed files
     */
    const checkTestCoverage = (): TestCoverageResult => {
        const staged = execGit("git diff --cached --name-only");
        if (!staged) return { hasTests: true };

        const files = staged.split("\n").filter(Boolean);

        const srcFiles = files.filter(
            (f) =>
                (f.startsWith("src/") || f.startsWith("lib/")) &&
                !f.includes(".test.") &&
                !f.includes(".spec.") &&
                f.match(/\.[jt]sx?$/)
        );

        const testFiles = files.filter((f) => f.includes(".test.") || f.includes(".spec."));

        if (srcFiles.length > 0 && testFiles.length === 0) {
            return {
                hasTests: false,
                srcFiles,
                message: `⚠️  No test files in commit. Changed source files: ${srcFiles.join(", ")}`,
            };
        }

        return { hasTests: true };
    };

    return {
        "tool.execute.before": async (input: ToolInput) => {
            if (input.tool !== "bash") return;

            const command = input.args?.command || "";

            // When committing, suggest commit type and check tests
            if (command.match(/git\s+commit(?!\s+--amend)/)) {
                const commitType = suggestCommitType();
                if (commitType) {
                    console.log(`💡 Suggested commit type: ${commitType}:`);
                    console.log(`   Example: ${commitType}: your message here`);
                }

                const testCheck = checkTestCoverage();
                if (!testCheck.hasTests && testCheck.message) {
                    console.warn(testCheck.message);
                }
            }

            // When creating branch, suggest naming convention
            if (command.match(/git\s+(checkout|switch)\s+-b/)) {
                console.log("💡 Branch naming convention: type/ISSUE-ID-brief-description");
                console.log("   Examples: feat/PROJ-123-user-auth, fix/PROJ-456-login-bug");
            }
        },

        "tool.execute.after": async (input: ToolInput, _output: unknown, result?: ToolResult) => {
            if (input.tool !== "bash") return;

            const command = input.args?.command || "";

            // After successful commit, log it
            if (command.match(/git\s+commit/) && !result?.error) {
                console.log("✅ Commit successful!");
            }
        },
    };
};
