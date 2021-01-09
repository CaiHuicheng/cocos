--[[

	多重继承实现关键：

	将函数用作__index。当一个表的 metatable 存在一个__index
	函数时，如果 Lua 调用一个原始表中不存在的函数，Lua 将调用这个__index 指定的函数。
	这样可以用__index 实现在多个父类中查找子类不存在的域


	多重继承意味着一个类拥有多个父类，不能用创建一个类的方法去创建子类。
	取而代之的是，我们定义一个特殊的函数 createClass 来完成这个功能
	将被创建的新类的父类作为这个函数的参数。这个函数创建一个表来表示新类，
	并且将它的metatable 设定为一个可以实现多继承的__index metamethod。
	尽管是多重继承，每一个实例依然属于一个在其中能找得到它需要的方法的单独的类。
	所以，这种类和父类之间的关系与传统的类与实例的关系是有区别的。
	特别是，一个类不能同时是其实例的metatable 又是自己的 metatable。
]]--

-->





-- 在表 "plist" 列表中查找 "k"
local function search (k, plist) 
	for i=1, table.getn(plist) do
		 local v = plist[i][k] 		-- 试试 'i' - 超类
		 if v then return v end
	end 
end

function createClass(...)
	local c = {}	--new class

	-- 类将搜索其列表中的每种方法
	-- parent（'arg' 是父母名单）
	setmetatable(c,{__index = function(t,k)
		local v = search(k,arg)
		t[k] = v 
		return v
	end})

	-- 准备 "c" 成为其实例的元可
	c.__index = c

	-- 为这个新类定义一个新的构造函数
	function c:new( o )
		o = o or {}
		setmetatable(o,c)
		return o
	end
	return c
end

Named = {}

function Named:getname()
	return self.name 
end

function Named:setname(n)
	self.name = n
end

name_account = createClass(account,Named)
account = name_account:new{name = "pual"}
parent(account:getname())

