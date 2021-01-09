local mt = {}

mt.__tostring = function(t)
	local s ="{"
	for i,v in pairs(t) do
		if i > 1 then
			s = s..","
		end
		s = s..v
	end
	s = s.."}"
	return s
end

t = {1,2,3}
print(t)
setmetatable(t,mt)
print(t)