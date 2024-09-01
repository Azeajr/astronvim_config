-- lua/plugins/ruff.lua
if true then return {} end

return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    vim.list_extend(opts.sources, {
      null_ls.builtins.diagnostics.ruff, -- Add Ruff as a linter
    })
  end,
  {
    "williamboman/mason-null-ls.nvim",
    opts = {
      ensure_installed = { "ruff" }, -- Ensure ruff is installed
    },
  },
}
