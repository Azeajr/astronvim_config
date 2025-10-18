return {
  "zaldih/themery.nvim",
  cmd = "Themery",
  config = function()
    ----------------------------------------------------------------------
    -- 🧠 Dynamically detect installed color schemes
    ----------------------------------------------------------------------
    local function get_available_colorschemes()
      local ok, colors = pcall(vim.fn.getcompletion, "", "color")
      if not ok then
        vim.notify("Could not list colorschemes", vim.log.levels.WARN)
        return {}
      end

      -- filter out vim built-ins
      local ignore = {
        -- "default",
        -- "delek",
        -- "elflord",
        -- "evening",
        -- "industry",
        -- "koehler",
        -- "morning",
        -- "murphy",
        -- "pablo",
        -- "peachpuff",
        -- "ron",
        -- "shine",
        -- "slate",
        -- "torte",
        -- "zellner",
      }

      local function is_not_ignored(name)
        for _, bad in ipairs(ignore) do
          if name == bad then return false end
        end
        return true
      end

      return vim.tbl_filter(is_not_ignored, colors)
    end

    ----------------------------------------------------------------------
    -- 🎨 Setup Themery
    ----------------------------------------------------------------------
    require("themery").setup {
      themes = get_available_colorschemes(), -- auto-detected list
      livePreview = true, -- preview before apply
      persist = true, -- remember last theme
      onApply = function(theme) vim.notify("Switched to theme: " .. theme, vim.log.levels.INFO) end,
    }
  end,
}
