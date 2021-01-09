--[[

	搞清楚保存 package 的文件名和 package 名的关系。当然，将他们联系起来是一个好的想法，
	因为 require 命令使用文件而不是 packages。一种解决方法是在 package 的后面加上后缀
	（比如.lua）来命名文件。Lua 并不需要固定的扩展名，而是由你的路径设置决定。
	例如，如果你的路径包含："/usr/local/lualibs/?.lua"，那么复数 package 可能保存在一个 complex.lua 文件中。

]]--
local P = {}		-- package 
if _REQUIREDNAME == nil then
	complex = P
else
	 _G{_REQUIREDNAME} = P
end


--[[

	package 的所有公有成员的定义放在一起，例如，我们可以在一个独
	立分开的 chunk 中给我们的复数 package 增加一个新的函数

]]--

function complex.div(c1,c2)
	return complex.mul(c1,complex.inv(c2))
end

--[[

	package 外部，如果我们需要经常使用某个函数，我们可以给他们定义一个局部变量名
	
]]
local add ,i = complex.add,complex.i
c1 = add(complex.new(10,20),i)

--[[

	我们不想一遍又一遍的重写package名，我们用一个短的局部变量表示package：

]]

local C = complex
c1 = C.add(complex.new(12,23),C.i)

--[[
	写一个函数拆开 package 也是很容易的，将 package 中所有的名字放到全局命名空
间即可：
	function openpackage (ns) 
		for n,v in pairs(ns) do _G[n] = v end
	end 
	openpackage(complex) 
	c1 = mul(new(10, 20), i)

]]

--[[

你担心打开 package 的时候会有命名冲突，可以在赋值以前检查一下名字是否
存在

]]
function openpackage( ns )
	for n,v in ipairs(ns) do
		if _G[n] ~= nil then
			error("name clash: " .. n .. " is already defined") 
 		end 
 	_G[n] = v 
	end 
end
