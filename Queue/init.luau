--!strict
local queue = {}
queue.__index = queue

--> Constructor

--[=[

	Create a new queue
	@public
	@return queue class
	
]=]
function queue.new()
	return setmetatable({
		queue = {},
		processing = false,
	}, queue)
end

--> Methods

--[=[

	Add a new task to the queue
	@public
	
]=]
function queue:Add(task : () -> ())
	table.insert(self.queue, task)
end

--[=[

	Remove a task from the queue
	@public
	
]=]
function queue:Remove(task : () -> ())
	local index = table.find(self.queue, task)
	if index == nil then return end
	table.remove(self.queue, index)
end

--[=[

	Run all the tasks in the queue from order added
	@public
	
]=]
function queue:Process(...)
	if self.processing == true then
		repeat task.wait() until self.processing == false
	end
	self.processing = true
	for i = 1, #self.queue do
		local _task = self.queue[i]
		task.spawn(_task, ...)
	end
	self.processing = false
end

--> return
return queue