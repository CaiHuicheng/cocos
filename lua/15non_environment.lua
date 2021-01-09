--[[

	Lua 5.0 允许每个函数可以有自己的环境来改善这个问题，听起来这很奇怪；毕竟，
	全局变量表的目的就是为了全局性使用。然而在 Section 15.4 我们将看到这个机制带来很
	多有趣的结构，全局的值依然是随处可以获取的。

	可以使用 setfenv 函数来改变一个函数的环境。
	Setfenv 接受函数和新的环境作为参
	数。除了使用函数本身，还可以指定一个数字表示栈顶的活动函数。数字 1 代表当前函
	数，数字 2 代表调用当前函数的函数（这对写一个辅助函数来改变他们调用者的环境是
	很方便的）依此类推。下面这段代码是企图应用 setfenv 失败的例子：

	a = 1 -- create a global variable 
	-- change current environment to a new empty table 
	setfenv(1, {}) 
	print(a)

--]]

--[[

	在单独的 chunk 内运行这段代码，如果交互模式逐行运行他，每一行
	都是一个不同的函数，调用 setfenv 只会影响他自己的那一行。）一旦改变了运行的环境，
	所有全局访问都使用这个新的表，如果她为空，你就丢失所有你的全局变量，甚至_G，
	所以，你应该首先使用一些有用的值封装（populate）她，比如老的环境：

]]--

-->Lua 5.1可用
-- a = 1  -->global variable

-- setfenv(1,{_G = _G})
-- _G.print(a)	-->nil
-- _G.print(_G.a)	-->1


a = 1 
local newgt = {} -- create new environment 
setmetatable(newgt, {__index = _G}) 
setfenv(1, newgt) -- set it 
print(a) --> 1

a = 10 
print(a) --> 10 
print(_G.a) --> 1 
_G.a = 20 
print(_G.a) --> 20