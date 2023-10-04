# logana.nvim

A neovim plugin for [https://github.com/micmine/logana](https://github.com/micmine/logana).

[![Demo](https://img.youtube.com/vi/BE72vc-Secs/0.jpg)](https://www.youtube.com/watch?v=BE72vc-Secs)

## Installation
Before you start with this install logana.

Use your favorite plugin manager
``` lua
use "micmine/logana.nvim"
local logana = require("logana");

vim.keymap.set(
    {"n"},
    "ä",
    function()
        -- This will load a ".logana-report" file. And will replace your quickfix list with these errors
        -- If there is no error in the file it will close the quickfix list
        logana.set_qfl()
    end,
)
```

Analyze a buffer
``` lua
local logana = require("logana")
-- Set a parser (Optional)
logana.analyze.set_parser("go")

vim.keymap.set(
    {"n"},
    "<leader>h",
    function()
        -- With these settings it will analyze the current line inclusive of the next 10 lines
        -- If there is only one error then it will go to that line. Else it will put them into a quick fix list
        logana.analyze.run("line", "size")
    end,
)
```
