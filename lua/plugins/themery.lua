-- Themery: dynamic theme picker for AstroNvim
-- https://github.com/zaldih/themery.nvim

---@type LazySpec
return {
  "zaldih/themery.nvim",
  cmd = "Themery",
  event = "VeryLazy",
  dependencies = { "AstroNvim/astroui" },

  config = function()
    ----------------------------------------------------------------------
    -- 🧠 Detect installed color schemes dynamically
    ----------------------------------------------------------------------
    local function get_available_colorschemes()
      local ok, colors = pcall(vim.fn.getcompletion, "", "color")
      if not ok or not colors or #colors == 0 then
        vim.notify("Themery: could not list colorschemes", vim.log.levels.WARN)
        return {}
      end

      -- optionally ignore default vim schemes
      local ignore = {
        "default",
        "delek",
        "elflord",
        "evening",
        "industry",
        "koehler",
        "morning",
        "murphy",
        "pablo",
        "peachpuff",
        "ron",
        "shine",
        "slate",
        "torte",
        "zellner",
      }

      local ignore_set = {}
      for _, name in ipairs(ignore) do
        ignore_set[name] = true
      end

      return vim.tbl_filter(function(name) return not ignore_set[name] end, colors)
    end

    ----------------------------------------------------------------------
    -- 🎨 Setup Themery
    ----------------------------------------------------------------------
    local themes = get_available_colorschemes()
    if #themes == 0 then
      vim.notify("Themery: No color schemes found", vim.log.levels.WARN)
      return
    end

    require("themery").setup {
      themes = themes, -- auto-detected list
      livePreview = true, -- preview before apply
      persist = true, -- remember last theme
      onApply = function(theme)
        -- update astroui state so Astro reloads highlight groups properly
        vim.cmd.colorscheme(theme)
        vim.schedule(function() vim.notify("🎨 Switched to theme: " .. theme, vim.log.levels.INFO) end)
      end,
    }

    ----------------------------------------------------------------------
    -- 🪄 Optional: integrate with AstroUI highlight reload
    ----------------------------------------------------------------------
    vim.api.nvim_create_user_command("ThemeReload", function()
      local cs = vim.g.colors_name
      if cs then
        vim.cmd.colorscheme(cs)
        vim.notify("Theme reloaded: " .. cs, vim.log.levels.INFO)
      else
        vim.notify("No active colorscheme found", vim.log.levels.WARN)
      end
    end, { desc = "Reload current colorscheme" })
  end,
}
