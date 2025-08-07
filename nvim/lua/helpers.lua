local cmd = vim.cmd
function keymap(mode, keybind, command, other)
	if mode == "i" then
		vim.api.nvim_set_keymap(mode, keybind, "<Esc><cmd>" .. command .. "<cr>", other or {})
	else
		vim.api.nvim_set_keymap(mode, keybind, "<cmd>" .. command .. "<cr>", other or {})
	end
end

function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

function set(option, value)
    --print("set " .. option .. "=" .. value)
    if value == nil then
        cmd("set " .. option)
    else
        cmd("set " .. option .. "=" .. value)
    end
end



function ignoreLetters( ignore,c )
  return (c:gsub(ignore, ""))
end


return{
	scandir = scandir,
	ignoreLetters = ignoreLetters,
	set = set,
	cmd = cmd,
	keymap = keymap
}
