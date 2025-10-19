-- Treesitter: syntax highlighting, indentation, and selection
-- Docs: :h nvim-treesitter

---@type LazySpec
return {
  -- main treesitter engine
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ------------------------------------------------------------------------------
      -- Parsers to install
      ------------------------------------------------------------------------------
      ensure_installed = {
        -- Core
        "lua",
        "vim",
        "vimdoc",
        "query",

        -- Programming languages
        "python",
        "bash",
        "json",
        "yaml",
        "toml",
        "dockerfile",
        "typescript",
        "javascript",

        -- Markup / config
        "markdown",
        "markdown_inline",
        "html",
        "css",
      },

      ------------------------------------------------------------------------------
      -- Feature modules
      ------------------------------------------------------------------------------
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_lang, buf)
          -- disable for very large files
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > 1024 * 256
        end,
      },

      indent = {
        enable = true,
        disable = { "python" }, -- treesitter indentation for python can be buggy
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },

      ------------------------------------------------------------------------------
      -- Optional modules if you use nvim-treesitter-textobjects
      ------------------------------------------------------------------------------
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
        },
      },
    },
  },

  -- add-on plugin that actually implements `textobjects`
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true, -- it will auto-load when treesitter does
  },
}
