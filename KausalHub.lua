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
            end
        end)
    end
end)

local islandPositions = {
    ["Fisherman Island"] = Vector3.new(123, 3, 2782),
    ["Pirate Island"] = Vector3.new(250, 10, 100),
    ["Magma Island"] = Vector3.new(-300, 10, 150),
    ["Snow Island"] = Vector3.new(350, 10, -200),
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

Tabs.Player:AddSlider("WalkSpeed", {
    Title = "WalkSpeed",
    Description = "Adjust your movement speed",
    Min = 16,
    Max = 100,
    Default = 16
}):OnChanged(function(value)
    local char = game.Players.LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = value
        end
    end
end)

Tabs.Player:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Description = "Jump as many times as you want",
    Default = false
}):OnChanged(function(state)
    _G.InfJump = state
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

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

