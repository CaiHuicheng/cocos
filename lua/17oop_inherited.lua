--[[
	
	继承是指一个对象直接使用另一对象的属性和方法。可用于扩展基础类的属性和方法。

	以下演示了一个简单的继承实例：


	--class
	shape = {area = 0}
	--function
	function shape:new(o,side)
		o = o or {}
		setmetatable(o,self)
		self.__index = self
		side = side or 0
		self.aera = side*side
		return 0
	end

	--function print area
	function shap:print_area()
		print("面积为：",self.aera)
	end

	square = shap:new()
	--Derived class method new
	function square:new(o,side)
		o = o or shape:new(o,side)
		setmetatable(o,self)
		self __index = self
		return o
	end

]]--


 -- Base class
Shape = {area = 0}
-- 基础类方法 new
function Shape:new (o,side)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  side = side or 0
  self.area = side*side;
  return o
end
-- 基础类方法 printArea
function Shape:printArea ()
  print("shape面积为 ",self.area)
end

-- 创建对象
myshape = Shape:new(nil,10)
myshape:printArea()

Square = Shape:new()
-- 派生类方法 new
function Square:new (o,side)
  o = o or Shape:new(o,side)
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 派生类方法 printArea
function Square:printArea ()
  print("正方形面积为 ",self.area)
end

-- 创建对象
mysquare = Square:new(nil,10)
mysquare:printArea()

Rectangle = Shape:new()
-- 派生类方法 new
function Rectangle:new (o,length,breadth)
  o = o or Shape:new(o)
  setmetatable(o, self)
  self.__index = self
  self.area = length * breadth
  return o
end

-- 派生类方法 printArea
function Rectangle:printArea ()
  print("矩形面积为 ",self.area)
end

-- 创建对象
myrectangle = Rectangle:new(nil,10,20)
myrectangle:printArea()



