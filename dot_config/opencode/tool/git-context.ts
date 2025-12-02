import { tool } from "@opencode-ai/plugin"

/**
 * Get current git context in one call
 */
export default tool({
    description: "Get git context: branch, status, recent commits, diff stats",
    args: {},
    async execute() {
        const [branch, status, log, diff, remote] = await Promise.all([
            Bun.$`git branch --show-current`.text().catch(() => "unknown"),
            Bun.$`git status --short`.text().catch(() => ""),
            Bun.$`git log --oneline -5`.text().catch(() => "No commits"),
            Bun.$`git diff --stat HEAD~1 2>/dev/null`.text().catch(() => ""),
            Bun.$`git status -sb | head -1`.text().catch(() => ""),
        ])

        // Parse ahead/behind
        let sync = ""
        if (remote.includes("ahead")) {
            const m = remote.match(/ahead (\d+)/)
            if (m) sync = `↑${m[1]} ahead`
        }
        if (remote.includes("behind")) {
            const m = remote.match(/behind (\d+)/)
            if (m) sync += `${sync ? ", " : ""}↓${m[1]} behind`
        }
        if (!sync && remote.includes("...")) sync = "✓ up to date"

        const statusLines = status.trim().split("\n").filter(Boolean)
        const statusDisplay = statusLines.length
            ? statusLines.slice(0, 10).join("\n") +
            (statusLines.length > 10 ? `\n... +${statusLines.length - 10} more` : "")
            : "(clean)"

        return `Branch: ${branch.trim()}${sync ? ` [${sync}]` : ""}

Status:
${statusDisplay}

Recent commits:
${log.trim()}

Last commit changed:
${diff.trim() || "(no diff)"}`
    },
})
