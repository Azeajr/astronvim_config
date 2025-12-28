-- ~/.config/nvim/lua/plugins/python.lua
return {
  ------------------------------------------------------------------------------
  -- LSP: Ty + Ruff (uv-installed binaries assumed in ~/.local/bin)
  ------------------------------------------------------------------------------
  {
    "AstroNvim/astrolsp",
    optional = true,

    -- Put PATH fixes here so they happen before LSP startup
    init = function()
      local home = vim.env.HOME or ""
      local localbin = home .. "/.local/bin"
      if home ~= "" and not string.find(vim.env.PATH or "", localbin, 1, true) then
        vim.env.PATH = localbin .. ":" .. (vim.env.PATH or "")
      end
    end,

    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      -- Astro recommends function form when touching list-like tables such as `servers` :contentReference[oaicite:1]{index=1}
      local astrocore = require "astrocore"
      opts.servers = astrocore.list_insert_unique(opts.servers or {}, { "ty", "ruff" })
      local util = require "lspconfig.util"
      local py_root = util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", "requirements.txt", ".git")

      opts.config = astrocore.extend_tbl(opts.config or {}, {
        ty = {
          cmd = { "ty", "server" },
          filetypes = { "python" },
          root_dir = py_root,
          settings = {
            ty = {
              -- ty language server settings go here
            },
          },
        },
      })
    end,
  },

  ------------------------------------------------------------------------------
  -- Treesitter
  ------------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "python", "toml" })
      end
    end,
  },

  ------------------------------------------------------------------------------
  -- Debugger (nvim-dap-python + debugpy)
  ------------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    optional = true,
    specs = {
      {
        "mfussenegger/nvim-dap-python",
        dependencies = "mfussenegger/nvim-dap",
        ft = "python",
        config = function(_, dap_py_opts)
          -- Prefer debugpy-adapter if present, else fall back to python
          local path = vim.fn.exepath "debugpy-adapter"
          if path == "" then path = vim.fn.exepath "python" end
          require("dap-python").setup(path, dap_py_opts)
        end,
      },
    },
  },

  ------------------------------------------------------------------------------
  -- Neotest
  ------------------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "nvim-neotest/neotest-python", config = function() end },
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      table.insert(opts.adapters, require "neotest-python"(require("astrocore").plugin_opts "neotest-python"))
    end,
  },

  ------------------------------------------------------------------------------
  -- Conform (Ruff format + organize imports)
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
  -- none-ls (mypy diagnostics; work device only)
  ------------------------------------------------------------------------------
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    ft = { "python" },
    opts = function(_, opts)
      -- Only enable mypy on work devices
      if vim.env.DEVICE ~= "work" then return opts end

      local null_ls = require "null-ls"

      opts.sources = opts.sources or {}

      table.insert(
        opts.sources,
        null_ls.builtins.diagnostics.mypy.with {
          command = "mypy",
          -- Intentionally rely solely on pyproject.toml
        }
      )

      return opts
    end,
  },

  ------------------------------------------------------------------------------
  -- Virtualenv selector
  -- BROKEN: currently doesn't work well with ty LSP server
  ------------------------------------------------------------------------------
  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
  --   },
  --   ft = "python", -- Load when opening Python files
  --   keys = {
  --     { "<Leader>lv", "<Cmd>VenvSelect<CR>", desc = "Select VirtualEnv" },
  --   },
  --   opts = { -- this can be an empty lua table - just showing below for clarity.
  --     search = {}, -- if you add your own searches, they go here.
  --     options = {}, -- if you add plugin options, they go here.
  --   },
  -- },
}
