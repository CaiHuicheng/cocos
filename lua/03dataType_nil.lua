print(type(a))

tab1 = {key1 = "val1",key2 = "vla2","val3"}

for k,v in pairs(tab1) do
	print(k.."-"..v)
end

-- 	nil 给全局变量或者 table 表里的变量赋一个 nil 值，等同于把它们删掉
tab1.key1 = nil
for k,v in pairs(tab1) do
	print(k.."-"..v)
end

--	nil做比较的时候加上双引号“”

print(type(a)==nil)
print(type(a)=="nil")
