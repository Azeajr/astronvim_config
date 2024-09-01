-- lua/plugins/mypy.lua
if true then return {} end

return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    vim.list_extend(opts.sources, {
      null_ls.builtins.diagnostics.mypy.with {
        extra_args = { "--ignore-missing-imports" }, -- Adjust arguments as needed
      },
    })
  end,
  {
    "williamboman/mason-null-ls.nvim",
    opts = {
      ensure_installed = { "mypy" }, -- Ensure mypy is installed
    },
  },
}
