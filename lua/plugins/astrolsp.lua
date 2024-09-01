if true then return {} end

-- lua/plugins/lsp_setup.lua
return {
  {
    "AstroNvim/astrolsp",
    opts = {
      -- Features and settings
      features = {
        inlay_hints = true, -- Enable inlay hints
        semantic_tokens = true, -- Enable semantic tokens
      },
      formatting = {
        format_on_save = {
          enabled = true, -- Enable auto-formatting on save globally
          -- ignore_filetypes = { "python" }, -- Disable for Python, as Ruff handles formatting
        },
        timeout_ms = 2000, -- Timeout for formatting
      },
      handlers = {
        -- Use AstroLSP to set up Pyright
        pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end,
        ruff = function(_, opts) require("lspconfig").ruff.setup(opts) end,
      },
      config = {
        -- Pyright configuration
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "strict", -- Adjust type checking level as needed
              },
            },
          },
        },
        ruff = {
          filetypes = { "python" }, -- Enable Ruff for Python
        },
      },
      -- Setup additional servers or sources
      servers = { "pyright" },
      on_attach = function(client, bufnr)
        -- Custom on_attach logic, if any
      end,
    },
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local none_ls = require "none-ls"
  --     vim.list_extend(opts.sources, {
  --       -- none_ls.builtins.diagnostics.ruff,             -- Linting with Ruff
  --       none_ls.builtins.diagnostics.mypy.with {
  --         extra_args = { "--ignore-missing-imports" }, -- Adjust MyPy args as needed
  --       },
  --     })
  --   end,
  --   {
  --     "williamboman/mason-null-ls.nvim",
  --     opts = {
  --       ensure_installed = {
  --         "ruff",
  --         "mypy",
  --       }, -- Ensure Ruff and MyPy are installed
  --     },
  --   },
  -- },
}
