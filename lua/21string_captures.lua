--[[

	Capture5是这样一种机制：可以使用模式串的一部分匹配目标串的一部分
	
]]

-->string.find 使用 captures 的时候，函数会返回捕获的值作为额外的结果。这常被用来将一个目标串拆分成多个：
pair = "name = cai"
_,_,key,value = string.find(pair,"(%a+)%s* = %s*(%a+)")
print(key,value)-->name		cai


-->日期
date = "17/7/1999"
_,_,d,m,y = string.find(date,"(%d+)/(%d+)/(%d+)")
print(d,m,y) 

-->在模式中使用向前引用，'%d'（d 代表 1-9 的数字）表示第 d 个捕获的拷贝
s = [[then he said:"it's all right"!]]
a, b, c, quoted_part = string.find(s, "([\"'])(.-)%1")
print(quoted_part)
print(c)

-->对一个字符串中的每一个字母进行复制，并用连字符将复制的字母和原字母连接起来：
print(string.gsub("hello Lua!", "(%a)", "%1-%1")) 
 --> h-he-el-ll-lo-o L-Lu-ua-a!

 -->下面代码互换相邻的字符:
print(string.gsub("hello lua!","(.)(.)","%2%1"))

-->写一个格式转换器：从命令行获取 LaTeX 风格的字符串，形如：
--[[
\command{some text}
将它们转换为 XML 风格的字符串：
<command>some text</command> 
对于这种情况,下面的代码可以实现这个功能：
]]
s = "the \\quote{task} is to \\em{change} that."
s = string.gsub(s,"\\(%a+){(.-)}","<%1>%2<%1>")

-->去除字符串首尾的空格：
function trim( s )
	return (string.gsub(s,"^%s*(.-)%s*$", "%1"))
end

-->将一个字符串中全局变量$varname 出现的地方替换为变量 varname 的值：

function expand(s)
	s = string.gsub(s,"$(%w+)",function(n)
		-->不能确定给定的变量是否为 string 类型，可以使用 tostring 进行转换：
		return tostring(_G[n])
	end)
	return s
end
name = "Lua";status = "great"
print(expand("$name is $status, isn't it?"))

-->使用 loadstring 来计算一段文本内$后面跟着一对方括号内表达式的值：
s = "sin(3) = $[math.sin(3)]; 2^5 = $[2^5]"
print((string.gsub(s, "$(%b[])", function (x) 
	x = "return " .. string.sub(x, 2, -2) 
	local f = loadstring(x) 
	return f() 
end)))

-->常常需要使用 string.gsub 遍历字符串，而对返回结果不感兴趣。
-->比如，我们收集一个字符串中所有的单词，然后插入到一个表中：
s = "hello hi,again!"
-- words = {} 
-- string.gsub(s, "(%a+)", function (w) 
-- 	table.insert(words, w)
-- end)
words = {} 
for w in string.gfind(s, "(%a)") do
	table.insert(words, w) 
end
-->gfind 函数比较适合用于范性 for 循环。他可以遍历一个字符串内所有匹配模式的子串。我们可以进一步的简化上面的代码
for w in string.gfind(s, "%a") do
 table.insert(words, w) 
end


--[[

	使用 URL 编码，URL 编码是 HTTP 协议来用发送 URL 中的参数进行的编码。
	这种编码将一些特殊字符（比如 '='、'&'、'+'）转换为 "%XX" 形式的编码，
	其中 XX 是字符的 16 进制表示，然后将空白转换成 '+'。
	比如，将字符串 "a+b = c" 编码为 "a%2Bb+%3D+c"。
	最后，将参数名和参数值之间加一个 '='；在 name=value 对之间加一个 "&"。比如字符串：

	name = "al";query = "a+b = c";q = "yes or no" 
	name=al&query=a%2Bb+%3D+c&q=yes+or+no

]]

-->URL 解码功能
--[[

第一个语句将 '+' 转换成空白，第二个 gsub 匹配所有的 '%' 后跟两个数字的 16 进
制数，然后调用一个匿名函数，匿名函数将 16 进制数转换成一个数字（tonumber 在 16
进制情况下使用的）然后再转化为对应的字符。比如：


]]
function unescape(s)
	s = string.gsub(s,"+"," ")
	s = string.gsub(s,"%%(%x%x)",function (h)
		return string.char(tonumber(h,16))
	end)
	return s
end

print(unescape("a%2Bb+%3D+c")) --> a+b = c

--[[

	对于 name=value 对，我们使用 gfind 解码，因为 names 和 values 都不能包含 '&' 和 '='
我们可以用模式 '[^&=]+' 匹配他们：

]]

cgi = {}
function decode(s)
	for name,value in string.gfind(s,"([^&=]+)=([^&=]+)") do
		name = unescape(name)
		value = unescape(value)
		cgi[name] = value
	end
end


--[[
	
	URL编码

]]
-->escape 函数，这个函数将所有的特殊字符转换成 '%' 后跟字符对应的 ASCII 码转换成两位的 16 进制数字（不足两位，前面补 0），然后将空白转换为 '+'：
function escape(s)
	s = string.gsub(s,"([&=+%c])",function(c)
		return string.format("%%%02X",string.byte(c))
	end)
	s = string.gsub(s," ","+")
	return s
end
-->编码函数遍历要被编码的表，构造最终的结果串：
function encode(t)
	local s = ""
	for k,v in pairs(t) do
		s = s .. "&"..escape(k) .. "=" .. escape(v)
	end
	return string.sub(s,2) -- remove first ‘&’
end

t = {name = "al",query = "a+b=c",q = "yes or no"}
print(encode(t))