--[[ 
    ESP + Hitbox élargie Roblox Educatif
    Usage: loadstring(game:HttpGet("TON-LIEN-GITHUB", true))()
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURATION
local ESPEnabled = true
local HitboxScale = Vector3.new(5,6,3) -- taille des hitbox

-- Fonction pour vérifier s'il y a un mur
local function canSee(fromPos, toPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character} -- ignorer soi-même
    local result = workspace:Raycast(fromPos, (toPos - fromPos), raycastParams)
    if result then
        return false
    end
    return true
end

-- Tableau pour ESP
local ESPBoxes = {}

local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if ESPBoxes[player] then return end

    -- Vérifie si on peut voir le joueur et qu'il n'est pas coéquipier
    local isTeamMate = player.Team == LocalPlayer.Team
    if isTeamMate then return end
    if not canSee(Camera.CFrame.Position, player.Character.HumanoidRootPart.Position) then return end

    -- Création hitbox/ESP
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

-- Loop principal
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                createESP(plr)
            end
        end
    else
        for plr, _ in pairs(ESPBoxes) do
            removeESP(plr)
        end
    end
end)
