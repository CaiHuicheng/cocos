--[[

	序列化一些数据，为了将数据转换为字节流或者字符流
	这样就可以保存到文件或者通过网络发送出去。
	Lua代码中描述序列化的数据，在这种方式下，运行读取程序即可从代码中构造出保存的值
	varname = 来保存一个全局变量的值

--]]

--》对于数值
function serialize( o )
	if type(o) == "number" then
		io.write(o)
	else 
		-- ...
	end
end

--》对于字符串
if type(o) == "string" then
	io.write("'",o,"'")
end

--》对于特殊字符的处理（包含引号或者换行符）、
if type(o) == "string" then
	io.write("[[", o,"]]")
end

-->!!!双引号是针对手写的字符串的而不是针对自动产生的字符串。

-- 如果有人恶意的引导你的程序去使用 "]]..os.execute('rm *')..[[ "
-- 这样的方式去保存某些东西（比如它可能提供字符串作为地址）你最终的 chunk 将是这个样子：
-- varname = [[ ]]..os.execute('rm *')..[[ ]] 


-->string 标准库提供了格式化函数专门提供"%q"选项
function serialize2(o)
	-- body
	if type(o) == "number" then
		io.write(o)
	elseif type(o) == "string" then
		io.write(string.format("%q",o))
	else 
		-- ... 
	end
end

--》对于表(无循环table)

function serialize3(o)
	-- body
	if type(o) == "number" then
		io.write(o)
	elseif type(o) == "string" then
		io.write(format("%q",o))
	elseif type(o) == "table" then
		io.write("{\n")
		for k,v in pairs(o) do
			io.write(" ",k," = ")
			serialize3(v)
			io.write("}\n")
		end
	io.write("}\n")
	else
		error("cannot serialize a" .. type(o))
	end
end

--[[

如果表中有不符合 Lua 语法的数字关键字或者字符串关键字，上面的代码将碰到麻烦。
一个简单的解决这个难题的方法是将：
	io.write(" ", k, " = ") 
	改为 
	io.write(" [") 
	serialize(k) 
	io.write(") = ") 
	这样一来，我们改善了我们的函数的健壮性，比较一下两次的结果：
	-- result of serialize{a=12, b='Lua', key='another "one"'} 
	-- 第一个版本
	{ 
	a = 12, 
	b = "Lua", 
	key = "another \"one\"", 
	} 
	-- 第二个版本
	{ 
	["a"] = 12, 
	["b"] = "Lua", 
	["key"] = "another \"one\"", 
	} 

	可以通过测试每一种情况，看是否需要方括号
	将 io.write(" ", k, " = ") 改为：
	io.write("[);serialize(k);io.write("]")即可。


--]]


--》对于表（有循环table）

-->要做一个限制：要保存的 table 只有一个字符串或者数字关键字。下面的这个函数序列化基本类型并返回结果
function basic_serialize( o )
	if type(o) == "number" then
		return tostring(o)
	else
		return string.format("%q",o)
	end
end

-->这个函数，saved 这个参数是上面提到的记录已经保存的表的踪迹的 table。
function save (name, value, saved) 
	saved = saved or {} -- initial value 
	io.write(name, " = ") 
	if type(value) == "number" or type(value) == "string" then
		io.write(basic_serialize(value), "\n") 
	elseif type(value) == "table" then
		if saved[value] then -- value already saved? 
			-- use its previous name 
			io.write(saved[value], "\n") 
		else 
			saved[value] = name -- save name for next time 
			io.write("{}\n") -- create a new table 
			for k,v in pairs(value) do -- save its fields 
				local fieldname = string.format("%s[%s]", name, basic_serialize(k)) 
				save(fieldname, v, saved) 
			end 
		end 
	else 
	 error("cannot save a " .. type(value)) 
	end 
end 

--》例子：
a = {x=1, y=2; {3,4,5}} 
a[2] = a -- cycle 
a.z = a[1] -- shared sub-table 
save('a',a)



--》例子：
a = {{"one", "two"}, 3} 
b = {k = a[1]} 
--保存它们：
save('a', a) 
save('b', b) 
--结果将分别包含相同部分：
a = {} 
a[1] = {} 
a[1][1] = "one"
a[1][2] = "two"
a[2] = 3 
b = {} 
b["k"] = {} 
b["k"][1] = "one"
b["k"][2] = "two"
--然而如果我们使用同一个 saved 表来调用 save 函数：
local t = {} 
save('a', a, t) 
save('b', b, t) 
--结果将共享相同部分：
a = {} 
a[1] = {} 
a[1][1] = "one"
a[1][2] = "two"
a[2] = 3 
b = {} 
b["k"] = a[1] 
