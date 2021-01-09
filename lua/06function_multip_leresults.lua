--[[

optional_function_scope function function_name( argument1, argument2, argument3..., argumentn)
    function_body
    return result_params_comma_separated
end


function add(a)
	-- body
	local sum = 0
	for i,v in ipairs(a) do
		sum = sum + v
	end
	return sum
end

]]

--全局计数器
function incCount(n)
	n = n or 1
	count = count + n
end


function max(num1, num2)

   if (num1 > num2) then
      result = num1;
   else
      result = num2;
   end

   return result;
end
-- 调用函数
print("两值比较最大值为 ",max(10,4))
print("两值比较最大值为 ",max(5,6))

--Lua 中我们可以将函数作为参数传递给函数
myprint = function(param)
   print("这是打印函数 -   ##",param,"##")
end

function add(num1,num2,functionPrint)
   result = num1 + num2
   -- 调用传递的函数参数
   functionPrint(result)
end
myprint(10)
-- myprint 函数作为参数传递
add(2,5,myprint)


--多重返回值	在return后面列出返回值
-->查找数组中的最大元素
function maximun(a)
	-- body
	local mi = 1
	local m = a[mi]
	for i,val in ipairs(a) do
		if val>m then
			mi = i;m = val
		end
	end
	return m,mi
end

print(maximun({8,10,23,12,5})) -->23 3


-->unpack 接受一个数组作为参数，并从下标为1开始返回该数组的所有的元素

--print(unpack{10,20,30})
--a,b = unpack{10,20,30}
--print(a,b)