--[[

	类似goto的函数调用   
	一个函数的调用是其他函数的最后一个动作
	function f(x) return g(x) end

	函数f调用g函数之后,f无用清除，g调用结束直接返回到f的调用点

--]]


--游戏状态机 	从一间房间移动到另一间房间
function room1()
	local move = io.read()
	if move == "south" then return room3()
	elseif move == "east" then return room2()
	else
		print("invalid move")
		return room1()
	end
end

function room2()
	local move = io.read()
	if move == "south" then return room4()
	elseif move == "wast" then return room2()
	else
		print("invalid move")
		return room2()
	end
end

function room3()
	local move = io.read()
	if move == "north" then return room4()
	elseif move == "east" then return room2()
	else
		print("invalid move")
		return room3()
	end
end
function room4()
	print("congratulations!")
end

room1()
