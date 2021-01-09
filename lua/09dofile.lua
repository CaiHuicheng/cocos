--[[

	dofile 定义

--]]

function dofile( filename )
	local f = assert(loadfile(filename))
	return f()
end


--[[

	loadstring 定义

--]]


i = 32
local i = 0 
-->出错 ：loadstring在lua5.2中已经被弃用了 5.1可用
-- loadstring 优先采用的是全局变量，采用local时i的值会叠加
--f = loadstring("i = i + 1";print(i)) 
-- i = 0
-- f();print(i)
-- f();print(i)


-- 匿名函数采用的是local
f = function () i = i + 1;print(i) end
f()
f()
f()


-->load可用：

load( "print( 'test' )" )( )


-->对一个表达式求值，则必须在其之前添加return
local l = io.read()
local f = assert(loadstring('return "' .. l .. '"'))

print(type(f))
print(type(f()))
print(f())
for i=1,20 do
	x = i
	print(string.rep("*", f()))
end