--[[

	复杂状态的迭代器实现：
	1、对于泛型for提供一个恒定状态和一个控制变量用于保存
	2、对于复杂状态的解决方法是用closure 或者 table

--]]

local iterator

function allwords()
	-- body
	local state = {line = io.read(),pos = 1}
	return iterator,state
end

-->iterator函数真正工作
function iterator( state )
	while state.line do		-->有效行内容就进入循环
		--搜索下一个单词
		local s,e = string.find(state.line,"%W+",state.pos)
		if s then
			state.pos = e + 1
			return string.sub(state.line,s,e)
		else						--没有找到单词
			state.line = io.read() 	--尝试下一行
			state.pos = 1
		end
	end
	return nil
end

array = {"Google", "Runoob"}

function elementIterator (collection)
   local index = 0
   local count = #collection
   -- 闭包函数
   return function ()
      index = index + 1
      if index <= count
      then
         --  返回迭代器的当前元素
         return collection[index]
      end
   end
end

for element in elementIterator(array)
do
   print(element)
end