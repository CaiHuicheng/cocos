
--[[

	无状态的迭代器 ： 自身不保存任何状态的迭代器

	可以在多个循环使用同一个无状态迭代器，避免创建新的closure开销

--]]

a = {"one","two","three"}
for i,v in ipairs(a) do
	print(i,v)
end


local function iter( a,i )
	-- body
	i  = i + 1
	local v = a[i]
	if v then
		return i,v
	end
end


-->ipairs 调用iter(a,0)..iter(a,n-1)
function ipairs( a )
 	-- body
 	return iter,a,0
 end

--> pairs 调用next(t,nil)
 function pairs( t )
 	-- body
 	return next,t,nil
 end


 -->例子 : 遍历链表的迭代器
--[[
 local function getnext( list,node )
 	if not node then
 		return list
 	else
 		return node.next
 	end
 end

 function traverse(list)
 	-- body
 	return getnext,list,nil
 end
]]


-->例子： n的平方
function square(iteratorMaxCount,currentNumber)
   if currentNumber<iteratorMaxCount
   then
      currentNumber = currentNumber+1
   return currentNumber, currentNumber*currentNumber
   end
end

for i,n in square,3,0
do
   print(i,n)
end