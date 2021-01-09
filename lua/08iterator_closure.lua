--[[

	迭代器（iterator）是一种对象，它能够用来遍历标准模板库容器中的部分
	或全部元素，每个迭代器对象代表容器中的确定的地址。在 Lua 中迭代器是
	一种支持指针类型的结构，它可以遍历集合的每一个元素。

--]]

function values(t)
	-- body
	local i = 0
	return function () i = i + 1;return t[i] end
end

t = {10,20,30}
iter = values(t)	-->创建迭代器
while true do
	local element = iter()	-->调用迭代器
	if element == nil then break end
	print(element)
end



-->使用泛型for

for element in values(t) do
	print(element)
end


-->查找单词
function allwords()
	local line = io.read()
	local pos = 1
	return function ()
		while line do
			local s,e = string.find(line,"%W+",pos)
			if s then
				pos = e + 1
				return string.sub(line,s,e)
			else
				line = io.read()
				pos  = 1
			end
		end
		return nil
	end 
end

print(allwords())