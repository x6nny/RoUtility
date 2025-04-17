--!strict
local garbager = {}
garbager.__index = garbager

--> methods
local methods = {
	['thread'] = task.cancel,
	['function'] = task.spawn,
	['Instance'] = game.Destroy,
	['RBXScriptConnection'] = disconnect,
}

--[=[

	Disconnect a RBXScriptConnection
	@private
	@param connection RBXScriptConnection

]=]
function disconnect(connection : RBXScriptConnection)
	connection:Disconnect()
end

--[=[

	Garbage Collect the full table
	@private
	@param tbl Table

]=]
function tbldestroy(tbl : any)
	local destroy = tbl.Destroy or tbl.destroy

	if destroy then
		destroy(tbl)
	end

	for i, v in pairs(tbl) do
		if methods[typeof(v)] then
			methods[typeof(v)](v)
		end
	end
end

methods['table'] = tbldestroy

--> Constructor

--[=[

	Create a new garbage collection class
	@public

]=]
function garbager.new()
	return setmetatable({
		Collection = {}
	}, garbager)
end

--> Methods

--[=[

	Add a item to garbage collection to be collected when collected
	@public
	@param item thread | function | Instance | RBXScriptConnection | table

]=]
function garbager:Add(item : any)
	assert(methods[typeof(item)], 'Passed item is not a valid item to add to garbage collection.')
	self.Collection[item] = methods[typeof(item)]
end

--[=[

	Remove a item from garbage collection
	@public
	@param item thread | function | Instance | RBXScriptConnection | table

]=]
function garbager:Remove(item : any)
	assert(self.Collection[item], `Passed item was never added to garbage collection, make sure you call 'garbager:Add(item)' before calling 'garbager:Remove(item)'.`)
	self.Collection[item] = nil
end

--[=[

	Collect all items in garbage collection
	@public
	
]=]
function garbager:Collect()
	for item, method in pairs(self.Collection) do
		method(item)
		self.Collection[item] = nil
	end
end

--[=[

	Collect all items in garbage collection and destroy the class
	@public
	
]=]
function garbager:Destroy()
	self:Collect()
	table.clear(self)
end

--> return
return garbager
