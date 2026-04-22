local M = {}

M.config = require("solarized-duo.config")

function M.setup(opts)
  M.config.setup(opts)
end

function M.load(variant)
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = variant == "dark" and "dark" or "light"
  vim.g.colors_name = variant == "dark" and "solarized-darcula" or "solarized-lightcula"

  local hl = require("solarized-duo.highlights").build(variant, M.config.options)
  for group, spec in pairs(hl) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("SolarizedDuoSnacks", { clear = true }),
    pattern = {
      "snacks_picker_list",
      "snacks_picker_input",
      "snacks_picker_preview",
      "snacks_dashboard",
    },
    callback = function()
      local extra = "EndOfBuffer:SnacksPicker,Normal:SnacksPicker,LineNr:SnacksPicker,SignColumn:SnacksPicker"
      local cur = vim.wo.winhighlight
      if cur == "" then
        vim.wo.winhighlight = extra
      elseif not cur:find("EndOfBuffer:SnacksPicker", 1, true) then
        vim.wo.winhighlight = cur .. "," .. extra
      end
    end,
  })
end

return M
