--[[

		String 库中的一些函数是非常简单的：
		string.len(s)返回字符串 s 的长度；
		string.rep(s, n)返回重复 n 次字符串 s 的串；
		你使用 string.rep("a", 2^20)可以创建一个 1M bytes 的字符串（比如，为了测试需要；
		string.lower(s)将 s 中的大写字母转换成小写（string.upper将小写转换成大写）。

]]--

-->大小写对一个数组进行排序的话，你可以这样：
--table.sort(a,function(a,b) return string.lower(a)<string.lower(b) end)
print(string.upper("a??o"))


-->sub
s = "sahfkhslmsc;alc"
print(string.sub(s,2,10))
--String.sub 函数以及 Lua 中其他的字符串操作函数都不会改变字符串的值，而是返回一个新的字符串
string.sub(s,2,10)
print(s)
--如果你想修改一个字符串变量的值，就必须将变量赋给一个新的字符串：
s = string.sub(s,2,5)
print(s)

-->string.char 函数和 string.byte 函数用来将字符在字符和数字之间转换
print(string.char(97)) --> a 
i = 99; print(string.char(i, i+1, i+2)) --> cde 
print(string.byte("abc")) --> 97 
print(string.byte("abc", 2)) --> 98 
print(string.byte("abc", -1)) --> 99

-->函数 string.format 在用来对字符串进行格式化的时候，特别是字符串输出
--[[

%s    -  接受一个字符串并按照给定的参数格式化该字符串
 %d    - 接受一个数字并将其转化为有符号的整数格式
 %f    -  接受一个数字并将其转化为浮点数格式(小数)，默认保留6位小数，不足位用0填充
 %x    - 接受一个数字并将其转化为小写的十六进制格式
 %X    - 接受一个数字并将其转化为大写的十六进制格式

]]
print(string.format("pi = %.4f", math.pi)) 
 --> pi = 3.1416 
d = 5; m = 11; y = 1990 
print(string.format("%02d/%02d/%04d", d, m, y)) 
 --> 05/11/1990 
tag, title = "h1", "a title"
print(string.format("<%s>%s</%s>", tag, title, tag)) 
 --> <h1>a title</h1>


 --[[

	string 库中功能最强大的函数是：
	string.find（字符串查找），
	string.gsub（全局字符串替换），
	string.gfind（全局字符串查找）。
	这些函数都是基于模式匹配的

 ]]

s = "helllasdlklakd world sandnan as"
i,j = string.find(s,"world")
print(i,j)					-->16	20
print(string.sub(s, i, j)) --> world 
print(string.find(s, "world")) --> 16	20
i, j = string.find(s, "l") 
print(i, j) --> 3 3 
print(string.find(s, "aaa")) --> nil

--[[

	string.find 函数第三个参数是可选的：标示目标串中搜索的起始位置。当我们想查找
目标串中所有匹配的子串的时候，这个选项非常有用。我们可以不断的循环搜索，每一
次从前一次匹配的结束位置开始。下面看一个例子，下面的代码用一个字符串中所有的
新行构造一个表：

]]

local t = {}
local i = 0
while true do
	i = string.find(s,"\n",i+1)
	if i == nil then break end
	table.insert(t,i)
end


--[[

	string.gsub 函数有三个参数：
	目标串，模式串，替换串。
	他基本作用是用来查找匹配模式的串，并将使用替换串其替换掉：

]]

str = string. gsub("lua is cute","cute","great")
print(str)
--第四个参数是可选的，用来限制替换的范围：
s = string.gsub("all lii", "l", "x", 2) 
print(s) --> axx lii

-->!!!string.gsub 的第二个返回值表示他进行替换操作的次数
_,count = string.gsub("asbhkabfkabfbafabsfba","a","d")
print("count a to d: "..count)