-- Work around a snacks.nvim bug in vim.ui.select (code actions etc.): snacks/picker/select.lua
-- fits the list to `vim.o.lines * 0.8 - 10`, which is fractional unless the screen height is a
-- multiple of 5, and Neovim 0.12 rejects it ("Invalid 'height': Number is not integral").
-- Wrap the select layout's config hook so it floors the list height after snacks sets it.
-- Remove once fixed upstream (snacks 2.31.0 still has it).
local ok, snacks = pcall(require, "snacks")
if ok then
  local pick = snacks.picker.pick
  snacks.picker.pick = function(source, opts)
    local o = type(source) == "table" and source or opts
    local layout = o and o.source == "select" and type(o.layout) == "table" and o.layout
    if layout and type(layout.config) == "function" then
      local config = layout.config
      layout.config = function(l, ...)
        local ret = config(l, ...)
        for _, box in ipairs((ret or l).layout or {}) do
          if type(box.height) == "number" and box.height >= 1 then box.height = math.floor(box.height) end
        end
        return ret
      end
    end
    return pick(source, opts)
  end
end
