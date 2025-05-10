--[[
    Ultra Fling Exploit with GUI for Roblox
    Made for Exploit Executors like JJSploit, Synapse, etc.
    Features:
     - One-click target selection from server player list
     - ULTRA POWER fling that sends targets flying to the other side of the map
     - Returns your character to the starting position when fling stops
     - Modern GUI with easy-to-use controls
     - Credit label "KILASIK"
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraFlingExploitGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 250)
Frame.Position = UDim2.new(0.5, -150, 0.5, -125)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "💥 ULTRA FLING EXPLOIT 💥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

-- Target display label
local TargetDisplay = Instance.new("TextLabel")
TargetDisplay.Position = UDim2.new(0, 10, 0, 40)
TargetDisplay.Size = UDim2.new(0, 280, 0, 25)
TargetDisplay.BackgroundTransparency = 1
TargetDisplay.Text = "Selected Target: None"
TargetDisplay.TextColor3 = Color3.fromRGB(220, 220, 220)
TargetDisplay.Font = Enum.Font.Gotham
TargetDisplay.TextSize = 14
TargetDisplay.TextXAlignment = Enum.TextXAlignment.Left
TargetDisplay.Parent = Frame

-- Target selection button
local SelectTargetButton = Instance.new("TextButton")
local selectedTarget = nil
local startPosition = nil  -- To store initial position

SelectTargetButton.Position = UDim2.new(0, 10, 0, 70)
SelectTargetButton.Size = UDim2.new(0, 280, 0, 35)
SelectTargetButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
SelectTargetButton.BorderSizePixel = 0
SelectTargetButton.Text = "👉 SELECT TARGET PLAYER 👈"
SelectTargetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectTargetButton.Font = Enum.Font.GothamBold
SelectTargetButton.TextSize = 16
SelectTargetButton.Parent = Frame

-- Start Button
local StartButton = Instance.new("TextButton")
StartButton.Position = UDim2.new(0, 10, 0, 115)
StartButton.Size = UDim2.new(0, 280, 0, 45)
StartButton.BackgroundColor3 = Color3.fromRGB(25, 145, 230)
StartButton.BorderSizePixel = 0
StartButton.Text = "🚀 START ULTRA FLING 🚀"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 18
StartButton.Parent = Frame

-- Stop Button
local StopButton = Instance.new("TextButton")
StopButton.Position = UDim2.new(0, 10, 0, 170)
StopButton.Size = UDim2.new(0, 280, 0, 30)
StopButton.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
StopButton.BorderSizePixel = 0
StopButton.Text = "⛔ STOP FLING ⛔"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.GothamBold
StopButton.TextSize = 16
StopButton.Parent = Frame

-- Credit Label (made much more prominent)
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Position = UDim2.new(0, 0, 1, -30)
CreditLabel.Size = UDim2.new(1, 0, 0, 30)
CreditLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CreditLabel.BorderSizePixel = 0
CreditLabel.Text = "KILASIK"
CreditLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
CreditLabel.Font = Enum.Font.GothamBold
CreditLabel.TextSize = 18
CreditLabel.TextXAlignment = Enum.TextXAlignment.Center
CreditLabel.Parent = Frame

-- Player Selection GUI
local PlayerSelectionFrame = Instance.new("Frame")
PlayerSelectionFrame.Size = UDim2.new(0, 250, 0, 300)
PlayerSelectionFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
PlayerSelectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerSelectionFrame.BorderSizePixel = 0
PlayerSelectionFrame.Visible = false
PlayerSelectionFrame.Parent = ScreenGui
PlayerSelectionFrame.ZIndex = 10
PlayerSelectionFrame.Active = true
PlayerSelectionFrame.Draggable = true

-- Selection Title
local SelectionTitle = Instance.new("TextLabel")
SelectionTitle.Size = UDim2.new(1, 0, 0, 30)
SelectionTitle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SelectionTitle.BorderSizePixel = 0
SelectionTitle.Text = "Select Player To Fling"
SelectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectionTitle.Font = Enum.Font.GothamBold
SelectionTitle.TextSize = 16
SelectionTitle.Parent = PlayerSelectionFrame
SelectionTitle.ZIndex = 11

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

-- Player list scroll frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = PlayerSelectionFrame
ScrollFrame.ZIndex = 11
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be adjusted dynamically

-- Variables
local flingRunning = false
local flingConnection
local playerButtons = {}

-- Utility functions
local function getPlayerByName(name)
    name = name or ""
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower() == name:lower() then
            return p
        end
    end
    return nil
end

-- Player selection functions
local function refreshPlayerList()
    -- Clear existing buttons
    for _, button in pairs(playerButtons) do
        button:Destroy()
    end
    playerButtons = {}
    
    -- Add buttons for each player
    local yPos = 5
    local playerList = Players:GetPlayers()
    table.sort(playerList, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    for i, player in ipairs(playerList) do
        local playerButton = Instance.new("TextButton")
        playerButton.Position = UDim2.new(0, 5, 0, yPos)
        playerButton.Size = UDim2.new(1, -10, 0, 30)
        playerButton.BackgroundColor3 = (player == LocalPlayer) and Color3.fromRGB(70, 70, 100) or Color3.fromRGB(60, 60, 60)
        playerButton.BorderSizePixel = 0
        playerButton.Text = player.Name
        playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerButton.Font = Enum.Font.Gotham
        playerButton.TextSize = 14
        playerButton.Parent = ScrollFrame
        playerButton.ZIndex = 12
        
        -- On button click, select this player
        playerButton.MouseButton1Click:Connect(function()
            if player ~= LocalPlayer then
                selectedTarget = player
                TargetDisplay.Text = "Selected Target: " .. player.Name
                PlayerSelectionFrame.Visible = false
            else
                -- Can't target yourself
                TargetDisplay.Text = "❌ You can't target yourself!"
                wait(1)
                TargetDisplay.Text = "Selected Target: None"
            end
        end)
        
        -- Highlight on hover
        playerButton.MouseEnter:Connect(function()
            if player ~= LocalPlayer then
                playerButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end
        end)
        
        playerButton.MouseLeave:Connect(function()
            if player ~= LocalPlayer then
                playerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            else
                playerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
            end
        end)
        
        table.insert(playerButtons, playerButton)
        yPos = yPos + 35
    end
    
    -- Update scroll frame canvas size
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end

-- ULTRA POWER fling function - much stronger than before
local function startUltraFling(targetPlayer)
    if flingRunning then
        TargetDisplay.Text = "Fling already running"
        return
    end
    
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        TargetDisplay.Text = "Target player not found!"
        return
    end
    
    local targetHRP = targetPlayer.Character.HumanoidRootPart
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not localHRP then
        TargetDisplay.Text = "Your character not ready"
        return
    end

    -- Store start position
    startPosition = localHRP.Position
    
    flingRunning = true
    TargetDisplay.Text = "ULTRA FLINGING: " .. targetPlayer.Name

    -- Create BodyVelocity with MAXIMUM FORCE
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge) -- unlimited force
    bv.P = 1e9                                                 -- maximum power
    bv.Parent = localHRP

    -- Create BodyAngularVelocity for EXTREME spinning
    local bav = Instance.new("BodyAngularVelocity")
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)  -- unlimited torque
    bav.AngularVelocity = Vector3.new(500, 500, 500)              -- extreme spinning
    bav.P = 1e9                                                    -- maximum power
    bav.Parent = localHRP

    -- Create BodyGyro to maintain better control
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 1e9
    bg.Parent = localHRP

    local lastPosition = targetHRP.Position
    local velocityMultiplier = 50000  -- ULTRA HIGH value for extreme velocity

    flingConnection = RunService.Heartbeat:Connect(function()
        if
            not flingRunning or
            not targetHRP or
            not targetHRP.Parent or
            not localHRP or
            not localHRP.Parent
        then
            flingConnection:Disconnect()
            if bv and bv.Parent then bv:Destroy() end
            if bav and bav.Parent then bav:Destroy() end
            if bg and bg.Parent then bg:Destroy() end
            
            -- Return to start position when fling ends
            if localHRP and startPosition then
                localHRP.CFrame = CFrame.new(startPosition)
            end
            
            flingRunning = false
            TargetDisplay.Text = "Fling stopped - returned to start"
            return
        end

        -- Track target even if they move
        local targetPosition = targetHRP.Position
        local moveDirection = (targetPosition - lastPosition).Unit
        lastPosition = targetPosition

        -- Set position very close to target for maximum impact
        localHRP.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
        
        -- Apply extreme velocity toward target
        bv.Velocity = moveDirection * velocityMultiplier
        
        -- Rapidly change spin direction for chaotic motion
        bav.AngularVelocity = Vector3.new(
            math.random(-500, 500), 
            math.random(-500, 500), 
            math.random(-500, 500)
        )
        
        -- Focus gyro on target
        bg.CFrame = CFrame.new(localHRP.Position, targetPosition)
    end)
end

local function stopFling()
    if not flingRunning then
        TargetDisplay.Text = "No fling running"
        return
    end
    
    flingRunning = false
    
    if flingConnection then
        flingConnection:Disconnect()
        flingConnection = nil
    end
    
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if localHRP then
        for _, inst in pairs(localHRP:GetChildren()) do
            if inst:IsA("BodyVelocity") or inst:IsA("BodyAngularVelocity") or inst:IsA("BodyGyro") then
                inst:Destroy()
            end
        end
        
        -- Return to start position
        if startPosition then
            localHRP.CFrame = CFrame.new(startPosition)
        end
    end
    
    TargetDisplay.Text = "Fling stopped - returned to start"
end

-- Button events
SelectTargetButton.MouseButton1Click:Connect(function()
    refreshPlayerList() -- Refresh the list when opening
    PlayerSelectionFrame.Visible = true
end)

StartButton.MouseButton1Click:Connect(function()
    if not selectedTarget then
        TargetDisplay.Text = "Please select a target first!"
        return
    end
    
    startUltraFling(selectedTarget)
end)

StopButton.MouseButton1Click:Connect(function()
    stopFling()
end)

-- Close button for player selection
CloseButton.MouseButton1Click:Connect(function()
    PlayerSelectionFrame.Visible = false
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
    
    -- If the selected target left, clear selection
    if selectedTarget == player then
        selectedTarget = nil
        TargetDisplay.Text = "Selected Target: None"
        if flingRunning then
            stopFling()
        end
    end
end)

-- Cleanup on character reset, but keep GUI
LocalPlayer.CharacterAdded:Connect(function()
    if flingRunning then
        stopFling()
    end
end)

-- Prevent character from dying during fling
LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

-- Initial refresh of player list
refreshPlayerList()

-- Display initial message
TargetDisplay.Text = "Select a target to begin!"
