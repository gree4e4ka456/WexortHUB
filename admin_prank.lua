local Player = game.Players.LocalPlayer
local StarterGui = game.StarterGui
local TweenService = game:GetService("TweenService")
local Lighting = game.Lighting

-- Randomize map
for _, Part in pairs(workspace:GetDescendants()) do
	if Part:IsA("Part") then
		Part.Material = Enum.Material:GetEnumItems()[math.random(1, #Enum.Material:GetEnumItems())]
		Part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
		Part.Orientation = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360))
		Part.Shape = Enum.PartType:GetEnumItems()[math.random(1, #Enum.PartType:GetEnumItems())]
	end
end


-- Randomize lighting
for _, LightingObject in pairs(Lighting:GetDescendants()) do
	LightingObject:Destroy()
end
local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
ColorCorrectionEffect.Parent = Lighting
task.defer(function()
	while task.wait(1) do
		TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1), {TintColor = Color3.fromRGB(math.random(155, 255), math.random(155, 255), math.random(155, 255))}):Play()
	end
end)

-- Randomize UIs
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
for _, GuiObject in pairs(Player.PlayerGui:GetDescendants()) do
	if GuiObject:IsA("GuiObject") then
		GuiObject.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
		GuiObject.Rotation = math.random(0, 360)
	end
end
for _, GuiObject in pairs(StarterGui:GetDescendants()) do
	if GuiObject:IsA("GuiObject") then
		GuiObject.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
		GuiObject.Rotation = math.random(0, 360)
	end
end

-- Music
local Music = Instance.new("Sound")
Music.SoundId = "rbxassetid://1843789930"
Music.Parent = workspace
Music.Name = "Dead End"
Music.Looped = true
Music.Volume = 5
Music.PlaybackSpeed = 0.75
Music:Play()

-- Sound
for _, Sound in pairs(game:GetDescendants()) do
	if Sound:IsA("Sound") then
		Sound.Volume += 1.5
		Sound.RollOffMaxDistance = 100000
		Sound.RollOffMinDistance = 10
		local ReverbEffect = Instance.new("ReverbSoundEffect")
		ReverbEffect.Parent = Sound
		ReverbEffect.DryLevel = 20
		ReverbEffect.WetLevel = 5
		ReverbEffect.DecayTime = 0.1
	end
end

-- Day/Night
local CycleTime = 0.5 * 60
local MiD = 24 * 60
local StartTime = tick() - (Lighting:getMinutesAfterMidnight() / MiD) * CycleTime
local EndTime = StartTime + CycleTime


task.defer(function()
    while task.wait() do
	    local CurrentTime = tick()

	    if CurrentTime > EndTime then
		    StartTime = EndTime
	        EndTime = StartTime + CycleTime
	    end

	    Lighting:setMinutesAfterMidnight((CurrentTime - StartTime) * (MiD / CycleTime))
    end
end)
