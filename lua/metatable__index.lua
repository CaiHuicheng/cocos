local mt = {}
mt.__index = function(t,key)
	return "it is"..key
end

t = {1,2,3}
print(t.key)
setmetatable(t,mt)
print(t.key)