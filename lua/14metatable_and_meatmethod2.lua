--[[

	有默认值的表

--]]

function set_default( t,d )
	-- body
	local  mt = {__index = function () return d end}
	setmetatable(t,mt)
end

tab = {x = 10,y = 20}
print(tab.x,tab.z)	--> nil 10
set_default(tab,0)
print(tab.x,tab.z)	-- 10 0


--[[

	跟踪table的访问
	__index和__newindex都是在table中没有所需访问的index时才发挥作用的
	为了监控某个table的访问状况，我们可以为其提供一个空table作为代理，
	之后再将__index和__newindex元方法重定向到原来的table上，见如下代码：

--]]
t = {}        --原来的table
local _t = t  --保持对原有table的私有访问。
t = {}        --创建代理
--创建元表
local mt = {
    __index = function(table,key)
        print("access to element " .. tostring(key))
        return _t[key]  --通过访问原来的表返回字段值
    end,
    
    __newindex = function(table,key,value)
        print("update of element " .. tostring(key) .. " to " .. tostring(value))
        _t[key] = value  --更新原来的table
    end
}
setmetatable(t,mt)
t[2] = "hello"
print(t[2])
--输出结果为
--update of element 2 to hello
--access to element 2
--hello


--[[
	只读的table
	实现只读table。只需跟踪所有对table的更新操作，并引发一个错误即可

--]]

function readOnly( t )
	-- body
	local  proxy = { }
	local mt = {
		__index = t,
		__newindex = function(t,k,v)
			error("attempt to update a read-only table")
		end
	}
	setmetatable(proxy,mt)
	return proxy
end

days = readOnly{"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
print(days[1])
days[2] = "Noday"
--输出结果为：
--[[
Sunday
lua: d:/test.lua:6: attempt to update a read-only table
stack traceback:
        [C]: in function 'error'
        d:/test.lua:6: in function <d:/test.lua:5>
        d:/test.lua:15: in main chunk
        [C]: ?
]]--





