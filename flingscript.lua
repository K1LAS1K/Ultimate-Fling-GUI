--[[
Super Simple Fling Exploit
By KILASIK
]]
-- Get services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KilasikFlingGUI"
ScreenGui.Parent = game.CoreGui
-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -30, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "SUPER FLING"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.Parent = MainFrame
-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = MainFrame
-- Target TextBox
local TargetBox = Instance.new("TextBox")
TargetBox.Name = "TargetBox"
TargetBox.Size = UDim2.new(1, -20, 0, 30)
TargetBox.Position = UDim2.new(0, 10, 0, 40)
TargetBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TargetBox.BorderSizePixel = 0
TargetBox.Text = ""
TargetBox.PlaceholderText = "Target player name"
TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.Font = Enum.Font.SourceSans
TargetBox.TextSize = 16
TargetBox.Parent = MainFrame
-- Fling Button
local FlingButton = Instance.new("TextButton")
FlingButton.Name = "FlingButton"
FlingButton.Size = UDim2.new(1, -20, 0, 40)
FlingButton.Position = UDim2.new(0, 10, 0, 80)
FlingButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
FlingButton.BorderSizePixel = 0
FlingButton.Text = "FLING!"
FlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingButton.Font = Enum.Font.SourceSansBold
FlingButton.TextSize = 22
FlingButton.Parent = MainFrame
-- Stop Button
local StopButton = Instance.new("TextButton")
StopButton.Name = "StopButton"
StopButton.Size = UDim2.new(1, -20, 0, 30)
StopButton.Position = UDim2.new(0, 10, 0, 130)
StopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
StopButton.BorderSizePixel = 0
StopButton.Text = "STOP"
StopButton.TextColor3 = Color3.fromRGB(200, 200, 200)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.TextSize = 16
StopButton.Parent = MainFrame
StopButton.AutoButtonColor = false
-- KILASIK Credit
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "CreditLabel"
CreditLabel.Size = UDim2.new(0, 100, 0, 20)
CreditLabel.Position = UDim2.new(0.5, -50, 1, 10)
CreditLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CreditLabel.BorderSizePixel = 0
CreditLabel.Text = "KILASIK"
CreditLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
CreditLabel.Font = Enum.Font.SourceSansBold
CreditLabel.TextSize = 16
CreditLabel.Parent = ScreenGui
-- Variables
local flingActive = false
local connection = nil
-- Functions
local function getPlayer(name)
    name = name:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #name) == name then
            return player
        end
    end
    return nil
end
local function updateStopButton()
    if flingActive then
        StopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        StopButton.AutoButtonColor = true
    else
        StopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        StopButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        StopButton.AutoButtonColor = false
    end
end
local function stopFling()
    if not flingActive then return end
    
    flingActive = false
    updateStopButton()
    
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    -- Stop character movements
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
            if part:IsA("BodyVelocity") or part:IsA("BodyAngularVelocity") then
                part:Destroy()
            end
        end
    end
end
local function flingPlayer()
    local targetName = TargetBox.Text
    if targetName == "" then
        TargetBox.PlaceholderText = "Enter a name!"
        wait(1)
        TargetBox.PlaceholderText = "Target player name"
        return
    end
    
    local targetPlayer = getPlayer(targetName)
    if not targetPlayer then
        TargetBox.Text = "Player not found!"
        wait(1)
        TargetBox.Text = ""
        return
    end
    
    if targetPlayer == LocalPlayer then
        TargetBox.Text = "Cannot target yourself!"
        wait(1)
        TargetBox.Text = ""
        return
    end
    
    -- Check characters
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        TargetBox.Text = "Target not ready!"
        wait(1)
        TargetBox.Text = ""
        return
    end
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        TargetBox.Text = "Your character not ready!"
        wait(1)
        TargetBox.Text = ""
        return
    end
    
    -- Start flinging
    flingActive = true
    updateStopButton()
    TargetBox.Text = "Flinging " .. targetPlayer.Name .. "!"
    
    -- Target player's HumanoidRootPart
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    
    -- Ultra powerful fling
    local velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    velocity.P = math.huge
    
    -- Ultra powerful direction
    local randomDirection = Vector3.new(
        math.random(-50, 50), 
        math.random(80, 100), -- More upward force
        math.random(-50, 50)
    ).Unit * 9999999 -- Maximum power
    
    velocity.Velocity = randomDirection
    velocity.Parent = targetRoot
    
    -- Spinning
    local spin = Instance.new("BodyAngularVelocity")
    spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    spin.AngularVelocity = Vector3.new(
        math.random(-50, 50),
        math.random(-50, 50),
        math.random(-50, 50)
    )
    spin.P = math.huge
    spin.Parent = targetRoot
    
    -- Clean up after 5 seconds
    spawn(function()
        wait(5)
        if velocity and velocity.Parent then
            velocity:Destroy()
        end
        if spin and spin.Parent then
            spin:Destroy()
        end
        if flingActive then
            stopFling()
            TargetBox.Text = "Fling completed!"
            wait(1)
            TargetBox.Text = ""
        end
    end)
end
-- Button connections
FlingButton.MouseButton1Click:Connect(flingPlayer)
StopButton.MouseButton1Click:Connect(stopFling)
CloseButton.MouseButton1Click:Connect(function()
    stopFling()
    ScreenGui:Destroy()
end)
-- Initial state
updateStopButton()
-- Success message
print("KILASIK Super Fling Exploit loaded! Enter target and press FLING!")
