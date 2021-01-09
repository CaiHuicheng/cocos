--[[
字符串缓冲
--]]
 
-- 字符串拼接低效操作
-- 读取整个文件的内容，保存在变量中
 
local buff = ""
for line in io.lines() do
	buff = buff .. line .. "\n"
end

--[[

	用table作为一个缓冲区，用到一个关键函数 table.concat

--]]
local t= {}
for line in io.lines() do
    t[#t+1]=line	
end
t[#t+1] = ""
table.concat(t,"\n")

 
--[[
代码说明：
1. io.lines()默认不读取换行'\n'，所以在最后添加换行符
2. lua里字符串是常量，即不可修改，当执行buff = buff .. line .. "\n"时，
会重新申请一段内存，将原来buff里的值拷贝到新的buff中，然后将line的值和‘\n’拷贝到buff中
3. lua虚拟机会进行垃圾回收，当可回收的内存达到一定值，会进行垃圾回收。
所以原来buff占用的内存累计起来会不断被回收掉，导致执行效率较低。
--]]
 
--[[ 实际上，通常使用io.read("*all")操作读取整个文件。
但是当文件大小大于机器内存时，这种方法就使用不了。
这时可以利用io.read("*all")的实现原理自己实现效率较高的读取文件的操作。
--]]
 
function newStack()
	return {""} -- 栈底是空字符串
end
 
function addString(stack, str)
	table.insert(stack, str) -- 字符串入栈
 
	for i = table.getn(stack) - 1, 1, -1 do
		if string.len(stack[i]) > string.len(stack[i + 1]) then
			break
		end
 
		 -- 上一个字符串比下一个字符串长，就将上一个字符串合并到下一个字符串里
		stack[i] = stack[i] .. table.remove(stack)
	end
end
 
local s = newStack()
for line in io.lines() do
	addString(s, line .. "\n")
end
 
 
s = table.concat(s, "\n") --这里有一个问题，最后没有换行符
print(s)
 
-- 其中一个解决办法是：
s = table.concat(s, "\n")
s = s .. '\n' --这种方法里会进行字符串的拷贝，效率较低
print(s)
 
-- 另一种方法是：
table.insert(s, '\n')
s = table.concat(s, "\n")
print(s)




