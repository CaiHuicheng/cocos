--define module
local profiler = {}

-- load modules
local os        = require("base/os")
local path      = require("base/path")
local table     = require("base/table")
local utils     = require("base/utils")
local string    = require("base/string")



--start profiling
function profiler:start(mode)

	--初始化报告
	self._REPORTS			={}
	self._REPORTS_BY_TITLE	={}

	--记录开始时间
	self.STARTTIME = os.clock()


	--开始hook，注册hander，记录call和return事件
	debug.sethook(profiler._profiling_handler,'cr',0)
end

--stop profiling

function profiler:stop(mode)
	--记录结束时间
	self._STOPTIME = os.clock()

	--停止hook
	debug.sethook()

	--记录总耗时
	local totaltime = self._STOPTIME - self.STARTTIME

	--排序报告
	table.sort(self._REPORTS,function(a,b)
		return a.totaltime>b.totaltime
	end)

	--格式化报告输出
	for_,report in ipairs(self._REPORTS) do

		--colculate percent
		local percent = (report.totaltime/totaltime) * 100
		if percent < 1 then
			break
		end

		--trace
		utils.print("%6.3f,%6.2f%%,%7d,%s",report.totaltime,percent,report.callcount,report.title)
	end
end


--profiling call

function profiler:_profiling_call(funcinfo)

	--获取当前函数对应报告，如果不存在则初始化
	local report = self:_func_report(funcinfo)
	assert(report)

	--记录这个函数的起始调用事件
	report.callcount = os.clock()

	--累加这个函数的调用次数
	report.callcount = report.callcount + 1
end


--profiling return 
function profiler:_profiling_return(funcinfo)

	--记录这个函数的返回时间
	local stoptime = os.clock()

	--获取当前函数的报告
	local report = self:_func_report(funcinfo)
	assert(report)

	--计算和累加当前函数的调用总时间
	if report.calltime and report.calltime > 0 then
		report.totaltime = report.totaltime+(stoptime-report.calltime)
		report.calltime = 0
	end
end


--the profiling handler
function profiler._profiling_handler(hooktype)

	--获取当前函数信息
	local funcinfo = debug.getinfo(2,"nS")

	--根据事件类型，分别处理
	if hooktype == "call" then
		profiler:_profiling_call(funcinfo)
	elseif hooktype == "return" then
		profiler:_profiling_return(funcinfo)
	end
end


-- get the function title
function profiler:_func_title( funcinfo )
	
	--check
	assert(funcinfo)

	-- the function name
	local name = funcinfo.name or 'anonymous'

	-- the function line
	local line = string.format("%d",funcinfo.linedefind or 0)

	-- the function source
	local source = funcinfo.short_src or 'C_FUNC'
	if os.isfile(source) then
		source = path.relative(source,xmake._PROGRAM_DIR)
	end

	--make title
	return string.format("%-30s:%s:%s",name,source,line)
end

--get the function report

function profiler:_func_report(funcinfo)

	--get the function title
	local title = self:_func_title(funcinfo)

	--get the function report
	local report = self._REPORTS_BY_TITLE[title]
	if not report then

		-- init report
		report = {
			title = self:_func_title(funcinfo)
			,	callcount = 0
			,	totaltime = 0
		}


		-- save it 
		self._REPORTS_BY_TITLE[title] = report
		table.insert(self._REPORTS,report)
	end

	--ok?
	return report
end

--[[
	通过debug.sethook的方式，进行hook计时本身也是有性能损耗的，因此不可能完全精确，如果改用c实现也许会好些。

	不过，对于平常的性能瓶颈分析，应该够用

]]
xmake --profile
