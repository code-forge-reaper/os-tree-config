local fns = require "helpers"
require "config.lazy"

-- Load all files from the keybinds folder
local keybinds_path = vim.fn.stdpath('config') .. '/lua/keybinds/'
local keybinds_files = fns.scandir(keybinds_path)
for _, file in ipairs(keybinds_files) do
    if not (file == "." or file == "..") then
        require("keybinds." .. fns.ignoreLetters(".lua", file))
    end
end

--fns.set("relativenumber")
vim.cmd("set relativenumber")
vim.cmd("set softtabstop=4")
vim.cmd("set tabstop=4")
