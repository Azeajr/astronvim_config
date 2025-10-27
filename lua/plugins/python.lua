-- ~/.config/nvim/lua/plugins/python_stack_ruff_pyright.lua
---@type LazySpec
return {
  ------------------------------------------------------------------------------
  -- 🧠 LSP setup: Ruff + Pyright (no Mason installation)
  ------------------------------------------------------------------------------
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local extend = require("astrocore").extend_tbl
      opts.servers = opts.servers or {}
      opts.config = opts.config or {}

      -- ensure both Ruff and Pyright are enabled
      vim.list_extend(opts.servers, { "ruff", "pyright", "ty" })

      -- Ruff: disable hover so Pyright provides it
      opts.config = extend(opts.config, {
        ruff = {
          on_attach = function(client) client.server_capabilities.hoverProvider = false end,
        },

        -- Pyright: local-only config (not installed by Mason)
        pyright = {
          before_init = function(_, config)
            if not config.settings then config.settings = {} end
            if not config.settings.python then config.settings.python = {} end
            config.settings.python.pythonPath = vim.fn.exepath "python"
          end,
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
      })
    end,
  },

  ------------------------------------------------------------------------------
  -- 🧩 Formatters: Ruff for import & format
  ------------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },

  ------------------------------------------------------------------------------
  -- 🐍 Virtualenv selector (optional)
  ------------------------------------------------------------------------------
  {
    "linux-cultist/venv-selector.nvim",
    enabled = vim.fn.executable "fd" == 1 or vim.fn.executable "fdfind" == 1 or vim.fn.executable "fd-find" == 1,
    ft = "python",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>lv"] = { "<Cmd>VenvSelect<CR>", desc = "Select VirtualEnv" },
            },
          },
        },
      },
    },
    opts = {

      search = {}, -- if you add your own searches, they go here.
      options = {}, -- if you add plugin options, they go here.
    },
    cmd = "VenvSelect",
  },
}
