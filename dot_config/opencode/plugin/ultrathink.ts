/**
 * Ultrathink Plugin
 * 
 * Injects "Ultrathink: " prefix before user prompts for specific models
 * that benefit from extended thinking mode.
 */

interface PluginContext {
    client: unknown;
    $: unknown;
}

const PREFIX = "Ultrathink: "
const TARGET_MODELS = ["glm-4.6", "big-pickle"] as const

export const UltrathinkPlugin = async (_ctx: PluginContext) => {
    const originalFetch = globalThis.fetch

    globalThis.fetch = async (input: RequestInfo | URL, init?: RequestInit) => {
        if (!init?.body || typeof init.body !== 'string') {
            return originalFetch(input, init)
        }

        try {
            const body = JSON.parse(init.body)
            const modelId = body.model ?? ''

            if (!TARGET_MODELS.some(t => modelId.includes(t))) {
                return originalFetch(input, init)
            }

            const messages = body.messages ?? body.contents
            if (Array.isArray(messages) && injectPrefix(messages, body.contents ? 'parts' : 'content')) {
                init = { ...init, body: JSON.stringify(body) }
            }
        } catch {
            // Parse failed, continue with original
        }

        return originalFetch(input, init)
    }

    // Return hooks object (empty since we use fetch interception)
    return {}
}

function injectPrefix(messages: any[], partsKey: 'content' | 'parts'): boolean {
    for (let i = messages.length - 1; i >= 0; i--) {
        const msg = messages[i]
        if (msg.role !== 'user') continue

        const parts = msg[partsKey]

        // String content (OpenAI simple format)
        if (typeof parts === 'string') {
            if (!parts.startsWith(PREFIX)) {
                msg[partsKey] = PREFIX + parts
                return true
            }
            return false
        }

        // Array content (OpenAI/Anthropic/Gemini multipart)
        if (Array.isArray(parts)) {
            for (const part of parts) {
                const text = part.text ?? (part.type === 'text' ? part.text : null)
                if (typeof text === 'string' && !text.startsWith(PREFIX)) {
                    part.text = PREFIX + text
                    return true
                }
            }
        }
    }
    return false
}
