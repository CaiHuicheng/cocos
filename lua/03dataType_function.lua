--求!N函数
function factorial1( n )
	if n == 0 then
		return 1
	else
		return n*factorial1(n-1)
	end
end


print(factorial1(5))

--函数可赋值
factorial2 = factorial1
print(factorial2(5))


--匿名函数
function testFun( tab,fun )
	for k,v in pairs(tab) do
		print(fun(k,v));
	end
end


tab = {key1 = "val1",key2 = "val2"};
testFun(tab,function ( key,val )--匿名函数
	-- body
	return key.."="..val;
end);