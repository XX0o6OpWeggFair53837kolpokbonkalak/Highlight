local FillColor = Color3.fromRGB(175, 25, 255)
local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineColor = Color3.fromRGB(255, 255, 255)
local OutlineTransparency = 0

local CoreGui = game:FindService("CoreGui")
local Players = game:FindService("Players")
local connections = {}

local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

local function CreateBillboard(plr)
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = plr.Name .. "_Billboard"
    Billboard.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    Billboard.Size = UDim2.new(3, 0, 0.8, 0)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Parent = Storage

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Text = plr.Name
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 14
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    NameLabel.Parent = Billboard

    local HealthLabel = Instance.new("TextLabel")
    HealthLabel.Name = "HealthLabel"
    HealthLabel.Font = Enum.Font.GothamBold
    HealthLabel.TextSize = 16
    HealthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    HealthLabel.TextStrokeTransparency = 0.5
    HealthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    HealthLabel.BackgroundTransparency = 1
    HealthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    HealthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    HealthLabel.Parent = Billboard

    local function UpdateHealth()
        local humanoid = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            HealthLabel.Text = "HP: " .. math.floor(humanoid.Health)
        end
    end

    connections[plr] = {
        CharacterAdded = plr.CharacterAdded:Connect(function(char)
            Billboard.Adornee = char:FindFirstChild("HumanoidRootPart")
            UpdateHealth()
        end),
        HealthChanged = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and
            plr.Character:FindFirstChildOfClass("Humanoid").HealthChanged:Connect(UpdateHealth)
    }

    UpdateHealth()
end

local function Highlight(plr)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.FillColor = FillColor
    Highlight.DepthMode = DepthMode
    Highlight.FillTransparency = FillTransparency
    Highlight.OutlineColor = OutlineColor
    Highlight.OutlineTransparency = OutlineTransparency
    Highlight.Parent = Storage

    local plrchar = plr.Character
    if plrchar then
        Highlight.Adornee = plrchar
    end

    if not connections[plr] then
        connections[plr] = {}
    end

    connections[plr].CharacterAdded = plr.CharacterAdded:Connect(function(char)
        Highlight.Adornee = char
    end)

    CreateBillboard(plr)
end

Players.PlayerAdded:Connect(Highlight)
for _, v in ipairs(Players:GetPlayers()) do
    Highlight(v)
end

Players.PlayerRemoving:Connect(function(plr)
    if Storage:FindFirstChild(plr.Name) then
        Storage[plr.Name]:Destroy()
    end
    if connections[plr] then
        for _, conn in pairs(connections[plr]) do
            conn:Disconnect()
        end
        connections[plr] = nil
    end
    if Storage:FindFirstChild(plr.Name .. "_Billboard") then
        Storage[plr.Name .. "_Billboard"]:Destroy()
    end
end)
