--[[

	模式匹配对于字符串操纵来说是强大的工具，你可能只需要简单的调用 string.gsub和 find 就可以完成复杂的操作
	
	对正常的解析器而言，模式匹配不是一个替代品。对于一个 quick-and-dirty 程序，
你可以在源代码上进行一些有用的操作，但很难完成一个高质量的产品。前面提到的匹
配 C 程序中注释的模式是个很好的例子：'/%*.-%*/'。如果你的程序有一个字符串包含了
"/*"，最终你将得到错误的结果：

]]

-->样内容的字符串很罕见，如果是你自己使用的话上面的模式可能还凑活
test = [[char s[] = "a /* here";/* a tricky string */]]
print(string.gsub(test,"/%*.-%*/","<COMMENT>"))
-->	char s[] = "a <COMMENT>	1


-->小心空模式：匹配空串的模式。比如，如果你打算用模式 '%a*' 匹配名字，你会发现到处都是名字：
i,j = string.find(";$%	**#$hello13","%a*")
print(i,j)	-->	1	0

--[[

	我们查找一个文本中行字符大于 70 个的行，也就是匹配一个非换行符之前有 70 个字符的行。我们使用字符类
	'[^\n]'表示非换行符的字符。所以，我们可以使用这样一个模式来满足我们的需要：重复
	匹配单个字符的模式 70 次，后面跟着一个匹配一个字符 0 次或多次的模式。我们不手工
	来写这个最终的模式，而使用函数 string.rep：

]]

pattern = string.rep("[^\n]",70).."[^\n]*"


-->大小写无关的查找
--[[

	方法之一是将任何一个字符x变为字符类 '[xX]'。我们也可以使用一个函数进行自动转换：

]]

function nocase(s)
	s = string.gsub(s ,"%a",function(c)
		return string.format("[%s%s]",string.lower(c),string.upper(c))
	end)
	return s
end
print(nocase("Hi there!"))	-->[hH][iI] [tT][hH][eE][rR][eE]!


--[[

将字符串 s1 转化为 s2，而不关心其中的特殊字符。如果字符串
s1 和 s2 都是字符串序列，你可以给其中的特殊字符加上转义字符来实现。但是如果这
些字符串是变量呢，你可以使用 gsub 来完成这种转义：

]]
-- s1 = string.gsub(s1,"(%w)","%%%1")
-- s2 = string.gsub(s2,"%%","%%%%")


--->将一段文本内的双引号内的字符串转换为大写，但是要注意双引号之间可以包含转义的引号（"""）：
-->"This is "great"!".
function code(s)
	return (string.gsub(s,"\\(.)",function(x)
		return string.format("\\%03d",string.byte(x))
	end))
end
-->原始串中的 "\ddd" 也会被编码，解码是很容易的：
function decode(s)
	return (string.gsub(S,"\\(%d%d%d)",function(d)
		return "\\"..string,char(d)
	end))
end

s = [[follows a typical string: "This is "great"!".]] 
s = code(s) 
s = string.gsub(s, '(".-")', string.upper) 
s = decode(s) 
print(s) 
--> follows a typical string: "THIS IS "GREAT"!".
