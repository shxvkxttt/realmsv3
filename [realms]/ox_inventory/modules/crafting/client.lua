if not lib then return end

local CraftingBenches = {}
local Items = require 'modules.items.client'
local createBlip = require 'modules.utils.client'.CreateBlip

---@param id number
---@param data table
local function createCraftingBench(id, data)
	
end

for id, data in pairs(lib.load('data.crafting')) do createCraftingBench(id, data) end

return CraftingBenches
