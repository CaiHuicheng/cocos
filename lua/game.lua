--[[

	local m = {}
	local modeName = ...;
	_G[modeName] = m
	function m.play()
		-- body
		print("\nplay")
	end

	function m.quit()
		-- body
		print("quit m")
	end
	return m;

	模块内函数之间的调用仍然要保留模块名的限定符，如果是私有变量还需要加 local 关键字，
	同时不能加模块名限定符。如果需要将私有改为公有，或者反之，都需要一定的修改。
	那又该如何规避这些问题呢？

--]]
local m = {}
local modeName = ...;
_G[modeName] = m
function m.play()
	print("\nplay")
end

function m.quit()

	print("quit m")
end
return m;



-->因为此时的全局环境就是 M，不带前缀去定义变量，就是全局变量，这时的全局变量是保存在 M 里
-- local M = {};
-- local modelName = ...;
-- _G[modelName] = M;
-- package.loaded[modelName] = M
-- setfenv(1, M);
-- function play()
--     print("那么，开始吧");
-- end
-- function quit()
--     print("你走吧，我保证你不会出事的，呵，呵呵");
-- end
-- return M;

--》module函数
-- local modname = ...
-- local M = {}
-- _G[modname] = M
-- package.loaded[modname] = M
--      --[[
--      和普通Lua程序块一样声明外部函数。
--      --]]
-- setfenv(1,M)
-- module(...,package.seeall)
-- function play()
--     print("那么，开始吧")
-- end

-- function quit()
--     print("你走吧，我保证你不会出事的，呵，呵呵");
-- end