/**
 * Git Safety Plugin
 *
 * Prevents accidental commits/pushes to protected branches:
 * - Blocks direct commits to main/master
 * - Warns on force pushes
 * - Prevents pushing to protected branches
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

export const GitSafety = async (_ctx: PluginContext) => {
    const protectedBranches = ["main", "master", "production", "prod", "release"];

    /**
     * Get current git branch
     */
    const getCurrentBranch = (): string | null => {
        try {
            const result = execSync("git rev-parse --abbrev-ref HEAD", {
                encoding: "utf-8",
                stdio: ["pipe", "pipe", "pipe"],
            });
            return result.trim();
        } catch {
            return null;
        }
    };

    return {
        /**
         * Before bash execution - check git commands
         */
        "tool.execute.before": async (input: ToolInput, _output: unknown) => {
            if (input.tool !== "bash") return;

            const command = input.args?.command || "";

            // Check for git commit on protected branch
            if (command.match(/git\s+commit/)) {
                const branch = getCurrentBranch();
                if (branch && protectedBranches.includes(branch)) {
                    throw new Error(
                        `🔒 Git Safety: Direct commits to '${branch}' branch are blocked. Create a feature branch first.`
                    );
                }
            }

            // Check for git push to protected branch
            if (command.match(/git\s+push/)) {
                const branch = getCurrentBranch();

                // Block force push
                if (command.match(/git\s+push\s+(-f|--force)/)) {
                    throw new Error(
                        "🔒 Git Safety: Force push is blocked. Use --force-with-lease if necessary."
                    );
                }

                // Block push to protected branches (unless explicitly to a different remote branch)
                if (branch && protectedBranches.includes(branch)) {
                    // Allow if pushing to a different branch explicitly
                    const pushMatch = command.match(/git\s+push\s+\w+\s+(\S+)/);
                    if (!pushMatch || protectedBranches.includes(pushMatch[1])) {
                        throw new Error(
                            `🔒 Git Safety: Direct push to '${branch}' is blocked. Create a PR instead.`
                        );
                    }
                }
            }

            // Warn on rebase of protected branches
            if (command.match(/git\s+rebase/)) {
                const branch = getCurrentBranch();
                if (branch && protectedBranches.includes(branch)) {
                    console.warn(
                        `⚠️  Warning: Rebasing on protected branch '${branch}'. Be careful!`
                    );
                }
            }

            // Block reset --hard on protected branches
            if (command.match(/git\s+reset\s+--hard/)) {
                const branch = getCurrentBranch();
                if (branch && protectedBranches.includes(branch)) {
                    throw new Error(
                        `🔒 Git Safety: Hard reset on '${branch}' is blocked. This could lose commits.`
                    );
                }
            }

            // Warn on branch deletion
            if (command.match(/git\s+branch\s+(-d|-D)\s+/)) {
                const branchMatch = command.match(/git\s+branch\s+(-d|-D)\s+(\S+)/);
                if (branchMatch && protectedBranches.includes(branchMatch[2])) {
                    throw new Error(
                        `🔒 Git Safety: Cannot delete protected branch '${branchMatch[2]}'.`
                    );
                }
            }
        },
    };
};
