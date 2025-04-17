--!strict
local signal = {}
signal.__index = signal

local disconnect = {}
disconnect.__index = disconnect

--> refs
local queue = require('./Queue')

--> types
type signalData = {
	queue : typeof(queue.new()),
	connections : {disconnect?}
}
type signal = {
	Connect : (signal, fn : () -> ()) -> disconnect,
	Fire : (signal, any) -> (),
	Once : (signal, fn : () -> ()) -> (),
	Wait : (signal) -> (),
	DisconnectAll : (signal) -> ()
}

type disconnect = {
	signal : signal,
	fn : () -> (),
	
	Disconnect : (disconnect) -> (),
}

--> Constructor

--[=[

	Create a new connection class
	@private
	@param sig signal
	@return connection class

]=]
function disconnect.new(sig : typeof(signal.new()), fn : () -> ()) : disconnect
	return setmetatable({
		signal = sig,
		fn = fn
	}, disconnect) :: any
end

--[=[

	Create a new signal class
	@public
	@return signal class

]=]
function signal.new() : signal
	return setmetatable({
		queue = queue.new(),
		connections = {}
	}, signal) :: any
end

--> Methods

--[=[

	Create a new connection
	@public
	@param fn function
	@return connection class
	
]=]
function signal:Connect(fn : () -> ())
	self = self :: signal & signalData
	local connection = disconnect.new(self, fn)
	self.queue:Add(fn)
	table.insert(self.connections, connection)
	return connection
end

--[=[

	Fire the signal to all connections
	@public
	@param ... any

]=]
function signal:Fire(...)
	self = self :: signal & signalData
	self.queue:Process(...)
end

--[=[

	Create a one-time connection
	@public
	@param fn function

]=]
function signal:Once(fn : () -> ())
	local connection = nil
	connection = self:Connect(function(...)
		connection:Disconnect()
		task.spawn(fn, ...)
	end)
end

--[=[

	Wait for the signal to fire
	@public

]=]
function signal:Wait()
	local thread = coroutine.running()
	
	self:Once(function()
		coroutine.resume(thread)
	end)
	
	return coroutine.yield(thread)
end

--[=[

	Disconnect all connections to signal
	@public

]=]
function signal:DisconnectAll()
	for i, v in pairs(self.connections) do
		v:Disconnect()
	end
end

--[=[

	Disconnect the connection from the signal
	@public

]=]
function disconnect:Disconnect()
	self.signal.queue:Remove(self.fn)
	local index = table.find(self.signal.connections, self)
	if index == nil then return end
	table.remove(self.signal.connections, index)
end

--> return
return signal