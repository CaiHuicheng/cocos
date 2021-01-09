--[[
	非全局的函数
--]]
-->方式1
-- lib = {}
-- lib.foo = function ( x,y ) return x+y end
-- lib.goo = function ( x,y ) return x-y end

-->方式2
lib = {
	foo = function ( x,y ) return x+y end,
	goo = function ( x,y ) return x-y end
}

-->方式3
-- lib = {}
-- function lib.foo( x,y ) return x+y end


-->例子 !n
-->错误示范
--在调用fact(n-1)的地方时，局部变量尚未定义，此表达式调用了一个全局的fact
-- local  fact = function ( n )
-- 	if n == 0 then return 1
-- 	else return n*fact(n-1)
-- 	end
-- end

local fact
fact = function ( n )
	if n == 0 then return 1
	else return n*fact(n-1)
	end
end

print(fact(5))

