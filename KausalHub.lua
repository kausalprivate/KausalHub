-- Load Fluent UI (you can change this to your hosted version later)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Create the window
local Window = Fluent:CreateWindow({
    Title = "Fish It Hub",
    SubTitle = "By You",
    Acrylic = true,
    Theme = "Dark"
})

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Teleport = Window:AddTab({ Title = "Teleport" }),
    Player = Window:AddTab({ Title = "Player" })
}

------------------------------------------------------------
-- 1. MAIN TAB: Auto Farm Toggle
------------------------------------------------------------
local autoFarm = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Default = false
})

autoFarm:OnChanged(function(value)
    _G.AutoFarmEnabled = value
    if value then
        task.spawn(function()
            while _G.AutoFarmEnabled do
                -- TODO: Add your auto-farm logic here
                -- Example: Cast + Reel
                -- game:GetService("ReplicatedStorage").Remotes.Cast:FireServer()
                -- wait(1)
                -- game:GetService("ReplicatedStorage").Remotes.Reel:FireServer()
                task.wait(1)
            end
        end)
    end
end)

------------------------------------------------------------
-- 2. TELEPORT TAB: Island Teleports
------------------------------------------------------------

local islandLocations = {
    ["Spawn Island"] = Vector3.new(0, 10, 0),
    ["Pirate Island"] = Vector3.new(200, 10, 100),
    ["Magma Island"] = Vector3.new(-300, 10, 250),
    ["Snow Island"] = Vector3.new(400, 10, -100),
    ["Desert Island"] = Vector3.new(150, 10, -350),
    ["Sky Island"] = Vector3.new(0, 500, 0)
}

for islandName, position in pairs(islandLocations) do
    Tabs.Teleport:AddButton(islandName, function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(position)
        end
    end)
end

------------------------------------------------------------
-- 3. PLAYER TAB: WalkSpeed, Infinite Jump, Teleport to Player
------------------------------------------------------------

-- WalkSpeed Slider
Tabs.Player:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed",
    Description = "Adjust your walk speed",
    Min = 16,
    Max = 100,
    Default = 16
}):OnChanged(function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- Infinite Jump Toggle
local infJump = Tabs.Player:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Default = false
})

infJump:OnChanged(function(state)
    _G.InfJump = state
end)

-- Infinite Jump Logic
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
end)

-- Teleport to Player Dropdown
local allPlayers = {}
for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        table.insert(allPlayers, player.Name)
    end
end

Tabs.Player:AddDropdown("PlayerTeleportDropdown", {
    Title = "Teleport to Player",
    Values = allPlayers,
    Multi = false,
    Default = allPlayers[1]
}):OnChanged(function(selectedName)
    local target = game.Players:FindFirstChild(selectedName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

------------------------------------------------------------
-- Notify when loaded
------------------------------------------------------------
Fluent:Notify({
    Title = "Fish It Hub",
    Content = "UI loaded successfully!",
    Duration = 4
})

