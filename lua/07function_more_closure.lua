--[[

lua容易混淆的概念
	函数与所有其他值一样都是匿名的
	在讨论一个函数时，实际上在讨论一个持有某个函数变量


-->例子
a = {b = print}
a.b("Hello world")
--'print'引用了正弦函数
print = math.sin
a.b(print(1)) -->0.8414709848079
--'sin'引用了print函数
sin = a.b
sin(10,20)

--函数构造方式1
function foo( x )
	return 2*x
end

--函数构造方式2
foo = function (x)
	return 2*x
end


	table.sort用法


network = {
	{name = "cai01", IP = "210.26.30.34"},
	{name = "cai12", IP = "210.26.30.23"},
	{name = "cai33", IP = "210.26.23.12"},
	{name = "cai04", IP = "210.26.23.20"},
}
table.sort(network,function (a,b) return (a.name>b.name) 
	-- body
end)

-- for s in pairs(network) do
-- 	for i,v in pairs(s) do
-- 		print("name="..i,"IP="..v)
-- 	end	
-- end

-- local maxI = 4;maxJ = 2
-- for i=1,maxI do
-- 	for j=1,maxJ do
-- 		print(network[i][j])
-- 	end
-- end
--]]


--closure 闭合函数
names = {"Peter","Pual","Mary"}
grades = {Mary = 10,Pual = 7,Peter = 8}

-- table.sort(names,function (n1,n2)
-- 	-- body
-- 	return grades[n1]>grades[n2]
-- end)


--非局部变量
function sort_by_grade( name,grades )
	table.sort(name,function ( n1,n2 )
		return grades[n1]>grades[n2]
	end)
end

sort_by_grade(names,grades)

for i,v in pairs(grades) do
	print(i.."="..v)
end

-->例子
--[[
function newCounter()
	local i = 0
	return function ()
		i = i + 1
		return i
	end
end

c1 = newCounter()
print(c1())		-->1
print(c1())		-->2


c2 = newCounter()
print(c2())		-->1
print(c1())		-->3
print(c2())		-->2

--]]

--十进制计数器
function digitButton( digit )
	-- body
	return Button{
		label = tostring(digit),
		action = function ()
			-- body
			add_to_display(digit)
		end
	}
end


--重新定义某些函数		重新定义某些预定义函数
-->1
oldSin = math.sin
math.sin = function (x)
	return oldSin(x*math.pi/180)
end
-->2
do
	local oldSin = math.sin
	local k = math.pi/180
	math.sin = function ( x )
		return oldSin(x*k)
	end
end