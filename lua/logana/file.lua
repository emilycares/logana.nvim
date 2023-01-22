local M = {}

M.exists = function(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

M.get_content = function(path)
  local f = io.open(path, "rb")
  if f == nil then
    return nil
  end

  local content = f:read("*all")
  f:close()
  return content
end

M.parse = function(content)
  if content == nil then
    return {}
  end

  local result = {}

  for line in content:gmatch("([^\r\n]*)[\r\n]?") do
    if line == "" then
    else
      local dive = ""
      if line:sub(2, 2) == ":" then
        dive = line:sub(0, 2)
        line = line:sub(3)
      end
      local message = vim.split(line, "|")


      local location = message[1]
      local text = message[2]
      local split_location = vim.split(location, ":")
      local path = split_location[1]
      local row = split_location[2]
      local col = split_location[3]

      table.insert(result, {
	filename = dive .. path,
	lnum = row,
	col = col,
        text = text,
      })
    end
  end

  return result
end

return M
