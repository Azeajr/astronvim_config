if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- AstroLSP: customize the LSP layer of AstroNvim (v5-compliant)
-- Docs: :h astrolsp

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ------------------------------------------------------------------------------
    -- AstroLSP feature toggles
    ------------------------------------------------------------------------------
    features = {
      codelens = true, -- refresh CodeLens automatically
      inlay_hints = false, -- disable inline parameter hints
      semantic_tokens = true, -- enable semantic highlighting
      diagnostics = true, -- enable diagnostics (v5-safe)
    },

    ------------------------------------------------------------------------------
    -- LSP UI defaults (new in Astro v5)
    ------------------------------------------------------------------------------
    defaults = {
      hover = { border = "rounded" },
      signature_help = { border = "rounded" },
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },

    ------------------------------------------------------------------------------
    -- Formatting configuration
    ------------------------------------------------------------------------------
    formatting = {
      format_on_save = {
        enabled = true,
        ignore_filetypes = {}, -- empty = global
      },
      -- disable formatting for these LSPs (use Ruff instead)
      disabled = { "pyright", "pylyzer", "pyrefly", "ty", "lua_ls" },
      timeout_ms = 2000,
      -- If you ever want only Ruff to format:
      -- filter = function(client) return client.name == "ruff" end,
    },

    ------------------------------------------------------------------------------
    -- Explicitly enable servers (optional; Mason auto-registers anyway)
    ------------------------------------------------------------------------------
    servers = {
      -- "pyright",
      -- "ruff",
      -- "lua_ls",
    },

    ------------------------------------------------------------------------------
    -- Custom LSP config overrides
    ------------------------------------------------------------------------------
    config = {
      -- Example override: set UTF-8 offset for clangd
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
    },

    ------------------------------------------------------------------------------
    -- Handlers (leave default; use per-language overrides in plugin files)
    ------------------------------------------------------------------------------
    handlers = {
      -- To disable a specific LSP, set it to false:
      -- rust_analyzer = false,
      -- Example custom setup:
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end,
    },

    ------------------------------------------------------------------------------
    -- Buffer-local autocommands
    ------------------------------------------------------------------------------
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },

    ------------------------------------------------------------------------------
    -- Keymaps
    ------------------------------------------------------------------------------
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },

    ------------------------------------------------------------------------------
    -- on_attach hook
    ------------------------------------------------------------------------------
    on_attach = function(client, bufnr)
      -- Example tweak: disable semantic tokens globally
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
