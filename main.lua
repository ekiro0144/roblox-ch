-- Script Hack Roblox Educatif (ESP + Lock Player)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURATION
local ESPEnabled = false
local LockEnabled = false

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "HackMenu"

local function createButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 40)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = ScreenGui
    return btn
end

createButton("Toggle ESP", UDim2.new(0,10,0,10), function()
    ESPEnabled = not ESPEnabled
end)

createButton("Toggle Lock", UDim2.new(0,10,0,60), function()
    LockEnabled = not LockEnabled
end)

-- ESP
local ESPBoxes = {}
local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if ESPBoxes[player] then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4,6,2)
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

-- Main loop
RunService.RenderStepped:Connect(function()
    -- ESP
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if ESPEnabled then
                createESP(plr)
            else
                removeESP(plr)
            end
        end
    end

    -- Lock Player sur crosshair
    if LockEnabled then
        local closestDist = math.huge
        local target = nil
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        target = plr
                    end
                end
            end
        end
        if target and target.Character then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)
