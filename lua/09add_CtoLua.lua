--[[

	Lua 加载 C代码
	通过动态库 so

--]]

local path = "usr/local/lib/lua/5.1/socket.so"
local f = package.loadlib(path,"luaopen_socket")

