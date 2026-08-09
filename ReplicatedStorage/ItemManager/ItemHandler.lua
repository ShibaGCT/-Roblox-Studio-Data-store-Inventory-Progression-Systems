local itemHandler = {}

local items = require(game.ReplicatedStorage.ItemManager.Items)

itemHandler.GiveItem = function(player, item, amount)
	
	local image = items[item].Image
	local rarity = items[item].Rarity
	
		
	local inventory = player.PlayerData.Inventory.Items
	if inventory:FindFirstChild(item) then
		inventory[item].Value += amount
		return
	end
	local itemData = Instance.new("IntValue")
	itemData.Name = item
	itemData.Value = amount
	itemData.Parent = inventory
end

itemHandler.RemoveItem = function(player, item, amount)
	local inventory = player.PlayerData.Inventory.Items
	if not inventory:FindFirstChild(item) then return end
	if amount >= inventory[item].Value then
		inventory[item]:Destroy()
		return
	end
	inventory[item].Value -= amount
end

return itemHandler















