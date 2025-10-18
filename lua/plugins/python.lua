-- 🐍 Python stack for AstroNvim (single file, no pickers, no manual installer logic)
-- Switch the active LSP by changing ACTIVE_SERVER below (or set $NVIM_PYLS).
-- Choices: "pyright" | "pylyzer" | "pyrefly" | "ty"

-- --- choose here (comment/uncomment one) -----------------------
-- local ACTIVE_SERVER = "pyright" -- VS Code/Pylance parity for work
-- local ACTIVE_SERVER = "pylyzer"  -- fast Rust LSP
local ACTIVE_SERVER = "pyrefly" -- Meta's Rust LSP (early)
-- local ACTIVE_SERVER = "ty"       -- experimental Rust LSP
-- ----------------------------------------------------------------

-- Optional env override: NVIM_PYLS=pyright|pylyzer|pyrefly|ty
do
  local env_choice = vim.fn.getenv "NVIM_PYLS"
  if env_choice ~= vim.NIL and env_choice ~= "" then ACTIVE_SERVER = tostring(env_choice) end
end

-- Per-server configs (Ruff configured separately and always on)
local SERVER_CONFIGS = {
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic", -- VS Code default; change to "strict" if you like
          autoImportCompletions = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
  },
  pylyzer = {
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          typeCheckingMode = "basic",
          diagnosticMode = "workspace",
        },
      },
    },
  },
  pyrefly = {
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          typeCheckingMode = "basic",
        },
      },
    },
  },
  ty = {}, -- minimal stub; add settings here if/when needed
}

-- Safety: warn if ACTIVE_SERVER typo
if not SERVER_CONFIGS[ACTIVE_SERVER] then
  vim.schedule(
    function() vim.notify("Python: unknown ACTIVE_SERVER = " .. tostring(ACTIVE_SERVER), vim.log.levels.ERROR) end
  )
end

return {
  ------------------------------------------------------------------------------
  -- AstroLSP: declare servers + config the Astro way (ruff always + 1 chosen LSP)
  ------------------------------------------------------------------------------
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local extend = require("astrocore").extend_tbl

      opts.servers = opts.servers or {}
      opts.config = opts.config or {}

      -- ensure these servers are started
      if not vim.tbl_contains(opts.servers, "ruff") then table.insert(opts.servers, "ruff") end
      if not vim.tbl_contains(opts.servers, ACTIVE_SERVER) then table.insert(opts.servers, ACTIVE_SERVER) end

      -- merge Ruff config (disable hover so main LSP owns it)
      opts.config = extend(opts.config, {
        ruff = {
          on_attach = function(client) client.server_capabilities.hoverProvider = false end,
        },
      })

      -- merge the active server's config
      if SERVER_CONFIGS[ACTIVE_SERVER] then
        opts.config = extend(opts.config, {
          [ACTIVE_SERVER] = SERVER_CONFIGS[ACTIVE_SERVER],
        })
      end

      -- formatting: make Ruff the only formatter (optional; keep if you had this)
      opts.formatting = extend(opts.formatting or {}, {
        format_on_save = { enabled = true, ignore_filetypes = {} },
        disabled = { "pyright", "pylyzer", "pyrefly", "ty" },
        timeout_ms = 3200,
      })

      -- optional: LSP file operations integration
      opts.file_operations = extend(opts.file_operations or {}, {
        timeout = 10000,
        operations = {
          willCreate = true,
          didCreate = true,
          willRename = true,
          didRename = true,
          willDelete = true,
          didDelete = true,
        },
      })
    end,
  },

  ------------------------------------------------------------------------------
  -- Treesitter: Python + TOML
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
  -- Mason installs: keep it simple — just ensure all servers/tools you might use
  ------------------------------------------------------------------------------
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      -- Install all so switching ACTIVE_SERVER is seamless
      opts.ensure_installed = require("astrocore").list_insert_unique(
        opts.ensure_installed,
        { "ruff", "pyright", "pylyzer", "pyrefly", "ty" }
      )
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "ruff", "mypy", "debugpy" })
    end,
  },

  ------------------------------------------------------------------------------
  -- DAP (Debugpy) + Neotest + Venv Selector + Conform (Ruff formatting)
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
            n = {
              ["<Leader>lv"] = { "<Cmd>VenvSelect<CR>", desc = "Select VirtualEnv" },
            },
          },
        },
      },
    },
    cmd = "VenvSelect",
    opts = {
      search = {
        -- If you later add uv/poetry searches, put them here
        -- uv_cache = { command = "$FD '/python$' ~/.cache/uv/environments-v2 --full-path --color never" },
      },
      options = {},
    },
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
