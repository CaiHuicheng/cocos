--[[
	简单 IO 模式

	简单模式的所有操作都是在两个当前文件之上。I/O 库将当前输入文件作为标准输
	入（stdin），将当前输出文件作为标准输出（stdout）

--]]

io.write("sin(3) = ",math.sin(3),"\n")
io.write(string.format("sin(3) = %.4f\n",math.sin(3)))

-->!编写代码时应当避免像 io.write(a..b..c)；这样的书写，这同 io.write(a,b,c)的效果是一样的

print("hello", "Lua"); print("Hi")
-- hello	Lua
-- Hi
io.write("hello", "Lua"); io.write("Hi", "\n")
--> helloLuaHi


--[[

	"*all" 读取整个文件
	"*line" 读取下一行
	"*number" 从串中转换出一个数值
	num 读取 num 个字符到串

	io.read("*all")函数从当前位置读取整个输入文件。
	如果当前位置在文件末尾，或者文件为空，函数将返回空串。

]]

-- t = io.read("*all") -- read the whole file 
-- t = string.gsub(t, ...) -- do the job 
-- io.write(t) -- write the file

-->处理字符串的例子

t = io.read("*all")
t = string.gsub(t,"([\128-\255=])",function(c)
	return string.format("=%02X",string.byte(c))
end)
io.write(t)

--[[

	io.read("*line")函数返回当前输入文件的下一行（不包含最后的换行符）。当到达文
	件末尾，返回值为 nil（表示没有下一行可返回）。该读取方式是 read 函数的默认方式，
	所以可以简写为 io.read()。通常使用这种方式读取文件是由于对文件的操作是自然逐行
	进行的，否则更倾向于使用*all 一次读取整个文件，或者稍后见到的逐块的读取文件。
	
]]

local count = 1
while true do 
	local line = io.read()
	if line == nil then break end
	io.write(string.format("%6d ",count),line,"\n")
	count = count + 1
end

local lines = {}

-- read the lines in table 'lines'

for line in io.lines() do
	table.insert(lines,line)
end

--sort
table.sort(lines)

--write all the lines
for i,l in ipairs(lines) do io.write(l,"\n")end


-->打印出每行最大的一个数，就可以使用一次 read 函数调用来读取出每行的全部三个数字：
while true do 
	local n1,n2,n3 = io.read("*number","*number","*number")
	if not n1 then break end
	print(math.max(n1,n2,n3))
end

-->在任何情况下，都应该考虑选择使用 io.read 函数的 " *.all " 选项读取整个文件，然后使用 gfind 函数来分解：

local pat = "(%S+)%s+(%S+)%s+(%S+)%s+"
for n1, n2, n3 in string.gfind(io.read("*all"), pat) do
	print(math.max(n1,n2,n3))
end


--[[
除了基本读取方式外，还可以将数值 n 作为 read 函数的参数。在这样的情况下 read
函数将尝试从输入文件中读取 n 个字符。如果无法读取到任何字符（已经到了文件末尾），
函数返回 nil。否则返回一个最多包含 n 个字符的串。以下是关于该 read 函数参数的一
个进行高效文件复制的例子程序（当然是指在 Lua 中）

]]
local size = 2^13
while true do
	local block = io.read(size)
	if not block then break end
	io.write(block)
end
