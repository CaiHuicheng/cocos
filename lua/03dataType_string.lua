string1 = "this is string1"
string2 = "this is string2"

html = [[
<html>
<head></head>
<body>
	<a href="http://www.runoob.com/">菜~~~</a>
</body>
</html>
]]

print(html)


-- 数字字符串上进行算术操作时，Lua 会尝试将这个数字字符串转成一个数字:
print("2"+8)

--以下代码中"error" + 1执行报错了，字符串连接使用的是 .. 
--print("error" + 8)
--即有如下拼接字符串方式
print("er".."runoob") -->errunoob

print(#"leetCode 429") -->12
