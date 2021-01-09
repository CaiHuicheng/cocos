--[[

	在函数参数列表中使用三点 ... 表示函数有可变的参数

--]]

function add(...)  
local s = 0  
  for i, v in ipairs{...} do   --> {...} 表示一个由所有变长参数构成的数组  
    s = s + v  
  end  
  return s  
end  
print(add(3,4,5,6,7))  --->25


-->计算几个数的平均值
function average(...)
   result = 0
   local arg={...}    --> arg 为一个表，局部变量
   for i,v in ipairs(arg) do
      result = result + v
   end
   print("总共传入 " .. #arg .. " 个数")
   return result/#arg
end

print("平均值为",average(10,5,3,4,5,6))


--[[
	可能需要几个固定参数加上可变参数，固定参数必须放在变长参数之前:
--]]

function fwrite( fmt,... )
	return io.write(string.format(fmt,...))
	-- body
end

fwrite("runoob\n")
fwrite("%d%d\n",1,2)



-->遍历变长参数的时候只需要使用 {…}，然而变长参数可能会包含一些 nil
-->那么就可以用 select 函数来访问变长参数了：select('#', …)
do
	function foo( ... )
		for i=1,select('#',...) do
			local arg = select(i,...);
			print("arg",arg);
		end
	end
	foo(1,2,3,4)
end
