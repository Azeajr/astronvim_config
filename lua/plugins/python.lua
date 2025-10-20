-- 🐍 Python stack for AstroNvim (v5 style)
-- switch the active LSP by changing ACTIVE_SERVER below (or set $NVIM_PYLS)
-- choices: "pyright" | "pyrefly" | "ty"

-- --- choose here (comment/uncomment one) -----------------------
local ACTIVE_SERVER = "pyright" -- VSCode/Pylance parity
-- local ACTIVE_SERVER = "pyrefly" -- Meta's Rust LSP (early)
-- local ACTIVE_SERVER = "ty"       -- experimental Rust LSP
-- ----------------------------------------------------------------

-- optional env override
do
  local env_choice = vim.fn.getenv "NVIM_PYLS"
  if env_choice ~= vim.NIL and env_choice ~= "" then ACTIVE_SERVER = tostring(env_choice) end
end

-- per-server configs (Ruff is configured separately and always on)
local SERVER_CONFIGS = {
  pyright = {
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
  -- pyrefly = {
  --   settings = {
  --     python = {
  --       analysis = {
  --         autoImportCompletions = true,
  --         typeCheckingMode = "basic",
  --       },
  --     },
  --   },
  -- },
  -- ty = {},
}

-- Register experimental servers if lspconfig doesn't provide them
-- do
--   local ok, lspconfig = pcall(require, "lspconfig")
--   if ok then
--     local util = require "lspconfig.util"
--
--     -- pyrefly
--     if not lspconfig.pyrefly then
--       lspconfig.pyrefly = {
--         default_config = {
--           cmd = { "pyrefly" },
--           filetypes = { "python" },
--           root_dir = function(fname)
--             return util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", "requirements.txt", ".git")(fname)
--           end,
--           settings = {},
--         },
--       }
--     end
--
--     -- ty
--     if not lspconfig.ty then
--       lspconfig.ty = {
--         default_config = {
--           cmd = { "ty" },
--           filetypes = { "python" },
--           root_dir = function(fname)
--             return util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", "requirements.txt", ".git")(fname)
--           end,
--           settings = {},
--         },
--       }
--     end
--   end
-- end

-- safety: warn if ACTIVE_SERVER typo
if not SERVER_CONFIGS[ACTIVE_SERVER] then
  vim.schedule(
    function() vim.notify("Python: unknown ACTIVE_SERVER = " .. tostring(ACTIVE_SERVER), vim.log.levels.ERROR) end
  )
end

return {
  ------------------------------------------------------------------------------
  -- AstroLSP: merge Ruff + one selected LSP
  ------------------------------------------------------------------------------
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local extend = require("astrocore").extend_tbl
      opts.servers = opts.servers or {}
      opts.config = opts.config or {}

      -- ensure both Ruff and the chosen LSP are active
      if not vim.tbl_contains(opts.servers, "ruff") then table.insert(opts.servers, "ruff") end
      if not vim.tbl_contains(opts.servers, ACTIVE_SERVER) then table.insert(opts.servers, ACTIVE_SERVER) end

      -- Ruff config (disable hover so main LSP owns it)
      opts.config = extend(opts.config, {
        ruff = {
          on_attach = function(client) client.server_capabilities.hoverProvider = false end,
        },
      })

      -- merge active LSP config
      if SERVER_CONFIGS[ACTIVE_SERVER] then
        opts.config = extend(opts.config, {
          [ACTIVE_SERVER] = SERVER_CONFIGS[ACTIVE_SERVER],
        })
      end

      -- python-specific formatting preference (Ruff only)
      opts.formatting = extend(opts.formatting or {}, {
        format_on_save = { enabled = true },
        disabled = { "pyright", "pyrefly", "ty" },
        timeout_ms = 3200,
      })
    end,
  },

  ------------------------------------------------------------------------------
  -- DAP, Neotest, Venv Selector, Conform (no manual install logic)
  ------------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    optional = true,
    specs = {
      {
        "mfussenegger/nvim-dap-python",
        dependencies = "mfussenegger/nvim-dap",
        ft = "python",
        config = function(_, _)
          local path = vim.fn.exepath "debugpy-adapter"
          if path == "" then path = vim.fn.exepath "python" end
          require("dap-python").setup(path, {})
        end,
      },
    },
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "nvim-neotest/neotest-python", config = function() end },
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      table.insert(opts.adapters, require "neotest-python"(require("astrocore").plugin_opts "neotest-python"))
    end,
  },

  {
    "linux-cultist/venv-selector.nvim",
    enabled = vim.fn.executable "fd" == 1 or vim.fn.executable "fdfind" == 1 or vim.fn.executable "fd-find" == 1,
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = { ["<Leader>lv"] = { "<Cmd>VenvSelect<CR>", desc = "Select VirtualEnv" } },
          },
        },
      },
    },
    cmd = "VenvSelect",
    opts = { search = {}, options = {} },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },
}
