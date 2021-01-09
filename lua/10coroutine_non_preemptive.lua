--[[

	协同提供 一种协作式的多线程	每个协同程序都等于是一个线程

	yield-resume 可以将执行权在不同线程之间切换

	！！！
	
		协同与多线程的不同之处：
			协同是非抢占式

	！！！
	
--]]

-->导入socket包
require "socket"



--[[

--> 访问 world wide web consortium
host = "www.w3.org"

file = "/TR/REC-html132.html"

-->打开TCP链接	端口 80
c = assert(socket.connect(host,80))

-->返回一个链接对象，可以用它来发送文件请求
c:send("GET"..file.."HTTP/1.0\r\n\r\n")

-->接收文件 1K字节块	写到标准输出
while true do 
	local s,status,partial = c:receive(2^10)
	io.write(s or partial)
	if status == "closed" then break end
end

-->关闭链接
c:close()

--]]


function download( host,file )
	local c = assert(socket.connect(host,80))
	local count = 0		--记录接收的字节数
	c:send("GET"..file.."HTTP/1.0\r\n\r\n")
	while true do
		local s,status,partial = receive(c)
		count = count + #(s or partial)
		if	status == "closed" then break end
	end
	c:close()
	print(file,count)
end

-->辅助函数receive 从连接接收数据
-- function receive( connection )
-- 	-- body
-- 	return connection:receive(2^10)
-- end

-->并发实现的receive 不能阻塞	没有足够可用的数据时挂起执行

function receive( connection )
	-- body
	connection:settimeout(0)		--使receive调用不会阻塞
	local s,status,partial = connection:receive(2^10)
	if status == "timeout" then
		coroutine.yield(connection)
	end
	return s or partial,status
end


threads = {}	-->记录所有正在运行的线程
function get( host,file )
	--创建协同程序
	local co = coroutine.create(function()
		download(host,file)
	end)
	--将其插入记录表中
	table.insert(threads,co)
end

function dispatch()
	-- body
	local i = 1
	while true do
		if threads[i] == nil then	--还有线程？
			if threads[1] == nil then break end		--列表是否为空?
			i = 1
		end
		local status,res = coroutine.resume(threads[i])
		if not res then
			table.remove(threads,i)
		else
			i = i + 1
		end
	end
end

--> 访问 world wide web consortium
host = "www.w3.org"

get(host,"/TR/html1401/html40.txt")
get(host,"/TR/2002/ERC-xhtml11-20020801/xhtml1.pdf")
get(host,"/TR/ERC-html132.html")
get(host,"/TR/200/ERC-DOM-Level-2-Core-20001113/DOM2-Core.txt")
