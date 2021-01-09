--[[

	循环迭代器 --> 消费者与生产者的一种特例

	一个迭代器会产生一些内容，循环体会消费这些内容

--]]

-->例子：遍历某个数组的所有排列组合形式


-->将数组元素都依次放到最后一个位置，然后递归生成其余元素的排列
function permgen(a,n)
	n = n or #a
	if n <= 1 then
		--printResult(a)
		coroutine.yield(a)
	else
		for i=1,n do
			a[n],a[i] = a[i],a[n]
			permgen(a,n-1)
			a[n],a[i] = a[i],a[n]
		end
	end
end

-->打印每次改变的数组
function printResult(a)
	for i=1,#a do
		io.write(a[i]," ")
	end
	io.write("\n")
end


-->方法1
-- function permutations(a)
-- 	local co = coroutine.create(function () permgen(a) end)
-- 	return function()
-- 		local code,res = coroutine.resume(co)
-- 		return res
-- 	end
-- end

--方法2
function permutations( a )
	return coroutine.wrap(function() permgen(a) end)
end

--permgen({1,2,3,4,5,6})

for p in permutations{"a","b","c"} do
	printResult(p)
end



