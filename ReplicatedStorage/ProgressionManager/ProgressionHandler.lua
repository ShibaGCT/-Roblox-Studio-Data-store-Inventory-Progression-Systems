local ProgressionHandler = {}

ProgressionHandler.maxLevel = 50

ProgressionHandler.getRequiredEXP = function(level)
	return math.floor(100 + (level * 12.5))
end

ProgressionHandler.setup = function(player)
	player.PlayerData.Progression.Experience.Changed:Connect(function()
		local exp = player.PlayerData.Progression.Experience
		local level = player.PlayerData.Progression.Level
		local requiredEXP = ProgressionHandler.getRequiredEXP(level.Value)
		
		if level.Value >= ProgressionHandler.maxLevel then
			exp.Value = 0
			level.Value = ProgressionHandler.maxLevel
			return
		end
		
		while exp.Value >= requiredEXP do
			exp.Value -= requiredEXP
			level.Value += 1
			
			requiredEXP = ProgressionHandler.getRequiredEXP(level.Value)
		end
	end)
end

ProgressionHandler.addEXP = function(player, amount)
	player.PlayerData.Progression.Experience.Value += amount
end


return ProgressionHandler






