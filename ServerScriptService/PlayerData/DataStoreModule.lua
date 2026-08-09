	local dts = game:GetService("DataStoreService")
	local plrData = dts:GetDataStore("PlayerData")

	local datastore = {}

	--SAVE DATA
	datastore.saveData = function(player)
		
		if not player.PlayerData then
			warn("Player data not found for " .. player.Name)
			return
		end
		
		-- Move data from folder to table
		
		local inventoryData = {}
		local questData = {}
		local equippedData = {}
		local progressionData = {}
		local currencyData = {}
		
		
		for _, type in ipairs(player.PlayerData.Inventory:GetChildren()) do
			inventoryData[type.Name] = {}
			for _, v in ipairs(type:GetChildren()) do
			inventoryData[type.Name][v.Name] = v.Value
			end
		end
		
		for _, v in ipairs(player.PlayerData.Quest:GetChildren()) do
			questData[v.Name] = v.Value
		end
		
		for _, v in ipairs(player.PlayerData.Equipped:GetChildren()) do
			equippedData[v.Name] = v.Value
		end
		
		for _, v in ipairs(player.PlayerData.Progression:GetChildren()) do
			progressionData[v.Name] = v.Value
		end
		
		for _, v in ipairs(player.PlayerData.Currency:GetChildren()) do
			currencyData[v.Name] = v.Value
		end
		
		-- Update Async
		
		local attempt = 1
		local success
		local errorMsg
		
		repeat
			success, errorMsg = pcall(function()
				plrData:UpdateAsync(player.UserId, function(oldData)
					oldData = oldData or {}

					oldData.Equipped = equippedData
					oldData.Inventory = inventoryData
					oldData.Progression = progressionData
					oldData.Quest = questData
					oldData.Currency = currencyData

					return oldData
				end)
			end)
			if not success then
				print("Unable to save data for ".. player.Name .. " retrying...")
				task.wait(1)
			end
			attempt += 1
		until success or attempt > 10
		
		if success then
			print("Saved data for ".. player.Name)
		else
			warn("Unable to save data for ".. player.Name .. " " .. errorMsg)
		end
	end

	--LOAD DATA
	datastore.loadData = function(player)
		
		-- Get Async
		
		local retrivedData
		
		local attempt = 1
		local success
		local errorMsg
		
		repeat
			success, errorMsg = pcall(function()
				retrivedData = plrData:GetAsync(player.UserId)
			end)
			if not success then
				warn("Unable to retrieve data for " .. player.Name .. "retrying...")
			end
			attempt += 1
		until success or attempt > 10
		
		if success then
			print("Retrieve data for " .. player.Name .. " Successfully")
		else
			player:Kick("Unable to retrieve data for " .. player.Name)
			return
		end
		
		--Check for new player
		
		if not retrivedData then
			print("New player: " .. player.Name .. " Detected")
			return
		end
		
		--Move loaded data into player data folder
		
		if retrivedData.Equipped then
			for k, v in pairs(retrivedData.Equipped) do
				if k == "Ability" then
					player.PlayerData.Equipped.Ability.Value = v
				end
				if k == "Accessory" then
					player.PlayerData.Equipped.Accessory.Value = v
				end
				if k == "Class" then
					player.PlayerData.Equipped.Class.Value = v
				end
				if k == "Race" then
					player.PlayerData.Equipped.Race.Value = v
				end
				if k == "Weapon" then
					player.PlayerData.Equipped.Weapon.Value = v
				end
			end
		end
		
		if retrivedData.Inventory then
			for k, v in pairs(retrivedData.Inventory) do
				
				local categoryFolder = player.PlayerData.Inventory:FindFirstChild(k)
			
				if categoryFolder then
					for k, v in pairs(v) do
						local stored = Instance.new("IntValue")
						stored.Name = k
						stored.Value = v
						stored.Parent = categoryFolder
					end
				end
			end
		end
		
		if retrivedData.Progression then
			for k, v in pairs(retrivedData.Progression) do
				if k == "Experience" then
					player.PlayerData.Progression.Experience.Value = v
				end
				if k == "Level" then
					player.PlayerData.Progression.Level.Value = v
				end
			end
		end
		
		if retrivedData.Quest then
			for k, v in pairs(retrivedData.Quest) do
				local key = Instance.new("IntValue")
				key.Name = k
				key.Value = v
				key.Parent = player.PlayerData.Quest
			end
		end
		
		if retrivedData.Currency then
			for k, v in pairs(retrivedData.Currency) do
				if k == "Money" then
					player.PlayerData.Currency.Money.Value = v
				end
				if k == "Shard" then	
					player.PlayerData.Currency.Shard.Value = v
				end
			end
		end
	end

	--CREATE CONTAINER FOR IN GAME DATA
	datastore.createContainer = function(player)
		local data = Instance.new("Folder")
		data.Parent = player
		data.Name = "PlayerData"

		local prog = Instance.new("Folder")
		prog.Parent = data
		prog.Name = "Progression"

		local lv = Instance.new("IntValue")
		lv.Parent = prog
		lv.Name = "Level"
		lv.Value = 1

		local exp = Instance.new("IntValue")
		exp.Parent = prog
		exp.Name = "Experience"
		
		local currency = Instance.new("Folder")
		currency.Parent = data
		currency.Name = "Currency"
		
		local money = Instance.new("IntValue")
		money.Parent = currency
		money.Name = "Money"
		
		local shard = Instance.new("IntValue")
		shard.Parent = currency
		shard.Name = "Shard"
	
		local inv = Instance.new("Folder")
		inv.Parent = data
		inv.Name = "Inventory"
		
		local storeditem = Instance.new("Folder")
		storeditem.Parent = inv
		storeditem.Name = "Items"
		
		local storedweapon = Instance.new("Folder")
		storedweapon.Parent = inv
		storedweapon.Name = "Weapons"
		
		local storedability = Instance.new("Folder")
		storedability.Parent = inv
		storedability.Name = "Abilities"
		
		local storedacc = Instance.new("Folder")
		storedacc.Parent = inv
		storedacc.Name = "Accessories"
		
		local storedtool = Instance.new("Folder")
		storedtool.Parent = inv
		storedtool.Name = "Tools"

		local quest = Instance.new("Folder")
		quest.Parent = data
		quest.Name = "Quest"

		local equipped = Instance.new("Folder")
		equipped.Parent = data
		equipped.Name = "Equipped"

		local ability = Instance.new("StringValue")
		ability.Parent = equipped
		ability.Name = "Ability"

		local weapon = Instance.new("StringValue")
		weapon.Parent = equipped
		weapon.Name = "Weapon"
		
		local tool = Instance.new("StringValue")
		tool.Parent = equipped
		tool.Name = "Tool"

		local acc = Instance.new("StringValue")
		acc.Parent = equipped
		acc.Name = "Accessory"

		local class = Instance.new("StringValue")
		class.Parent = equipped
		class.Name = "Class"

		local race = Instance.new("StringValue")
		race.Parent = equipped
		race.Name = "Race"
	end

	return datastore
