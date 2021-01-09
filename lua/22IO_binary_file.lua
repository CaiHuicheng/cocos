--[[
	默认的简单模式总是以文本模式打开。在 Unix 中二进制文件和文本文件并没有区
别，但是在如 Windows 这样的系统中，二进制文件必须以显式的标记来打开文件。控制
这样的二进制文件，你必须将“b”标记添加在 io.open 函数的格式字符串参数中。在 Lua
中二进制文件的控制和文本类似。一个串可以包含任何字节值，库中几乎所有的函数都
可以用来处理任意字节值。（你甚至可以对二进制的“串”进行模式比较，只要串中不存
在 0 值。如果想要进行 0 值字节的匹配，你可以使用%z 代替）这样使用*all 模式就是读
取整个文件的值，使用数字 n 就是读取 n 个字节的值。以下是一个将文本文件从 DOS
模式转换到 Unix 模式的简单程序。（这样转换过程就是将“回车换行字符”替换成“换
行字符”。）因为是以二进制形式（原稿是 Text Mode！！？？）打开这些文件的，这里无
法使用标准输入输入文件（stdin/stdout）。所以使用程序中提供的参数来得到输入、输出
文件名。

]]

local inp = assert(io.open(arg[1], "rb")) 
local out = assert(io.open(arg[2], "wb")) 
local data = inp:read("*all") 
data = string.gsub(data, "\r\n", "\n") 
out:write(data) 
assert(out:close())

-->test CMD lua prog.lua file.dos file.unix


-->打印在二进制文件中找到的所有特定字符串。
local f = assert(io.open(arg[1], "rb"))
local data = f:read(*all)
local validchars = "[%w%p%s]"
local pattern = string.rep(validchars,6).."+%z"
for w in string.gfind(data,pattern) do
	print(W)
end

-->该程序对二进制文件进行一次值分析6（Dump）
local f = assert(io.open(arg[1], "rb")) 
local block = 10 
while true do
	local bytes = f:read(block) 
	if not bytes then break end
	for b in string.gfind(bytes, ".") do
		io.write(string.format("%02X ", string.byte(b))) 
	end 
	io.write(string.rep(" ", block - string.len(bytes) + 1)) 
	io.write(string.gsub(bytes, "%c", "."), "\n") 
end
