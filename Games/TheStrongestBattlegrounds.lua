if getgenv().WexortLoaded then
	return
end
if not game:IsLoaded() then
	game.Loaded:Wait()
end
getgenv().WexortLoaded = true

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Connections = {}
local Animations = {}
local AnimationTracks = {}

do
	local RightDash = Instance.new("Animation")
	RightDash.Parent = ReplicatedFirst
	RightDash.AnimationId = "rbxassetid://10480793962"
	RightDash.Name = "RightDash"

	local LeftDash = Instance.new("Animation")
	LeftDash.Parent = ReplicatedFirst
	LeftDash.AnimationId = "rbxassetid://10480796021"
	LeftDash.Name = "LeftDash"

	local FrontDash = Instance.new("Animation")
	FrontDash.Parent = ReplicatedFirst
	FrontDash.AnimationId = "rbxassetid://10479335397"
	FrontDash.Name = "FrontDash"

	table.insert(Animations, RightDash)
	table.insert(Animations, LeftDash)
	table.insert(Animations, FrontDash)
end

local UpdateCharacter = function(Character)
	if not Character then return end

	local Humanoid = Character:WaitForChild("Humanoid", 2.5)
	local Animator = (Humanoid) and Humanoid:WaitForChild("Animator", 2.5)
	if Animator then
		for _, Animation in Animations do
			print(Animation.Name)
			local Loaded = Animator:LoadAnimation(Animation)
			if Loaded then
				Loaded.Priority = Enum.AnimationPriority.Action
				AnimationTracks[Animation.Name] = Loaded
			end
		end
	end
end
LocalPlayer.CharacterAdded:Connect(UpdateCharacter)
task.spawn(UpdateCharacter, LocalPlayer.Character)

local Repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/gree4e4ka456/WexortLinoria/refs/heads/main/Library.lua'))(); function Library:MakeNotification(Arguments) StarterGui:SetCore("SendNotification", Arguments) end;
local ThemeManager = loadstring(game:HttpGet(Repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/Sepper2023/Scorp.xyz/refs/heads/main/SaveManagerFixed'))()
ThemeManager.BuiltInThemes['Wexort'] = {9, HttpService:JSONDecode('{"FontColor":"ffe8eb","MainColor":"211c1c","AccentColor":"ff333a","BackgroundColor":"0f0f0f","OutlineColor":"302929"}') }
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyTheme('Wexort')

Functions = {
	AddBox = function(Parent, Properties)
		local Box = Instance.new("SelectionBox")
		for Property, Value in pairs(Properties) do
			Box[Property] = Value
		end
		Box.Visible = true
		Box.Parent = Parent
		Box.Adornee = Parent

		return Box
	end
}
Data = {
	ModifyDash = {
		Toggle = true,
		Multiplier = 1.35,
		FakeDash = {
			Toggle = true,
			Distance = 27.5,
			Duration = 0.25,
			Cooldown = 1.5,
			Debounce = false
		}
	},
    Misc = {
        UnlimitedJump = false
    },
	Counter = {
		Detection = true,
		Highlight = {
			LineThickness = 0.125,
			Color3 = Color3.fromRGB(255, 0, 0),
			Transparency = 0,
			SurfaceColor3 = Color3.fromRGB(255, 0, 0),
			SurfaceTransparency = 0.5
		}
	},
	Visual = {
		Shaders = {Toggle = true, NoShadows = true},
		FOV = {Toggle = true, Value = 120},
		WideScreen = {Toggle = true, Value = 0.75},
		MotionBlur = {Toggle = true, Last = Camera.CFrame.LookVector, Time = 0.25, Multiplier = 100},
		CameraSway = {Toggle = true, Multiplier = 10}
	}
}
GuiObjects = {}
GuiObjects["Tabs"] = {}
GuiObjects["Groupboxes"] = {}
GuiObjects["Window"] = Library:CreateWindow({
	Title = "WexortHub | The Strongest Battlegrounds",
	Center = false,
	AutoShow = true,
	TabPadding = 5,
	MenuFadeTime = 0.25
})
GuiObjects.Tabs["Main"] = GuiObjects["Window"]:AddTab("Main")

GuiObjects.Groupboxes["Dash"] = GuiObjects.Tabs.Main:AddLeftGroupbox("Dash Modification")
GuiObjects.Groupboxes["Misc"] = GuiObjects.Tabs.Main:AddLeftGroupbox("Misc")
GuiObjects.Groupboxes["Counter"] = GuiObjects.Tabs.Main:AddRightGroupbox("Counter Detection")
GuiObjects.Groupboxes["Visual"] = GuiObjects.Tabs.Main:AddRightGroupbox("Visual")

GuiObjects.Groupboxes.Dash:AddToggle("ModifyDash", {
	Text = "Modify Dash",
	Default = Data.ModifyDash.Toggle,
	Tooltip = "Allows to modify side dash."
}):OnChanged(function(Value)
	Data.ModifyDash.Toggle = Value
	if Value then
		Connections["MD_Dashed"] = workspace.Live.DescendantAdded:Connect(function(DashVelocity)
			if DashVelocity.Name == "dodgevelocity" then
				while DashVelocity.Parent do
					DashVelocity.Velocity *= Data.ModifyDash.Multiplier
					task.wait()
				end
			end
		end)
	else
		if Connections["MD_Dashed"] then
			Connections["MD_Dashed"]:Disconnect()
			Connections["MD_Dashed"] = nil
		end
	end
end)
GuiObjects.Groupboxes.Dash:AddSlider("DashMultiplier", {
	Text = "Dash Force Multiplier",
	Default = Data.ModifyDash.Multiplier,
	Min = 0,
	Max = 5,
	Rounding = 0.25,
	Compact = false
}):OnChanged(function(Value) 
	Data.ModifyDash.Multiplier = Value
end)

GuiObjects.Groupboxes.Dash:AddDivider({Text = "Fake Dash", Tooltip = "Useful for M1 reset"})

GuiObjects.Groupboxes.Dash:AddToggle("FakeDash", {
	Text = "Fake Dash",
	Default = Data.ModifyDash.FakeDash.Toggle,
	Tooltip = "Allows you to dash from stun."
}):OnChanged(function(Value)
	Data.ModifyDash.FakeDash.Toggle = Value
end)
GuiObjects.Groupboxes.Dash:AddSlider("FakeDashDistance", {
	Text = "Distance",
	Default = Data.ModifyDash.FakeDash.Distance,
	Min = 10,
	Max = 50,
	Rounding = 1,
	Compact = true
}):OnChanged(function(Value) 
	Data.ModifyDash.FakeDash.Distance = Value
end)
GuiObjects.Groupboxes.Dash:AddSlider("FakeDashDuration", {
	Text = "Duration",
	Default = Data.ModifyDash.FakeDash.Duration,
	Min = 0.05,
	Max = 5,
	Rounding = 0.05,
	Compact = true
}):OnChanged(function(Value) 
	Data.ModifyDash.FakeDash.Duration = Value
end)
GuiObjects.Groupboxes.Dash:AddSlider("FakeDashCooldown", {
	Text = "Cooldown",
	Default = Data.ModifyDash.FakeDash.Cooldown,
	Min = 0,
	Max = 10,
	Rounding = 1,
	Compact = true
}):OnChanged(function(Value)
	Data.ModifyDash.FakeDash.Cooldown = Value
end)
GuiObjects.Groupboxes.Dash:AddLabel("Fake Dash Bind"):AddKeyPicker("FakeDashBind", {
	Default = "E",
	SyncToggleState = false,
	Mode = "Toggle",
	Text = "Fake Dash",
	NoUI = false,
	Callback = function()
		if not UserInputService:GetFocusedTextBox() and Data.ModifyDash.FakeDash.Toggle and not Data.ModifyDash.FakeDash.Debounce then
			local Character = LocalPlayer.Character
			local Humanoid = (Character) and Character:FindFirstChildWhichIsA("Humanoid")
			local HRP: Part = (Character) and Character:FindFirstChild("HumanoidRootPart")
			local Animator = (Humanoid) and Humanoid:FindFirstChildWhichIsA("Animator")
			local Camera = workspace.CurrentCamera
			if HRP and Camera then
				Data.ModifyDash.FakeDash.Debounce = true
				task.delay(Data.ModifyDash.FakeDash.Cooldown, function() 
					Data.ModifyDash.FakeDash.Debounce = false
				end)

				local Direction = (UserInputService:IsKeyDown(Enum.KeyCode.A)) and -1 or 1
				local Animation = (Direction == 1) and AnimationTracks["RightDash"] or AnimationTracks["LeftDash"]
				if Animation then
					Animation:Play()
				end
				local CameraCF = Camera.CFrame
				local CameraRV = CameraCF.RightVector * Direction
				local Position = HRP.CFrame.Position + CameraRV * Data.ModifyDash.FakeDash.Distance
				TweenService:Create(HRP, TweenInfo.new(Data.ModifyDash.FakeDash.Duration), {CFrame = CFrame.new(Position)}):Play()
			end
		end
	end
})

GuiObjects.Groupboxes.Misc:AddLabel("Stop Velocity"):AddKeyPicker("StopVelocity", {
	Default = "Z",
	SyncToggleState = false,
	Mode = "Toggle",
	Text = "Stop Velocity",
	NoUI = false,
	Callback = function()
		local Character = LocalPlayer.Character
		local HRP = (Character) and Character:FindFirstChild("HumanoidRootPart")
		if HRP then
			HRP.AssemblyLinearVelocity = Vector3.zero
			HRP.AssemblyAngularVelocity = Vector3.zero
			for _, BV in Character:GetDescendants() do
				if BV:IsA("BodyVelocity") then
					BV.Parent = nil
				end
			end
		end
	end
})
GuiObjects.Groupboxes.Misc:AddLabel("Camera Lock Bind"):AddKeyPicker("CameraLockBind", {
	Default = "LeftShift",
	SyncToggleState = false,
	Mode = "Toggle",
	Text = "Fake Dash",
	NoUI = false,
	ChangedCallback = function(Key)
		LocalPlayer:FindFirstChild("PlayerScripts"):FindFirstChild("PlayerModule"):FindFirstChild("CameraModule"):FindFirstChild("MouseLockController"):FindFirstChild("BoundKeys").Value = Key.Name
	end
}); LocalPlayer:FindFirstChild("PlayerScripts"):FindFirstChild("PlayerModule"):FindFirstChild("CameraModule"):FindFirstChild("MouseLockController"):FindFirstChild("BoundKeys").Value = "LeftShift"
GuiObjects.Groupboxes.Misc:AddToggle("UnlimitedJump", {
	Text = "Unlimited Jump",
	Default = Data.Misc.UnlimitedJump,
	Tooltip = "Minimizes any jump limits."
}):OnChanged(function(Value)
	Data.Misc.UnlimitedJump = Value
    if Value then
		Connections["UJ_LimitAdded"] = workspace.Live.DescendantAdded:Connect(function(Descendant)
            if LocalPlayer.Character and Descendant:IsDescendantOf(LocalPlayer.Character) and Descendant.Name == "NoJump" then
                repeat
                    Descendant:Destroy()
                    task.wait()
                until
                    Descendant.Parent == nil
            end
        end)
    else
        if Connections["UJ_LimitAdded"] then
            Connections["UJ_LimitAdded"]:Disconnect()
            Connections["UJ_LimitAdded"] = nil
        end
    end
end)

GuiObjects.Groupboxes.Counter:AddToggle("CounterDetection", {
	Text = "Counter Detection",
	Default = Data.Counter.Detection,
	Tooltip = "Detects counters."
}):OnChanged(function(Value)
	Data.Counter.Detection = Value
	if Value then
		Connections["CD_CounterAdded"] = workspace.Live.DescendantAdded:Connect(function(Descendant)
			if not Descendant:IsDescendantOf(LocalPlayer.Character) then
				if string.find(Descendant.Name, "Counter") and Descendant:IsA("Accessory") then
					local Character = Descendant:FindFirstAncestorWhichIsA("Model")
					local HRP = (Character) and Character:FindFirstChild("HumanoidRootPart")
					if HRP then
                        local CounterBox = Functions.AddBox(Character, Data.Counter.Highlight)
						local Removed
						Removed = Descendant.AncestryChanged:Connect(function()
							if not Descendant.Parent or not Character.Parent then
								Removed:Disconnect()
								CounterBox:Destroy()
							end
						end)
					end
				end
			end
		end)
	else
		if Connections["CD_CounterAdded"] then
			Connections["CD_CounterAdded"]:Disconnect()
			Connections["CD_CounterAdded"] = nil
		end
	end
end)

GuiObjects.Groupboxes.Counter:AddDivider({Text = "ESP Configuration"})

GuiObjects.Groupboxes.Counter:AddSlider("LineThickness", {
	Text = "Line Thickness",
	Default = Data.Counter.Highlight.LineThickness,
	Min = 0.1,
	Max = 1,
	Rounding = 0.1,
	Compact = true
}):OnChanged(function(Value) 
	Data.Counter.Highlight.LineThickness = Value
end)
GuiObjects.Groupboxes.Counter:AddSlider("LineTransparency", {
	Text = "Line Transparency",
	Default = Data.Counter.Highlight.Transparency,
	Min = 0,
	Max = 1,
	Rounding = 0.1,
	Compact = true
}):OnChanged(function(Value) 
	Data.Counter.Highlight.Transparency = Value
end)
GuiObjects.Groupboxes.Counter:AddSlider("SurfaceTransparency", {
	Text = "Surface Transparency",
	Default = Data.Counter.Highlight.SurfaceTransparency,
	Min = 0,
	Max = 1,
	Rounding = 0.1,
	Compact = true
}):OnChanged(function(Value) 
	Data.Counter.Highlight.SurfaceTransparency = Value
end)
GuiObjects.Groupboxes.Counter:AddLabel("Line Color"):AddColorPicker("LineColor", {
	Default = Data.Counter.Highlight.Color3,
	Title = "Line Color",
	Callback = function(Value)
		Data.Counter.Highlight.Color3 = Value
	end
})
GuiObjects.Groupboxes.Counter:AddLabel("Surface Color"):AddColorPicker("SurfaceColor", {
	Default = Data.Counter.Highlight.SurfaceColor3,
	Title = "Surface Color",
	Callback = function(Value)
		Data.Counter.Highlight.SurfaceColor3 = Value
	end
})


GuiObjects.Groupboxes.Visual:AddToggle("LowGraphicsShaders", {
	Text = "Low-Graphics Shaders",
	Default = Data.Visual.Shaders.Toggle,
	Tooltip = "Adds bloom and depth of field effects."
}):OnChanged(function(Value)
	Data.Visual.Shaders.Toggle = Value
	if Value then
		local BG = Instance.new("BloomEffect")
		BG.Name = "#Shaders"
		BG.Parent = Lighting
		BG.Intensity = 0.25
		BG.Size = 5
		BG.Threshold = 0.5
		local CC = Instance.new("ColorCorrectionEffect")
		CC.Name = "#Shaders"
		CC.Parent = Lighting
		CC.Contrast = 0.125
		CC.Brightness = 0.05
		CC.Saturation = 0.575
		CC.TintColor = Color3.fromRGB(225, 245, 255)
	else
		for _, Child in Lighting:GetChildren() do
			if Child.Name == "#Shaders" then
				Child:Destroy()
			end
		end
	end
end)
GuiObjects.Groupboxes.Visual:AddToggle("NoShadows", {
	Text = "No Shadows",
	Default = Data.Visual.Shaders.NoShadows,
	Tooltip = "Disables shadows."
}):OnChanged(function(Value)
	Data.Visual.Shaders.NoShadows = Value
	Lighting.GlobalShadows = not Value
end)

GuiObjects.Groupboxes.Visual:AddDivider({Text = "FOV Lock"})

GuiObjects.Groupboxes.Visual:AddToggle("FOVLock", {
	Text = "FOV Lock",
	Default = Data.Visual.FOV.Toggle,
	Tooltip = "Locks camera's field of view."
}):OnChanged(function(Value)
	Data.Visual.FOV.Toggle = Value
	if Value then
		Connections["RS_FOV"] = RunService.RenderStepped:Connect(function()
			Camera.FieldOfView = Data.Visual.FOV.Value
		end)
	else
		if Connections["RS_FOV"] then
			Connections["RS_FOV"]:Disconnect()
			Connections["RS_FOV"] = nil
		end
	end
end)
GuiObjects.Groupboxes.Visual:AddSlider("FOVValue", {
	Text = "FOV Value",
	Default = Data.Visual.FOV.Value,
	Min = 0,
	Max = 120,
	Rounding = 5,
	Compact = true
}):OnChanged(function(Value) 
	Data.Visual.FOV.Value = Value
end)

GuiObjects.Groupboxes.Visual:AddDivider({Text = "Wide Screen"})

GuiObjects.Groupboxes.Visual:AddToggle("WideScreen", {
	Text = "Wide Screen",
	Default = Data.Visual.WideScreen.Toggle,
	Tooltip = "Makes screen wide."
}):OnChanged(function(Value)
	Data.Visual.WideScreen.Toggle = Value
	if Value then
		Connections["RS_WS"] = RunService.RenderStepped:Connect(function()
			Camera.CFrame *= CFrame.new(0, 0, 0, 1, 0, 0, 0, Data.Visual.WideScreen.Value, 0, 0, 0, 1)
		end)
	else
		if Connections["RS_WS"] then
			Connections["RS_WS"]:Disconnect()
			Connections["RS_WS"] = nil
		end
	end
end)
GuiObjects.Groupboxes.Visual:AddSlider("ScreenLength", {
	Text = "Screen Length",
	Default = Data.Visual.WideScreen.Value,
	Min = 0.05,
	Max = 1,
	Rounding = 0.05,
	Compact = true
}):OnChanged(function(Value) 
	Data.Visual.WideScreen.Value = Value
end)

GuiObjects.Groupboxes.Visual:AddDivider({Text = "Motion Blur"})

GuiObjects.Groupboxes.Visual:AddToggle("MotionBlur", {
	Text = "Motion Blur",
	Default = Data.Visual.MotionBlur.Toggle,
	Tooltip = "Adds motion blur effect."
}):OnChanged(function(Value)
	Data.Visual.MotionBlur.Toggle = Value
	if Value then
		local Blur = Instance.new("BlurEffect")
		Blur.Name = "#MotionBlur"
		Blur.Parent = Lighting
		local DOF = Instance.new("DepthOfFieldEffect")
		DOF.Name = "#MotionBlur"
		DOF.Parent = Lighting
		DOF.FarIntensity = 0.25
		DOF.FocusDistance = 0
		DOF.InFocusRadius = 50
		DOF.NearIntensity = 1

		Connections["RS_MB"] = RunService.RenderStepped:Connect(function()
			local Time = Data.Visual.MotionBlur.Time
			local Multiplier = Data.Visual.MotionBlur.Multiplier

			if Blur.Size - 0.05 > 0 then
				Blur.Size -= 0.05
			end

			local Magnitude = (Camera.CFrame.LookVector - Data.Visual.MotionBlur.Last).Magnitude
			TweenService:Create(DOF, TweenInfo.new(Time, Enum.EasingStyle.Sine), {FarIntensity = Magnitude * (Multiplier / 10)}):Play()
			TweenService:Create(Blur, TweenInfo.new(Time, Enum.EasingStyle.Sine), {Size = Magnitude * Multiplier}):Play()
			Data.Visual.MotionBlur.Last = Camera.CFrame.LookVector
		end)
	else
		if Connections["RS_MB"] then
			Connections["RS_MB"]:Disconnect()
			Connections["RS_MB"] = nil
		end

		for _, Child in Lighting:GetChildren() do
			if Child.Name == "#MotionBlur" then
				Child:Destroy()
			end
		end
	end
end)
GuiObjects.Groupboxes.Visual:AddSlider("BlurTime", {
	Text = "Blur Time",
	Default = Data.Visual.MotionBlur.Time,
	Min = 0.05,
	Max = 3,
	Rounding = 0.05,
	Compact = true
}):OnChanged(function(Value) 
	Data.Visual.MotionBlur.Time = Value
end)
GuiObjects.Groupboxes.Visual:AddSlider("BlurMultiplier", {
	Text = "Blur Multiplier",
	Default = Data.Visual.MotionBlur.Multiplier,
	Min = 10,
	Max = 500,
	Rounding = 10,
	Compact = true
}):OnChanged(function(Value) 
	Data.Visual.MotionBlur.Multiplier = Value
end)

GuiObjects.Groupboxes.Visual:AddDivider({Text = "Camera Sway"})

GuiObjects.Groupboxes.Visual:AddToggle("CameraSway", {
	Text = "Camera Sway",
	Default = Data.Visual.CameraSway.Toggle,
	Tooltip = "Adds sway effect on camera move."
}):OnChanged(function(Value)
	Data.Visual.CameraSway.Toggle = Value
	if Value then
		local Turn = 0
		local Lerp = function(a, b, t) 
			return a + (b - a) * t 
		end

		RunService:BindToRenderStep("CameraSway", Enum.RenderPriority.Camera.Value + 1, function(DeltaTime)
			local Multiplier = Data.Visual.CameraSway.Multiplier
			local MouseDelta = UserInputService:GetMouseDelta()

			Turn = Lerp(Turn, math.clamp(MouseDelta.X, -Multiplier, Multiplier), (DeltaTime * Multiplier))
			Camera.CFrame *= CFrame.Angles(0, 0, math.rad(Turn))
		end)
	else
		RunService:UnbindFromRenderStep("CameraSway")
	end
end)
GuiObjects.Groupboxes.Visual:AddSlider("SwayMultiplier", {
	Text = "Sway Multiplier",
	Default = Data.Visual.CameraSway.Multiplier,
	Min = 5,
	Max = 50,
	Rounding = 1,
	Compact = true
}):OnChanged(function(Value) 
	Data.Visual.CameraSway.Multiplier = Value
end)

Library:MakeNotification({
	Title = "WexortHub",
	Text = "Loaded!",
	Duration = "5",
})
