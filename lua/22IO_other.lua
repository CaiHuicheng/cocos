--[[

函数 tmpfile 函数用来返回零时文件的句柄，并且其打开模式为 read/write 模式。该
零时文件在程序执行完后会自动进行清除。函数 flush 用来应用针对文件的所有修改。同
write 函数一样，该函数的调用既可以按函数调用的方法使用 io.flush()来应用当前输出文
件；也可以按文件句柄方法的样式 f:flush()来应用文件 f。函数 seek 用来得到和设置一个
文件的当前存取位置。它的一般形式为 filehandle:seek(whence,offset)。Whence 参数是一
个表示偏移方式的字符串。它可以是 "set"，偏移值是从文件头开始；"cur"，偏移值从
当前位置开始；"end"，偏移值从文件尾往前计数。offset 即为偏移的数值，由 whence 的
值和 offset 相结合得到新的文件读取位置。该位置是实际从文件开头计数的字节数。
whence 的默认值为 "cur"，offset 的默认值为 0。这样调用 file:seek()得到的返回值就是文
件当前的存取位置，且保持不变。file:seek("set")就是将文件的存取位置重设到文件开头。
（返回值当然就是 0）。而 file:seek("end")就是将位置设为文件尾，同时就可以得到文件
的大小。如下的代码实现了得到文件的大小而不改变存取位置

]]


function fsize (file) 
local current = file:seek() -- get current position 
local size = file:seek("end") -- get file size 
 file:seek("set", current) -- restore position 
return size 
end