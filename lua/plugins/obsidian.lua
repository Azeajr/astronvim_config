---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  opts = {
    -- Notes created from a daily note (YYYY-MM-DD.md) go to notes/<date>/
    note_path_func = function(spec)
      local date = "^%d%d%d%d%-%d%d%-%d%d$"
      local path = spec.dir / tostring(spec.id)
      local root = Obsidian.workspace.root
      local day = vim.fn.expand "%:t:r"
      if day:match(date) and not tostring(spec.id):match(date) and tostring(spec.dir) == tostring(root) then
        path = root / "notes" / day / tostring(spec.id)
      end
      return path:with_suffix(".md", true)
    end,
  },
}
