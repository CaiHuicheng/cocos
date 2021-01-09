--[[

错误处理与异常

function foo()
	<一些代码>
	if 未逾期的条件 then error() end
	<一些代码>
	print(a[i])		--潜在的错误：a可能不是一个table
	<一些代码>
	end

-->pcall 来调用foo：
	if pcall(foo) then
	--在执行foo时没有发生错误
		<常规代码>
	else、
	--foo引发了一个错误，采取适当的行动
	end
	
-->在调用pcall时可以传入一个匿名函数
	if pcall(function()
		<受保护的代码>
	end) then
		<常规代码>
	else
		<错误处理代码>
	end

--]]

-->1、pcall
--[[

	if pcall(function_name, ….) then
		-- no error
	else
		-- some error
	end

--]]
-->test
--true
print(pcall(function(i) print(i) end, 33))
--false
--print(pcall(function(i) print(i) error('error..') end, 33))



-->2、xpcall
--[[

	xpcall函数，xpcall接收第二个参数——一个错误处理函数
	当错误发生时，Lua会在调用桟展看（unwind）前调用错误处理函数
	于是就可以在这个函数中使用debug库来获取关于错误的额外信息

--]]
-->test
print(xpcall(function(i) print(i) error('error..') end, function() print(debug.traceback()) end, 33))


