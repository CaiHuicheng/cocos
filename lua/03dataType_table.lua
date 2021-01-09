--table 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。也可以在表里添加一些数据，直接初始化表
local tal1 = {}
local tal2 = {"apple","pear","orange","grape"}

--表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字或者是字符串。
-- key <--> value

tal1["key"] = "vlaue"
key = 10;
tal1[key] = 22
tal1[key+1] = tal1[key]+11
for v,k in pairs(tal1) do
	print(v..":"..k)
end


--Lua 里表的默认初始索引一般以 1 
for k,v in pairs(tal2) do
	print(k,v)
end

--table 不会固定长度大小，有新数据添加时 table 长度会自动增长，没初始的 table 都是 nil
a3 = {}
for i=1,10 do
	a3[i] = i
end
a3["key1"] = "val"
print(a3["key1"])
print(a3["none"])