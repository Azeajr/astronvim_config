-- C# through easy-dotnet.nvim (Roslyn LSP, debugger, tests, NuGet, EF helpers)
-- instead of astrocommunity.pack.cs. Needs the global tool
-- `dotnet tool install -g EasyDotnet`; it installs roslyn-language-server
-- itself. Check with :checkhealth easy-dotnet.

---@type LazySpec
return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    ft = { "cs", "razor" },
    cmd = "Dotnet",
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim", "mfussenegger/nvim-dap" },
    init = function()
      -- zsh puts dotnet global tools on PATH, but Neovim started outside a
      -- shell (a desktop launcher) wouldn't have them.
      local tools = vim.fs.normalize "~/.dotnet/tools"
      if not (":" .. vim.env.PATH .. ":"):find(":" .. tools .. ":", 1, true) then
        vim.env.PATH = vim.env.PATH .. ":" .. tools
      end
    end,
    -- neotest shows the tests; easy-dotnet's runner still discovers them.
    opts = { test_runner = { neotest_integration = true } },
    config = function(_, opts) require("easy-dotnet").setup(opts) end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "GustavEikaas/easy-dotnet.nvim" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require "easy-dotnet.neotest")
    end,
  },
  {
    "AstroNvim/astrocore",
    optional = true,
    opts = { treesitter = { ensure_installed = { "c_sharp" } } },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "csharpier" })
    end,
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      -- csharpier formats C#, so Roslyn doesn't format on save too.
      opts.formatting = opts.formatting or {}
      opts.formatting.disabled = require("astrocore").list_insert_unique(opts.formatting.disabled, { "easy_dotnet" })
      -- AstroNvim starts whatever Mason has installed, and hosts that had
      -- pack.cs still have csharp-language-server. Keep it from attaching
      -- next to Roslyn.
      opts.handlers = opts.handlers or {}
      opts.handlers.csharp_ls = false
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    -- Same for pack.cs's netcoredbg: its coreclr launch entry would sit next
    -- to easy-dotnet's in the F5 picker. easy-dotnet bundles its own debugger.
    opts = { handlers = { coreclr = function() end } },
  },
}
