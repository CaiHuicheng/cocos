--[[
	数据文件与持久化

	写文件比读取文件内容来的容易。因为我们可以很好的控制文件的写操作，
	而从文件读取数据常常碰到不可预知的情况。一个健壮的程序不仅应该
	可以读取存有正确格式的数据还应该能够处理坏文件（
	译者注：对数据内容和格式进行校验，对异常情况能够做出恰当处理）。

	Donald E. Knuth,Literate Programming,CSLI,1992 
	Jon Bentley,More Programming Pearls,Addison-Wesley,1990 
	写成
	Entry{"Donald E. Knuth", 
	"Literate Programming", 
	"CSLI", 
	1992} 
	Entry{"Jon Bentley", 
	"More Programming Pearls", 
	"Addison-Wesley", 
	1990} 

--]]

-->下面这段代码计算数据文件中记录数

local count = 0
function Entry( b )
	count = count + 1
end
dofile("data")
print("number of entries:"..count)

