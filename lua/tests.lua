BatchManual = BatchManual or BaseClass()

function BatchManual:__init(end_callback)
	self.task_list = {}
	self.end_callback = end_callback
end

function BatchManual:AddTask(handle_func)

	local function end_callback_func(  )
		-- body
		self:RunNextTask()
	end

	local function task_func( ... )
		-- body
		handle_func(end_callback_func)
	end

	table.insert( self.task_list, task_func)
end

function BatchManual:RemoveTask(task_id)
	table.remove( self.task_list,task_id)
end

function BatchManual:Start( )
	self:RunNextTask()
end

function BatchManual:GetNextTask( )
	local task
	if #self.task_list > 0 then
		task = self.task_list[1]
		self:RemoveTask(1)
	end
	return task
end

function BatchManual:RunNextTask( )
	local next_task = self:GetNextTask()
	if next_task then
		next_task()	
	else
		self:AllTaskEnd()
	end
end


function BatchManual:AllTaskEnd( )
	
	if self.end_callback and type(self.end_callback) == "function" then
		self.end_callback()
	end
	self.end_callback = nil
	self:DeleteMe()
end
