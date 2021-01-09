
list = nil
--count = 10

for line in io.lines() do
	--count --
	list = {next = list,value = line}
	--if count < 0 then
		--break
	--end
end

local l = list
while l do
	print(l.value)
	l = l.next
end