--[[

	将集合元素作为索引放入一个table中
	对于任意值都无须搜索table，只需要该值来索引table，查看result是否为nil

--]]

reserved = {
	["while"] = true,
	["end"] = true,
	["function"] = true,
	["local"] = true,
 }

 for w in allwords() do
 	if not reserved[w] then
 		--<对‘W’作任意处理>		--‘W’不是保留字
 	end
 end

 -->负责函数 创建集合
function Set( list )
	local  set = {}
	for _,l in ipairs(list) do set[l] = true end
	return set
end

reserved = Set{"while","end","function","local"}


-->Multiset
-->插入一个元素
function insert( bag,element )
	-- body
	bag[element] = (bag[element] or 0) + 1
end
--> 删除一个元素
function remove( bag,element )
	local count = bag[element]
	bag[element] = (count and count > 1) and count - 1 or nil
end