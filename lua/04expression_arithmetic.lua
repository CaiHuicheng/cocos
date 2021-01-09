--[[
	
	+	加法
	-	减法
	*	乘法
	/	除法
	^	指数
	%	取模
	-	负号

例如：
	x^0.5	计算x的平方根

--]]

--a % b == a - floor(a/b)*b

--精确到小数点XX位
x = math.pi
print(x - x%0.01)


local x = 10
function isturnback( angle )
	-- body
	angle = angle % 360
	--弧度
	--angle = angle % (math.pi*2)
	return (math.abs(angle-180)<x)
end


print(isturnback(-180)) -->true





