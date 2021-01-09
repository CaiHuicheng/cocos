local metaarray = getmetatable(newarray(1)) 
metaarray.__index = array.get 
metaarray.__newindex = array.set

a = array.new(1000) 
a[10] = 3.4 -- setarray 
print(a[10]) -- getarray --> 3.4