--[[

	泛型for的语法

	for<var-list> in <exp-list> do
		<body>
	end

	or

	for k,v in pairs(t) do print(k,v) end

--]]



array = {"Google", "Runoob"}

for key,value in ipairs(array)
do
   print(key, value)
end
