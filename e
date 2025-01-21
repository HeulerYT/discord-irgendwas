-- Cmds
if table.find(getgenv().Alts,game.Players.LocalPlayer.UserId) then
	getgenv().PointInTable = table.find(getgenv().Alts,game.Players.LocalPlayer.UserId)
else
	return
end
if game.Players.LocalPlayer.Name == getgenv().HostUser or getgenv().Executed then
	return
end


getgenv().Executed = true

--// Code --//

local Services = {
	["Players"] = game:GetService("Players"),
}

local Variables = {
	HostUser = getgenv().HostUser,
	Player = game.Players.LocalPlayer,
}

local Host = Services["Players"]:FindFirstChild(Variables["HostUser"])

if not Host then
	print("Host is not here waiting for him to join!")
	Services["Players"]:WaitForChild(Variables["HostUser"],9e9)
	Host = Services["Players"]:FindFirstChild(Variables["HostUser"])
end
print("Script loaded!")
local CmdSettings = {}

local function AirLock(Type)
	if CmdSettings["AirLock"] == nil and Type == true then
		local BP = Variables["Player"].Character.HumanoidRootPart:FindFirstChild("AirLockBP")
		if BP then
			BP:Destroy()
		end
		CmdSettings["AirLock"] = true
		Variables["Player"].Character.HumanoidRootPart.CFrame = Variables["Player"].Character.HumanoidRootPart.CFrame*CFrame.new(0,10,0)
		local BP = Instance.new("BodyPosition",Variables["Player"].Character.HumanoidRootPart)
		BP.Name = "AirLockBP"
		BP.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		BP.Position = Variables["Player"].Character.HumanoidRootPart.Position
	elseif CmdSettings["AirLock"] == true and Type == false then
		CmdSettings["AirLock"] = nil
		local BP = Variables["Player"].Character.HumanoidRootPart:FindFirstChild("AirLockBP")
		if BP then
			BP:Destroy()
		end
	end
end



local BringLocations = {
	["bank"] = CFrame.new(-396.988922, 21.7570763, -293.929779, -0.102468058, -1.9584887e-09, -0.994736314, 7.23731564e-09, 1, -2.71436984e-09, 0.994736314, -7.47735651e-09, -0.102468058),
	["admin"] = CFrame.new(-872.453674, -32.6421318, -532.476379, 0.999682248, -1.36019978e-08, 0.0252073351, 1.33811247e-08, 1, 8.93094043e-09, -0.0252073351, -8.59080007e-09, 0.999682248),
	["klub"] = CFrame.new(-264.434479, 0.0355005264, -430.854736, -0.999828756, 9.58909574e-09, -0.0185054261, 9.92017934e-09, 1, -1.77993904e-08, 0.0185054261, -1.79799198e-08, -0.999828756),	
	["vault"] = CFrame.new(-495.485901, 23.1428547, -284.661713, -0.0313318223, -4.10440322e-08, 0.999509037, 2.18453966e-08, 1, 4.17489829e-08, -0.999509037, 2.31427428e-08, -0.0313318223),
	["train"] = CFrame.new(591.396118, 34.5070686, -146.159561, 0.0698467195, -4.91725913e-08, -0.997557759, 5.03374231e-08, 1, -4.57684664e-08, 0.997557759, -4.70177071e-08, 0.0698467195),	
}

local SetupsTable = {
	Bank = {
		Origin = CFrame.new(-386.826202, 21.2503242, -325.340912, 0.998742342, 0, -0.0501373149, 0, 1, 0, 0.0501373149, 0, 0.998742342)*CFrame.new(0,0,-3),
		ZMultiplier = 3,
		XMultiplier = 8,
		PerRow = 10,
		Rows = 4,
	},
	Admin = {
		Origin = CFrame.new(-884.12915, -38.3972931, -545.291809, -0.99998939, 2.69316498e-08, -0.00460755778, 2.6944301e-08, 1, -2.68358624e-09, 0.00460755778, -2.80770518e-09, -0.99998939),
		ZMultiplier = 3,
		XMultiplier = 8,
		PerRow = 10,
		Rows = 4,
	},
	Klub = {
		Origin = CFrame.new(-237.016571, -4.87585974, -411.940063, 0.994918466, -1.5840282e-08, -0.100683607, 6.8329018e-09, 1, -8.9807088e-08, 0.100683607, 8.86627731e-08, 0.994918466),
		ZMultiplier = 6,
		XMultiplier = -12,
		PerRow = 10,
		Rows = 4,
	},
	Vault = {
		Origin = CFrame.new(-519.201355, 23.1994667, -292.362, -0.0597927198, 6.70288927e-08, -0.998210788, 2.96872589e-08, 1, 6.53707701e-08, 0.998210788, -2.57254467e-08, -0.0597927198),
		ZMultiplier = -2.5,
		XMultiplier = 4,
		PerRow = 10,
		Rows = 4,
	},
	Train = {
		Origin = CFrame.new(606.527588, 34.5070801, -159.083542, 0.0376962014, -7.60452892e-08, 0.999289274, 6.54496404e-08, 1, 7.36304173e-08, -0.999289274, 6.26275352e-08, 0.0376962014),
		ZMultiplier = 5,
		XMultiplier = -7,
		PerRow = 10,
		Rows = 4,
	}
}
local function Setup(Type,Debugmode)
	CmdSettings["Aura"] = nil
	if Debugmode then
		for PointInTable = 1,40 do
			local Table = SetupsTable[Type]

			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Table["Origin"]

			local XAxis 
			local ZAxis
			local i 
			if PointInTable <= 10 then
				i = 1
			elseif PointInTable <= 20 then
				i = 2
			elseif PointInTable <= 30 then
				i = 3
			elseif PointInTable <= 40 then
				i = 4
			end
			if i == 1 then
				if PointInTable <= Table["PerRow"]   then
					XAxis = 0
					if PointInTable == 1 then
						ZAxis = 0
					else
						ZAxis = (PointInTable-1)*Table["ZMultiplier"]
					end

				end
			else
				local index = i*Table["PerRow"]
				if (Table["PerRow"]*i) >= PointInTable then
					XAxis = (i-1)*Table["XMultiplier"]
					ZAxis = (i*Table["PerRow"]-PointInTable)*Table["ZMultiplier"]

				end
			end


			game.Players.LocalPlayer.Character.Archivable = true
			local clone = game.Players.LocalPlayer.Character:Clone()
			clone.Parent = workspace
			clone.HumanoidRootPart.CFrame = Table["Origin"]*CFrame.new(XAxis,0,ZAxis)
		end
	else
		local Table = SetupsTable[Type]

		local PointInTable = getgenv().PointInTable
		local XAxis 
		local ZAxis
		local i
		if PointInTable <= 10 then
			i = 1
		elseif PointInTable <= 20 then
			i = 2
		elseif PointInTable <= 30 then
			i = 3
		elseif PointInTable <= 40 then
			i = 4
		end

		if i == 1 then
			if PointInTable <= Table["PerRow"]   then
				XAxis = 0
				if PointInTable == 1 then
					ZAxis = 0
				else
					ZAxis = (PointInTable-1)*Table["ZMultiplier"]
				end

			end
		else
			local index = i*Table["PerRow"]
			if (Table["PerRow"]*i) >= PointInTable then
				XAxis = (i-1)*Table["XMultiplier"]
				ZAxis = (i*Table["PerRow"]-PointInTable)*Table["ZMultiplier"]

			end
		end


		Variables["Player"].Character.HumanoidRootPart.CFrame = Table["Origin"]*CFrame.new(XAxis,0,ZAxis)
	end

end

local CurrAnim

local LPlayer = getgenv().HostUser

local function Initiate()
	CurrAnim = nil
	for Index,Var in pairs(CmdSettings) do
		CmdSettings[Var] = nil
	end
	CmdSettings = {}

	local function onPlayerChatted(player, msg)
		if player == LPlayer then
        local Message = msg:lower()
		local Args = string.split(Message," ")
		
			if Message == ".circle host" and Host and Host.Character and Host.Character:FindFirstChild("Humanoid") and Host.Character.Humanoid.Health > 0 then
				local angle = 0
				local cfr = Host.Character.HumanoidRootPart.CFrame*CFrame.new(0,1,0)
				local Index = 0
				local size = 3

				local PointInTable = getgenv().PointInTable

				local ZAxis
				local angle = 0
				if PointInTable <= 10 then
					ZAxis = 2
					angle = (10-PointInTable)
				elseif PointInTable <= 20 then
					ZAxis = -1
					angle = (20-PointInTable)
				elseif PointInTable <= 30 then
					ZAxis = -4
					angle = (30-PointInTable)
				elseif PointInTable <= 40 then
					ZAxis = -8
					angle = (40-PointInTable)
				end
				angle = angle*36
				local Clone = game.Players.LocalPlayer.Character
				Clone.HumanoidRootPart.CFrame = cfr * CFrame.fromEulerAnglesXYZ(0,math.rad(angle),0) * CFrame.new(0,-size,-10)
				Clone.HumanoidRootPart.CFrame=Clone.HumanoidRootPart.CFrame*CFrame.new(0,0,2)
				Clone.HumanoidRootPart.CFrame=Clone.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(180),0)
			elseif Args[1] == ".airlock" then
				AirLock(true)
			elseif Args[1] == ".stopairlock" then
				AirLock(false)
			elseif Message == ".bring" then
				-- didnt feel the need for a function lmao
				if Host and Host.Character and Host.Character:FindFirstChild("HumanoidRootPart") then
					Variables["Player"].Character.HumanoidRootPart.CFrame = Host.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,-1)
				end
			elseif Message == ".setup bank" then
				Setup("Bank")
			elseif Message == ".setup admin" then
				Setup("Admin")
			elseif Message == ".setup klub" then
				Setup("Klub")
			elseif Message == ".setup vault" then
				Setup("Vault")
			elseif Message == ".setup train" then
				Setup("Train")
		end
	end)
end

if Host then
	Initiate()
end

Services["Players"].PlayerAdded:Connect(function(Player)
	if Player.Name == Variables["HostUser"] then
		Initiate()
	end
end)
