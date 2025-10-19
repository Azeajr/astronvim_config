-- AstroCore: central place to modify mappings, vim options, autocommands, and more
-- Docs: :h astrocore

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    ------------------------------------------------------------------------------
    -- Core features (Astro v5 structure)
    ------------------------------------------------------------------------------
    features = {
      large_buf = { size = 1024 * 512, lines = 20000 }, -- treat very large files gracefully
      autopairs = true, -- enable autopairs at startup
      cmp = true, -- enable completion
      diagnostics = { -- diagnostic display defaults
        virtual_text = true,
        virtual_lines = false,
      },
      highlighturl = true, -- underline URLs
      notifications = true, -- enable notifications globally
    },

    ------------------------------------------------------------------------------
    -- Vim diagnostics configuration (applied when diagnostics are on)
    ------------------------------------------------------------------------------
    diagnostics = {
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    },

    ------------------------------------------------------------------------------
    -- Filetype definitions
    ------------------------------------------------------------------------------
    filetypes = {
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },

    ------------------------------------------------------------------------------
    -- Vim options (opt and g tables)
    ------------------------------------------------------------------------------
    options = {
      opt = {
        relativenumber = true, -- show relative line numbers
        number = true, -- show current line number
        spell = false, -- disable spell checking
        signcolumn = "yes", -- always show sign column
        wrap = false, -- disable word wrap
        cursorline = true, -- highlight current line
        scrolloff = 4, -- keep context around cursor
      },
      g = {
        -- global variables (vim.g)
        -- mapleader is defined in lazy_setup.lua
      },
    },

    ------------------------------------------------------------------------------
    -- Key mappings
    ------------------------------------------------------------------------------
    mappings = {
      n = {
        -- navigate buffers
        ["]b"] = {
          function() require("astrocore.buffer").nav(vim.v.count1) end,
          desc = "Next buffer",
        },
        ["[b"] = {
          function() require("astrocore.buffer").nav(-vim.v.count1) end,
          desc = "Previous buffer",
        },

        -- close buffers via picker
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- example: toggle line wrap quickly
        ["<Leader>uw"] = {
          function()
            vim.opt.wrap = not vim.opt.wrap:get()
            vim.notify("Wrap " .. (vim.opt.wrap:get() and "enabled" or "disabled"))
          end,
          desc = "Toggle line wrap",
        },
        -- ["<Leader>un"] = { function() require("snacks").notifier.show_history() end, desc = "Notification history" },
      },
    },
  },
}
