--[[

操作系统库包含了文件管理，系统时钟等等与操作系统相关信息。这些函数定义在
表（table）os 中。定义该库时考虑到 Lua 的可移植性，因为 Lua 是以 ANSI C 写成的，
所以只能使用 ANSI 定义的一些标准函数。许多的系统属性并不包含在 ANSI 定义中，
例如目录管理，套接字等等。所以在系统库里并没有提供这些功能。另外有一些没有包
含在主体发行版中的 Lua 库提供了操作系统扩展属性的访问。


]]

--[[

	Date 和 Timme

	time 和 date 两个函数在 Lua 中实现所有的时钟查询功能。

	year 	a full year 
	month 	01-12 
	day 	01-31 
	hour 	01-31 
	min 	00-59 
	sec 	00-59 
	isdst 	a boolean, true if daylight saving

	前三项是必需的，如果未定义后几项，默认时间为正午（12:00:00）

]]

-- obs: 14400
print(os.time{year=1970,month=1,day=1,hour=0})

-- obs: 14401
print(os.time{year=1970, month=1, day=1, hour=0, sec=1})

-- obs: 100800  obs = (14400+24*60*60)
print(os.time{year=1970, month=1, day=2})



temp = os.date("*t",906000490)

print(os.date("today is %A, in %B")) 
--> today is Saturday, in January 
print(os.date("%x", 906000490)) 
--> 09/17/98

--[[
	都是按照英语系的显示描述的

	%a abbreviated weekday name (e.g., Wed) 
	%A full weekday name (e.g., Wednesday) 
	%b abbreviated month name (e.g., Sep) 
	%B full month name (e.g., September) 
	%c date and time (e.g., 09/16/98 23:48:10) 
	%d day of the month (16) [01-31] 
	%H hour, using a 24-hour clock (23) [00-23] 
	%I hour, using a 12-hour clock (11) [01-12] 
	%M minute (48) [00-59] 
	%m month (09) [01-12] 
	%p either "am" or "pm" (pm) 
	%S second (10) [00-61] 
	%w weekday (3) [0-6 = Sunday-Saturday] 
	%x date (e.g., 09/16/98) 
	%X time (e.g., 23:48:10)


]]

--> to other
--[[

	函数 os.exit 终止一个程序的执行。
	函数 os.getenv 得到“环境变量”的值。

]]

print(os.getenv("HOME"))
-->/home/A1-0685

--[[

	os.execute

	函数 os.setlocale 设定 Lua程序所使用的区域（locale）。区域定义的变化
	对于文化和语言是相当敏感的。setlocale有两个字符串参数：区域名和特性（
	category，用来表示区域的各项特性）。在区域中包含六项特性：“collate”（
	排序）控制字符的排列顺序；"ctype" controls the types of individual 
	characters (e.g., what is a letter) and the conversion between 
	lower and upper cases; "monetary"（货币）对 Lua 程序没有影响；
	"numeric"（数字）控制数字的格式；"time"控制时间的格式（也就是 os.date 函数）；
	和“all”包含以上所以特性。函数默认的特性就是“all”，所以如果你只包含地域名就调用函数
	 setlocale 那么所有的特性都会被改变为新的区域特性。如果运行成功函数返回地域名，
	 否则返回 nil（通常因为系统不支持给定的区域）。

]]

-->例子：在 Unix 和DOS-Windows 系统里都可以执行如下代码创建一个新目录：
function createDir (dirname) 
 os.execute("mkdir " .. dirname) 
end

print(os.setlocale("ISO-8859-1","collate")) -->ISO-8859-1