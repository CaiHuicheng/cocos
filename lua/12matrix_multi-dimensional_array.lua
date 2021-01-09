--[[

	Lua 表示矩阵
	1、使用“数组的数组”
	2、table中的每个元素是另一个table

--]]

-->方法一：创建一个矩阵
local N,M = 4,4
mt = {}
for i=1,N do
	mt[i] = {}
	for j=1,M do
		mt[i][j] = 0
	end
end


-->方法二： 创建矩阵
mt1 = {}
for i=1,N do
	for j=1,M do
		mt[(i-1)*M+j] = 0
	end
end

function mult( a,rowindex,k )
	local  row = a[rowindex]
	for i,v in pairs(row) do
		row[i] = v*k
	end
end



-->例子：
-- 初始化数组
array = {}
for i=1,3 do
   array[i] = {}
      for j=1,3 do
         array[i][j] = i*j
      end
end

-- 访问数组
for i=1,3 do
   for j=1,3 do
      print(array[i][j])
   end
end



