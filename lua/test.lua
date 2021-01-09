--[[

	Lua中创建一个模块最简单的方法是：
	创建一个table，并将所有需要导出的函数放入其中，最后返回这个table就可以了。
	相当于将导出的函数作为table的一个字段，在Lua中函数是第一类值，提供了天然的优势。
	来写一个我们自己的模块，代码如下：


complex = {}    -- 全局的变量，模块名称

 
function complex.new(r, i) return {r = r, i = i} end


-- 定义一个常量i

complex.i = complex.new(0, 1)

 
function complex.add(c1, c2)

    return complex.new(c1.r + c2.r, c1.i + c2.i)

end


function complex.sub(c1, c2)

    return complex.new(c1.r - c2.r, c1.i - c2.i)

end
 

return complex  -- 返回模块的table


]]

test_base = {}
 
function test_base:Func1()
   print("test_base Func1")
end
 
function Func2()
   print("test_base Func2")
end
 
return test_base


--[[

	会发现必须显式地将模块名放到每个函数定义中；
	而且，一个函数在调用同一个模块中的另一个函数时，必须限定被调用函数的名称，
	然而我们可以稍作变通，在模块中定义一个局部的table类型的变量，
	通过这个局部的变量来定义和调用模块内的函数，然后将这个局部名称赋予模块的最终的名称，
	代码如下：



local M = {}    -- 局部的变量

complex = M     -- 将这个局部变量最终赋值给模块名

 

function M.new(r, i) return {r = r, i = i} end

 

-- 定义一个常量i

M.i = M.new(0, 1)

 

function M.add(c1, c2)

    return M.new(c1.r + c2.r, c1.i + c2.i)

end

 

function M.sub(c1, c2)

    return M.new(c1.r - c2.r, c1.i - c2.i)

end

 

return complex  -- 返回模块的table



]]



--[[

我们在模块内部其实使用的是一个局部的变量。
这样看起来比较简单粗暴，但是每个函数仍需要一个前缀。
实际上，我们可以完全避免写模块名，因为require会将模块名作为参数传给模块。

]]

-- 打印参数
-- for i = 1, select('#',...) do
-- 	print(select(i,...))
-- end
-- local M = {};	-- 局部的变量
-- local moduleName = ...;
-- _G[moduleName] = M     -- 将这个局部变量最终赋值给模块名
-- function M.new(r, i) return {r = r, i = i} end
-- M.i = M.new(0, 1)
-- function M.add(c1, c2)
-- 	return M.new(c1.r + c2.r, c1.i + c2.i)
-- end
--  
-- function M.sub(c1, c2)
-- 	return M.new(c1.r - c2.r, c1.i - c2.i)
-- end

-- return M -- 返回模块的table


module("test_module",package.seeall);
function Func1()
   print("test_module Func1")
end
 
local function Func2()
   print("test_module Func2")
end



--》环境
--[[

1.在使用了module函数的脚本，使用require并不能返回一个table，而是一个bool值，这个值告诉你是否加载成功

2.require一个使用了module函数的脚本，结果会被存在_G的全局表里，所以我们可以使用JCTest2:Func1（）去调用函数

3.这个方式的require的结果也会在package.loaded这个table中存放，输出的100,证明了他的唯一性

4.如果在JCTest2.lua 里的函数前面加上 local，则无法访问到该函数（变量也一样，当然lua里函数也是变量）

5.虽然Func1并没有显示指明他的所属关系，但它并非是一个全局函数(重要！！！)

上面的论点5，是module函数的关键概念。

module函数的作用是创造出一个新的“环境”，在这个模块的所有全局函数都只属于这个环境，如果外部需要调用，我们只能需要使用论点2的方式。而如果，在模块中使用了local 定义变量，很抱歉，这个变量将不能被外部调用

]]--

local print = print;   --相当于 local print = _G.print
module("test_environment");
function Func1()
   print("test_environment Func1")
end
 
local function Func2()
   print("test_environment Func2")
end