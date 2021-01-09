--[[

	数组，就是相同数据类型的元素按一定顺序排列的集合，可以是一维数组和多维数组。

	Lua 数组的索引键值可以使用整数表示，数组的大小不是固定的

--]]

--> lua 下标从1开始
array = {"lua","Test"}

for i=1,2 do
	print(array[i])
end


-->下标索引可以从0开始，也可以从负数开始
array1 = {}
for i=-2,2 do
	array1[i] = i*2
end

for i=-2,2 do
	print(array1[i])
end


