local print = print;   --相当于 local print = _G.print
module("test_environment");
function Func1()
   print("test_environment Func1")
end
 
local function Func2()
   print("test_environment Func2")
end