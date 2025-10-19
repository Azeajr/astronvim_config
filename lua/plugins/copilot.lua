if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- Copilot: GitHub Copilot integration for AstroNvim
-- Docs: https://github.com/zbirenbaum/copilot.lua

---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot", -- lazy-loads on :Copilot command
    event = "InsertEnter", -- start Copilot when typing
    opts = function(_, opts)
      opts.suggestion = vim.tbl_deep_extend("force", opts.suggestion or {}, {
        auto_trigger = true, -- auto-suggest as you type
        keymap = {
          accept = "<C-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      })

      opts.panel = vim.tbl_deep_extend("force", opts.panel or {}, {
        enabled = true,
        keymap = { jump_prev = "[[", jump_next = "]]", accept = "<CR>", refresh = "gr", open = "<M-CR>" },
      })

      -- enable for specific filetypes
      opts.filetypes = vim.tbl_extend("force", opts.filetypes or {}, {
        markdown = true,
        lua = true,
        python = true,
        javascript = true,
        typescript = true,
        yaml = true,
        toml = true,
        sh = true,
        terraform = true,
        ["*"] = false, -- disable globally, then selectively re-enable
      })

      opts.copilot_node_command = "node" -- use system node
      opts.server_opts_overrides = opts.server_opts_overrides or {}
    end,
  },
}
