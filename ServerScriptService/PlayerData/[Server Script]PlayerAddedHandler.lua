local DataStore = require(game.ServerScriptService.PlayerData.DataStoreModule)
local ProgHandler = require(game.ReplicatedStorage.Progression.ProgressionHandler)

game.Players.PlayerAdded:Connect(function(player)
	DataStore.createContainer(player)
	DataStore.loadData(player)
	ProgHandler.setup(player)
end)

game.Players.PlayerRemoving:Connect(function(player)
	DataStore.saveData(player)
end)

game:BindToClose(function()
	for _, player in pairs(game.Players:GetPlayers()) do
		DataStore.saveData(player)
	end
end)
