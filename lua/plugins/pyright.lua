-- lua/plugins/pyright.lua
if true then return {} end

return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    setup_handlers = {
      -- Setup Pyright
      pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end,
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "pyright" }, -- Ensure pyright is installed
    },
  },
}
