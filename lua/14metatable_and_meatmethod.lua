--[[

	元表与元方法

	lua中每个值其实都有元表，不过每个table和userdata都可以有自己专有的元表
	（userdata是宿主中的数据结构，可以使用宿主语言的方法，为了限制过度对其使用元表，
	不能在lua脚本中直接设置,需通过lua_setmetatable创建，这里不讨论），
	而其他类型的预定义操作都在一个共享的元表中，新的table默认没有元表，
	必须通过setmetatable和getmetatable设置和查询元表。	

	t =｛ ｝
	assert(getmetatable(t) == nil)
	t1 = {}
	assert(getmetatable(t) == t1)

--]]

-->1、算数类元方法
--[[

	代码中只需要给表a设置了元表，表b没有元表也能正常运行，这与lua查找元表的顺序有关系。
	lua先查找第一个table，如果有元表并且其中有 __add方法就调用该方法，
	不关心第二个table有没有元表；否则查找第二个table有没有__add的元方法，
	有就调用第二个table的元方法；如果都没有这个元方法就引发一个错误。

--]]
a = {"a1","a2","a3"}
b = {"b1","b2","b3"}

meta = { }
meta.__add = function(t1,t2)
	t = { }
	for k,v in ipairs(t1) do
		table.insert(t,v)
	end
	for k,v in ipairs(t2) do
		table.insert(t,v)
	end
	return t
end
print("----------------算数类元方法------------")
setmetatable(a,meta)
c = a+b
for _,v in ipairs(c) do
	print(v)
end

-->2、关系类元方法
--[[
	关系类元方法只有等于__eq，小于__lt和小于等于__le这3个操作
	其他3个会自动转化，如a>b会自动转为b<a.
--]]

--小于等于__le
meta.__le = function(a,b)
	for k in pairs(a) do
		if not b[k] then return false end
	end
	return true
end

--小于__lt
meta.__lt = function (a,b)
	return a <= b and not (b<=a)
end

--等于__eq 通过集合的包含
meta.__eq = function (a,b)
	return a <= b and b <= a
end

s1 = a
s2 = b

print("---------关系类元方法----------")

print(s1<=s2)	-->true
print(s1<s2)	-->true
print(s1>=s2)	-->true
print(s1>s2)	-->false
--print(s1 == s2 * s1) -->true


-->3、库定义的元方法
--[[

	上面的元方法都是lua核心具有的，是lua虚拟机定义的
	除此之外，各种程序库也会用自己的字段定义元方法，比如print总是调用table的tostring方法

--]]
a = {"a1","a2"}
meta.__tostring = function(a)
	local l = { }
	for _,k in pairs(a) do
		l[#l+1] = k;
	end
	--return"{"..table.concat(1,"1").."}"
	return "{"..table.concat(l, ",").."}"
end
print("-------库定义的元方法-----------")
setmetatable(a,meta)
print(a)


-->4、访问类元方法

--[[

	访问元方法使用最普遍的是__index和__newindex。一般当访问一个table中不存在的元素时会返回nil
	但是如果table具有__index元方法，就不返回nil而是调用这个元方法。利用__index可以方便地实现继承，

--]]

mt = { }
mt.__index = function ( t,k )
	return base[k]
end

base = {b1 = 1,b2 = 2,b3 = 3}
derive = { d = 4 }

print("----------访问类元方法----------")
setmetatable(derive,mt)
print(derive.bl)
print(derive.d)

-->当对table中不存在的索引赋值时就会调用__newindex元方法

mt.__newindex = function ( t,k,v )
	base[k] = v
end
derive["d2"] = 5
print("------------调用__newindex元方法---------------")
print(base.d2)



print("---例子：产生迭代递增表---")

T = { container = { } }

T.mt = {

  __add = function(a, b)
    local c = T.new{}
    for k,v in pairs(T.new(a)) do
      c[k] = v
    end
    for k,v in pairs(T.new(b)) do
      c[k] = v
    end
    return c
  end,

  __sub = function(a, b)
    local c = T.new{}
    for k,v in pairs(T.new(a)) do
      c[k] = v
    end
    for k,v in pairs(T.new(b)) do
      c[k] = nil
    end
    return c
  end,

  __tostring = function(a)
    local l = { }
    for k in pairs(a) do
      l[#l+1] = k;
    end
    return "{"..table.concat(l, ",").."}"
  end
}

T.new = function(t)
  if (t == nil) then t = {} end
  if (getmetatable(t) == T.mt) then return t end
 local r = {}
  for _, b in ipairs(t) do
    r[tostring(b)] = true
  end
  setmetatable(r, T.mt)
  return r
end

T.print = function(t) 
   for k, v in pairs(t.container) do
     print(k)
     print(v)
   end
 end

local mt = {
  __newindex = function(t, k, v)
    t.container[k] = T.new(v)
  end,

  __index = function(t, k)
    return t.container[k]
  end,
}

setmetatable(T, mt)

T["first"] = { "a1", "b1"}
print("elements in table first")
T.print(T)
T["second"] = T["first"] + { "a2", "b2", "a3", "b3"}
print("elements in table first and  second")
T.print(T)
T["third"] = T["second"] - { "a3", "b3" }
print("elements in table first, second and third")
T.print(T)