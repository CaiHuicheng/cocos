--[[

	1、if then else
	2、while
	3、repeat
	4、数字型for
	5、泛型for
	6、break与return
--]]

--1
if a < 0 then a = 0 end
if line>MAXLINES then
	showpage()
	line = 0
end

--2
local i = 1
while a[i] do
	print(a[i])
	i = i+1
end

--3 repeat repeat-until 重复执行循环体直到条件为真时结束
repeat
	line = io.read()
until line ~= ""
print(line)

local sqr = x/2
repeat
	sqr = (sqr+x/sqr)/2
	local error = math.abs(sqr^2 - x)
until error < x/10000

--4
--[[
for var=exp1,exp2,exp3 do
	<执行体>
end
]]
for i=1,f(x) do
	print(i)
end

--在一个列表查找一个值
local found = nil
for i=1,#a do
	if a[i]<0 then
		found = i
		break
	end
end
print(found)


--5泛型for
days = {"sunday","Monday","Tuesday","Wednesday","Thursday","Friday","saturday"}

for k,v in pairs(days) do
	print(k.."="..v)
end


--break and return 
local i = 1
while a[i] do
	if a[i] == v then break end
	i = i+1
end

function foo( ... )
	-- body
	-- return --<<语法错误
	do return end --OK
end

    
