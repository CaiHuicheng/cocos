--[[

	Lua 中的模块 (module) 和包 (package) 详解
	1、require 函数
	2、写一个模块
	3、package.loaded
	4、module 函数等内容.


	require "mod"
	mod.foo()
	local m2 = require "mod2"
	local f = mod2,foo
	f()

--]]


--》1、require函数
--[[

	require 函数的调用形式为 require "模块名"。
	该调用会返回一个由模块函数组成的 table，并且还会定义一个包含该 table 的全局变量。
	在使用 Lua 中的标准库时可以不用显示的调用 require，因为 Lua 已经预先加载了他们。

	require 函数在搜素加载模块时，有一套自定义的模式，如：
	?;?.lua;c:/windows/?;/usr/local/lua/?/?.lua

]]--

local m  =require "io"
m.write("test require")


-->requir 详解

--[[

	Lua 将 require 搜索的模式字符串放在变量 package.path 中。
	当 Lua 启动后，便以环境变量 LUA_PATH 的值来初始化这个变量。
	如果没有找到该环境变量，则使用一个编译时定义的默认路径来初始化。
	如果 require 无法找到与模块名相符的 Lua 文件，就会找 C 程序库。
	C 程序库的搜索模式存放在变量 package.cpath 中

	function require( name )
	-- body
	if not package.loaded[name] then	-->模块是否加载？
		local  loader = findloader(name)
		if loader == nil then
			error("unable to load module"..name)
		end
		package.loaded[name] = true		-->将模块标记为已加载
		local res = loader(name)		--> 初始化模块
		if res ~= loader(name)
			package.loaded[name] = res
		end
	end
	return package.loaded[name]
end

]]--

local jctest = require("test_base")
print("\n")
test_base:Func1()
test_base.num = 100
local test_base = require("test_base")
print(test_base.num)
Func2();
print(_G.test_base)



--》2、packge

--[[

	编写模块的基本方法：
	新建一个文件，命名为 game.lua

]]--

--[[
	game.lua
	local m = {}
	local modeName = ...;
	_G[modeName] = m
	function m.play()
		-- body
		print("module")
	end

	function m.quit()
		-- body
		print("quit m")
	end
	return m;

]]

-- game = require"game"
-- game.play()




--》3、使用环境

--[[

	模块内函数之间的调用仍然要保留模块名的限定符，如果是私有变量还需要加 local 关键字，
	同时不能加模块名限定符。如果需要将私有改为公有，或者反之，都需要一定的修改。
	那又该如何规避这些问题呢？

--]]
print("\n")
require("test_environment")
test_environment:Func1()

--game.quit()


--》4、module

--[[

module 不提供外部访问，必须在调用它之前，为需要访问的外部函数或模块声明适当的局部变量。
然后 Lua 提供了一种更为方便的实现方式，即在调用 module 函数时，多传入一个 package.seeall 的参数，
相当于 setmetatable(M, {__index = _G}) .

如：

module(...,package.seeall)

]]--
print("\n")
local result = require("test_module")
print(result)
test_module:Func1()  --相当于 _G.test_module:Func1()
test_module.num = 100
require("test_module")
print(test_module.num)
print(test_module.Func2);
print(Func2)