
--[[

	table.concat test

--]]

-->1、方法1
-- local t = {}
-- local test = {"a","x","def","type","fire","time","bottle","xo","wtf"}
-- for i, var in ipairs(test) do
--     t[#t+1] = var
--     t[#t+1] = "\n"
-- end
-- local s = table.concat(t)
-- print(s)

-->2、方法2
local t = {}
local test = {"a","x","def","type","fire","time","bottle","xo","wtf"}
for i, var in ipairs(test) do
    t[#t+1] = var
end
t[#t+1] = ""
local s = table.concat(t,"\n")
print(s)