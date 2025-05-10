--[[
    Super Fling Exploit with GUI for Roblox
    Made for Exploit Executors like JJSploit, Synapse, etc.
    Features:
     - Select target player from server player list
     - Super high power range for extreme flinging (50-10000)
     - Start/Stop fling with one click
     - Modern GUI with player selection menu
     - Credit label "KILASIK"
--]]

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
Frame.Size = UDim2.new(0, 300, 0, 280)
Frame.Position = UDim2.new(0.5, -150, 0.5, -140)
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
Title.Text = "🔥 Super Fling Exploit"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

-- Target display label
local TargetDisplay = Instance.new("TextLabel")
TargetDisplay.Position = UDim2.new(0, 10, 0, 40)
TargetDisplay.Size = UDim2.new(0, 280, 0, 20)
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

SelectTargetButton.Position = UDim2.new(0, 10, 0, 65)
SelectTargetButton.Size = UDim2.new(0, 280, 0, 30)
SelectTargetButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
SelectTargetButton.BorderSizePixel = 0
SelectTargetButton.Text = "👉 Click to Select Target Player 👈"
SelectTargetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectTargetButton.Font = Enum.Font.GothamBold
SelectTargetButton.TextSize = 14
SelectTargetButton.Parent = Frame

-- Fling Power Label
local PowerLabel = Instance.new("TextLabel")
PowerLabel.Position = UDim2.new(0, 10, 0, 105)
PowerLabel.Size = UDim2.new(0, 280, 0, 20)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Text = "Fling Power (50-10000):"
PowerLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
PowerLabel.Font = Enum.Font.Gotham
PowerLabel.TextSize = 14
PowerLabel.TextXAlignment = Enum.TextXAlignment.Left
PowerLabel.Parent = Frame

-- Fling Power TextBox
local PowerBox = Instance.new("TextBox")
PowerBox.Position = UDim2.new(0, 10, 0, 130)
PowerBox.Size = UDim2.new(0, 280, 0, 30)
PowerBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
PowerBox.BorderSizePixel = 0
PowerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PowerBox.Font = Enum.Font.Gotham
PowerBox.TextSize = 14
PowerBox.PlaceholderText = "5000"
PowerBox.Text = "5000"
PowerBox.ClearTextOnFocus = true
PowerBox.Parent = Frame

-- Start Button
local StartButton = Instance.new("TextButton")
StartButton.Position = UDim2.new(0, 10, 0, 170)
StartButton.Size = UDim2.new(0, 135, 0, 40)
StartButton.BackgroundColor3 = Color3.fromRGB(35, 150, 110)
StartButton.BorderSizePixel = 0
StartButton.Text = "START FLING"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 16
StartButton.Parent = Frame

-- Stop Button
local StopButton = Instance.new("TextButton")
StopButton.Position = UDim2.new(0, 155, 0, 170)
StopButton.Size = UDim2.new(0, 135, 0, 40)
StopButton.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
StopButton.BorderSizePixel = 0
StopButton.Text = "STOP FLING"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.GothamBold
StopButton.TextSize = 16
StopButton.Parent = Frame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Position = UDim2.new(0, 10, 0, 220)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextWrapped = true
StatusLabel.Parent = Frame

-- Credit Label
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Position = UDim2.new(0, 10, 1, -30)
CreditLabel.Size = UDim2.new(1, -20, 0, 20)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "KILASIK"
CreditLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
CreditLabel.Font = Enum.Font.GothamBold
CreditLabel.TextSize = 16
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
SelectionTitle.Text = "Select Player"
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

local function safeNumber(text, default)
    local n = tonumber(text)
    if not n or n < 50 then return default or 5000 end
    if n > 10000 then return 10000 end
    return n
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
                StatusLabel.Text = "You can't target yourself!"
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

-- Main fling function
local function startFling(targetPlayer, power)
    if flingRunning then
        StatusLabel.Text = "Fling already running."
        return
    end
    
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        StatusLabel.Text = "Target player not found or no character."
        return
    end
    
    local targetHRP = targetPlayer.Character.HumanoidRootPart
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not localHRP then
        StatusLabel.Text = "Your character not ready."
        return
    end

    flingRunning = true
    StatusLabel.Text = "Flinging " .. targetPlayer.Name .. " with power " .. power

    -- Create BodyVelocity
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9) -- Increased force for better flinging
    bv.Parent = localHRP

    -- Create BodyAngularVelocity for spinning
    local bav = Instance.new("BodyAngularVelocity")
    bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9) -- Increased torque
    bav.AngularVelocity = Vector3.new(power/10, power/5, power/10)
    bav.Parent = localHRP

    local angle = 0

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
            flingRunning = false
            StatusLabel.Text = "Fling stopped."
            return
        end

        -- Increase angle for circular motion
        angle = angle + math.rad(power / 10)
        if angle > math.rad(360) then
            angle = angle - math.rad(360)
        end

        -- Calculate circular position around target with variable radius
        local radius = 5 + math.sin(angle*3) * 2
        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)

        -- Set player position and orientation
        localHRP.CFrame = CFrame.new(targetHRP.Position + offset) * CFrame.Angles(0, angle, 0)

        -- Apply velocity toward target for maximum impact
        bv.Velocity = (targetHRP.Position - localHRP.Position).Unit * power
    end)
end

local function stopFling()
    if not flingRunning then
        StatusLabel.Text = "No fling running."
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
            if inst:IsA("BodyVelocity") or inst:IsA("BodyAngularVelocity") then
                inst:Destroy()
            end
        end
    end
    
    StatusLabel.Text = "Fling stopped."
end

-- Button events
SelectTargetButton.MouseButton1Click:Connect(function()
    refreshPlayerList() -- Refresh the list when opening
    PlayerSelectionFrame.Visible = true
end)

StartButton.MouseButton1Click:Connect(function()
    if not selectedTarget then
        StatusLabel.Text = "Please select a target player first!"
        return
    end
    
    local power = safeNumber(PowerBox.Text, 5000)
    startFling(selectedTarget, power)
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

-- Cleanup GUI on character reset
LocalPlayer.CharacterRemoving:Connect(function()
    stopFling()
end)

-- Initial refresh of player list
refreshPlayerList()
