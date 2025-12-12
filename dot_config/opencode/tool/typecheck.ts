import { tool } from "@opencode-ai/plugin"
import { existsSync } from "node:fs"
import { join } from "node:path"
import { executeCommand } from "../util/exec"

/**
 * Detect package manager from lock files
 */
function detectPackageManager(cwd: string = process.cwd()): "pnpm" | "yarn" | "bun" | "npm" {
    if (existsSync(join(cwd, "pnpm-lock.yaml"))) return "pnpm"
    if (existsSync(join(cwd, "yarn.lock"))) return "yarn"
    if (existsSync(join(cwd, "bun.lockb"))) return "bun"
    return "npm"
}

/**
 * TypeScript type check with smart error grouping
 */
export default tool({
    description: "Run TypeScript type check, return errors grouped by file",
    args: {
        file: tool.schema.string().optional().describe("Specific file to check"),
    },
    async execute({ file }) {
        try {
            const pm = detectPackageManager()
            
            // Build command based on package manager
            let cmd: string
            let tscArgs: string[]
            
            if (pm === "pnpm") {
                cmd = "pnpm"
                tscArgs = file ? ["exec", "tsc", "--noEmit", file] : ["exec", "tsc", "--noEmit"]
            } else if (pm === "yarn") {
                cmd = "yarn"
                tscArgs = file ? ["tsc", "--noEmit", file] : ["tsc", "--noEmit"]
            } else if (pm === "bun") {
                cmd = "bun"
                tscArgs = file ? ["run", "tsc", "--noEmit", file] : ["run", "tsc", "--noEmit"]
            } else {
                cmd = "npx"
                tscArgs = file ? ["tsc", "--noEmit", file] : ["tsc", "--noEmit"]
            }

            const { stdout, stderr } = await executeCommand(cmd, tscArgs)
            const output = stdout + stderr

            if (!output.trim()) {
                return JSON.stringify({
                    status: "success",
                    type_errors: 0,
                    files_checked: file ? 1 : "all",
                    message: "✓ No type errors found"
                }, null, 2)
            }

            // Parse errors with detailed regex
            const errorLines = output.split("\n").filter((l) => l.includes("error TS"))
            if (errorLines.length === 0) {
                return JSON.stringify({
                    status: "success",
                    type_errors: 0,
                    files_checked: file ? 1 : "all",
                    message: "✓ No type errors found"
                }, null, 2)
            }

            // Group by file with detailed parsing
            const byFile: Record<string, Array<{
                line: number
                column?: number
                code: string
                message: string
                severity: "error"
            }>> = {}
            
            for (const line of errorLines) {
                const match = line.match(/^([^(]+)\((\d+),(\d+)\): error (TS\d+): (.+)$/)
                if (match) {
                    const [, filePath, lineNum, colNum, code, msg] = match
                    const key = filePath.trim()
                    if (!byFile[key]) byFile[key] = []
                    
                    byFile[key].push({
                        line: parseInt(lineNum),
                        column: parseInt(colNum),
                        code,
                        message: msg.trim(),
                        severity: "error"
                    })
                }
            }

            const totalErrors = errorLines.length
            const filesWithErrors = Object.keys(byFile).length
            
            // Generate remediation hints based on common error patterns
            const remediationHints: string[] = []
            const allErrorCodes = new Set<string>()
            
            Object.values(byFile).forEach(errors => {
                errors.forEach(error => {
                    allErrorCodes.add(error.code)
                    
                    // Common remediation patterns
                    if (error.code === "TS2307") {
                        remediationHints.push("Check import paths and module resolution in tsconfig.json")
                    } else if (error.code === "TS2322") {
                        remediationHints.push("Type mismatches found - use type assertions or fix variable types")
                    } else if (error.code === "TS2531") {
                        remediationHints.push("Optional chaining issues - add null checks or use optional chaining operator")
                    } else if (error.code.startsWith("TS23")) {
                        remediationHints.push("Type definition issues - check interfaces and type declarations")
                    }
                })
            })

            const result = {
                status: "error",
                type_errors: totalErrors,
                files_checked: file ? 1 : "all",
                files_with_errors: filesWithErrors,
                errors: Object.entries(byFile)
                    .slice(0, 10)
                    .map(([filePath, errors]) => ({
                        file: filePath,
                        error_count: errors.length,
                        errors: errors.slice(0, 5).map(e => ({
                            line: e.line,
                            column: e.column,
                            code: e.code,
                            message: e.message,
                            severity: e.severity
                        })),
                        truncated: errors.length > 5
                    })),
                summary: {
                    total_errors: totalErrors,
                    unique_error_codes: Array.from(allErrorCodes.values()),
                    most_common_file: Object.entries(byFile)
                        .sort(([,a], [,b]) => b.length - a.length)[0]?.[0] || null
                },
                remediation: {
                    hints: [...new Set(remediationHints)],
                    general: [
                        `Run '${pm} install' to ensure dependencies are available`,
                        "Check tsconfig.json for correct compiler options",
                        "Ensure all imported modules have type declarations",
                        "Consider using 'any' temporarily for complex type issues"
                    ],
                    specific_file: Object.entries(byFile).length > 10 
                        ? `Showing first 10 of ${Object.entries(byFile).length} files with errors`
                        : null
                }
            }

            return JSON.stringify(result, null, 2)
        } catch (e) {
            const pmFallback = detectPackageManager()
            return JSON.stringify({
                status: "failed",
                message: "Type check execution failed",
                error: e instanceof Error ? e.message : String(e),
                remediation: [
                    `Ensure TypeScript is installed: '${pmFallback} add -D typescript'`,
                    "Check that tsconfig.json exists and is valid",
                    "Verify the project has necessary dependencies installed"
                ]
            }, null, 2)
        }
    },
})
