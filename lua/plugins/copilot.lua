--@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      opts.filetypes = opts.filetypes or {}
      opts.filetypes.markdown = true
    end,
  },
}
