--[[

	Lua 中的主要对象设计不提供私有性访问机制。
	部分原因因为这是我们使用通用数据结构 tables 来表示对象的结果。
	但是这也反映了后来的 Lua 的设计思想。

	Lua 的另一个目标是灵活性，提供程序员元机制（meta-mechanisms），通过他你可以实现很多不同的机制。




	privacy 实现
	设计的基本思想是，每个对象用两个表来表示：
	一个描述状态；另一个描述操作（或者叫接口）。
	对象本身通过第二个表来访问，也就是说，通过接口来访问对象。
	为了避免未授权的访问，表示状态的表中不涉及到操作；
	表示操作的表也不涉及到状态，取而代之的是，状态被保存在方法的闭包内。

]]--

--》用这种设计表述我们的银行账号，我们使用下面的函数工厂创建新的对象

--[[

	函数创建一个表用来描述对象的内部状态，并保存在局部变量 self 内。然后，
	函数为对象的每一个方法创建闭包（也就是说，嵌套的函数实例）。最后，函数创建并返
	回外部对象，外部对象中将局部方法名指向最终要实现的方法。这儿的关键点在于：这
	些方法没有使用额外的参数 self，代替的是直接访问 self。因为没有这个额外的参数，我
	们不能使用冒号语法来访问这些对象。函数只能像其他函数一样调用：

]]
function new_account(initialBalance)
	local self = {balance = initialBalance}
	local withdraw = function(v)
		self.balance = self.balance - v
	end
	local deposit = function(v)
		self.balance = self.balance + v
	end
	local  getBalance = function ()
		return self.balance
	end
	return {
		withdraw = withdraw,
		deposit = deposit,
		getBalance = getBalance
	}
end

accl = new_account(100.00)
accl.withdraw(40.10)
print(accl.getBalance())

--》例如，我们的账号可以给某些用户取款享有额外的 10%的存款上限，但是我们不想用户直接访问这种计算的详细信息，我们实现如下：
function new_account_lim(initialBalance)
	local self = {
		balance = initialBalance,
		LIM = 10000.00,
	}

	local extra = function ()
		if self.balance > self.LIM then
			return self.balance*0.10
		else
			return 0
		end
	end

	local withdraw = function(v)
		self.balance = self.balance - v
	end

	local deposit = function(v)
		self.balance = self.balance + v
	end

	local  getBalance = function ()
		return self.balance + extra() --> 直接用extra，self中没有extra 不可用self.extra
	end

	return {
		withdraw = withdraw,
		deposit = deposit,
		getBalance = getBalance
	}
end

accl_lim = new_account_lim(1000000.00)
accl_lim.withdraw(40.10)
print(accl_lim.getBalance())