---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- opts variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

    -- Only insert new sources, do not replace the existing ones
    -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- Add mypy as a diagnostic tool
      null_ls.builtins.diagnostics.mypy.with {
        extra_args = function()
          local virtual_env = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX" or "/usr"
          return { "--python-executable", virtual_env .. "/bin/python3" }
        end,
      },
    })
  end,
}
