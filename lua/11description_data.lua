--[[

	Lua官方网站的数据库中保存着一些“使用了Lua”的项目的信息
	在数据库中，我们用一个构造器以自动归档的方式表示每个工程入口

	
	为了读取数据，我们需要做的是正确的定义函数entry
	使用dofile直接运行数据文件（db.lua）即可

--]]

-- entry{
--     title = "Tecgraf",
--     org = "Computer Graphics Technology Group, PUC-Rio",
--     url = "http://www.tecgraf.puc-rio.br/",
--     contact = "Waldemar Celes",
--     description = [[
--     TeCGraf is the result of a partnership between PUC-Rio,
--     the Pontifical Catholic University of Rio de Janeiro,
--     and <A HREF="http://www.petrobras.com.br/">PETROBRAS</A>,
--     the Brazilian Oil Company.
--     TeCGraf is Lua's birthplace,
--     and the language has been used there since 1993.
--     Currently, more than thirty programmers in TeCGraf use
--     Lua regularly; they have written more than two hundred
--     thousand lines of code, distributed among dozens of
--     final products.]]
--     }




-->辅助函数 输出格式化后的文本
function fwrite (fmt, ...)
    return io.write(string.format(fmt, ...))
end

-->writeheader 写出 不变的头文件部分
function writeheader()
	io.write([[
	<HTML>
	<HEAD><TITLE>Projects using Lua</TITLE></HEAD>
	<BODY BGCOLOR="#FFFFFF">
	Here are brief descriptions of some projects around the
	world that use <A HREF="home.html">Lua</A>.
	<BR>
	]])
end

-->定义entry函数. 第一个entry函数，将每个工程一列表方式写出，entry的参数o是描述工程的table
function entry1 (o)
    N=N + 1
    local title = o.title or '(no title)'
    fwrite('<LI><A HREF="#%d">%s</A>\n', N, title)
end

-->o.title为nil表明table中的域title没有提供，我们用固定的"no title"替换。
-->第二个entry函数，写出工程所有的相关信息，稍微有些复杂，因为所有项都是可选的。
function entry2 (o)
    N=N + 1
    local title = o.title or o.org or 'org'
    fwrite('<HR>\n<H3>\n')
    local href = ''
    if o.url then
       href = string.format(' HREF="%s"', o.url)
    end
    fwrite('<A NAME="%d"%s>%s</A>\n', N, href, title)
    if o.title and o.org then
       fwrite('\n<SMALL><EM>%s</EM></SMALL>', o.org)
    end
    fwrite('\n</H3>\n')
    if o.description then
       fwrite('%s', string.gsub(o.description,
                     '\n\n\n*', '<P>\n'))
       fwrite('<P>\n')
    end
    if o.email then
       fwrite('Contact: <A HREF="mailto:%s">%s</A>\n',
              o.email, o.contact or o.email)
    elseif o.contact then
       fwrite('Contact: %s\n', o.contact)
    end
end

-->定义结束页面函数
function writetail()
	fwrite('</BODY></HTML>\n')
end

-->main

writeheader()

N = 0
entry = entry1
fwrite('<UL>\n')
dofile('db.lua')
fwrite('</UL>\n')
N = 0
entry = entry2
dofile('db.lua')

-- entry = entry1
-- fwrite('<UL>\n')
-- dofile('db.lua')
-- fwrite('</UL>\n')

-- N = 0
-- entry = entry2
-- dofile('db.lua')

writetail()


-->结果
--[[

	<HTML>
	<HEAD><TITLE>Projects using Lua</TITLE></HEAD>
	<BODY BGCOLOR="#FFFFFF">
	Here are brief descriptions of some projects around the
	world that use <A HREF="home.html">Lua</A>.
	<UL>
	<LI><A HREF="#1">TeCGraf</A>
	<LI> ...
	</UL>
	<H3>
	<A NAME="1"
	    HREF="http://www.tecgraf.puc-rio.br/">TeCGraf</A>
	<SMALL><EM>Computer Graphics Technology Group,
	PUC-Rio</EM></SMALL>
	</H3>
	TeCGraf is the result of a partnership between
	...
	distributed among dozens of final products.<P>
	Contact: Waldemar Celes
	<A NAME="2"></A><HR>
	...
	</BODY></HTML>

--]]