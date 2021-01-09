--[[

	OOP设计的方法有一种特殊情况：对象只有一个单一的方法

	这种情况下，我们不需要创建一个接口表，取而代之的是，我们将这个单一的方法作为对象返回。
	这听起来有些不可思议，如果需要可以复习一下 7.1 节，那里我们介绍了如何构造迭代
	子函数来保存闭包的状态。其实，一个保存状态的迭代子函数就是一个 single-method 对
	象。

]]--

function new_object(value)
	return function(action,v)
		if action == "get" then return value
		elseif action == "set" then value = v
		else error("invalid action")
		end
	end
end


d = new_object(0)
print(d("get"))	-->0
d("set", 10)
print(d("get"))	-->10
