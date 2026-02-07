-- MADE BY @ASHLENGTHEGREAT
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local SpawnMachineRemote = Net:WaitForChild("RF/SpawnMachine.Action")


local player = Players.LocalPlayer
local oldGui = player.PlayerGui:FindFirstChild("MainUtilityGUI")
if oldGui then oldGui:Destroy() end

local brainrotsList = {
	"Galactio Fantasma",
	"Strawberry Elephant",
	"Din Din Vaultero",
	"Grappellino D'Oro",
    "Martino Gravitino",
	"Bulbito Bandito Traktorito",
	"Burgerini Bearini",
}

local EQUIP_DELAY = 0.5
local autoEquipEnabled = false
local removeVIPEnabled = false
local autoATMEnabled = false
local atmTeleportEnabled = false
local autoCombineEnabled = false

local function isBrainrot(petName)
	if not petName then return false end
	for _, name in ipairs(brainrotsList) do
		if name == petName then return true end
	end
	return false
end

local function getHeldPetName()
	local playerRoot = Workspace:FindFirstChild(player.Name)
	if not playerRoot then return nil end

	for _, child in ipairs(playerRoot:GetChildren()) do
		local render = child:FindFirstChild("RenderModel")
		if render then
			for _, pet in ipairs(render:GetChildren()) do
				if pet:IsA("Model") or pet:IsA("Folder") then
					return pet.Name
				end
			end
		end
	end
	return nil
end

local function isSelectedPetEquipped()
	local heldPet = getHeldPetName()
	return heldPet and isBrainrot(heldPet)
end

local function getMachine()
	local sm = Workspace:FindFirstChild("SpawnMachines")
	if not sm then return nil, nil end

	if sm:FindFirstChild("Blackhole") then
		return sm.Blackhole, "BLACKHOLE"
	end

	if sm:FindFirstChild("ATM") then
		return sm.ATM, "ATM"
	end

	if sm:FindFirstChild("Arcade") then
		return sm.Arcade, "ARCADE"
	end

	return nil, nil
end



local function machineHasPet(machine)
	if not machine then return false end
	return machine.Main.Billboard.BillboardGui.Frame.Brainrots:FindFirstChild("Line_1") ~= nil
end


local godConnection
local godModeEnabled = true

local function enableGodMode(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.BreakJointsOnDeath = false
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	humanoid.MaxHealth = math.huge
	humanoid.Health = math.huge

	if godConnection then godConnection:Disconnect() end
	godConnection = humanoid.HealthChanged:Connect(function()
		if humanoid.Health <= 0 then
			humanoid.Health = humanoid.MaxHealth
		end
	end)
end

task.spawn(function()
	while true do
		task.wait(0.5)
		if godModeEnabled and player.Character then
			pcall(function()
				enableGodMode(player.Character)
			end)
		end
	end
end)

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if godModeEnabled then enableGodMode(char) end
end)

task.spawn(function()
	while true do
		task.wait(EQUIP_DELAY)
		if autoEquipEnabled then
			local char = player.Character
			local backpack = player:FindFirstChild("Backpack")
			if char and backpack then
				local hum = char:FindFirstChild("Humanoid")
				if hum then
					for _, tool in ipairs(backpack:GetChildren()) do
						if tool:IsA("Tool") then
							hum:EquipTool(tool)
							task.wait(0.1)
							if isSelectedPetEquipped() then break end
						end
					end
				end
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(2)
		if removeVIPEnabled then
			for _, obj in ipairs(Workspace:GetDescendants()) do
				if obj:IsA("Model") and obj.Name == "VIPWalls" then
					obj:Destroy()
				end
			end
		end
	end
end)

local ATM_POSITION = Vector3.new(909.410645, 3.532636, 32.877258)
local BLACKHOLE_POSITION = Vector3.new(894.619934, 3.614657, 6.723338)
local ARCADE_POSITION = Vector3.new(901.143799, 3.372710, -15.076845)



task.spawn(function()
	while true do
		task.wait(0.2)

		if not atmTeleportEnabled then continue end
		if not isSelectedPetEquipped() then continue end

		local machine, kind = getMachine()
		if not machine then continue end

		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then continue end

		if kind == "BLACKHOLE" then
	hrp.CFrame = CFrame.new(BLACKHOLE_POSITION)
elseif kind == "ATM" then
	hrp.CFrame = CFrame.new(ATM_POSITION)
elseif kind == "ARCADE" then
	hrp.CFrame = CFrame.new(ARCADE_POSITION)
end
	end
end)


task.spawn(function()
	while true do
		task.wait(0.35)

		if not autoATMEnabled then
			continue
		end

		if not isSelectedPetEquipped() then
			continue
		end

		local machine = getMachine()
		if not machine then
			continue
		end

		-- 🚫 already has pet
		if machineHasPet(machine) then
			continue
		end

		pcall(function()
			SpawnMachineRemote:InvokeServer("Deposit", machine)
		end)
	end
end)


task.spawn(function()
	while true do
		task.wait(0.35)

		if not autoCombineEnabled then continue end

		local machine = getMachine()
		if not machine then continue end

		pcall(function()
			SpawnMachineRemote:InvokeServer("Combine", machine)
		end)
	end
end)



local gui = Instance.new("ScreenGui")
gui.Name = "MainUtilityGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 300)
frame.Position = UDim2.new(0.03, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Ashleng on Top!"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.TextScaled = true
statusLabel.Visible = false
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = gui
Instance.new("UICorner", statusLabel).CornerRadius = UDim.new(0, 12)

task.spawn(function()
	while true do
		task.wait(0.2)

		if not autoATMEnabled then
			statusLabel.Visible = false
			continue
		end

		local _, kind = getMachine()
		statusLabel.Visible = true

		if kind == "BLACKHOLE" then
	statusLabel.Text = "🛸 UFO Event Found!"
elseif kind == "ATM" then
	statusLabel.Text = "💰 Money Event Found!"
elseif kind == "ARCADE" then
	statusLabel.Text = "🎮 Arcade Event Found!"
else
	statusLabel.Text = "⏳ Event not available"
end
	end
end)


local function createToggle(text, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 34)
	btn.Position = UDim2.new(0.05, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = text .. ": OFF"
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		local state = callback()
		btn.Text = text .. ": " .. (state and "ON" or "OFF")
	end)
end

local y = 50

createToggle("Auto Equip Pet", y, function()
	autoEquipEnabled = not autoEquipEnabled
	return autoEquipEnabled
end)
y += 40

createToggle("Remove VIP", y, function()
	removeVIPEnabled = not removeVIPEnabled
	return removeVIPEnabled
end)
y += 40

createToggle("Auto Teleport", y, function()
	atmTeleportEnabled = not atmTeleportEnabled
	return atmTeleportEnabled
end)
y += 40

createToggle("Auto Deposit", y, function()
	autoATMEnabled = not autoATMEnabled
	return autoATMEnabled
end)

y += 40

createToggle("Auto Combine", y, function()
	autoCombineEnabled = not autoCombineEnabled
	return autoCombineEnabled
end)

