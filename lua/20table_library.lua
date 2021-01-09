--[[

	Table 库定义了两个函数操纵 array 的大小：getn，返回 array 的大小；setn，设置 array
的大小。

]]

-- print(table.getn{10,2,4})
-- print(table.getn{10,2,nil})
-- print(table.getn{10,2,nil;n =3})
-- print(table.getn{n = 1000})

-- a = {}

-- print(table.getn(a))
-- --table.setn(a,100)	-->不支持 setn
-- print(table.getn(a))

-- a = {n = 10}
-- print(table.getn(a))
-- --table.setn(a,100)	--不支持 setn
-- print(table.getn(a))


-->insert and delete

-- t = {}
-- for line in io.lines() do
-- 	table.insert(t,line)
-- end
-- print(#t)


-->sort
lines = {
	lua_set	= 10,
	lua_get = 50,
	lua_print = 48
}
a = {}
for n in pairs(lines) do table.insert(a,n) end
table.sort(a)
for i,n in ipairs(a) do print(n) end


--[[

	有一个更好的解决方法，我们可以写一个迭代子来根据 key 值遍历这个表。一个可
选的参数 f 可以指定排序的方式。首先，将排序的 keys 放到数组内，然后遍历这个数组，
每一步从原始表中返回 key 和 value：

]]
function pairs_by_keys(t,f)
	local a = {}
	for n in pairs(t) do table.insert(a,n) end
	table.sort(a,f)
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i],t[a[i]]
		end
	end
	return iter
end

for name,line in pairs_by_keys(lines) do
	print(name,line)
end