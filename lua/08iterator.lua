function allword( f )	
	-- body
	for line in io.lines() do
		for word in string.gmatch(line,"%W+") do
			f(word)
		end
	end
end


local count = 0
allword(function ( w )
	-- body
	if w == "hello" then count = count + 1 end
end)
print(count)  