--[[

	面向对象特征
	1） 封装：指能够把一个实体的信息、功能、响应都装入一个单独的对象中的特性。
	2） 继承：继承的方法允许在不改动原程序的基础上对其进行扩充，这样使得原功能得以保存，而新功能也得以扩展。这有利于减少重复编码，提高软件的开发效率。
	3） 多态：同一操作作用于不同的对象，可以有不同的解释，产生不同的执行结果。在运行时，可以通过指向基类的指针，来调用实现派生类中的方法。
	4）抽象：抽象(Abstraction)是简化复杂的现实问题的途径，它可以为具体问题找到最恰当的类定义，并且可以在最恰当的继承级别解释问题。


	Lua 中面向对象:
	LUA中最基本的结构是table，所以需要用table来描述对象的属性。
	lua中的function可以用来表示方法。那么LUA中的类可以通过table + function模拟出来。


	-->例子：
	account = {balance = 0}

	function account.withdraw( v )
		account.balance = account.balance - v
	end

	-->test
	account.withdraw(100.0)
	print(account.balance)

]]

-->简单的类包含了三个属性： area, length 和 breadth，printArea方法用于打印计算结果：
--class
rectangle = {area = 0,length = 0,breadth = 0}

--派生类的方法 new
function rectangle:new( o,length,breadth )
	o = o or {}
	setmetatable(o,self)	--setmetatable 函数来替换掉 table 的 metatable
	self.__index = self
	self.length = length or 0
	self.breadth = breadth or 0
	self.area = length*breadth;
	return o
end

--test
function rectangle:printArea()
	print("矩形面积为：",self.area)
end

r = rectangle:new(nil,10,20)
r:printArea()
print("长度："..r.length)
