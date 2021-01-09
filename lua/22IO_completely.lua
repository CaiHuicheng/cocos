--[[

	为了对输入输出的更全面的控制，可以使用完全模式。完全模式的核心在于文件句柄（file handle）。
	打开一个文件的函数是 io.open。它模仿 C 语言中的 fopen 函数，同
	样需要打开文件的文件名参数，打开模式的字符串参数。模式字符串可以是 "r"（读模
	式），"w"（写模式，对数据进行覆盖），或者是 "a"（附加模式）。并且字符 "b" 可附加
	在后面表示以二进制形式打开文件。正常情况下 open 函数返回一个文件的句柄。如果发
	生错误，则返回 nil，以及一个错误信息和错误代码

	windows下路径分割必须用两个斜线，这是因为 \是转移序列。\n表示换行 \\表示\本身 。\t表示制表符

]] 

print(io.open("non-existent file","r"))
-->nil	non-existent file: No such file or directory

print(io.open("01test.lua","w"))
-->file (000007fefef02b10)

-->打开一个文件并全部读取
filename = "01test.lua"
local f = assert(io.open(filename, mode))
local f = assert(io.open(filename, "r")) 
local t = f:read("*all") 
f:close()
--[[

	同 C 语言中的流（stream）设定类似，I/O 库提供三种预定义的句柄：
	io.stdin、io.stdout和 io.stderr。因此可以用如下代码直接发送信息到错误流（error stream）

]]

--io.stderr:write(message)


-->暂时的改变当前输入文件，可以使用如下代码：
-- local temp = io.input() -- save current file 
-- io.input("newinput") -- open a new current file 
-- ... -- do something with new input 
-- io.input():close() -- close current file 
-- io.input(temp) -- restore previous current file



--[[

	I/O 优化的一个小技巧

	Lua 中读取整个文件要比一行一行的读取一个文件快的多。尽管我们有时
	候针对较大的文件（几十，几百兆），不可能把一次把它们读取出来。要处理这样的文件
	我们仍然可以一段一段（例如 8kb 一段）的读取它们。同时为了避免切割文件中的行，
	还要在每段后加上一行：

]]



--local lines,rest = f:read(BUFSIZE,"*line")
local BUFSIZE = 2^13 -- 8K 
--local f = io.input(arg[1]) -- open input file 
local f = io.input("tests.lua")
local cc, lc, wc = 0, 0, 0 -- char, line, and word counts 
while true do
	local lines, rest = f:read(BUFSIZE, "*line") 
	if not lines then break end
	if rest then lines = lines .. rest .. '\n' end
		cc = cc + string.len(lines) 
	-- count words in the chunk
	local _,t = string.gsub(lines,"%S+","")
	wc = wc + t
	-- count newlines in the chunk
	_,t = string.gsub(lines,"\n","\n")
	lc = lc + t
end
print(lc,wc,cc)
