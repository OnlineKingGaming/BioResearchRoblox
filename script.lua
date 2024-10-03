local TweenService = game:GetService("TweenService")

local BreachButton = script.Parent -- Adjust this to refer to the parent of the script directly
local BreachLED = workspace.BreachLEDs:GetChildren()
local Lights = workspace.BreachLEDs:GetDescendants()
local Sound = game.Workspace.BreachAlarm.BreachSound
local Sound2 = game.Workspace.BreachAlarm.AttentionPersonnel

local alarmsOn = false
local tweens = {}

-- Set up the PointLights and create tweens for each light
for i, v in pairs(Lights) do
	if v:IsA("PointLight") then
		v.Color = Color3.fromRGB(255, 255, 255)

		-- Create the tween to switch color to red
		local goalToRed = {Color = Color3.new(1, 0, 0.0156863)}
		local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
		local tweenToRed = TweenService:Create(v, tweenInfo, goalToRed)

		-- Store the tween for later use
		table.insert(tweens, {light = v, tween = tweenToRed})
	end
end

-- Function to create tweens for BreachLED parts
local function createColorTween(part, color)
	local goal = {Color = color}
	local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	return TweenService:Create(part, tweenInfo, goal)
end

-- Function to toggle the alarm
local function toggleAlarm()
	if alarmsOn == false then
		alarmsOn = true

		-- Play sounds
		Sound:Play()
		Sound2:Play()

		-- Create tweens to change the BreachLED color to red
		for i, v in pairs(BreachLED) do
			if v:IsA("BasePart") then
				local redTween = createColorTween(v, Color3.fromRGB(255, 0, 0)) -- Really red
				redTween:Play()
			end
		end

		-- Play the tween to change the lights to red
		for y, data in pairs(tweens) do
			data.tween:Play()
		end
	else
		alarmsOn = false

		-- Stop sounds
		Sound:Stop()
		Sound2:Stop()

		-- Create tweens to change the BreachLED color to white
		for i, v in pairs(BreachLED) do
			if v:IsA("BasePart") then
				local whiteTween = createColorTween(v, Color3.fromRGB(248, 248, 248)) -- Institutional white
				whiteTween:Play()
			end
		end

		-- Cancel the tween and reset the light color to white
		for _, data in pairs(tweens) do
			data.tween:Cancel()
			data.light.Color = Color3.fromRGB(255, 255, 255)
		end
	end
end

-- Ensure ClickDetector is properly connected
if BreachButton:FindFirstChild("ClickDetector") then
	BreachButton.ClickDetector.MouseClick:Connect(toggleAlarm)
else
	warn("ClickDetector not found on the button.")
end
