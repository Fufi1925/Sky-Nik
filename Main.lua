--// RIVALS ARENA NEON PURPLE + MOON SKY
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- Clear Lighting
for _,v in pairs(Lighting:GetChildren()) do
	if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") then
		v:Destroy()
	end
end

task.wait(0.1)

-- SKY
local sky = Instance.new("Sky")
sky.SkyboxBk = "rbxassetid://151165214"
sky.SkyboxDn = "rbxassetid://151165197"
sky.SkyboxFt = "rbxassetid://151165224"
sky.SkyboxLf = "rbxassetid://151165191"
sky.SkyboxRt = "rbxassetid://151165206"
sky.SkyboxUp = "rbxassetid://151165227"

sky.MoonTextureId = "rbxassetid://6444320592"
sky.MoonAngularSize = 30 -- großer Arena-Mond
sky.SunAngularSize = 0
sky.Parent = Lighting

Lighting.Changed:Connect(function()
	if not Lighting:FindFirstChildOfClass("Sky") then
		sky:Clone().Parent = Lighting
	end
end)

-- LIGHTING (Arena Fokus)
Lighting.ClockTime = 20
Lighting.Brightness = 2.6
Lighting.ExposureCompensation = 0.4
Lighting.EnvironmentDiffuseScale = 1
Lighting.EnvironmentSpecularScale = 1
Lighting.Ambient = Color3.fromRGB(120, 85, 190)
Lighting.OutdoorAmbient = Color3.fromRGB(105, 70, 170)

-- ATMOSPHERE
local atmo = Instance.new("Atmosphere")
atmo.Density = 0.38
atmo.Offset = 0.25
atmo.Color = Color3.fromRGB(185, 130, 255)
atmo.Decay = Color3.fromRGB(90, 60, 140)
atmo.Parent = Lighting

-- COLOR CORRECTION (Clean Purple)
local cc = Instance.new("ColorCorrectionEffect")
cc.Contrast = 0.35
cc.Saturation = 0.05
cc.TintColor = Color3.fromRGB(220, 200, 255)
cc.Parent = Lighting

-- BLOOM (Neon Look)
local bloom = Instance.new("BloomEffect")
bloom.Intensity = 1.8
bloom.Size = 65
bloom.Threshold = 0.65
bloom.Parent = Lighting

-- FOG (Arena Close)
Lighting.FogColor = Color3.fromRGB(30, 18, 55)
Lighting.FogStart = 0
Lighting.FogEnd = 350

-- WATER (falls vorhanden)
if Terrain then
	Terrain.WaterColor = Color3.fromRGB(25, 15, 45)
	Terrain.WaterTransparency = 0.05
	Terrain.WaterReflectance = 1
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
end

-- ARENA + WEAPONS → NEON PURPLE
for _,obj in pairs(Workspace:GetDescendants()) do
	if obj:IsA("BasePart") then
		obj.Color = Color3.fromRGB(160, 90, 255)
		obj.Material = Enum.Material.Neon
		obj.Reflectance = 0.15
	elseif obj:IsA("MeshPart") then
		obj.Color = Color3.fromRGB(165, 95, 255)
		obj.Material = Enum.Material.Neon
	end
end
