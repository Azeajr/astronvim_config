-- AstroUI: control theming, highlights, and interface icons
-- Docs: :h astroui

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    ------------------------------------------------------------------------------
    -- Colorscheme
    ------------------------------------------------------------------------------
    colorscheme = "astrodark", -- change to "catppuccin-mocha" or "solarized-osaka" if installed

    ------------------------------------------------------------------------------
    -- Highlights
    ------------------------------------------------------------------------------
    highlights = {
      init = {
        -- global highlight overrides
        -- Normal = { bg = "none" },
        -- Comment = { italic = true, fg = "#7c7c7c" },
      },
      astrodark = {
        -- theme-specific tweaks
        -- Normal = { bg = "#0f1117" },
        -- CursorLine = { bg = "#1b1d26" },
      },
    },

    ------------------------------------------------------------------------------
    -- Icons (flattened for type safety)
    ------------------------------------------------------------------------------
    icons = {
      -- LSP spinner (statusline)
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",

      -- Diagnostics
      DiagnosticError = " ",
      DiagnosticWarn = " ",
      DiagnosticInfo = " ",
      DiagnosticHint = "󰌵 ",

      -- Git
      GitAdded = " ",
      GitModified = " ",
      GitRemoved = " ",

      -- Misc UI
      FolderClosed = "",
      FolderOpen = "",
      FolderEmpty = "",
    },
  },
}
