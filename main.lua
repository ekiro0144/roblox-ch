--[[ 
    Roblox ESP + Hitbox + AutoKill
    Usage : loadstring(game:HttpGet("TON-LIEN-GITHUB", true))()
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURATION
local ESPEnabled = true
local HitboxScale = Vector3.new(5,6,3)
local AutoKillEnabled = true

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "HackMenu"

local function createButton(text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 40)
    btn.Position = position
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Parent = ScreenGui
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createButton("Toggle ESP", UDim2.new(0,10,0,10), function() ESPEnabled = not ESPEnabled end)
createButton("Toggle AutoKill", UDim2.new(0,10,0,60), function() AutoKillEnabled = not AutoKillEnabled end)

-- Vérifie si le joueur est visible (pas de mur)
local function canSee(fromPos, toPos)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    local result = workspace:Raycast(fromPos, (toPos - fromPos), params)
    return result == nil
end

-- ESP et hitbox
local ESPBoxes = {}

local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if ESPBoxes[player] then return end
    if player.Team == LocalPlayer.Team then return end
    if not canSee(Camera.CFrame.Position, player.Character.HumanoidRootPart.Position) then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Size = HitboxScale
    box.Adornee = player.Character.HumanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Color3 = Color3.new(1,0,0)
    box.Transparency = 0.5
    box.Parent = workspace

    ESPBoxes[player] = box
end

local function removeESP(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Destroy()
        ESPBoxes[player] = nil
    end
end

-- Fonction AutoKill
local function checkAutoKill()
    if not AutoKillEnabled then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
            if player.Team ~= LocalPlayer.Team then
                local hrp = plr.Character.HumanoidRootPart
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                local result = workspace:Raycast(Camera.CFrame.Position, (hrp.Position - Camera.CFrame.Position), rayParams)
                if result and result.Instance:IsDescendantOf(plr.Character) then
                    -- AutoKill : réduit la vie à 0
                    plr.Character.Humanoid.Health = 0
                end
            end
        end
    end
end

-- Boucle principale
RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if ESPEnabled then
                createESP(plr)
            else
                removeESP(plr)
            end
        end
    end
    checkAutoKill()
end)
