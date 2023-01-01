# logana.nvim

A neovim plugin for [https://github.com/micmine/logana](https://github.com/micmine/logana).


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

