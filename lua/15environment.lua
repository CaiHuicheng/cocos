--[[

	environment普通表来保存所有的全局变量
	（更精确的说，Lua
在一系列的 environment 中保存他的“global”变量，但是我们有时候可以忽略这种多样
性）这种结果的优点之一是他简化了 Lua 的内部实现，因为对于所有的全局变量没有必
要非要有不同的数据结构。另一个(主要的)优点是我们可以像其他表一样操作这个保存
全局变量的表。为了简化操作，Lua 将环境本身存储在一个全局变量_G 中，（_G._G 等 于_G）。

--]]

--下面代码打印在当前环境中所有的全局变量的名字：
--for n in pairs(_G) do print(n) end



--1、使用动态名字访问全局变量
--[[

	赋值操作对于访问和修改全局变量已经足够。然而，我们经常需要一些原编
	程（meta-programming）的方式，比如当我们需要操纵一个名字被存储在另一个变量中
	的全局变量，或者需要在运行时才能知道的全局变量。为了获取这种全局变量的值，有
	的程序员可能写出下面类似的代码：


	loadstring("value = " .. varname)()

	or

	value = loadstring("return ".. varname)()
	--更高效更简洁的完成同样的功能，代码如下
	value = _G[varname]


	function getfield(f)
	local v = _G
	for w in string.gfind(f,"{%w_}+") do
		v = v[w]
	end
	return value
end

a.b.c.d.e = value
-->等价于
local temp = a.b.c.d
temp.e = v
-->也就是说，我们必须记住最后一个名字，必须独立的处理最后一个域。新的 setfield函数当其中的域（译者注：中间的域肯定是表）不存在的时候还需要创建中间表。

function setfield (f, v) 
	local t = _G -- start with the table of globals 
	for w, d in string.gfind(f, "([%w_]+)(.?)") do
		if d == "." then -- not last field? 
			t[w] = t[w] or {} -- create table if absent 
			t = t[w] -- get the table 
		else -- last field 
			t[w] = v -- do the assignment 
		end 
	end 
end

setfield("t.x.y", 10)

print(t.x.y)
print(getfield("t.x.y"))

]]--



--[[

	声明全局变量

	全局变量不需要声明，虽然这对一些小程序来说很方便
	但程序很大时，一个简单的拼写错误可能引起 bug 并且很难发现
	因为 Lua 所有的全局变量都保存在一个普通的表中，我们可以使用 metatables 来改变访
问全局变量的行为


]]--


setmetatable(_G,{
	__newindex = function ( _,n )
		error("attempt to write to underclared variable "..n,2)
	end,
	__index = function(_,n)
		error("attempt to read underclared variable "..n,2)
	end ,
})

--a = 1
--[[
result:
	lua: E:\ʵϰ\lua\Codes\15environment.lua:92: attempt to write to underclared variable a
stack traceback:
	[C]: in function 'error'
	E:\ʵϰ\lua\Codes\15environment.lua:85: in metamethod '__newindex'
	E:\ʵϰ\lua\Codes\15environment.lua:92: in main chunk
	[C]: in ?
	[Finished in 0.1s]

]]--



--[[
	声明全局变量2


	带有 false 是为了保证新的全局变量不会为 nil。注意：你应该在安装访问控制
	以前（before installing the access control）定义这个函数，否则将得到错误信息：毕竟你
	是在企图创建一个新的全局声明。只要刚才那个函数在正确的地方，你就可以控制你的
	全局变量了：
	if rawget(_G, var) == nil then
	-- 'var' is undeclared 
	 ... 
	end

]]--

local declaredNames = {} 
function declare (name, initval) 
	rawset(_G, name, initval) 
	declaredNames[name] = true
end 
setmetatable(_G, { 
	__newindex = function (t, n, v) 
		if not declaredNames[n] then
			error("attempt to write to undeclared var. "..n, 2) 
		else 
			rawset(t, n, v) -- do the actual set 
		end 
	end, 
	__index = function (_, n) 
		if not declaredNames[n] then
			error("attempt to read undeclared var. "..n, 2) 
		else 
		 	return nil
		end 
	end, 
})


--[[
	result:
	lua: E:\ʵϰ\lua\Codes\15environment.lua:123: attempt to write to underclared variable declare
stack traceback:
	[C]: in function 'error'
	E:\ʵϰ\lua\Codes\15environment.lua:85: in metamethod '__newindex'
	E:\ʵϰ\lua\Codes\15environment.lua:123: in main chunk
	[C]: in ?

]]--


