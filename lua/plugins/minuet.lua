-- Minuet AI completion served by a local Ollama model
-- Keymaps mirror the old Copilot pack: suggestions show as virtual text and
-- are driven through blink.cmp keymaps

local function minuet_action(action)
  return function()
    local virtualtext = require "minuet.virtualtext"
    if virtualtext.action.is_visible() then
      virtualtext.action[action]()
      return true -- doesn't run the next command
    end
  end
end

local function minuet_cycle(direction)
  return function()
    -- cycles suggestions, or requests one when none is visible
    require("minuet.virtualtext").action[direction]()
    return true
  end
end

---@type LazySpec
return {
  {
    "milanglacier/minuet-ai.nvim",
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1, -- recommended for local models to save resources
      context_window = 2048, -- characters around the cursor, raise if latency allows
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM", -- Ollama ignores the key, but minuet needs a non-empty env var name
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:7b",
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { "*" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      if not opts.keymap then opts.keymap = {} end

      -- run the minuet command first, then fall through to the existing mapping
      local function prepend(key, command)
        opts.keymap[key] = vim.list_extend({ command }, opts.keymap[key] or { "fallback" })
      end

      prepend("<Tab>", minuet_action "accept")
      prepend("<C-J>", minuet_action "accept_line")
      prepend("<C-e>", minuet_action "dismiss")
      opts.keymap["<C-X>"] = { minuet_cycle "next" }
      opts.keymap["<C-Z>"] = { minuet_cycle "prev" }
    end,
  },
}
