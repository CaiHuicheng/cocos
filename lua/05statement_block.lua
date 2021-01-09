--[[
	
	a = 1		全局变量
	local b= 1	局部变量

	block		控制结构体、函数执行体、程序块

	一个语句块跟一个 chunk 相同
	block ::= chunk
	一个语句块可以被显式的写成一个单独的语句段
	stat ::= do block end
--]]


x = 10

--程序块1
local i = 1 --程序块的局部变量
if i>20 then
	local x = 20	--局部变量
	print(x+2)
else
	print(x)		--全局变量
end


--程序块2
do
	local a = 3
	local b = 4
	local c = 5
	local a2 = 2*a
	local d = (b^2-4*a*c)^(1/2)
	x1 = (-b+d)/a2
	x2 = (-b-d)/a2
end
print(x1,x2)

--程序块3
--任何声明local的表达式都会改变块中所声明local的值
local a,b =1,10
if a<b then
	print(a)
	local a
	print(a)
end
print(a,b)





