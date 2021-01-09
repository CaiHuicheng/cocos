--[[

	debug 库中主要的自省函数是 debug.getinfo

	对于函数 foo 调用 debug.getinfo(foo)，将返回关于这个函数信息的一个表。
这个表有下列一些域：
	
	source，标明函数被定义的地方。如果函数在一个字符串内被定义（通过loadstring），source 就是那个字符串。如果函数在一个文件中定义，source 是@加上文件名。
	
	short_src，source 的简短版本（最多 60 个字符），记录一些有用的错误信息。
	
	linedefined，source 中函数被定义之处的行号。

	what，标明函数类型。如果 foo 是一个普通得 Lua 函数，结果为 "Lua"；如果是一个 C 函数，结果为 "C"；如果是一个 Lua 的主 chunk，结果为 "main"。 

	name，函数的合理名称。
	
	namewhat，上一个字段代表的含义。这个字段的取值可能为：W"global"、"local"、"method"、"field"，或者 ""（空字符串）。空字符串意味着 Lua 没有找到这个函数名。
	
	nups，函数的 upvalues 的个数。
	
	func，函数本身；详细情况看后面


	'n' selects fields name and namewhat 
	'f' selects field func 
	'S' selects fields source, short_src, what, and linedefined 
	'l' selects field currentline 
	'u' selects field nup

]]

-->打印一个活动栈的原始跟踪信息（traceback）：
function traceback()
	local  level = 1
	while true do
		local info = debug.getinfo(level,"Sl")
		if not info then break end
		if info.what == "C" then
			print(level,"C function")
		else
			print(string.format("[%s]:%d",info.short_src,info.currentline))
		end
		level = level + 1
	end
end

--test 
function test()
	print(debug.traceback("stack trace"))
	print(debug.getinfo(1))
	print("stack trace end")
	return 10
end

test()
print(debug.getinfo(1))


-->访问局部变量
--	调用debug库的getlocal函数可以访问任何活动状态的局部变量
--[[
函数由两个参数：
	将要查询的函数的栈级别和变量的索引。
	函数有两个返回值：变量名和变量当前值。
	如果指定的变量的索引大于活动变量个数，getlocal 返回 nil。如果指定的栈级别无效，函数会抛出错误。（你可以使用 debug.getinfo 检查栈级别的有效性）

]]

-->函数中所出现的所有局部变量依次计数，只有在当前函数的范围内是有效的局部变量才会被计数.比如，下面的代码

-- function foo(a,b)
-- 	local x
-- 	local c = a - b
-- 	lcoal a = 1
-- 	while true do 
-- 		local name,value = debug.getlocal(1,a)
-- 		if not name then break end
-- 		print(name,value)
-- 		a = a + 1 
-- 	end
-- end

-- foo(10,20)


function foo()
	local n = 0
	local k = 0
	return function()
		k = n
		n = n + 1
		return n
	end
end

f = foo()
print(f())
print(f())



-->访问Upvalues
--[[

	通过 debug 库的 getupvalue 函数访问 Lua 函数的 upvalues。
	和局部变量不同的是，即使函数不在活动状态他依然有 upvalues（这也就是闭包的意义所在）。
	所以，getupvalue 的第一个参数不是栈级别而是一个函数（精确的说应该是一个闭包），第二个
	参数是 upvalue 的索引。Lua 按照 upvalue 在一个函数中被引用(refer)的顺序依次编号，
	因为一个函数不能有两个相同名字的 upvalues，所以这个顺序和 upvalue 并没什么关联（relevant）。
	可以使用函数 ebug.setupvalue 修改 upvalues。
	有三个参数：
	一个闭包，
	一个 upvalues 索引
	一个新的 upvalue 值。和 setlocal 类似，这个函数返回 upvalue的名字，或者 nil（如果 upvalue 索引超出索引范围）
	

]]
local i = 1
repeat
	name,val = debug.getupvalue(counter,i)
	if name then
		print("index",i,name,"=",val)
		if(name == "n")then
			debug.setupvalue(counter,2,10)
		end
		i = i + 1
	end -- if
until not name

print(f())


-->Hooks
--[[
debug 库的 hook 是这样一种机制：注册一个函数，用来在程序运行中某一事件到达时被调用。
有四种可以触发一个 hook 的事件：
	当 Lua 调用一个函数的时候 call 事件发生；
	每次函数返回的时候，return 事件发生；
	Lua 开始执行代码的新行时候，line 事件发生；
	运行指定数目的指令之后，count 事件发生。
Lua 使用单个参数调用 hooks，参数为一个描述产生调用的事件："call"、"return"、"line" 或 "count"。另外，对于 line 事件，还可
以传递第二个参数：新行号。我们在一个 hook 内总是可以使用 debug.getinfo 获取更多的信息


]]

-->安装原始的跟踪器：打印解释器执行的每一个新行的行号
-->简单的将 print 函数作为 hook 函数，并指示 Lua 当 line 事件发生时调用 print 函数
debug.sethook(print,"1")

-->可以使用 getinfo 将当前正在执行的文件名信息加上去，使得跟踪器稍微精致点的：
function trace(event,value)
	local s = debug.getinfo(2).short_src
	print(s..":"..line)
end
debug.sethook(trace,"1")




-->profiles
--[[

	debug 库名字上看来是一个调式库，除了用于调式以外，还可以用于完成其他任务。
	这种常见的任务就是 profiling。对于一个实时的 profile 来说（For a profile with timing），
	最好使用 C 接口来完成：
		对于每一个 hook 过多的 Lua 调用代价太大并且通常会导致测量的结果不准确。
		然而，对于计数的 profiles 而言，Lua 代码可以很好的胜任。

]]
-->下面这部分我们将实现一个简单的 profiler：列出在程序运行过程中，每一个函数被调用的次数:
--[[

	我们程序的主要数据结构是两张表，一张关联函数和他们调用次数的表，一张关联
	函数和函数名的表。这两个表的索引下标是函数本身。

]]
local counters = {}
local names = {}


--[[

	在 profiling 之后，我们可以访问函数名数据，但是记住：在函数在活动状态的情况
	下，可以得到比较好的结果，因为那时候 Lua 会察看正在运行的函数的代码来查找指定
	的函数名。
	现在我们定义hook 函数，他的任务就是获取正在执行的函数并将对应的计数器加1；
	同时这个 hook 函数也收集函数名信息

]]
local function hook()
	local f = debug.getinfo(2,"f").func
	if counters[f] == nil then
		counters[f] = 1
		names[f] = debug.getinfo(2,"Sn")
	else
		counters[f] = counters[f] +１
	end
end

--[[

下一步就是使用这个 hook 运行程序，我们假设程序的主 chunk 在一个文件内，并且
用户将这个文件名作为 profiler 的参数：
	prompt> lua profiler main-prog

]]

local f = assert(localfile(arg[1]))
debug.sethook(hook,"c")	-->turn on the hook
f()						-->run the main progarm
debug.sethook()			-->turn off the hook

--[[

	最后一步是显示结果，下一个函数为一个函数产生名称，因为在 Lua 中的函数名不
	确定，所以我们对每一个函数加上他的位置信息，型如 file:line 。如果一个函数没有名
	字，那么我们只用它的位置表示。如果一个函数是 C 函数，我们只是用它的名字表示（他
	没有位置信息）。

]]

function getname(func)
	local  n = name[func]
	if n.what == "C" then
		return n.name
	end
	local loc = string.format("[%s]:%s",n.short_src,n.linedefined)
	if n.namewhat ~= "" then
		return string.format("%s (%s)",loc,n.name)
	else
		return string.format("%s",loc)
	end
end

-->打印每一个函数和他的计数器：
for func,count in pairs(counters) do
	print(getname(func),count)
end
