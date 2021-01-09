--[[

	错误消息就是传递给error函数的值
	只要错误消息是一个字符串，Lua就会附加一些关于错误发生位置的信息

--]]

local status,err = pcall(function () a = "a" + 1 end)
print(err)
	-->stdin:1:attempt to perform arithmetic on a string value


local status,err = pcall(function () error("myerror") end)
print(err)
	-->stdin:1:my error
