local Job = require("plenary.job")
local file = require("logana.file")
local error_handling = require("logana.error_handling")
local M = {}

local function trimStdout(content)
  local result = ""
  for line in content:gmatch("([^\r\n]*)[\r\n]?") do
    if line == "" then
    else
      if vim.startswith(line, "logana: ") then
        line = line:gsub("logana: ", "")
      end
      result = result .. line .. "\n"
    end
  end
  return result
end

local function get_content(type)
  if type == "buffer" then
    return vim.api.nvim_buf_get_lines(0, 0, -1, false)
  end
  if type == "line" then
    local line_num = vim.fn.line(".")
    if line_num == nil then
      return ""
    end
    return vim.api.nvim_buf_get_lines(0, line_num - 1, line_num + 10, false)
  end
end

local function go_first(errors)
  local first = errors[1]
  if first == nil then
    return
  end
  vim.cmd("e +" .. first.lnum .. " " .. first.filename)
end

local Parser = nil

M.set_parser = function(name)
  Parser = name
end

M.choose_parser = function()
  vim.ui.select({
    "angular",
    "cargo",
    "clang",
    "dune",
    "eslint",
    "go",
    "gradle",
    "java",
    "karma-jasmine",
    "maven",
    "zig",
  }, {
    prompt = "Select the logana parser:",
  }, function(choice)
    Parser = choice
  end)
end

--@param input "buffer" | "line"
--@param output "qfl" | "go_first"
M.run = function(input, output)
  if Parser == nil then
    M.choose_parser()
  end
  M.run_parser(input, output, Parser)
end

--@param input "buffer" | "line"
--@param output "qfl" | "go_first"
--@param parser https://github.com/micmine/logana/tree/main/src/analyser
M.run_parser = function(input, output, parser)
  local stdout = ""
  local stderr = ""
  local stdin = get_content(input)
  Job:new({
    writer = stdin,
    command = "logana",
    args = { "-i", "stdin", "-p", parser, "-o", "stdout" },
    on_stdout = function(_error, data)
      stdout = stdout .. "\n" .. data
    end,
    on_stderr = function(_error, data)
      stderr = stderr .. "\n" .. data
    end,
    on_exit = function()
      if not stderr == "" then
        vim.print("Got error from logana: " .. stdout .. " " .. stderr)
        return
      end

      local to_parse = trimStdout(stdout)
      local result = file.parse(to_parse)

      -- This is needed to call vimscript functions out of a callback
      vim.schedule(function()
        if output == "size" then
          local length = table.getn(result)
          if length > 1 then
            error_handling.set_logana_qfl(result)
          else
            go_first(result)
          end
          return
        end
        if output == "qfl" then
          error_handling.set_logana_qfl(result)
          return
        end
        if output == "go_first" then
          go_first(result)
        end
      end)
    end,
  }):start()
end

return M
