--[[
    MEGA FLING Exploit with GUI for Roblox
    Made for Exploit Executors like JJSploit, Synapse, etc.
    Features:
     - ONE-SHOT super powerful fling that sends players to the moon in 1 second
     - Player selection from server list
     - Instant teleport back to origin point when done
     - Credit label "KILASIK"
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MegaFlingExploitGUI"
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
Title.Text = "💥 MEGA MOON FLING 💥"
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
local startPosition = nil

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
local MegaFlingButton = Instance.new("TextButton")
MegaFlingButton.Position = UDim2.new(0, 10, 0, 115)
MegaFlingButton.Size = UDim2.new(0, 280, 0, 60)
MegaFlingButton.BackgroundColor3 = Color3.fromRGB(230, 30, 30)
MegaFlingButton.BorderSizePixel = 0
MegaFlingButton.Text = "🌑 MEGA MOON FLING 🌑"
MegaFlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MegaFlingButton.Font = Enum.Font.GothamBold
MegaFlingButton.TextSize = 18
MegaFlingButton.Parent = Frame

-- Credit Label (full banner style)
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Position = UDim2.new(0, 0, 1, -40)
CreditLabel.Size = UDim2.new(1, 0, 0, 40)
CreditLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CreditLabel.BorderSizePixel = 0
CreditLabel.Text = "KILASIK"
CreditLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
CreditLabel.Font = Enum.Font.GothamBold
CreditLabel.TextSize = 22
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
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Variables
local isFlingActive = false
local playerButtons = {}

-- Utility functions
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

-- THE MEGA MOON FLING FUNCTION - completely redesigned for maximum fling power
local function executeMegaFling(targetPlayer)
    if isFlingActive then
        TargetDisplay.Text = "Wait until current fling completes"
        return
    end
    
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        TargetDisplay.Text = "Target player not found!"
        return
    end
    
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart or not humanoid then
        TargetDisplay.Text = "Your character not ready"
        return
    end
    
    isFlingActive = true
    
    -- Store starting position for return
    startPosition = rootPart.CFrame
    
    -- Prevent dying during fling
    local oldStateEnabled = {}
    for i, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        oldStateEnabled[state] = humanoid:GetStateEnabled(state)
        humanoid:SetStateEnabled(state, false)
    end
    
    -- The only state we want active
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    -- Save old properties to restore later
    local oldMaxForce = rootPart.MaxForce
    local oldVelocity = rootPart.Velocity
    local oldCanCollide = rootPart.CanCollide
    local oldPosition = rootPart.Position
    
    -- Configure character for maximum fling
    if character.PrimaryPart then
        character.PrimaryPart.Anchored = false
    end
    
    rootPart.CanCollide = false
    
    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        isFlingActive = false
        TargetDisplay.Text = "Target has no HumanoidRootPart"
        return
    end
    
    TargetDisplay.Text = "MEGA FLINGING: " .. targetPlayer.Name
    
    -- Set up physics for extreme fling
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.P = math.huge
    
    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngularVelocity.P = math.huge
    
    -- The fling attack sequence
    task.spawn(function()
        -- Phase 1: Setup and attach
        rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 0) -- Position directly on target
        task.wait(0.1)
        
        -- Phase 2: Initial spin and compression (prepare for launch)
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 99999, 0) -- Create a tornado effect
        bodyAngularVelocity.Parent = rootPart
        task.wait(0.1)
        
        -- Phase 3: MAXIMUM FLING - directly to the moon
        -- We're going to create a massive upward force
        local throwDirection = Vector3.new(
            math.random(-10, 10) * 10000, -- Random X for spread
            math.random(80, 100) * 10000,  -- Mostly UP for moon trajectory 
            math.random(-10, 10) * 10000  -- Random Z for spread
        )
        
        -- Apply the massive velocity - this is the main fling effect
        bodyVelocity.Velocity = throwDirection
        bodyVelocity.Parent = targetRoot -- Important: we attach to TARGET, not ourselves
        
        -- Add some chaotic spin to the target as they fly
        local targetSpin = Instance.new("BodyAngularVelocity")
        targetSpin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        targetSpin.AngularVelocity = Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
        targetSpin.P = 1000000
        targetSpin.Parent = targetRoot
        
        -- Let the physics work for a moment
        task.wait(0.2)
        
        -- Clean up our character
        if rootPart and rootPart.Parent then
            bodyAngularVelocity:Destroy()
        end
        
        -- Wait slightly longer before cleaning up target
        -- This ensures they continue flying for some time
        task.wait(1)
        
        if targetRoot and targetRoot.Parent then
            bodyVelocity:Destroy()
            targetSpin:Destroy()
        end
        
        -- Return to original position
        if rootPart and rootPart.Parent and startPosition then
            rootPart.CFrame = startPosition
        end
        
        -- Restore humanoid states
        for state, enabled in pairs(oldStateEnabled) do
            if humanoid and humanoid.Parent then
                humanoid:SetStateEnabled(state, enabled)
            end
        end
        
        isFlingActive = false
        TargetDisplay.Text = "Mega Fling Complete!"
    end)
end

-- Button events
SelectTargetButton.MouseButton1Click:Connect(function()
    refreshPlayerList()
    PlayerSelectionFrame.Visible = true
end)

MegaFlingButton.MouseButton1Click:Connect(function()
    if not selectedTarget then
        TargetDisplay.Text = "Please select a target first!"
        return
    end
    
    executeMegaFling(selectedTarget)
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
    
    if selectedTarget == player then
        selectedTarget = nil
        TargetDisplay.Text = "Selected Target: None"
    end
end)

-- Initial refresh of player list
refreshPlayerList()

-- Display initial message
TargetDisplay.Text = "Select a target and send them to the MOON!"
