import { tool } from "@opencode-ai/plugin"
import { executeCommand } from "../util/exec"

/**
 * Execute git command via secure executeCommand
 */
async function runGit(args: string[]): Promise<{ stdout: string; stderr: string; exitCode: number }> {
    return executeCommand("git", args)
}

/**
 * Get current git context in one call
 */
export default tool({
    description: "Get git context: branch, status, recent commits, diff stats",
    args: {},
    async execute() {
        const [statusV2Result, logResult, diffResult] = await Promise.all([
            runGit(["status", "--porcelain=v2", "-b"]).catch(() => ({ stdout: "", stderr: "", exitCode: 1 })),
            runGit(["log", "--oneline", "-5"]).catch(() => ({ stdout: "No commits", stderr: "", exitCode: 1 })),
            runGit(["diff", "--stat", "HEAD~1"]).catch(() => ({ stdout: "", stderr: "", exitCode: 1 })),
        ])

        const statusOutput = statusV2Result.stdout
        const log = logResult.stdout
        const diff = diffResult.stdout

        // Parse git status --porcelain=v2 -b format
        let branch = "unknown"
        let sync = ""
        const fileStatuses: string[] = []

        if (statusOutput) {
            const lines = statusOutput.split('\n')
            
            for (const line of lines) {
                if (line.startsWith('# branch.head ')) {
                    branch = line.substring('# branch.head '.length)
                } else if (line.startsWith('# branch.ab ')) {
                    // Format: # branch.ab +0 -0 (ahead behind)
                    const match = line.match(/# branch\.ab \+(\d+) -(\d+)/)
                    if (match) {
                        const ahead = parseInt(match[1])
                        const behind = parseInt(match[2])
                        if (ahead > 0 && behind > 0) {
                            sync = `↑${ahead} ahead, ↓${behind} behind`
                        } else if (ahead > 0) {
                            sync = `↑${ahead} ahead`
                        } else if (behind > 0) {
                            sync = `↓${behind} behind`
                        } else {
                            sync = "✓ up to date"
                        }
                    }
                } else if (line && !line.startsWith('#')) {
                    // File status line: 1 <XY> <sub> <mH> <mI> <mW> <hH> <hI> <path>
                    const parts = line.split(' ')
                    if (parts.length >= 3) {
                        const xy = parts[1]
                        const path = parts.slice(8).join(' ')
                        
                        let statusChar = '?'
                        if (xy[0] !== '?' && xy[0] !== ' ') {
                            statusChar = xy[0] // Staged changes
                        } else if (xy[1] !== '?' && xy[1] !== ' ') {
                            statusChar = xy[1] // Unstaged changes
                        }
                        
                        fileStatuses.push(`${statusChar} ${path}`)
                    }
                }
            }
        }

        const statusDisplay = fileStatuses.length
            ? fileStatuses.slice(0, 10).join('\n') +
            (fileStatuses.length > 10 ? `\n... +${fileStatuses.length - 10} more` : "")
            : "(clean)"

        return `Branch: ${branch}${sync ? ` [${sync}]` : ""}

Status:
${statusDisplay}

Recent commits:
${log.trim()}

Last commit changed:
${diff.trim() || "(no diff)"}`
    },
})
