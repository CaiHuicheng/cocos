--重命名函数
--无效的演示代码
--rename(old="temp.lua",new="temp1.lua")

--将rename修改只接受一个参数,并从这个参数中获取实际的参数
function rename(arg)
	-- body
	return os.rename(arg.old,arg.new)
end


--相同效果代码
rename{old="temp.lua",new="temp1.lua"}



-->windows函数
function Window(options)
	-- body
	if type(options.title) ~= "String" then
		error("not title")
	elseif type(options.width) ~="number" then
		error("not width")
	elseif type(options.height) ~="number" then
		error("not height")
	end

--其他参数都是可选的
	_Window(options.title,
			options.x or 0,		--默认值
			options.y or 0,		--默认值
			options.width,options.height,
			options.background or "white", --默认值
			options.border 	--默认值为false(nil)
		)
end