--[[

	章节 13.4.3，我们讨论了怎样使用非 nil 的默认值来实现表
	这两种默认值的技术实际上来源于我们前面提
	到的两种通用的技术的特殊应用：对象属性和记忆
	
]]--

--1、第一种方法，使用关联对象属性的方法，将表作为key，默认值作为value，存到一个弱key的weak表中：
local defaults = {}
setmetatable(defaults,{__mode = "k"})
local mt = {
	__index = function(t) return defaults[t] end
}

function setDefault(t,d)
	defaults[t] = d
	setmetatable(t,mt)
end


--2、针对不同的metatable来进行优化，对于每一个具体的默认值，
--生成一个与之对应的metatable，然后以默认值为key，metatable为value，
--存到一个弱value的weak表中：

metas = {}
setmetatable(metas,{__mode = "v"})

setdefault = function (t,d)
	local mt = metas[t]
	if mt == nil then
		mt = (__index =function() return d end)
		metas[d] = mt
	end
	setmetatable(t,mt)
end


--[[

	第一种方法对于每一个table都需要添加一个键值对，但是公用一个metatable。
	第二种方法需要许多个不同的metatable，但拥有相同默认值的table共用一个metatable，
	并且weak表要比第一种方法小。如果你的代码环境中有很多个table，
	但常用默认值只有那么几种，建议选择第二种方法，否则就选择第一种方法。

]]