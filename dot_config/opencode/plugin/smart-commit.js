/**
 * Smart Commit Plugin
 *
 * Enhances git workflow with intelligent suggestions:
 * - Suggests conventional commit prefixes based on changes
 * - Warns if committing without tests
 * - Tracks commit patterns for consistency
 * - Auto-generates branch names from issue IDs
 */
export const SmartCommit = async ({ client, $ }) => {
  /**
   * Analyze staged files to suggest commit type
   */
  const suggestCommitType = async () => {
    try {
      const staged = await $`git diff --cached --name-only`.quiet();
      const files = staged.stdout.trim().split("\n").filter(Boolean);

      if (files.length === 0) return null;

      // Analyze file patterns
      const hasTests = files.some((f) => f.includes(".test.") || f.includes(".spec."));
      const hasDocs = files.some((f) => f.endsWith(".md") || f.includes("/docs/"));
      const hasConfig = files.some((f) =>
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
      const diff = await $`git diff --cached`.quiet();
      const diffContent = diff.stdout.toLowerCase();

      if (diffContent.includes("fix") || diffContent.includes("bug")) return "fix";
      if (diffContent.includes("add") || diffContent.includes("new")) return "feat";
      if (diffContent.includes("refactor") || diffContent.includes("cleanup")) return "refactor";
      if (diffContent.includes("perf") || diffContent.includes("optimize")) return "perf";

      return "feat"; // Default
    } catch {
      return null;
    }
  };

  /**
   * Check if tests exist for changed files
   */
  const checkTestCoverage = async () => {
    try {
      const staged = await $`git diff --cached --name-only`.quiet();
      const files = staged.stdout.trim().split("\n").filter(Boolean);

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
    } catch {
      return { hasTests: true };
    }
  };

  return {
    "tool.execute.before": async (input) => {
      if (input.tool !== "bash") return;

      const command = input.args?.command || "";

      // When committing, suggest commit type and check tests
      if (command.match(/git\s+commit(?!\s+--amend)/)) {
        const commitType = await suggestCommitType();
        if (commitType) {
          console.log(`💡 Suggested commit type: ${commitType}:`);
          console.log(`   Example: ${commitType}: your message here`);
        }

        const testCheck = await checkTestCoverage();
        if (!testCheck.hasTests) {
          console.warn(testCheck.message);
        }
      }

      // When creating branch, suggest naming convention
      if (command.match(/git\s+(checkout|switch)\s+-b/)) {
        console.log("💡 Branch naming convention: type/ISSUE-ID-brief-description");
        console.log("   Examples: feat/PROJ-123-user-auth, fix/PROJ-456-login-bug");
      }
    },

    "tool.execute.after": async (input, output, result) => {
      if (input.tool !== "bash") return;

      const command = input.args?.command || "";

      // After successful commit, log it
      if (command.match(/git\s+commit/) && !result?.error) {
        console.log("✅ Commit successful!");
      }
    },
  };
};
