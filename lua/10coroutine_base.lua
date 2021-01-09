--[[

	Lua 协同程序(coroutine)与线程比较类似：
		1-拥有独立的堆栈
		2-独立的局部变量
		3-独立的指令指针，同时又与其它协同程序共享全局变量和其它大部分东西


		coroutine.create()		创建 coroutine，返回 coroutine， 参数是一个函数，当和 resume 配合使用的时候就唤醒函数调用
		coroutine.resume()		重启 coroutine，和 create 配合使用
		coroutine.yield()		挂起 coroutine，将 coroutine 设置为挂起状态，这个和 resume 配合使用能有很多有用的效果
		coroutine.status()		查看 coroutine 的状态
		coroutine.wrap（）		创建 coroutine，返回一个函数，一旦你调用这个函数，就进入 coroutine，和 create 功能重复
		coroutine.running()		返回正在跑的 coroutine，一个 coroutine 就是一个线程，当使用running的时候，就是返回一个 corouting 的线程号

--]]


co = coroutine.create(function() print("first thread") end)
print(co) -->thread:0x00000000003cd2d8


--[[

	协同程序的状态
	1、suspended		挂起
	2、running		运行
	3、dead			死亡
	4、normal		正常

--]]

print(coroutine.status(co)) -->suspended

-->函数 coroutine.resume用与启动或者再次启动一个协同程序的执行,并将其状态从挂起改为运行
coroutine.resume(co) -->first thread
-->协同程序打印“frist thread”后便终止了，即dead
print(coroutine.status(co)) -->dead



-->例子

thread_1 = coroutine.create(function ()
	for i=1,10 do
		print("thread_1",i)
		coroutine.yield() -->协同挂起
	end
end)

coroutine.resume(thread_1) -->thread_1 1
print(coroutine.status(thread_1)) -->suspended
coroutine.resume(thread_1) -->thread_1 2
coroutine.resume(thread_1) -->thread_1 3
coroutine.resume(thread_1) -->thread_1 4
coroutine.resume(thread_1) -->thread_1 5
coroutine.resume(thread_1) -->thread_1 6
coroutine.resume(thread_1) -->thread_1 7
coroutine.resume(thread_1) -->thread_1 8
coroutine.resume(thread_1) -->thread_1 9
coroutine.resume(thread_1) -->thread_1 10
coroutine.resume(thread_1) -->什么也不打印

print(coroutine.resume(thread_1))
	-->false cannot resume dead coroutine


--[[

	resume--yield 交换数据
	在第一次调用resume时，并没有对应yield在等待它，因为所有传递给resume的额外参数都将视为协同程序主函数的参数

--]]

thread_2 = coroutine.create(function (a,b,c)
		print("thread_2",a,b,c)
	end)
coroutine.resume(thread_1,a,b,c) -->thread_2 1 2 3

--> resume 调用返回的内容中，第一个值为true表示没有错误，而后面所有的值都是对应yield传入的参数
thread_3 = coroutine.create(function(a,b)
		coroutine.yield(a+b,a-b)
	end)
print(coroutine.resume(thread_3,20,10))	-->true 30 10

-->yield 返回的额外值就是对resume传入的参数
thread_4 = coroutine.create(function()
		print("thread_4",coroutine.yield())
	end)
coroutine.resume(thread_4)
coroutine.resume(thread_4,4,5)	-->thread_4 4 5

-->当一个协同程序结束时，它的主函数所返回的值都是作为对应resume 的返回值
thread_5 = coroutine.create(function()
	return 6,7
	end)
print(coroutine.resume(thread_5))	-->true 6 7


