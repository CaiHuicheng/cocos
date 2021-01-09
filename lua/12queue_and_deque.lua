--[[

	Lua 语言中实现队列（queue）的一种简单方法是使用 table 标准库中的函数 insert 和 remove
	这两个函数可以在一个数组的任意位置插入或删除元素，同时根据所做的操作移动其他元素

	这种移动对于较大的结构来说开销很大。一种更高效的实现是使用两个索引
	一个指向第一个元素，另一个指向最后一个元素。使用这种实现方式，
	如下方式以 O ( 1 ) O(1)O(1) 的时间复杂度同时在首尾两端插入或删除元素了：

--]]

-->双端队列

-- function ListNew()
-- 	return {first = 0,last = -1}
-- end

-->为了避免污染全局名称空间，将在一个table内部定义所有队列的操作
List{}

function List.new()
	-- body
	return {first = 0,last = -1}
end

function List.pushList( list,value )
	local  first = list.first - 1
	list.first = first
	list[first] = value
end

function List.popfirst(list)
	-- body
	local first = list.first
	if first > list.last then error("list is empty") end
	local value = list[first]
	list[first] = nil		--使元素能够被垃圾回收
	list.first = first + 1
	return value
end

function List.popLast(list)
	-- body
	local last = list.last
	if list.first >list.last then error("list is empty") end
	local value = list[last]
	list[last] = nil		--使元素能够被垃圾回收
	list.last = last - 1
	return value
end