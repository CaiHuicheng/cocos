--[[

	lua在发生错误时不能简单地崩溃或退出
	Lua就应该结束当前程序块并返回应用程序

--]]

print "enter a number"
-- n = io.read("*number")
-- if not n then error("invalid input") end
--or
--n = assert(io.read("*number"),"invalid input")

n = io.read()
assert(tonumber(n),"invalid input "..n.." is not number")



--[[

	错误处理		代码

	local res = math.sin(x)
	if not res then		--错误吗？
		<错误处理代码>

	--or
	if not tonumber(X) then	--X不是一个数字吗?
		<错误处理代码>

--]]

local file,msg
repeat
	print"enter a file name:"
	local name = io.read()
	if not name then return end --无输入
	file,msg = io.open(name,"r")
	if not file then print(msg) end
	--> 如果不想处理这种情况，但任想安全的运行程序，可以使用assert来检测即可

	file = assert(io.open(name,"r"))
	file = assert(io.open("no-file","r"))
		-->stdin:1:no-file:No such file or directory
until file

