local M = {}
local get_file_content = function (path)
  local f = io.open(path, "rb")
  if f == nil then
    return nil
  end

  local content = f:read("*all")
  f:close()
  return content
end

local toggle_list = function (items)
  local count = table.getn(items);
  if count then
    if count == 0 then
      vim.api.nvim_command("cclose")
    else
      vim.api.nvim_command("copen")
    end
  end
end

local get_logana_items = function (content)
  if content == nil then
    return {}
  end

  local result = {}

  for line in content:gmatch("([^\r\n]*)[\r\n]?") do
    if line == "" then
    else
      local message = vim.split(line, "|")

      local location = message[1]
      local split_location = vim.split(location, ":")
      local path = split_location[1]
      local row = split_location[2]
      local col = split_location[3]

      table.insert(result, {
        filename = path,
        lnum = row,
        col = col,
        text = message[2]
      })
    end
  end

  return result
end

local set_logana_qfl = function (data)
  local items = get_logana_items(data)

  vim.fn.setqflist({}, ' ', {items = items})

  toggle_list(items)
end


local file_exists = function (name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end



M.set_qfl = function ()
  if file_exists(".logana-report") then
    local file_content = get_file_content(".logana-report")
    if file_content then
      set_logana_qfl(file_content)
    end
  end
end
return M
