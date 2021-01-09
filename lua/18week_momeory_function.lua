--[[
	记忆函数--弱引用

	记忆函数结果来进行优化，当你用同样的参数再次调用函数时，它可以自动返回记忆的结果

	每当它收到一个请求，它调用 loadstring 加载字符串，然后调用函数进行处理。
	然而，loadstring 是一个“巨大”的函数，一些命令在服务器中会频繁地使用。
	不需要反复调用 loadstring 和后面接着的 closeconnection（），
	服务器可以通过使用一个辅助 table 来记忆 loadstring 的结果。
	在调用 loadstring 之前，服务器会在这个 table 中寻找这个字符串是否已经有了翻译好的结果。
	如果没有找到，那么（而且只是这个情况）服务器会调用 loadstring 并把这次的结果存入辅助 table。

]]--

local results = {}

function mem_loadstring(s)
	if results[s] then			--results是否存在
		return results[s]		--存在即返回
	else
		local res = loadstring(s)	--不存在，loadstring加载
		results[s] = results        --将值存入results
		return res
	end
end


--[[

这个方案的存储消耗可能是巨大的。尽管如此，它仍然可能会导致意料之外的数据
冗余。尽管一些命令一遍遍的重复执行，但有些命令可能只运行一次。渐渐地，这个 table
积累了服务器所有命令被调用处理后的结果；早晚有一天，它会挤爆服务器的内存。一
个 weak table 提供了对于这个问题的简单解决方案。如果这个结果表中有 weak 值，每次
的垃圾收集循环都会移除当前时间内所有未被使用的结果（通常是差不多全部）：

	local results = {}
	--setmetatable(results, {__mode = "v"}) -- make values weak
	setmetatable(results, {__mode = "kv"})
	function mem_loadstring (s)
	 ... -- as before

]]

-->记忆技术	颜色调解器
function create_rgb(r,g,b)
	return {red = r,green = g,blue = b}
end

--[[
使用记忆技术，我们可以将同样的颜色结果存储在同一个 table 中。为了建立每一种
颜色唯一的 key，我们简单的使用一个分隔符连接颜色索引下标：
--]]
local colors_result = {}
setmetatable(colors_result,{__mode = "v"})
function create_RGB(r,g,b)
	local ey = r.."-"..g.."-"..b
	if colors_result[key] then return colors_result[key]
	else
		local  new_color = {red = r,green = g ,blue = b}
		colors_result[key] = new_color
		return new_color
	end
end

-->例子
test = {}
test[1] = function() print("i am the first element") end
test[2] = function() print("i am the second element") end
test[3] = {10, 20, 30}

print(#test)            -- 3
collectgarbage()
print(#test)            -- 3


--》week的使用
--在编程环境中，有时你并不确定手动给一个键值赋nil的时机，
--而是需要等所有使用者用完以后进行释放，在释放以前，
--是可以访问这个键值对的。这种时候，weak表就派上用场了。
--关于weak table的理解，看下面这个小例子：

-- weakTable = {}
-- weakTable[1] = function() print("i am the first element") end
-- weakTable[2] = function() print("i am the second element") end
-- weakTable[3] = {10, 20, 30}

-- setmetatable(weakTable, {__mode = "v"})-- 设置为弱表
-- print(#weakTable)　　　　-- 3
-- ele = weakTable[1]　　　　　　　　　　　　-- 给第一个元素增加一个引用
-- collectgarbage()
-- print(#weakTable)　　　　　　-- 1，第一个函数引用为1，不能gc
-- ele = nil　　　　　　　　　　　　　-- 释放引用
-- collectgarbage()
-- print(#weakTable)　　　　-- 0，没有其他引用了，全部gc