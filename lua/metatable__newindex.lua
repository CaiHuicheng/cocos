local mt = {}
mt.__newindex = function(t,index,value)
	print("index is "..index)
	print("vlaue is "..value)
end

t = {key = "it is key"}
setmetatable(t,mt)
print(t.key)
t.newkey = 10
print(t.newkey)