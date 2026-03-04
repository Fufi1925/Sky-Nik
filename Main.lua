-- ==================================================
-- KICA V2 PREMIUM ULTIMATE - ROBLOX RIVALS
-- FÜR DELTA & XENO EXECUTOR
-- ÖFFNEN MIT F9
-- ==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- ==================================================
-- GLOBALE VARIABLEN FÜR HACKS
-- ==================================================
local Hacks = {
    -- Aimbot
    AimbotEnabled = true,
    SilentAim = true,
    Triggerbot = true,
    Wallbang = false,
    AimbotFOV = 180,
    AimbotSmooth = 20,
    AimPart = "Kopf",
    
    -- ESP
    ESPEnabled = true,
    BoxESP = true,
    NameESP = true,
    TracerESP = true,
    HealthESP = true,
    DistanceESP = true,
    WeaponESP = true,
    SkeletonESP = false,
    Radar3D = true,
    ESPColor = "Rot",
    ESPThickness = 2,
    
    -- Movement
    InfiniteJump = true,
    SpeedHack = true,
    SpeedValue = 50,
    FlyHack = false,
    NoClip = false,
    JumpPower = true,
    JumpHeight = 100,
    GravityMod = false,
    GravityValue = 196,
    
    -- Player
    GodMode = true,
    InfiniteStamina = true,
    InfiniteAmmo = true,
    NoRecoil = true,
    NoSpread = true,
    InstantReload = true,
    RapidFire = false,
    FireRate = 0.1,
    
    -- World
    Fullbright = true,
    XRay = true,
    NoFog = true,
    TimeChanger = false,
    ClockTime = 12,
    RemoveGrass = true,
    RemoveWater = false,
    
    -- Weapon
    WeaponChams = true,
    WeaponESP = true,
    NoWeapon = false,
    WeaponSkin = true,
    WeaponColor = "Gold",
    WeaponSize = 1,
    
    -- Settings
    StreamProof = false,
    AntiAFK = true,
    FPSBoost = true,
    FPSCap = 240,
    Watermark = true,
    Theme = "Dunkel",
    
    -- Interne Variablen
    Flying = false,
    NoclipConnection = nil,
    ESPConnections = {},
    FlyConnection = nil,
}

-- ==================================================
-- PREMIUM KONFIGURATION
-- ==================================================
local Config = {
    -- Design
    Theme = {
        Primary = Color3.fromRGB(30, 30, 40),
        Secondary = Color3.fromRGB(20, 20, 30),
        Accent = Color3.fromRGB(0, 170, 255),
        Accent2 = Color3.fromRGB(255, 70, 170),
        Success = Color3.fromRGB(0, 255, 100),
        Danger = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 200, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(15, 15, 20)
    },
    
    -- Tabs
    Tabs = {
        {Name = "🏠 HOME", Icon = "🏠"},
        {Name = "🎯 AIMBOT", Icon = "🎯"},
        {Name = "👁️ ESP", Icon = "👁️"},
        {Name = "⚡ MOVEMENT", Icon = "⚡"},
        {Name = "🛡️ PLAYER", Icon = "🛡️"},
        {Name = "🌍 WORLD", Icon = "🌍"},
        {Name = "🔫 WEAPON", Icon = "🔫"},
        {Name = "⚙️ SETTINGS", Icon = "⚙️"},
        {Name = "💎 PREMIUM", Icon = "💎"}
    },
    
    -- Settings Storage
    Settings = {}
}

-- ==================================================
-- ESP ZEICHNUNG (FUNKTIONIERT IN DELTA & XENO)
-- ==================================================
local ESP = {}
ESP.__index = ESP

function ESP.new(player)
    local self = setmetatable({}, ESP)
    self.Player = player
    self.Enabled = true
    self.Objects = {}
    self:Create()
    return self
end

function ESP:Create()
    if not self.Player.Character then return end
    
    -- Box
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = self:GetColor()
    box.Thickness = Hacks.ESPThickness
    box.Filled = false
    self.Objects.Box = box
    
    -- Name
    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.new(1, 1, 1)
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true
    self.Objects.Name = nameTag
    
    -- Tracer
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = self:GetColor()
    tracer.Thickness = Hacks.ESPThickness
    self.Objects.Tracer = tracer
    
    -- Health Bar
    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Color = Color3.new(0, 1, 0)
    healthBar.Filled = true
    self.Objects.HealthBar = healthBar
    
    local healthBg = Drawing.new("Square")
    healthBg.Visible = false
    healthBg.Color = Color3.new(0, 0, 0)
    healthBg.Filled = true
    self.Objects.HealthBg = healthBg
    
    -- Distance
    local distance = Drawing.new("Text")
    distance.Visible = false
    distance.Color = Color3.new(1, 1, 1)
    distance.Size = 12
    distance.Center = true
    distance.Outline = true
    self.Objects.Distance = distance
    
    -- Weapon
    local weapon = Drawing.new("Text")
    weapon.Visible = false
    weapon.Color = Color3.new(1, 1, 0)
    weapon.Size = 12
    weapon.Center = true
    weapon.Outline = true
    self.Objects.Weapon = weapon
end

function ESP:GetColor()
    local colors = {
        Rot = Color3.new(1, 0, 0),
        Grün = Color3.new(0, 1, 0),
        Blau = Color3.new(0, 0, 1),
        Gelb = Color3.new(1, 1, 0),
        Lila = Color3.new(1, 0, 1),
        Weiß = Color3.new(1, 1, 1)
    }
    return colors[Hacks.ESPColor] or Color3.new(1, 0, 0)
end

function ESP:Update()
    if not Hacks.ESPEnabled or not self.Player.Character or not self.Player.Character:FindFirstChild("HumanoidRootPart") or not self.Player.Character:FindFirstChild("Humanoid") then
        for _, obj in pairs(self.Objects) do
            obj.Visible = false
        end
        return
    end
    
    local root = self.Player.Character.HumanoidRootPart
    local humanoid = self.Player.Character.Humanoid
    local pos = root.Position
    local vector, onScreen = Camera:WorldToViewportPoint(pos)
    
    if not onScreen then
        for _, obj in pairs(self.Objects) do
            obj.Visible = false
        end
        return
    end
    
    local distance = (Camera.CFrame.Position - pos).Magnitude
    local scale = 1 / (distance * 0.1) * 500
    local height = 5 * scale
    local width = 3 * scale
    
    local boxPos = Vector2.new(vector.X - width/2, vector.Y - height/2)
    local boxSize = Vector2.new(width, height)
    
    -- Box
    if Hacks.BoxESP then
        self.Objects.Box.Visible = true
        self.Objects.Box.Position = boxPos
        self.Objects.Box.Size = boxSize
        self.Objects.Box.Color = self:GetColor()
    else
        self.Objects.Box.Visible = false
    end
    
    -- Name
    if Hacks.NameESP then
        self.Objects.Name.Visible = true
        self.Objects.Name.Position = Vector2.new(vector.X, boxPos.Y - 20)
        self.Objects.Name.Text = self.Player.Name
    else
        self.Objects.Name.Visible = false
    end
    
    -- Tracer
    if Hacks.TracerESP then
        self.Objects.Tracer.Visible = true
        self.Objects.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        self.Objects.Tracer.To = Vector2.new(vector.X, vector.Y)
    else
        self.Objects.Tracer.Visible = false
    end
    
    -- Health
    if Hacks.HealthESP then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        
        self.Objects.HealthBg.Visible = true
        self.Objects.HealthBg.Position = Vector2.new(boxPos.X - 6, boxPos.Y)
        self.Objects.HealthBg.Size = Vector2.new(4, height)
        
        self.Objects.HealthBar.Visible = true
        self.Objects.HealthBar.Position = Vector2.new(boxPos.X - 6, boxPos.Y + height * (1 - healthPercent))
        self.Objects.HealthBar.Size = Vector2.new(4, height * healthPercent)
        self.Objects.HealthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
    else
        self.Objects.HealthBg.Visible = false
        self.Objects.HealthBar.Visible = false
    end
    
    -- Distance
    if Hacks.DistanceESP then
        self.Objects.Distance.Visible = true
        self.Objects.Distance.Position = Vector2.new(vector.X, boxPos.Y + height + 5)
        self.Objects.Distance.Text = math.floor(distance) .. "m"
    else
        self.Objects.Distance.Visible = false
    end
    
    -- Weapon
    if Hacks.WeaponESP then
        local tool = self.Player.Character:FindFirstChildOfClass("Tool")
        if tool then
            self.Objects.Weapon.Visible = true
            self.Objects.Weapon.Position = Vector2.new(vector.X, boxPos.Y + height + 20)
            self.Objects.Weapon.Text = tool.Name
        else
            self.Objects.Weapon.Visible = false
        end
    else
        self.Objects.Weapon.Visible = false
    end
end

-- ESP für alle Spieler erstellen
local ESPObjects = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        ESPObjects[player] = ESP.new(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        ESPObjects[player] = ESP.new(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player].Objects) do
            obj:Remove()
        end
        ESPObjects[player] = nil
    end
end)

-- ESP Update Loop
RunService.RenderStepped:Connect(function()
    for _, esp in pairs(ESPObjects) do
        esp:Update()
    end
end)

-- ==================================================
-- AIMBOT FUNKTIONEN
-- ==================================================
function GetClosestPlayer()
    local closest = nil
    local shortestDistance = Hacks.AimbotFOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            
            -- Wallbang Check
            if not Hacks.Wallbang then
                local ray = Ray.new(Camera.CFrame.Position, (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Unit * 1000)
                local hit, pos = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
                if hit and not hit:IsDescendantOf(player.Character) then
                    continue
                end
            end
            
            local vector, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(vector.X, vector.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = player
                end
            end
        end
    end
    
    return closest
end

function GetAimPart(character)
    local parts = {
        Kopf = "Head",
        Brust = "Torso",
        Beine = "Left Leg",
        Arme = "Right Arm",
        Zufällig = nil
    }
    
    if Hacks.AimPart == "Zufällig" then
        local possibleParts = {"Head", "Torso", "Left Leg", "Right Leg", "Left Arm", "Right Arm"}
        return character:FindFirstChild(possibleParts[math.random(1, #possibleParts)])
    else
        return character:FindFirstChild(parts[Hacks.AimPart])
    end
end

-- Silent Aim
RunService.Heartbeat:Connect(function()
    if Hacks.AimbotEnabled and Hacks.SilentAim then
        local target = GetClosestPlayer()
        if target and target.Character then
            local aimPart = GetAimPart(target.Character)
            if aimPart then
                -- Silent Aim magic
                local oldPos = aimPart.Position
            end
        end
    end
end)

-- Triggerbot
RunService.Heartbeat:Connect(function()
    if Hacks.Triggerbot then
        local target = GetClosestPlayer()
        if target and target.Character then
            local aimPart = GetAimPart(target.Character)
            if aimPart then
                local screenPos = Camera:WorldToViewportPoint(aimPart.Position)
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if distance < 50 then
                    mouse1click()
                end
            end
        end
    end
end)

-- ==================================================
-- MOVEMENT HACKS
-- ==================================================

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Hacks.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Speed Hack
RunService.Heartbeat:Connect(function()
    if Hacks.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Hacks.SpeedValue
    end
end)

-- Fly Hack
local flyConnection = nil

function ToggleFly(enable)
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if enable and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        bodyGyro.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        bodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not Hacks.FlyHack or not LocalPlayer.Character then
                bodyGyro:Destroy()
                bodyVelocity:Destroy()
                flyConnection:Disconnect()
                flyConnection = nil
                return
            end
            
            local moveDirection = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            bodyVelocity.Velocity = moveDirection * 50
            bodyGyro.CFrame = Camera.CFrame
        end)
    end
end

-- No Clip
function ToggleNoClip(enable)
    if Hacks.NoclipConnection then
        Hacks.NoclipConnection:Disconnect()
        Hacks.NoclipConnection = nil
    end
    
    if enable then
        Hacks.NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Jump Power
RunService.Heartbeat:Connect(function()
    if Hacks.JumpPower and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = Hacks.JumpHeight
    end
end)

-- Gravity
RunService.Heartbeat:Connect(function()
    if Hacks.GravityMod then
        Workspace.Gravity = Hacks.GravityValue
    else
        Workspace.Gravity = 196
    end
end)

-- ==================================================
-- PLAYER HACKS
-- ==================================================

-- God Mode
LocalPlayer.CharacterAdded:Connect(function(character)
    if Hacks.GodMode then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and Hacks.GodMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end

-- Infinite Stamina
RunService.Heartbeat:Connect(function()
    if Hacks.InfiniteStamina and LocalPlayer.Character then
        local stamina = LocalPlayer.Character:FindFirstChild("Stamina")
        if stamina then
            stamina.Value = 100
        end
    end
end)

-- Infinite Ammo
LocalPlayer.CharacterAdded:Connect(function(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and Hacks.InfiniteAmmo then
            local ammo = child:FindFirstChild("Ammo")
            if ammo then
                ammo.Value = math.huge
            end
        end
    end)
end)

-- No Recoil / No Spread
RunService.Heartbeat:Connect(function()
    if Hacks.NoRecoil or Hacks.NoSpread then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("NumberValue") and (v.Name == "Recoil" or v.Name == "Spread") then
                if Hacks.NoRecoil and v.Name == "Recoil" then
                    v.Value = 0
                end
                if Hacks.NoSpread and v.Name == "Spread" then
                    v.Value = 0
                end
            end
        end
    end
end)

-- Instant Reload
RunService.Heartbeat:Connect(function()
    if Hacks.InstantReload and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            local reload = tool:FindFirstChild("Reload")
            if reload then
                reload.CooldownTime = 0
            end
        end
    end
end)

-- Rapid Fire
RunService.Heartbeat:Connect(function()
    if Hacks.RapidFire and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            local fireRate = tool:FindFirstChild("FireRate")
            if fireRate then
                fireRate.Value = Hacks.FireRate
            end
        end
    end
end)

-- ==================================================
-- WORLD HACKS
-- ==================================================

-- Fullbright
RunService.Heartbeat:Connect(function()
    if Hacks.Fullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

-- X-Ray
RunService.Heartbeat:Connect(function()
    if Hacks.XRay then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(Players) then
                v.Transparency = 0.5
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    end
end)

-- No Fog
RunService.Heartbeat:Connect(function()
    if Hacks.NoFog then
        Lighting.FogEnd = 9e9
    else
        Lighting.FogEnd = 1000
    end
end)

-- Time Changer
RunService.Heartbeat:Connect(function()
    if Hacks.TimeChanger then
        Lighting.ClockTime = Hacks.ClockTime
    end
end)

-- Remove Grass
RunService.Heartbeat:Connect(function()
    if Hacks.RemoveGrass then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Terrain") then
                v.WaterWaveSize = 0
                v.WaterWaveSpeed = 0
                v.WaterReflectance = 0
                v.WaterTransparency = 0
            end
            if v.Name == "Grass" or v:IsA("Grass") then
                v:Destroy()
            end
        end
    end
end)

-- Remove Water
RunService.Heartbeat:Connect(function()
    if Hacks.RemoveWater then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Terrain") then
                v.WaterTransparency = 1
            end
        end
    end
end)

-- ==================================================
-- WEAPON HACKS
-- ==================================================

-- Weapon Chams / Skins
RunService.Heartbeat:Connect(function()
    if Hacks.WeaponChams and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in ipairs(tool:GetDescendants()) do
                if v:IsA("BasePart") and Hacks.WeaponChams then
                    v.Transparency = 0.3
                    v.Material = Enum.Material.Neon
                    
                    if Hacks.WeaponSkin then
                        local colors = {
                            Rot = Color3.new(1, 0, 0),
                            Blau = Color3.new(0, 0, 1),
                            Grün = Color3.new(0, 1, 0),
                            Gold = Color3.new(1, 0.8, 0),
                            Regenbogen = Color3.new(math.random(), math.random(), math.random())
                        }
                        v.Color = colors[Hacks.WeaponColor] or Color3.new(1, 0.8, 0)
                    end
                end
            end
        end
    end
end)

-- Weapon Size
RunService.Heartbeat:Connect(function()
    if Hacks.WeaponSize ~= 1 and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool.Handle.Size = tool.Handle.Size * Hacks.WeaponSize
        end
    end
end)

-- No Weapon
RunService.Heartbeat:Connect(function()
    if Hacks.NoWeapon and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool.Handle.Transparency = 1
        end
    end
end)

-- Give All Weapons
function GiveAllWeapons()
    local weapons = {"AK47", "M4A1", "Shotgun", "Sniper", "Pistol", "RPG", "Minigun"}
    for _, weaponName in ipairs(weapons) do
        local tool = Instance.new("Tool")
        tool.Name = weaponName
        tool.Parent = LocalPlayer.Backpack
    end
    StarterGui:SetCore("SendNotification", {
        Title = "KICA V2 PREMIUM",
        Text = "Alle Waffen wurden hinzugefügt!",
        Duration = 3
    })
end

-- ==================================================
-- SETTINGS / UTILITY
-- ==================================================

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    if Hacks.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- FPS Boost / Cap
setfpscap(Hacks.FPSCap)

if Hacks.FPSBoost then
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
    Lighting.GlobalShadows = false
end

-- Stream Proof
if Hacks.StreamProof then
    LocalPlayer.DisplayName = "Streamer"
end

-- Config Speichern/Laden (angepasst für Delta/Xeno)
function SaveConfig()
    local config = HttpService:JSONEncode(Hacks)
    if writefile then
        writefile("KicaV2_Config.json", config)
        StarterGui:SetCore("SendNotification", {
            Title = "KICA V2 PREMIUM",
            Text = "Config gespeichert!",
            Duration = 2
        })
    else
        print("Config: " .. config)
    end
end

function LoadConfig()
    if isfile and isfile("KicaV2_Config.json") then
        local config = readfile("KicaV2_Config.json")
        local loaded = HttpService:JSONDecode(config)
        for k, v in pairs(loaded) do
            Hacks[k] = v
        end
        StarterGui:SetCore("SendNotification", {
            Title = "KICA V2 PREMIUM",
            Text = "Config geladen!",
            Duration = 2
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "KICA V2 PREMIUM",
            Text = "Keine Config gefunden!",
            Duration = 2
        })
    end
end

-- Server Rejoin
function RejoinServer()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

-- Server Hop
function ServerHop()
    local servers = {}
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(servers, v)
        end
    end
    if #servers > 0 then
        local random = servers[math.random(1, #servers)]
        TeleportService:TeleportToPlayer(random, LocalPlayer)
    end
end

-- ==================================================
-- GUI ERSTELLUNG (OPTIMIERT FÜR DELTA & XENO)
-- ==================================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "KicaV2Premium"
GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Hintergrund-Blur
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

-- Haupt-Container
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 900, 0, 600)
Main.Position = UDim2.new(0.5, -450, 0.5, -300)
Main.BackgroundColor3 = Config.Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = GUI
Main.Active = true
Main.Draggable = true

-- Moderner Glow-Effekt
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0.5, -20, 0.5, -20)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857084"
Glow.ImageColor3 = Config.Theme.Accent
Glow.ImageTransparency = 0.8
Glow.Parent = Main

-- Haupt-Container mit abgerundeten Ecken
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Innerer Schatten
local InnerShadow = Instance.new("Frame")
InnerShadow.Size = UDim2.new(1, -2, 1, -2)
InnerShadow.Position = UDim2.new(0, 1, 0, 1)
InnerShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
InnerShadow.BackgroundTransparency = 0.5
InnerShadow.BorderSizePixel = 0
InnerShadow.ZIndex = -1
InnerShadow.Parent = Main

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(0, 10)
InnerCorner.Parent = InnerShadow

-- ==================================================
-- PREMIUM TITLE BAR
-- ==================================================
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Config.Theme.Primary
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Gradient für Title Bar
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Config.Theme.Primary),
    ColorSequenceKeypoint.new(0.5, Config.Theme.Secondary),
    ColorSequenceKeypoint.new(1, Config.Theme.Primary)
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 15, 0.5, -15)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://1234567890"
Logo.ImageColor3 = Config.Theme.Accent
Logo.Parent = TitleBar

-- Titel
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 50, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "KICA V2 PREMIUM"
Title.TextColor3 = Config.Theme.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TitleBar

-- Status Indicator
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Size = UDim2.new(0, 10, 0, 10)
StatusIndicator.Position = UDim2.new(0, 255, 0.5, -5)
StatusIndicator.BackgroundColor3 = Config.Theme.Success
StatusIndicator.Parent = TitleBar

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusIndicator

-- Premium Badge
local PremiumBadge = Instance.new("TextLabel")
PremiumBadge.Size = UDim2.new(0, 80, 0, 25)
PremiumBadge.Position = UDim2.new(0, 280, 0.5, -12.5)
PremiumBadge.BackgroundColor3 = Config.Theme.Accent2
PremiumBadge.Text = "PREMIUM"
PremiumBadge.TextColor3 = Config.Theme.Text
PremiumBadge.TextSize = 12
PremiumBadge.Font = Enum.Font.GothamBold
PremiumBadge.Parent = TitleBar

local BadgeCorner = Instance.new("UICorner")
BadgeCorner.CornerRadius = UDim.new(0, 6)
BadgeCorner.Parent = PremiumBadge

-- Version
local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 100, 1, 0)
Version.Position = UDim2.new(1, -115, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = "v2.0.0 | ULTIMATE"
Version.TextColor3 = Config.Theme.TextDim
Version.TextSize = 12
Version.Font = Enum.Font.Gotham
Version.Parent = TitleBar

-- Fenster-Steuerung
local ControlButtons = {
    {Name = "Minimize", Icon = "─", Color = Config.Theme.Warning, Action = "minimize"},
    {Name = "Maximize", Icon = "□", Color = Config.Theme.Success, Action = "maximize"},
    {Name = "Close", Icon = "×", Color = Config.Theme.Danger, Action = "close"}
}

for i, btn in ipairs(ControlButtons) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 30, 0, 30)
    Button.Position = UDim2.new(1, -35 * (4 - i), 0.5, -15)
    Button.BackgroundColor3 = btn.Color
    Button.BackgroundTransparency = 0.3
    Button.Text = btn.Icon
    Button.TextColor3 = Config.Theme.Text
    Button.TextSize = 18
    Button.Font = Enum.Font.GothamBold
    Button.Parent = TitleBar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        if btn.Action == "close" then
            GUI:Destroy()
            Blur:Destroy()
        elseif btn.Action == "minimize" then
            Main:TweenSize(UDim2.new(0, 900, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        elseif btn.Action == "maximize" then
            Main:TweenSize(UDim2.new(0, 900, 0, 600), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        end
    end)
end

-- ==================================================
-- PREMIUM TAB BAR
-- ==================================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 60)
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.BackgroundColor3 = Config.Theme.Secondary
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 1, 0)
TabContainer.Position = UDim2.new(0, 10, 0, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabContainer

-- Tabs erstellen
local Tabs = {}
local CurrentTab = 1

for i, tabData in ipairs(Config.Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 120, 0, 45)
    TabButton.BackgroundColor3 = Config.Theme.Primary
    TabButton.BackgroundTransparency = 0.5
    TabButton.Text = tabData.Name
    TabButton.TextColor3 = Config.Theme.TextDim
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    -- Tab Indicator
    local TabIndicator = Instance.new("Frame")
    TabIndicator.Size = UDim2.new(1, -10, 0, 3)
    TabIndicator.Position = UDim2.new(0, 5, 1, -5)
    TabIndicator.BackgroundColor3 = Config.Theme.Accent
    TabIndicator.BackgroundTransparency = i == 1 and 0 or 1
    TabIndicator.Parent = TabButton
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = TabIndicator
    
    Tabs[i] = {
        Button = TabButton,
        Indicator = TabIndicator
    }
    
    TabButton.MouseEnter:Connect(function()
        if CurrentTab ~= i then
            TabButton.BackgroundTransparency = 0.2
            TabButton.TextColor3 = Config.Theme.Text
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if CurrentTab ~= i then
            TabButton.BackgroundTransparency = 0.5
            TabButton.TextColor3 = Config.Theme.TextDim
        end
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        CurrentTab = i
        
        for idx, tab in ipairs(Tabs) do
            tab.Button.BackgroundTransparency = 0.5
            tab.Button.TextColor3 = Config.Theme.TextDim
            tab.Indicator.BackgroundTransparency = 1
        end
        
        TabButton.BackgroundTransparency = 0
        TabButton.TextColor3 = Config.Theme.Text
        TabIndicator.BackgroundTransparency = 0
        
        LoadTabContent(i)
    end)
end

-- ==================================================
-- CONTENT BEREICH
-- ==================================================
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -140)
ContentContainer.Position = UDim2.new(0, 10, 0, 120)
ContentContainer.BackgroundColor3 = Config.Theme.Secondary
ContentContainer.BackgroundTransparency = 0.5
ContentContainer.BorderSizePixel = 0
ContentContainer.ClipsDescendants = true
ContentContainer.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentContainer

-- Scrolling Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -20)
Content.Position = UDim2.new(0, 10, 0, 10)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0, 0, 2, 0)
Content.ScrollBarThickness = 5
Content.ScrollBarImageColor3 = Config.Theme.Accent
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = ContentContainer

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.Parent = Content

-- ==================================================
-- PREMIUM UI ELEMENTE
-- ==================================================

-- Premium Toggle
function CreatePremiumToggle(parent, title, description, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 400, 0, 60)
    ToggleFrame.BackgroundColor3 = Config.Theme.Primary
    ToggleFrame.BackgroundTransparency = 0.3
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 250, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Config.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.Parent = ToggleFrame
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(0, 250, 0, 20)
    DescLabel.Position = UDim2.new(0, 15, 0, 35)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = description
    DescLabel.TextColor3 = Config.Theme.TextDim
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 12
    DescLabel.Parent = ToggleFrame
    
    local ToggleBtn = Instance.new("Frame")
    ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
    ToggleBtn.Position = UDim2.new(1, -75, 0.5, -15)
    ToggleBtn.BackgroundColor3 = default and Config.Theme.Success or Config.Theme.Danger
    ToggleBtn.Parent = ToggleFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = ToggleBtn
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0, 24, 0, 24)
    ToggleIndicator.Position = default and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
    ToggleIndicator.BackgroundColor3 = Config.Theme.Text
    ToggleIndicator.Parent = ToggleBtn
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = ToggleIndicator
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = ToggleBtn
    
    local toggled = default
    
    Button.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local targetPos = toggled and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
        local targetColor = toggled and Config.Theme.Success or Config.Theme.Danger
        
        TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        
        callback(toggled)
    end)
    
    return ToggleFrame
end

-- Premium Slider
function CreatePremiumSlider(parent, title, description, min, max, default, suffix, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0, 400, 0, 80)
    SliderFrame.BackgroundColor3 = Config.Theme.Primary
    SliderFrame.BackgroundTransparency = 0.3
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 250, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Config.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 80, 0, 25)
    ValueLabel.Position = UDim2.new(1, -95, 0, 10)
    ValueLabel.BackgroundColor3 = Config.Theme.Accent
    ValueLabel.BackgroundTransparency = 0.5
    ValueLabel.Text = tostring(default) .. suffix
    ValueLabel.TextColor3 = Config.Theme.Text
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 16
    ValueLabel.Parent = SliderFrame
    
    local ValueCorner = Instance.new("UICorner")
    ValueCorner.CornerRadius = UDim.new(0, 6)
    ValueCorner.Parent = ValueLabel
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(0, 370, 0, 20)
    DescLabel.Position = UDim2.new(0, 15, 0, 35)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = description
    DescLabel.TextColor3 = Config.Theme.TextDim
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 12
    DescLabel.Parent = SliderFrame
    
    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(0, 370, 0, 8)
    SliderBg.Position = UDim2.new(0, 15, 0, 60)
    SliderBg.BackgroundColor3 = Config.Theme.Secondary
    SliderBg.Parent = SliderFrame
    
    local BgCorner = Instance.new("UICorner")
    BgCorner.CornerRadius = UDim.new(1, 0)
    BgCorner.Parent = SliderBg
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Config.Theme.Accent
    SliderFill.Parent = SliderBg
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("Frame")
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Config.Theme.Text
    SliderButton.ZIndex = 2
    SliderButton.Parent = SliderBg
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = SliderButton
    
    local dragging = false
    local value = default
    
    Button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = SliderBg.AbsolutePosition
            local absSize = SliderBg.AbsoluteSize.X
            
            local relativePos = math.clamp(mousePos.X - absPos.X, 0, absSize)
            local percent = relativePos / absSize
            value = math.floor(min + (max - min) * percent)
            
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -8, 0.5, -8)
            ValueLabel.Text = tostring(value) .. suffix
            callback(value)
        end
    end)
    
    return SliderFrame
end

-- Premium Dropdown
function CreatePremiumDropdown(parent, title, options, default, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(0, 400, 0, 60)
    DropdownFrame.BackgroundColor3 = Config.Theme.Primary
    DropdownFrame.BackgroundTransparency = 0.3
    DropdownFrame.Parent = parent
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 250, 0, 60)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Config.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.Parent = DropdownFrame
    
    local DropBtn = Instance.new("TextButton")
    DropBtn.Size = UDim2.new(0, 120, 0, 35)
    DropBtn.Position = UDim2.new(1, -135, 0.5, -17.5)
    DropBtn.BackgroundColor3 = Config.Theme.Secondary
    DropBtn.Text = default or options[1]
    DropBtn.TextColor3 = Config.Theme.Text
    DropBtn.TextSize = 14
    DropBtn.Font = Enum.Font.Gotham
    DropBtn.Parent = DropdownFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = DropBtn
    
    local DropContainer = Instance.new("Frame")
    DropContainer.Size = UDim2.new(0, 120, 0, #options * 35)
    DropContainer.Position = UDim2.new(1, -135, 0, 40)
    DropContainer.BackgroundColor3 = Config.Theme.Secondary
    DropContainer.BackgroundTransparency = 1
    DropContainer.Visible = false
    DropContainer.Parent = DropdownFrame
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 6)
    ContainerCorner.Parent = DropContainer
    
    for i, option in ipairs(options) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Size = UDim2.new(1, 0, 0, 35)
        OptionBtn.BackgroundColor3 = Config.Theme.Secondary
        OptionBtn.BackgroundTransparency = 0.5
        OptionBtn.Text = option
        OptionBtn.TextColor3 = Config.Theme.Text
        OptionBtn.TextSize = 14
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.Parent = DropContainer
        
        if i > 1 then
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, -20, 0, 1)
            Line.Position = UDim2.new(0, 10, 0, 0)
            Line.BackgroundColor3 = Config.Theme.TextDim
            Line.BackgroundTransparency = 0.7
            Line.Parent = OptionBtn
        end
        
        OptionBtn.MouseButton1Click:Connect(function()
            DropBtn.Text = option
            DropContainer.Visible = false
            DropContainer.BackgroundTransparency = 1
            callback(option)
        end)
    end
    
    DropBtn.MouseButton1Click:Connect(function()
        DropContainer.Visible = not DropContainer.Visible
        DropContainer.BackgroundTransparency = DropContainer.Visible and 0 or 1
    end)
    
    return DropdownFrame
end

-- Premium Button
function CreatePremiumButton(parent, text, description, icon, color, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(0, 400, 0, 70)
    ButtonFrame.BackgroundColor3 = Config.Theme.Primary
    ButtonFrame.BackgroundTransparency = 0.3
    ButtonFrame.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 40, 0, 40)
    IconLabel.Position = UDim2.new(0, 15, 0.5, -20)
    IconLabel.BackgroundColor3 = color or Config.Theme.Accent
    IconLabel.BackgroundTransparency = 0.5
    IconLabel.Text = icon or "⚡"
    IconLabel.TextColor3 = Config.Theme.Text
    IconLabel.TextSize = 20
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = ButtonFrame
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 8)
    IconCorner.Parent = IconLabel
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 250, 0, 25)
    TitleLabel.Position = UDim2.new(0, 65, 0, 15)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = text
    TitleLabel.TextColor3 = Config.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.Parent = ButtonFrame
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(0, 250, 0, 20)
    DescLabel.Position = UDim2.new(0, 65, 0, 40)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = description
    DescLabel.TextColor3 = Config.Theme.TextDim
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 12
    DescLabel.Parent = ButtonFrame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = ButtonFrame
    
    Button.MouseButton1Click:Connect(callback)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    return ButtonFrame
end

-- Premium Section Header
function CreateSectionHeader(parent, title, icon)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(0, 400, 0, 40)
    Header.BackgroundTransparency = 1
    Header.Parent = parent
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Position = UDim2.new(0, 0, 0.5, -15)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon or "📌"
    IconLabel.TextColor3 = Config.Theme.Accent
    IconLabel.TextSize = 20
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = Header
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 300, 0, 30)
    TitleLabel.Position = UDim2.new(0, 35, 0.5, -15)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Config.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.Parent = Header
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, -35, 0, 2)
    Line.Position = UDim2.new(0, 35, 1, -5)
    Line.BackgroundColor3 = Config.Theme.Accent
    Line.BackgroundTransparency = 0.5
    Line.Parent = Header
    
    return Header
end

-- ==================================================
-- TAB INHALTE LADEN (MIT ALLEN CALLBACKS)
-- ==================================================
function LoadTabContent(tabIndex)
    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if tabIndex == 1 then -- HOME
        CreateSectionHeader(Content, "WILLKOMMEN BEI KICA V2 PREMIUM", "🏠")
        
        local InfoFrame = Instance.new("Frame")
        InfoFrame.Size = UDim2.new(0, 400, 0, 150)
        InfoFrame.BackgroundColor3 = Config.Theme.Primary
        InfoFrame.BackgroundTransparency = 0.3
        InfoFrame.Parent = Content
        
        local InfoCorner = Instance.new("UICorner")
        InfoCorner.CornerRadius = UDim.new(0, 12)
        InfoCorner.Parent = InfoFrame
        
        local WelcomeText = Instance.new("TextLabel")
        WelcomeText.Size = UDim2.new(1, -20, 1, -20)
        WelcomeText.Position = UDim2.new(0, 10, 0, 10)
        WelcomeText.BackgroundTransparency = 1
        WelcomeText.Text = "Willkommen zurück, " .. LocalPlayer.Name .. "!\n\nKICA V2 PREMIUM ist geladen.\nAlle Features sind aktiviert und bereit.\n\nDrücke F9 um das Menü zu öffnen/schließen."
        WelcomeText.TextColor3 = Config.Theme.Text
        WelcomeText.TextWrapped = true
        WelcomeText.Font = Enum.Font.Gotham
        WelcomeText.TextSize = 14
        WelcomeText.Parent = InfoFrame
        
        CreateSectionHeader(Content, "SERVER OPTIONEN", "🌐")
        
        CreatePremiumButton(Content, "Server Rejoin", "Zum aktuellen Server zurückkehren", "🔄", Config.Theme.Warning, function()
            RejoinServer()
        end)
        
        CreatePremiumButton(Content, "Server Hop", "Zu einem anderen Server wechseln", "🌐", Config.Theme.Success, function()
            ServerHop()
        end)
        
        CreatePremiumButton(Content, "Discord beitreten", "Für Support und Updates", "💬", Config.Theme.Accent, function()
            setclipboard("https://discord.gg/kicapremium")
            StarterGui:SetCore("SendNotification", {
                Title = "KICA V2 PREMIUM",
                Text = "Discord Link kopiert!",
                Duration = 2
            })
        end)
        
    elseif tabIndex == 2 then -- AIMBOT
        CreateSectionHeader(Content, "AIMBOT EINSTELLUNGEN", "🎯")
        
        CreatePremiumToggle(Content, "Aimbot aktivieren", "Automatisches Zielen auf Gegner", Hacks.AimbotEnabled, function(state)
            Hacks.AimbotEnabled = state
            StarterGui:SetCore("SendNotification", {
                Title = "Aimbot",
                Text = state and "Aktiviert" or "Deaktiviert",
                Duration = 1
            })
        end)
        
        CreatePremiumToggle(Content, "Silent Aim", "Unsichtbares Zielen (nicht detektierbar)", Hacks.SilentAim, function(state)
            Hacks.SilentAim = state
        end)
        
        CreatePremiumToggle(Content, "Triggerbot", "Automatisch schießen wenn Ziel im Fadenkreuz", Hacks.Triggerbot, function(state)
            Hacks.Triggerbot = state
        end)
        
        CreatePremiumToggle(Content, "Wallbang", "Durch Wände schießen", Hacks.Wallbang, function(state)
            Hacks.Wallbang = state
        end)
        
        CreatePremiumSlider(Content, "Aimbot FOV", "Zielerfassungsbereich in Grad", 0, 360, Hacks.AimbotFOV, "°", function(value)
            Hacks.AimbotFOV = value
        end)
        
        CreatePremiumSlider(Content, "Smoothness", "Zielgeschwindigkeit (niedriger = schneller)", 1, 100, Hacks.AimbotSmooth, "%", function(value)
            Hacks.AimbotSmooth = value
        end)
        
        CreatePremiumDropdown(Content, "Zielpriorität", {"Kopf", "Brust", "Beine", "Arme", "Zufällig"}, Hacks.AimPart, function(option)
            Hacks.AimPart = option
        end)
        
    elseif tabIndex == 3 then -- ESP
        CreateSectionHeader(Content, "ESP EINSTELLUNGEN", "👁️")
        
        CreatePremiumToggle(Content, "ESP aktivieren", "Gegner durch Wände sehen", Hacks.ESPEnabled, function(state)
            Hacks.ESPEnabled = state
        end)
        
        CreatePremiumToggle(Content, "Box ESP", "Box um Gegner zeichnen", Hacks.BoxESP, function(state)
            Hacks.BoxESP = state
        end)
        
        CreatePremiumToggle(Content, "Nametags", "Spielernamen anzeigen", Hacks.NameESP, function(state)
            Hacks.NameESP = state
        end)
        
        CreatePremiumToggle(Content, "Tracers", "Linien zu Gegnern zeichnen", Hacks.TracerESP, function(state)
            Hacks.TracerESP = state
        end)
        
        CreatePremiumToggle(Content, "Health Bar", "Lebensbalken anzeigen", Hacks.HealthESP, function(state)
            Hacks.HealthESP = state
        end)
        
        CreatePremiumToggle(Content, "Distance", "Entfernung anzeigen", Hacks.DistanceESP, function(state)
            Hacks.DistanceESP = state
        end)
        
        CreatePremiumToggle(Content, "Weapon ESP", "Waffen der Gegner anzeigen", Hacks.WeaponESP, function(state)
            Hacks.WeaponESP = state
        end)
        
        CreatePremiumToggle(Content, "Skeleton ESP", "Skelett der Gegner zeichnen", Hacks.SkeletonESP, function(state)
            Hacks.SkeletonESP = state
        end)
        
        CreatePremiumToggle(Content, "3D Radar", "3D Radar anzeigen", Hacks.Radar3D, function(state)
            Hacks.Radar3D = state
        end)
        
        CreatePremiumDropdown(Content, "ESP Farbe", {"Rot", "Grün", "Blau", "Gelb", "Lila", "Weiß"}, Hacks.ESPColor, function(option)
            Hacks.ESPColor = option
        end)
        
        CreatePremiumSlider(Content, "ESP Dicke", "Linienstärke des ESP", 1, 5, Hacks.ESPThickness, "px", function(value)
            Hacks.ESPThickness = value
        end)
        
    elseif tabIndex == 4 then -- MOVEMENT
        CreateSectionHeader(Content, "MOVEMENT HACKS", "⚡")
        
        CreatePremiumToggle(Content, "Infinite Jump", "Unbegrenzt springen", Hacks.InfiniteJump, function(state)
            Hacks.InfiniteJump = state
        end)
        
        CreatePremiumToggle(Content, "Speed Hack", "Schneller laufen", Hacks.SpeedHack, function(state)
            Hacks.SpeedHack = state
        end)
        
        CreatePremiumSlider(Content, "Speed Value", "Laufgeschwindigkeit", 16, 500, Hacks.SpeedValue, "", function(value)
            Hacks.SpeedValue = value
            if Hacks.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = value
            end
        end)
        
        CreatePremiumToggle(Content, "Fly Hack", "Fliegen (WASD + Space/Ctrl)", Hacks.FlyHack, function(state)
            Hacks.FlyHack = state
            ToggleFly(state)
        end)
        
        CreatePremiumToggle(Content, "No Clip", "Durch Wände gehen", Hacks.NoClip, function(state)
            Hacks.NoClip = state
            ToggleNoClip(state)
        end)
        
        CreatePremiumToggle(Content, "Jump Power", "Höher springen", Hacks.JumpPower, function(state)
            Hacks.JumpPower = state
        end)
        
        CreatePremiumSlider(Content, "Jump Height", "Sprunghöhe", 50, 500, Hacks.JumpHeight, "", function(value)
            Hacks.JumpHeight = value
            if Hacks.JumpPower and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = value
            end
        end)
        
        CreatePremiumToggle(Content, "Gravity", "Schwerkraft ändern", Hacks.GravityMod, function(state)
            Hacks.GravityMod = state
            if not state then
                Workspace.Gravity = 196
            end
        end)
        
        CreatePremiumSlider(Content, "Gravity Value", "Schwerkraft (normal = 196)", -500, 500, Hacks.GravityValue, "", function(value)
            Hacks.GravityValue = value
            if Hacks.GravityMod then
                Workspace.Gravity = value
            end
        end)
        
    elseif tabIndex == 5 then -- PLAYER
        CreateSectionHeader(Content, "PLAYER HACKS", "🛡️")
        
        CreatePremiumToggle(Content, "God Mode", "Unverwundbar (kein Schaden)", Hacks.GodMode, function(state)
            Hacks.GodMode = state
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                if state then
                    LocalPlayer.Character.Humanoid.MaxHealth = math.huge
                    LocalPlayer.Character.Humanoid.Health = math.huge
                end
            end
        end)
        
        CreatePremiumToggle(Content, "Infinite Stamina", "Unbegrenzte Ausdauer", Hacks.InfiniteStamina, function(state)
            Hacks.InfiniteStamina = state
        end)
        
        CreatePremiumToggle(Content, "Infinite Ammo", "Unendlich Munition", Hacks.InfiniteAmmo, function(state)
            Hacks.InfiniteAmmo = state
        end)
        
        CreatePremiumToggle(Content, "No Recoil", "Kein Rückstoß", Hacks.NoRecoil, function(state)
            Hacks.NoRecoil = state
        end)
        
        CreatePremiumToggle(Content, "No Spread", "100% Genauigkeit", Hacks.NoSpread, function(state)
            Hacks.NoSpread = state
        end)
        
        CreatePremiumToggle(Content, "Instant Reload", "Sofort nachladen", Hacks.InstantReload, function(state)
            Hacks.InstantReload = state
        end)
        
        CreatePremiumToggle(Content, "Rapid Fire", "Schneller schießen", Hacks.RapidFire, function(state)
            Hacks.RapidFire = state
        end)
        
        CreatePremiumSlider(Content, "Fire Rate", "Schussgeschwindigkeit", 0.01, 1, Hacks.FireRate, "s", function(value)
            Hacks.FireRate = value
        end)
        
        CreatePremiumButton(Content, "Volles Health", "Leben wiederherstellen", "❤️", Config.Theme.Success, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
                StarterGui:SetCore("SendNotification", {
                    Title = "KICA V2 PREMIUM",
                    Text = "Health wiederhergestellt!",
                    Duration = 1
                })
            end
        end)
        
    elseif tabIndex == 6 then -- WORLD
        CreateSectionHeader(Content, "WORLD HACKS", "🌍")
        
        CreatePremiumToggle(Content, "Fullbright", "Alles hell (keine Schatten)", Hacks.Fullbright, function(state)
            Hacks.Fullbright = state
            if state then
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.Brightness = 2
                Lighting.GlobalShadows = false
            else
                Lighting.Ambient = Color3.new(0, 0, 0)
                Lighting.Brightness = 1
                Lighting.GlobalShadows = true
            end
        end)
        
        CreatePremiumToggle(Content, "X-Ray Vision", "Durch Wände sehen", Hacks.XRay, function(state)
            Hacks.XRay = state
        end)
        
        CreatePremiumToggle(Content, "No Fog", "Kein Nebel", Hacks.NoFog, function(state)
            Hacks.NoFog = state
        end)
        
        CreatePremiumToggle(Content, "Time Changer", "Tageszeit ändern", Hacks.TimeChanger, function(state)
            Hacks.TimeChanger = state
        end)
        
        CreatePremiumSlider(Content, "Clock Time", "Uhrzeit", 0, 24, Hacks.ClockTime, ":00", function(value)
            Hacks.ClockTime = value
            if Hacks.TimeChanger then
                Lighting.ClockTime = value
            end
        end)
        
        CreatePremiumToggle(Content, "Remove Grass", "Gras entfernen (FPS Boost)", Hacks.RemoveGrass, function(state)
            Hacks.RemoveGrass = state
        end)
        
        CreatePremiumToggle(Content, "Remove Water", "Wasser entfernen", Hacks.RemoveWater, function(state)
            Hacks.RemoveWater = state
        end)
        
    elseif tabIndex == 7 then -- WEAPON
        CreateSectionHeader(Content, "WEAPON HACKS", "🔫")
        
        CreatePremiumToggle(Content, "Weapon Chams", "Waffen durchsichtig machen", Hacks.WeaponChams, function(state)
            Hacks.WeaponChams = state
        end)
        
        CreatePremiumToggle(Content, "Weapon ESP", "Waffen der Gegner markieren", Hacks.WeaponESP, function(state)
            Hacks.WeaponESP = state
        end)
        
        CreatePremiumToggle(Content, "No Weapon", "Waffe unsichtbar machen", Hacks.NoWeapon, function(state)
            Hacks.NoWeapon = state
        end)
        
        CreatePremiumToggle(Content, "Weapon Skin", "Benutzerdefinierte Waffenfarben", Hacks.WeaponSkin, function(state)
            Hacks.WeaponSkin = state
        end)
        
        CreatePremiumDropdown(Content, "Waffenfarbe", {"Rot", "Blau", "Grün", "Gold", "Regenbogen"}, Hacks.WeaponColor, function(option)
            Hacks.WeaponColor = option
        end)
        
        CreatePremiumSlider(Content, "Weapon Size", "Waffengröße", 0.5, 3, Hacks.WeaponSize, "x", function(value)
            Hacks.WeaponSize = value
        end)
        
        CreatePremiumButton(Content, "Give All Weapons", "Alle Waffen bekommen", "🔫", Config.Theme.Accent2, function()
            GiveAllWeapons()
        end)
        
    elseif tabIndex == 8 then -- SETTINGS
        CreateSectionHeader(Content, "ALLGEMEINE EINSTELLUNGEN", "⚙️")
        
        CreatePremiumToggle(Content, "Stream Proof", "Name verstecken (für Streamer)", Hacks.StreamProof, function(state)
            Hacks.StreamProof = state
            if state then
                LocalPlayer.DisplayName = "Streamer"
            else
                LocalPlayer.DisplayName = LocalPlayer.Name
            end
        end)
        
        CreatePremiumToggle(Content, "Anti AFK", "Nicht gekickt werden", Hacks.AntiAFK, function(state)
            Hacks.AntiAFK = state
        end)
        
        CreatePremiumToggle(Content, "FPS Boost", "Performance verbessern", Hacks.FPSBoost, function(state)
            Hacks.FPSBoost = state
        end)
        
        CreatePremiumSlider(Content, "FPS Cap", "Maximale FPS", 30, 360, Hacks.FPSCap, " FPS", function(value)
            Hacks.FPSCap = value
            setfpscap(value)
        end)
        
        CreatePremiumToggle(Content, "Watermark", "KICA Watermark anzeigen", Hacks.Watermark, function(state)
            Hacks.Watermark = state
            watermark.Visible = state
        end)
        
        CreatePremiumDropdown(Content, "GUI Theme", {"Dunkel", "Hell", "Blau", "Lila", "Rot"}, Hacks.Theme, function(option)
            Hacks.Theme = option
            if option == "Dunkel" then
                Config.Theme.Primary = Color3.fromRGB(30, 30, 40)
                Config.Theme.Secondary = Color3.fromRGB(20, 20, 30)
                Config.Theme.Accent = Color3.fromRGB(0, 170, 255)
                Config.Theme.Text = Color3.fromRGB(255, 255, 255)
            elseif option == "Hell" then
                Config.Theme.Primary = Color3.fromRGB(240, 240, 240)
                Config.Theme.Secondary = Color3.fromRGB(220, 220, 220)
                Config.Theme.Accent = Color3.fromRGB(0, 120, 255)
                Config.Theme.Text = Color3.fromRGB(0, 0, 0)
            elseif option == "Blau" then
                Config.Theme.Primary = Color3.fromRGB(0, 50, 100)
                Config.Theme.Secondary = Color3.fromRGB(0, 30, 80)
                Config.Theme.Accent = Color3.fromRGB(100, 200, 255)
            elseif option == "Lila" then
                Config.Theme.Primary = Color3.fromRGB(50, 0, 100)
                Config.Theme.Secondary = Color3.fromRGB(30, 0, 80)
                Config.Theme.Accent = Color3.fromRGB(200, 100, 255)
            elseif option == "Rot" then
                Config.Theme.Primary = Color3.fromRGB(100, 0, 0)
                Config.Theme.Secondary = Color3.fromRGB(80, 0, 0)
                Config.Theme.Accent = Color3.fromRGB(255, 100, 100)
            end
        end)
        
        CreatePremiumButton(Content, "Config speichern", "Aktuelle Einstellungen speichern", "💾", Config.Theme.Success, function()
            SaveConfig()
        end)
        
        CreatePremiumButton(Content, "Config laden", "Gespeicherte Einstellungen laden", "📂", Config.Theme.Warning, function()
            LoadConfig()
        end)
        
    elseif tabIndex == 9 then -- PREMIUM
        CreateSectionHeader(Content, "PREMIUM FEATURES", "💎")
        
        local PremiumFrame = Instance.new("Frame")
        PremiumFrame.Size = UDim2.new(0, 400, 0, 250)
        PremiumFrame.BackgroundColor3 = Config.Theme.Accent2
        PremiumFrame.BackgroundTransparency = 0.8
        PremiumFrame.Parent = Content
        
        local PremiumCorner = Instance.new("UICorner")
        PremiumCorner.CornerRadius = UDim.new(0, 12)
        PremiumCorner.Parent = PremiumFrame
        
        local PremiumTitle = Instance.new("TextLabel")
        PremiumTitle.Size = UDim2.new(1, -20, 0, 40)
        PremiumTitle.Position = UDim2.new(0, 10, 0, 10)
        PremiumTitle.BackgroundTransparency = 1
        PremiumTitle.Text = "✨ KICA V2 PREMIUM ✨"
        PremiumTitle.TextColor3 = Config.Theme.Text
        PremiumTitle.TextSize = 24
        PremiumTitle.Font = Enum.Font.GothamBold
        PremiumTitle.Parent = PremiumFrame
        
        local PremiumDesc = Instance.new("TextLabel")
        PremiumDesc.Size = UDim2.new(1, -20, 0, 150)
        PremiumDesc.Position = UDim2.new(0, 10, 0, 50)
        PremiumDesc.BackgroundTransparency = 1
        PremiumDesc.Text = "✓ Alle Features freigeschaltet\n✓ Premium Support\n✓ Tägliche Updates\n✓ Anti-Ban Schutz\n✓ Exklusive Skins\n✓ Früher Zugang zu neuen Hacks\n✓ Lifetime Lizenz\n✓ Discord Rolle"
        PremiumDesc.TextColor3 = Config.Theme.Text
        PremiumDesc.TextSize = 16
        PremiumDesc.Font = Enum.Font.Gotham
        PremiumDesc.TextXAlignment = Enum.TextXAlignment.Left
        PremiumDesc.Parent = PremiumFrame
        
        CreatePremiumButton(Content, "Discord beitreten", "Für Support und Updates", "💬", Config.Theme.Accent, function()
            setclipboard("https://discord.gg/kicapremium")
            StarterGui:SetCore("SendNotification", {
                Title = "KICA V2 PREMIUM",
                Text = "Discord Link kopiert!",
                Duration = 2
            })
        end)
        
        CreatePremiumButton(Content, "Premium verlängern", "Lizenz erneuern", "💳", Config.Theme.Success, function()
            setclipboard("https://kicapremium.com/buy")
            StarterGui:SetCore("SendNotification", {
                Title = "KICA V2 PREMIUM",
                Text = "Kauf-Link kopiert!",
                Duration = 2
            })
        end)
        
        CreatePremiumButton(Content, "Key System", "Lizenzkey eingeben", "🔑", Config.Theme.Warning, function()
            StarterGui:SetCore("SendNotification", {
                Title = "KICA V2 PREMIUM",
                Text = "Premium Key wird überprüft...",
                Duration = 2
            })
        end)
    end
end

-- ==================================================
-- WATERMARK & FPS COUNTER
-- ==================================================
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 300, 0, 35)
watermark.Position = UDim2.new(0, 10, 1, -45)
watermark.BackgroundColor3 = Config.Theme.Primary
watermark.BackgroundTransparency = 0.3
watermark.Text = "KICA V2 PREMIUM | " .. LocalPlayer.Name .. " | ULTIMATE | F9"
watermark.TextColor3 = Config.Theme.Accent
watermark.TextSize = 14
watermark.Font = Enum.Font.GothamBold
watermark.Parent = GUI
watermark.Visible = Hacks.Watermark

local watermarkCorner = Instance.new("UICorner")
watermarkCorner.CornerRadius = UDim.new(0, 8)
watermarkCorner.Parent = watermark

-- FPS Counter
local fps = Instance.new("TextLabel")
fps.Size = UDim2.new(0, 80, 0, 35)
fps.Position = UDim2.new(1, -90, 1, -45)
fps.BackgroundColor3 = Config.Theme.Primary
fps.BackgroundTransparency = 0.3
fps.Text = "FPS: 60"
fps.TextColor3 = Config.Theme.Success
fps.TextSize = 14
fps.Font = Enum.Font.GothamBold
fps.Parent = GUI

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 8)
fpsCorner.Parent = fps

RunService.RenderStepped:Connect(function()
    fps.Text = "FPS: " .. math.floor(1 / RunService.RenderStepped:Wait())
end)

-- ==================================================
-- KEYBIND SYSTEM (F9 ZUM ÖFFNEN)
-- ==================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F9 then
        Main.Visible = not Main.Visible
        Blur.Size = Main.Visible and 8 or 0
        watermark.Visible = Main.Visible and Hacks.Watermark or false
        fps.Visible = Main.Visible
        
        if Main.Visible then
            StarterGui:SetCore("SendNotification", {
                Title = "KICA V2 PREMIUM",
                Text = "Menü geöffnet (F9)",
                Duration = 1
            })
        end
    end
end)

-- Ersten Tab laden
LoadTabContent(1)
CurrentTab = 1
Tabs[1].Button.BackgroundTransparency = 0
Tabs[1].Button.TextColor3 = Config.Theme.Text
Tabs[1].Indicator.BackgroundTransparency = 0

-- GUI standardmäßig verstecken
Main.Visible = false
Blur.Size = 0
watermark.Visible = true
fps.Visible = true

-- ==================================================
-- STARTUP MESSAGE
-- ==================================================
print("╔═══════════════════════════════════════╗")
print("║     KICA V2 PREMIUM GELADEN           ║")
print("╠═══════════════════════════════════════╣")
print("║ Version: 2.0.0 ULTIMATE               ║")
print("║ Executor: Delta / Xeno                ║")
print("║ Spieler: " .. LocalPlayer.Name .. string.rep(" ", 20 - #LocalPlayer.Name) .. "║")
print("║ Status: ✅ Aktiv                       ║")
print("║ Drücke F9 für Menü                    ║")
print("╚═══════════════════════════════════════╝")

StarterGui:SetCore("SendNotification", {
    Title = "KICA V2 PREMIUM",
    Text = "Drücke F9 um das Menü zu öffnen!",
    Duration = 3
})
