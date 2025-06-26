-- AI-powered coding assistant with MCP integration
-- Avante.nvim Configuration

-- Local configuration variables for easy customization
local config = {
  providers = {
    default = "copilot",
    copilot_model = "claude-sonnet-4",
    ollama_model = "gemma3:1b",
    ollama_context = 16384,
  },
  file_selector = "snacks", -- "native" | "fzf" | "mini.pick" | "snacks" | "telescope"
  enable_hints = false,
  enable_slash_commands = true,
}

-- Helper function to safely get MCP system prompt
local function get_mcp_system_prompt()
  local ok, mcphub = pcall(require, "mcphub")
  if ok then
    local hub_ok, hub = pcall(mcphub.get_hub_instance)
    if hub_ok and hub then
      local prompt_ok, prompt = pcall(hub.get_active_servers_prompt, hub)
      if prompt_ok then
        return prompt
      end
    end
  end
  -- Fallback if mcphub is not available
  return "You are an AI coding assistant. Help the user with their programming tasks."
end

-- Helper function to safely get MCP custom tools
local function get_mcp_custom_tools()
  local ok, mcphub_avante = pcall(require, "mcphub.extensions.avante")
  if ok then
    local tool_ok, tool = pcall(mcphub_avante.mcp_tool)
    if tool_ok then
      return { tool }
    end
  end
  return {}
end

return {
  -- Main Avante plugin
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = LazyVim.is_win() and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
      "ravitemer/mcphub.nvim", -- Ensure mcphub loads before avante
    },
    opts = {
      -- Core configuration
      hints = { enabled = config.enable_hints },
      provider = config.providers.default,
      auto_suggest_provider = config.providers.default,

      -- Provider configurations
      providers = {
        copilot = {
          model = config.providers.copilot_model,
        },
        ollama = {
          model = config.providers.ollama_model,
          num_ctx = config.providers.ollama_context,
          num_predict = -1,
        },
      },

      -- File selector with error handling
      file_selector = {
        provider = config.file_selector,
        provider_opts = {},
      },

      -- MCP integration with safe fallbacks
      system_prompt = get_mcp_system_prompt,
      custom_tools = get_mcp_custom_tools,

      -- Disable conflicting tools to avoid duplication with MCP
      disabled_tools = {
        "list_files",
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash",
      },
    },
  },

  -- Image support plugin
  {
    "HakonHarnes/img-clip.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "PasteImage" },
    keys = {
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
    },
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
        use_absolute_path = true, -- Required for Windows users
      },
    },
  },

  -- Completion integration
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = function(_, opts)
      -- Safely extend existing sources instead of overwriting
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.avante = {
        module = "blink-cmp-avante",
        name = "Avante",
      }

      -- Add avante to default sources if not already present
      if opts.sources.default then
        if not vim.tbl_contains(opts.sources.default, "avante") then
          table.insert(opts.sources.default, "avante")
        end
      else
        opts.sources.default = { "avante" }
      end

      return opts
    end,
  },

  -- Markdown rendering support
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = function(_, file_types)
      return vim.list_extend(file_types or {}, { "markdown", "Avante" })
    end,
    opts = function(_, opts)
      opts = opts or {}
      opts.filetype = vim.list_extend(opts.filetype or {}, { "markdown", "Avante" })
      return opts
    end,
  },

  -- MCP Hub configuration
  {
    "ravitemer/mcphub.nvim",
    opts = {
      extensions = {
        avante = {
          make_slash_commands = config.enable_slash_commands,
        },
      },
    },
  },
}
