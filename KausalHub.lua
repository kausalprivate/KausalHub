local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fish It Hub",
    SubTitle = "By Kausal",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://6023426923" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "rbxassetid://6023426923" }),
    Player = Window:AddTab({ Title = "Player", Icon = "rbxassetid://6023426923" })
}

Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Description = "Automatically fish and reel",
    Default = false
}):OnChanged(function(state)
    _G.AutoFarm = state
    if state then
        task.spawn(function()
            while _G.AutoFarm do
                task.wait(1)
                -- Add your fishing logic here
            end
        end)
    end
end)

local islandPositions = {
    ["Fisherman Island"] = Vector3.new(123, 3, 2782),
    ["Kohana Island"] = Vector3.new(-633, 16, 609),
    ["Coral Reefs"] = Vector3.new(-2795, 7, 2130),
    ["Tropical Grove"] = Vector3.new(-2092, 53, 3757),
    ["Desert Island"] = Vector3.new(150, 10, -300),
    ["Sky Island"] = Vector3.new(0, 500, 0),
}

for name, position in pairs(islandPositions) do
    Tabs.Teleport:AddButton({
        Title = name,
        Description = "Teleport to " .. name,
        Callback = function()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(position)
            end
        end
    })
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

Tabs.Player:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed",
    Description = "Adjust your movement speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Rounding = 0
}):OnChanged(function(value)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = value
    end
end)

Tabs.Player:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Description = "Jump infinitely",
    Default = false
}):OnChanged(function(state)
    _G.InfJump = state
end)

if not _G.InfJumpConnection then
    _G.InfJumpConnection = UIS.JumpRequest:Connect(function()
        if _G.InfJump then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local playerNames = {}
for _, p in ipairs(game.Players:GetPlayers()) do
    if p ~= game.Players.LocalPlayer then
        table.insert(playerNames, p.Name)
    end
end

Tabs.Player:AddDropdown("PlayerTP", {
    Title = "Teleport to Player",
    Description = "Teleport to selected player",
    Values = playerNames,
    Default = playerNames[1]
}):OnChanged(function(selected)
    local target = game.Players:FindFirstChild(selected)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local me = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if me then
            me.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

Fluent:Notify({
    Title = "Fish It Hub",
    Content = "UI Loaded Successfully!",
    Duration = 5
})


