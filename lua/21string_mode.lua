0
.







--[[

	模式串中使用字符类。字符类指可以匹配一个特定字符集合内任何字符的模式项。
	比如，字符类 %d 匹配任意数字。所以你可以使用模式串'%d%d/%d%d/%d%d%d%d'
	搜索 dd/mm/yyyy 格式的
	日期：

]]

s = "Deadline is 30/05/1999, firm"
date = "%d%d/%d%d/%d%d%d%d"
print(string.sub(s,string.find(s,date)))

--[[
Lua 支持的所有字符类：
	. 任意字符
	%a 字母
	%c 控制字符
	%d 数字
	%l 小写字母
	%p 标点字符
	%s 空白符
	%u 大写字母
	%w 字母和数字
	%x 十六进制数字
	%z 代表 0 的字符
	上面字符类的大写形式表示小写所代表的集合的补集
]]
--例如，'%A'非字母的字符：
print(string.gsub("hello, up-down!","%A","."))
-->hello..up.down.	4

--[[
	在模式匹配中有一些特殊字符，他们有特殊的意义
	Lua 中的特殊字符如下：
	( ) . % + - * ? [ ^ $
]]

--[[
	
	模式串就是普通的字符串。他们和其他的字符串没有区别，也不会受到特殊对待。
	只有他们被用作模式串用于函数的时候，'%' 才作为转义字符。
	如果你需要在一个模式串内放置引号的话，你必须使用在其他的字符串中放置引号
	的方法来处理，使用 '\' 转义引号，'\' 是 Lua 的转义符。你可以使用方括号
	将字符类或者字符括起来创建自己的字符类
	比如，'[%w_]' 将匹配字母数字和下划线，'[01]' 匹配二进制数字，'[%[%]]--' 匹配一对方括号。
--]]
-->例子统计文本中元音字母出现的次数：
text = [[


David Kolf's JSON module for Lua 5.1/5.2

Version 2.5


For the documentation see the corresponding readme.txt or visit
<http://dkolf.de/src/dkjson-lua.fsl/>.

You can contact the author by sending an e-mail to 'david' at the
domain 'dkolf.de'.


Copyright (C) 2010-2013 David Heiko Kolf

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


]]
_,nvow = string.gsub(text,"[AEIOUaeiou]","")
print(nvow)

--[[
可以使用修饰符来修饰模式增强模式的表达能力，Lua 中的模式修饰符有四个：

	+ 匹配前一字符 1 次或多次
	* 匹配前一字符 0 次或多次
	- 匹配前一字符 0 次或多次
	? 匹配前一字符 0 次或 1 次

]]
-->'+'，匹配一个或多个字符，总是进行最长的匹配。比如，模式串 '%a+' 匹配一个或多个字母或者一个单词
print(string.gsub("one,and two,and three","%a+","word"))
--> word, word word; word word
-->'%d+' 匹配一个或多个数字（整数）：
i,j = string.find("the number 1298 is even","%d+")
print(i,j)--> 12 15

-->'-' 与 '*' 一样，都匹配一个字符的 0 次或多次出现，但是他进行的是最短匹配

t = "int x; /* x */ int y; /* y */"
-->由于 '.*' 进行的是最长匹配，这个模式将匹配程序中第一个 "/*" 和最后一个 "*/" 之间所有部分：
print(string.gsub(t, "/%*.*%*/", "<COMMENT>")) 
--> int x; <COMMENT>
-->然而模式 '.-' 进行的是最短匹配，她会匹配 "/*" 开始到第一个 "*/" 之前的部分：
test = "int x; /* x */ int y; /* y */"
print(string.gsub(test, "/%*.-%*/", "<COMMENT>")) 
--> int x; <COMMENT> int y; <COMMENT>


--[[
	以 '^' 开头的模式只匹配目标串的开始部分，相似的，以 '$' 结尾的模式只匹配目
标串的结尾部分。这不仅可以用来限制你要查找的模式，还可以定位（anchor）模式。
比如:
]]

--if string.find(s,"^%d") then ...
--检查字符串 s 是否以数字开头，而
--if string.find(s, "^[+-]?%d+$") then ...

--[[

'%b' 用来匹配对称的字符。常写为 '%bxy' ，x 和 y 是任意两个不同的字符；x 作为
匹配的开始，y 作为匹配的结束。比如，'%b()' 匹配以 '(' 开始，以 ')' 结束的字符串：

]]--

print(string.gsub("a (enclosed (in) parentheses) line", "%b()", ""))
-->a line