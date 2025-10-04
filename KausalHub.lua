-- Load Fluent 
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/jacklebeignet/Fluent-Reborn/refs/heads/main/src/ui.lua"))()

-- Create window
local Window = Fluent:CreateWindow({
    Title = "Fish It Hub",
    SubTitle = "By KausalHub",
    Acrylic = true,   
    Theme = "Dark"
})

-- Add tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Teleport = Window:AddTab({ Title = "Teleport" }),
    Settings = Window:AddTab({ Title = "Settings" })
}

--  Main tab, add a toggle for Auto Fish
local autoFishToggle = Tabs.Main:AddToggle("AutoFish", {
    Title = "Auto Fish",
    Default = false
})
autoFishToggle:OnChanged(function(value)
    _G.AutoFishEnabled = value
    if value then
        spawn(function()
            while _G.AutoFishEnabled do
                -- fish logic
                -- fire remote events or simulate inputs
                -- (Use pcall for safety)
                pcall(function()
                    -- call or invoke correct one: example
                    game:GetService("ReplicatedStorage").Remotes.Cast:FireServer()
                    wait(1)
                    game:GetService("ReplicatedStorage").Remotes.Reel:FireServer()
                end)
                wait(0.5)
            end
        end)
    end
end)

-- Teleport
Tabs.Teleport:AddButton("Go to Island 1", function()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(100, 50, 200)  -- example coords
    end
end)

-- Show a notification
Fluent:Notify({
    Title = "Fish It Hub",
    Content = "Loaded successfully!",
    Duration = 5
})

