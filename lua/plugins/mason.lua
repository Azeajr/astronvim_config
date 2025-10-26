-- Mason: unified installer for LSP servers, DAPs, linters, and formatters
-- AstroNvim v5 compliant

---@type LazySpec
return {
  ------------------------------------------------------------------------------
  -- Core Mason plugin UI tweaks
  ------------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  ------------------------------------------------------------------------------
  -- Mason-LSPConfig: automatically install and register LSP servers
  ------------------------------------------------------------------------------
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
        -- core Neovim LSPs
        "lua_ls",
        "bashls",
        "jsonls",
        "yamlls",
      })
      opts.automatic_installation = true
      opts.handlers = opts.handlers or {}
    end,
  },

  ------------------------------------------------------------------------------
  -- Mason-Nvim-DAP: automatically install debug adapters (from Astro recipe)
  ------------------------------------------------------------------------------
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
        "python", -- debugpy
      })
      opts.automatic_installation = true
      opts.handlers = opts.handlers or {}
    end,
  },

  ------------------------------------------------------------------------------
  -- Mason-Tool-Installer: automatically install formatters, linters, CLIs
  ------------------------------------------------------------------------------
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
        "stylua",
        "prettier",
        "shellcheck",

        -- debuggers
        "debugpy",

        -- other useful dev tools
        "tree-sitter-cli",
      })
      opts.automatic_installation = true
    end,
  },
}
