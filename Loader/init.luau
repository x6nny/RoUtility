--!strict
local loader = {}
loader.__index = loader

--> Constructor

--[=[

	Create a new loader class
	@param parent Instance

]=]
function loader.new(parent : Instance)
	local self = setmetatable({
		modules = {}
	}, loader)
	
	for _, v in pairs(parent:GetDescendants()) do
		if v:IsA('ModuleScript') then
			table.insert(self.modules, require(v))
		end
	end
	
	return self
end

--> Methods

--[=[

	Call the Init function on all loaded modules if it exists

]=]
function loader:Init()
	for _, v in pairs(self.modules) do
		if v.Init ~= nil and typeof(v.Init) == 'function' then
			task.spawn(v.Init)
		end
		if v.init ~= nil and typeof(v.init) == 'function' then
			task.spawn(v.init)
		end
	end
end

--> return
return loader
