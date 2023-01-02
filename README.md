# logana.nvim

A neovim plugin for [https://github.com/micmine/logana](https://github.com/micmine/logana).

[![Demo](https://img.youtube.com/vi/BE72vc-Secs/0.jpg)](https://www.youtube.com/watch?v=BE72vc-Secs)

## Installation
Before you start with this install logana.

Use your favorite plugin manager
``` lua
use "micmine/logana.nvim"
```
And setup the shortcut
``` lua
local logana = require("logana");

vim.keymap.set(
    {"n"},
    "ä",
    function()
        logana.set_qfl()
    end,
)
```

