local file = require("logana.file")
local M = {}

local toggle_list = function(items)
  local count = table.getn(items)
  if count then
    if count == 0 then
      vim.api.nvim_command("cclose")
    else
      vim.api.nvim_command("copen")
    end
  end
end

local file_name = ".logana-report"

local set_logana_qfl = function(items)
  vim.fn.setqflist({}, " ", { items = items })

  toggle_list(items)
end

M.set_qfl = function()
  if file.exists(file_name) then
    local file_content = file.get_file_content(file_name)
    if file_content then
      local items = file.parse(file_content)
      set_logana_qfl(items)
    end
  end
end
return M
