-[[
    ONE-CLICK SUPER FLING Exploit for Roblox
    Made for Exploit Executors like JJSploit, Synapse, etc.
    Credit: KILASIK
    
    FEATURES:
    - One-click instant super fling (no teleport required)
    - Smart stop button (grayed out when not active)
    - Player list for easy target selection
    - Stays in your position while flinging target
    - Close (X) button to exit the GUI
    - Maximum power to send target very far away
--]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperFlingExploitGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 220)
Frame.Position = UDim2.new(0.5, -150, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- Create rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

-- Rounded corners for title bar
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Fix the rounded corners on title bar (add a rectangle to fill bottom corners)
local CornerFix = Instance.new("Frame")
CornerFix.Size = UDim2.new(1, 0, 0, 10)
CornerFix.Position = UDim2.new(0, 0, 1, -10)
CornerFix.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CornerFix.BorderSizePixel = 0
CornerFix.ZIndex = 0
CornerFix.Parent = TitleBar

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "💫 ONE-CLICK SUPER FLING 💫"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = TitleBar

-- Close button (X) for main GUI
local CloseMainButton = Instance.new("TextButton")
CloseMainButton.Position = UDim2.new(1, -25, 0, 5)
CloseMainButton.Size = UDim2.new(0, 20, 0, 20)
CloseMainButton.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
CloseMainButton.BorderSizePixel = 0
CloseMainButton.Text = "X"
CloseMainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseMainButton.Font = Enum.Font.GothamBold
CloseMainButton.TextSize = 14
CloseMainButton.Parent = TitleBar
CloseMainButton.ZIndex = 2

-- Rounded corners for main close button
local MainCloseCorner = Instance.new("UICorner") 
MainCloseCorner.CornerRadius = UDim.new(0, 4)
MainCloseCorner.Parent = CloseMainButton

-- Target display
local TargetDisplay = Instance.new("TextLabel")
TargetDisplay.Position = UDim2.new(0, 15, 0, 40)
TargetDisplay.Size = UDim2.new(1, -30, 0, 25)
TargetDisplay.BackgroundTransparency = 1
TargetDisplay.Text = "Target: None Selected"
TargetDisplay.TextColor3 = Color3.fromRGB(220, 220, 220)
TargetDisplay.Font = Enum.Font.Gotham
TargetDisplay.TextSize = 14
TargetDisplay.TextXAlignment = Enum.TextXAlignment.Left
TargetDisplay.Parent = Frame

-- Select Target Button
local SelectTargetButton = Instance.new("TextButton")
local selectedTarget = nil
local flingActive = false

SelectTargetButton.Position = UDim2.new(0, 15, 0, 70)
SelectTargetButton.Size = UDim2.new(1, -30, 0, 35)
SelectTargetButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SelectTargetButton.BorderSizePixel = 0
SelectTargetButton.Text = "👉 SELECT TARGET 👈"
SelectTargetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectTargetButton.Font = Enum.Font.GothamSemibold
SelectTargetButton.TextSize = 15
SelectTargetButton.Parent = Frame

-- Rounded corners for select button
local SelectButtonCorner = Instance.new("UICorner")
SelectButtonCorner.CornerRadius = UDim.new(0, 6)
SelectButtonCorner.Parent = SelectTargetButton

-- Super Fling Button
local FlingButton = Instance.new("TextButton")
FlingButton.Position = UDim2.new(0, 15, 0, 115)
FlingButton.Size = UDim2.new(1, -30, 0, 40)
FlingButton.BackgroundColor3 = Color3.fromRGB(230, 30, 30)
FlingButton.BorderSizePixel = 0
FlingButton.Text = "🚀 SUPER FLING NOW! 🚀"
FlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingButton.Font = Enum.Font.GothamBold
FlingButton.TextSize = 16
FlingButton.Parent = Frame

-- Rounded corners for fling button
local FlingButtonCorner = Instance.new("UICorner")
FlingButtonCorner.CornerRadius = UDim.new(0, 6)
FlingButtonCorner.Parent = FlingButton

-- Stop Button (starting as gray/disabled)
local StopButton = Instance.new("TextButton")
StopButton.Position = UDim2.new(0, 15, 0, 165)
StopButton.Size = UDim2.new(1, -30, 0, 30)
StopButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- Gray when disabled
StopButton.BorderSizePixel = 0
StopButton.Text = "⛔ STOP FLING ⛔"
StopButton.TextColor3 = Color3.fromRGB(180, 180, 180) -- Lighter gray text when disabled
StopButton.Font = Enum.Font.GothamSemibold
StopButton.TextSize = 14
StopButton.Parent = Frame
StopButton.AutoButtonColor = false -- Disable the button effect when inactive

-- Rounded corners for stop button
local StopButtonCorner = Instance.new("UICorner")
StopButtonCorner.CornerRadius = UDim.new(0, 6)
StopButtonCorner.Parent = StopButton

-- Credit Label (floating at the bottom of the screen, not in the frame)
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Position = UDim2.new(0.5, -100, 1, -40)
CreditLabel.Size = UDim2.new(0, 200, 0, 30)
CreditLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CreditLabel.BorderSizePixel = 0
CreditLabel.Text = "KILASIK"
CreditLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
CreditLabel.Font = Enum.Font.GothamBold
CreditLabel.TextSize = 20
CreditLabel.Parent = ScreenGui

-- Rounded corners for credit label
local CreditCorner = Instance.new("UICorner")
CreditCorner.CornerRadius = UDim.new(0, 15) -- More rounded
CreditCorner.Parent = CreditLabel

-- Shadow effect for credit
local CreditShadow = Instance.new("Frame")
CreditShadow.Position = UDim2.new(0, 2, 0, 2)
CreditShadow.Size = UDim2.new(1, 0, 1, 0)
CreditShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CreditShadow.BackgroundTransparency = 0.6
CreditShadow.BorderSizePixel = 0
CreditShadow.ZIndex = -1
CreditShadow.Parent = CreditLabel

-- Rounded corners for shadow
local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 15)
ShadowCorner.Parent = CreditShadow

-- Player Selection GUI
local PlayerSelectionFrame = Instance.new("Frame")
PlayerSelectionFrame.Size = UDim2.new(0, 250, 0, 300)
PlayerSelectionFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
PlayerSelectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayerSelectionFrame.BorderSizePixel = 0
PlayerSelectionFrame.Visible = false
PlayerSelectionFrame.Parent = ScreenGui
PlayerSelectionFrame.ZIndex = 10
PlayerSelectionFrame.Active = true
PlayerSelectionFrame.Draggable = true

-- Rounded corners for player selection frame
local SelectionFrameCorner = Instance.new("UICorner")
SelectionFrameCorner.CornerRadius = UDim.new(0, 8)
SelectionFrameCorner.Parent = PlayerSelectionFrame

-- Selection Title
local SelectionTitle = Instance.new("TextLabel")
SelectionTitle.Size = UDim2.new(1, 0, 0, 30)
SelectionTitle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SelectionTitle.BorderSizePixel = 0
SelectionTitle.Text = "Select Player To Fling"
SelectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectionTitle.Font = Enum.Font.GothamBold
SelectionTitle.TextSize = 15
SelectionTitle.Parent = PlayerSelectionFrame
SelectionTitle.ZIndex = 11

-- Rounded corners for selection title
local SelectionTitleCorner = Instance.new("UICorner")
SelectionTitleCorner.CornerRadius = UDim.new(0, 8)
SelectionTitleCorner.Parent = SelectionTitle

-- Corner fix for selection title
local SelectionCornerFix = Instance.new("Frame")
SelectionCornerFix.Size = UDim2.new(1, 0, 0, 10)
SelectionCornerFix.Position = UDim2.new(0, 0, 1, -10)
SelectionCornerFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SelectionCornerFix.BorderSizePixel = 0
SelectionCornerFix.ZIndex = 10
SelectionCornerFix.Parent = SelectionTitle

-- Close button for player selection
local CloseButton = Instance.new("TextButton")
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = SelectionTitle
CloseButton.ZIndex = 12

-- Rounded corners for close button
local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 4)
CloseButtonCorner.Parent = CloseButton

-- Player list scroll frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = PlayerSelectionFrame
ScrollFrame.ZIndex = 11
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Rounded corners for scroll frame
local ScrollFrameCorner = Instance.new("UICorner")
ScrollFrameCorner.CornerRadius = UDim.new(0, 6)
ScrollFrameCorner.Parent = ScrollFrame

-- Variables
local playerButtons = {}
local flingAttachment = nil
local targetConnection = nil

-- Function to update Stop button appearance
local function updateStopButton()
    if flingActive then
        -- Enabled state
        StopButton.BackgroundColor3 = Color3.fromRGB(180, 35, 35) -- Red
        StopButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White
        StopButton.AutoButtonColor = true -- Enable button effect
    else
        -- Disabled state
        StopButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- Gray
        StopButton.TextColor3 = Color3.fromRGB(180, 180, 180) -- Light gray
        StopButton.AutoButtonColor = false -- Disable button effect
    end
end

-- Function to refresh player list
local function refreshPlayerList()
    for _, button in pairs(playerButtons) do
        button:Destroy()
    end
    playerButtons = {}
    
    local yPos = 5
    local playerList = Players:GetPlayers()
    table.sort(playerList, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    for i, player in ipairs(playerList) do
        if player ~= LocalPlayer then -- Don't show yourself in the list
            local playerButton = Instance.new("TextButton")
            playerButton.Position = UDim2.new(0, 5, 0, yPos)
            playerButton.Size = UDim2.new(1, -10, 0, 30)
            playerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            playerButton.BorderSizePixel = 0
            playerButton.Text = player.Name
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.Font = Enum.Font.Gotham
            playerButton.TextSize = 14
            playerButton.Parent = ScrollFrame
            playerButton.ZIndex = 12
            
            -- Rounded corners for player buttons
            local playerButtonCorner = Instance.new("UICorner")
            playerButtonCorner.CornerRadius = UDim.new(0, 4)
            playerButtonCorner.Parent = playerButton
            
            -- Select player on click
            playerButton.MouseButton1Click:Connect(function()
                selectedTarget = player
                TargetDisplay.Text = "Target: " .. player.Name
                PlayerSelectionFrame.Visible = false
            end)
            
            -- Highlight on hover
            playerButton.MouseEnter:Connect(function()
                playerButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
            end)
            
            playerButton.MouseLeave:Connect(function()
                playerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            end)
            
            table.insert(playerButtons, playerButton)
            yPos = yPos + 35
        end
    end
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end

-- Function to stop flinging
local function stopFling()
    if not flingActive then return end
    
    flingActive = false
    updateStopButton()
    
    if targetConnection then
        targetConnection:Disconnect()
        targetConnection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
            
            if part:IsA("BodyAngularVelocity") or part:IsA("BodyVelocity") then
                part:Destroy()
            end
        end
    end
    
    TargetDisplay.Text = "Target: " .. (selectedTarget and selectedTarget.Name or "None") .. " (Fling Stopped)"
end

-- SUPER FLING FUNCTION - direct method that doesn't teleport you
local function executeSuperFling()
    if flingActive then
        TargetDisplay.Text = "Already flinging! Stop first."
        return
    end
    
    if not selectedTarget then
        TargetDisplay.Text = "No target selected!"
        return
    end
    
    local targetPlayer = selectedTarget
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        TargetDisplay.Text = "Target character not found!"
        return
    end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        TargetDisplay.Text = "Your character not ready!"
        return
    end
    
    -- Set up for flinging
    flingActive = true
    updateStopButton()
    TargetDisplay.Text = "FLINGING: " .. targetPlayer.Name
    
    -- Make our character parts non-collidable to prevent flinging ourselves
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Create the rocket launcher (invisible force that launches target)
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    local launchForce = Instance.new("BodyVelocity")
    launchForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    launchForce.P = math.huge
    
    -- Direction to fling - extremely powerful upward and in a random horizontal direction
    local direction = Vector3.new(
        math.random(-100, 100), 
        math.random(500, 1000), -- Heavy upward force
        math.random(-100, 100)
    ).Unit * 9999999 -- Maximum force
    
    launchForce.Velocity = direction
    launchForce.Parent = targetRoot
    
    -- Add spin for more dramatic effect
    local spinForce = Instance.new("BodyAngularVelocity")
    spinForce.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    spinForce.AngularVelocity = Vector3.new(
        math.random(-50, 50),
        math.random(-50, 50),
        math.random(-50, 50)
    )
    spinForce.P = math.huge
    spinForce.Parent = targetRoot
    
    -- Create a connection to track when target is far enough away
    local startPos = targetRoot.Position
    targetConnection = RunService.Heartbeat:Connect(function()
        if not flingActive then
            return
        end
        
        -- Check if target still exists
        if not targetPlayer or not targetPlayer.Character or
           not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            stopFling()
            return
        end
        
        -- Check if target has gone far enough away
        local distance = (targetRoot.Position - startPos).Magnitude
        if distance > 500 then -- If target has gone at least 500 studs away
            -- They're gone! Clean up
            if launchForce and launchForce.Parent then
                launchForce:Destroy()
            end
            
            if spinForce and spinForce.Parent then
                spinForce:Destroy()
            end
            
            stopFling()
            TargetDisplay.Text = "Target sent flying successfully!"
        end
    end)
    
    -- Backup cleanup after 10 seconds in case distance check never triggers
    spawn(function()
        wait(10)
        if flingActive then
            stopFling()
        end
    end)
end

-- Button event connections
SelectTargetButton.MouseButton1Click:Connect(function()
    refreshPlayerList()
    PlayerSelectionFrame.Visible = true
end)

FlingButton.MouseButton1Click:Connect(executeSuperFling)

StopButton.MouseButton1Click:Connect(function()
    if flingActive then
        stopFling()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    PlayerSelectionFrame.Visible = false
end)

-- Main GUI close button
CloseMainButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Player added/removed events
Players.PlayerAdded:Connect(function()
    if PlayerSelectionFrame.Visible then
        refreshPlayerList()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if PlayerSelectionFrame.Visible then
        refreshPlayerList()
    end
    
    if selectedTarget == player then
        selectedTarget = nil
        TargetDisplay.Text = "Target: None (Player Left)"
        
        if flingActive then
            stopFling()
        end
    end
end)

-- Initialize stop button as disabled
updateStopButton()

-- Initial refresh of player list
refreshPlayerList()

-- Show welcome message
TargetDisplay.Text = "Select a target to begin!"
