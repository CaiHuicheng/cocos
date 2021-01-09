--[[

	生产者与消费者

	function producer()
	while true do
		local x = io.read()		--产生新的值
		send(x)					--发送给消费者
	end
end

function consumer()
	while true do
		local x = receive()		--从生产者接收值
		io.write(x,"\n")		--消费新的值
	end
end

	add 协同
	消费者驱动

 function receive()
 	-- body
 	local status,value = coroutine.resume(producer)
 	return value
 end

 function send(x)
 	coroutine.yield(x)		--> x表示发送的值，返回值后，挂起线程
 end
-->协同程序
producer = coroutine.create(function()
	while true do
		local x = io.read()
		send(x)
	end
end)

--]]


--[[

	过滤器filter

	过滤器一种位于生产者和消费者之间的处理功能，可以用于对数据的一些交换。

--]]


function receive(prod)
	local status,value = coroutine.resume(prod)
	return value
end

function send(x)
	-- body
	coroutine.yield(x)
end


function producer()
	-- body
	return coroutine.create(function()
		while true do
			local x = io.read()		--产生新值
			send(x)
		end
	end)
end

function filter( prod )		-->过滤器
	return coroutine.create(function ()
		-- body
		for line = 1,math.huge do
			local x = receive(prod)		--获取新值
			x = string.format("%5d %s",line,x)	--过滤信息
			send(x)						--将新值发送给消费者
		end
	end)
end

function consumer(prod)
	while true do
		local x = receive(prod)		--获取新值
		io.write(x,"\n")			--消费新值
	end
end


-- p = producer()
-- f = filter(p)
-- consumer(f)
consumer(filter(producer()))