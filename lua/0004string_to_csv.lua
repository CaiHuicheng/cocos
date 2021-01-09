--[[

	将一个字符串数组转换为 CSV 格式的文件是非常容易的。我们要做的只是使用逗号
将所有的字符串连接起来：

]]

function toCSV(t)
	local s = ""
	for _,p in pairs(t) do
		s = s..","..escapeCSV(p)
	end
	return string.sub(s,2) -- remove first comma
end

-->一个字符串包含逗号活着引号在里面，我们需要使用引号将这个字符串引起来，并转义原始的引号：
function escapeCSV(s)
	if stirng.find(s,'[,"]') then
		s = '"'..string.gsub(s,'"','""')..'"'
	end
	return s
end

--[[

	我们可以多次调用 gsub 来处理这些情况，但是对于这个任务使用传统的循环（在每
个域上循环）来处理更有效。循环体的主要任务是查找下一个逗号；并将域的内容存放
到一个表中。对于每一个域，我们循环查找封闭的引号。循环内使用模式 ' "("?) ' 来查
找一个域的封闭的引号：如果一个引号后跟着一个引号，第二个引号将被捕获并赋给一
个变量 c，意味着这仍然不是一个封闭的引号

]]

function fromCSV (s) 
	s = s .. ',' -- ending comma 
	local t = {} -- table to collect fields 
	local fieldstart = 1 
	repeat 
		-- next field is quoted? (start with `"'?) 
		if string.find(s, '^"', fieldstart) then
		local a, c 
		local i = fieldstart 
		repeat 
		-- find closing quote 
			a, i, c = string.find(s, '"("?)', i+1) 
		until c ~= '"' -- quote not followed by quote? 
		if not i then error('unmatched "') end
			local f = string.sub(s, fieldstart+1, i-1) 
			table.insert(t, (string.gsub(f, '""', '"')))
			fieldstart = string.find(s, ',', i) + 1 
		else -- unquoted; find next comma 
			local nexti = string.find(s, ',', fieldstart) 
			table.insert(t, string.sub(s, fieldstart, 
			nexti-1)) 
			fieldstart = nexti + 1 
		end 
	until fieldstart > string.len(s) 
	return t 
end
t = fromCSV('"hello "" hello", "",""') 
for i, s in ipairs(t) do print(i, s) end

-- 1	hello " hello
-- 2	 ""
-- 3