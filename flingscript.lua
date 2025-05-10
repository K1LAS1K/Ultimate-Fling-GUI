--[[
KILASIK's Ultimate Fling GUI
Multi-target, continuous flinging with advanced GUI
]]
-- Get services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateFlingGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.Parent = MainFrame
-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "KILASIK's Ultimate Fling GUI"
Title.TextColor3 = Color3.fromRGB(255, 80, 80)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar
-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Parent = TopBar
-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Select players to fling"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame
-- Player List Frame
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Name = "PlayerListFrame"
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Position = UDim2.new(0, 10, 0, 70)
PlayerListFrame.Size = UDim2.new(1, -20, 0, 160)
PlayerListFrame.Parent = MainFrame
-- Player Scroll
local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Name = "PlayerScroll"
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.Position = UDim2.new(0, 5, 0, 5)
PlayerScroll.Size = UDim2.new(1, -10, 1, -10)
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.ScrollBarThickness = 6
PlayerScroll.Parent = PlayerListFrame
-- Fling Button
local FlingButton = Instance.new("TextButton")
FlingButton.Name = "FlingButton"
FlingButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
FlingButton.BorderSizePixel = 0
FlingButton.Position = UDim2.new(0, 10, 0, 240)
FlingButton.Size = UDim2.new(0.5, -15, 0, 40)
FlingButton.Font = Enum.Font.SourceSansBold
FlingButton.Text = "START FLING"
FlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingButton.TextSize = 16
FlingButton.Parent = MainFrame
-- Stop Button
local StopButton = Instance.new("TextButton")
StopButton.Name = "StopButton"
StopButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
StopButton.BorderSizePixel = 0
StopButton.Position = UDim2.new(0.5, 5, 0, 240)
StopButton.Size = UDim2.new(0.5, -15, 0, 40)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.Text = "STOP FLING"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextSize = 16
StopButton.Parent = MainFrame
-- Select All Button
local SelectAllButton = Instance.new("TextButton")
SelectAllButton.Name = "SelectAllButton"
SelectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SelectAllButton.BorderSizePixel = 0
SelectAllButton.Position = UDim2.new(0, 10, 0, 290)
SelectAllButton.Size = UDim2.new(0.5, -15, 0, 30)
SelectAllButton.Font = Enum.Font.SourceSans
SelectAllButton.Text = "SELECT ALL"
SelectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllButton.TextSize = 14
SelectAllButton.Parent = MainFrame
-- Deselect All Button
local DeselectAllButton = Instance.new("TextButton")
DeselectAllButton.Name = "DeselectAllButton"
DeselectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DeselectAllButton.BorderSizePixel = 0
DeselectAllButton.Position = UDim2.new(0.5, 5, 0, 290)
DeselectAllButton.Size = UDim2.new(0.5, -15, 0, 30)
DeselectAllButton.Font = Enum.Font.SourceSans
DeselectAllButton.Text = "DESELECT ALL"
DeselectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeselectAllButton.TextSize = 14
DeselectAllButton.Parent = MainFrame
-- Variables
local selectedPlayers = {}
local playerCheckboxes = {}
local flingActive = false
local flingLoopConnection = nil
-- Character setup for flinging
local function setupCharacter()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Important configurations for effective flinging
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    
    -- Make character parts non-collidable
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    return character
end
-- Utility function to get player object by UserId
local function getPlayerById(userId)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.UserId == userId then
            return player
        end
    end
    return nil
end
-- Function to populate player list
local function refreshPlayerList()
    -- Clear existing entries
    for _, child in pairs(PlayerScroll:GetChildren()) do
        child:Destroy()
    end
    playerCheckboxes = {}
    
    -- Get and sort player list
    local playerList = Players:GetPlayers()
    table.sort(playerList, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    -- Create player entries
    local yPos = 5
    for _, player in ipairs(playerList) do
        if player ~= LocalPlayer then
            -- Player entry container
            local playerEntry = Instance.new("Frame")
            playerEntry.Name = player.Name .. "Entry"
            playerEntry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            playerEntry.BorderSizePixel = 0
            playerEntry.Position = UDim2.new(0, 0, 0, yPos)
            playerEntry.Size = UDim2.new(1, 0, 0, 30)
            playerEntry.Parent = PlayerScroll
            
            -- Checkbox
            local checkbox = Instance.new("TextButton")
            checkbox.Name = "Checkbox"
            checkbox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            checkbox.BorderSizePixel = 0
            checkbox.Position = UDim2.new(0, 5, 0.5, -10)
            checkbox.Size = UDim2.new(0, 20, 0, 20)
            checkbox.Text = ""
            checkbox.Parent = playerEntry
            
            -- Check mark (initially invisible)
            local checkmark = Instance.new("TextLabel")
            checkmark.Name = "Checkmark"
            checkmark.BackgroundTransparency = 1
            checkmark.Size = UDim2.new(1, 0, 1, 0)
            checkmark.Font = Enum.Font.SourceSansBold
            checkmark.Text = "✓"
            checkmark.TextColor3 = Color3.fromRGB(0, 255, 0)
            checkmark.TextSize = 18
            checkmark.Visible = selectedPlayers[player.UserId] ~= nil
            checkmark.Parent = checkbox
            
            -- Player name
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "NameLabel"
            nameLabel.BackgroundTransparency = 1
            nameLabel.Position = UDim2.new(0, 35, 0, 0)
            nameLabel.Size = UDim2.new(1, -40, 1, 0)
            nameLabel.Font = Enum.Font.SourceSans
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 16
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = playerEntry
            
            -- Make the whole entry clickable
            local clickArea = Instance.new("TextButton")
            clickArea.BackgroundTransparency = 1
            clickArea.Size = UDim2.new(1, 0, 1, 0)
            clickArea.ZIndex = 2
            clickArea.Text = ""
            clickArea.Parent = playerEntry
            
            -- Click handler
            clickArea.MouseButton1Click:Connect(function()
                if selectedPlayers[player.UserId] then
                    selectedPlayers[player.UserId] = nil
                    checkmark.Visible = false
                else
                    selectedPlayers[player.UserId] = player.UserId -- Store just the ID
                    checkmark.Visible = true
                end
                updateStatus()
            end)
            
            -- Store reference
            playerCheckboxes[player.UserId] = {
                entry = playerEntry,
                checkmark = checkmark
            }
            
            yPos = yPos + 35
        end
    end
    
    -- Adjust scroll frame canvas size
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end
-- Count selected players
local function countSelectedPlayers()
    local count = 0
    for _ in pairs(selectedPlayers) do
        count = count + 1
    end
    return count
end
-- Update status display
local function updateStatus()
    local count = countSelectedPlayers()
    if flingActive then
        StatusLabel.Text = "Flinging " .. count .. " player(s)"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        StatusLabel.Text = count .. " player(s) selected"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end
-- Select/Deselect all players
local function toggleAllPlayers(select)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local checkbox = playerCheckboxes[player.UserId]
            if checkbox then
                if select then
                    selectedPlayers[player.UserId] = player.UserId
                    checkbox.checkmark.Visible = true
                else
                    selectedPlayers[player.UserId] = nil
                    checkbox.checkmark.Visible = false
                end
            end
        end
    end
    updateStatus()
end
-- EFFECTIVE FLING MECHANISM
local function flingPlayer(targetPlayer)
    -- Skip if player doesn't exist or has no character
    if not targetPlayer or not targetPlayer.Character then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not root or not targetRoot then return end
    
    -- Get the target's velocity
    local targetVelocity = targetRoot.Velocity
    
    -- SUPER FLING: Create extremely powerful physics forces
    
    -- First, teleport to target
    local oldPos = root.CFrame
    root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 0.01) -- Position slightly offset
    
    -- Apply a massive velocity
    for i = 1, 3 do  -- Multiple attempts for more reliable flinging
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.P = math.huge
        
        -- We create a randomized but very powerful velocity
        local power = 9999999
        local randomDir = Vector3.new(
            math.random(-10, 10), 
            math.random(5, 10), 
            math.random(-10, 10)
        ).Unit * power
        
        bodyVelocity.Velocity = randomDir
        bodyVelocity.Parent = targetRoot
        
        -- Also add spin for more dramatic effect
        local bodyAngular = Instance.new("BodyAngularVelocity")
        bodyAngular.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngular.P = math.huge
        bodyAngular.AngularVelocity = Vector3.new(
            math.random(-30, 30), 
            math.random(-30, 30), 
            math.random(-30, 30)
        )
        bodyAngular.Parent = targetRoot
        
        -- Remove the forces quickly to prevent the game from compensating
        game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
        game:GetService("Debris"):AddItem(bodyAngular, 0.1)
    end
    
    -- After flinging, teleport back to original position
    root.CFrame = oldPos
end
-- Start the fling loop
local function startFlingLoop()
    if flingActive then return end
    
    if countSelectedPlayers() == 0 then
        StatusLabel.Text = "No players selected!"
        wait(1)
        updateStatus()
        return
    end
    
    -- Set up character for flinging
    setupCharacter()
    
    -- Start flinging
    flingActive = true
    updateStatus()
    
    flingLoopConnection = RunService.Heartbeat:Connect(function()
        -- Process all selected players
        for userId in pairs(selectedPlayers) do
            local player = getPlayerById(userId)
            if player then
                flingPlayer(player)
            else
                -- Remove player from selection if they've left
                selectedPlayers[userId] = nil
                if playerCheckboxes[userId] then
                    playerCheckboxes[userId].checkmark.Visible = false
                end
            end
        end
    end)
    
    -- Monitor character changes to re-setup as needed
    LocalPlayer.CharacterAdded:Connect(function()
        if flingActive then
            wait(0.5) -- Wait for character to initialize
            setupCharacter()
        end
    end)
end
-- Stop the fling loop
local function stopFlingLoop()
    if not flingActive then return end
    
    flingActive = false
    
    if flingLoopConnection then
        flingLoopConnection:Disconnect()
        flingLoopConnection = nil
    end
    
    -- Restore character to normal
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    
    updateStatus()
end
-- Set up button connections
FlingButton.MouseButton1Click:Connect(startFlingLoop)
StopButton.MouseButton1Click:Connect(stopFlingLoop)
SelectAllButton.MouseButton1Click:Connect(function() toggleAllPlayers(true) end)
DeselectAllButton.MouseButton1Click:Connect(function() toggleAllPlayers(false) end)
CloseButton.MouseButton1Click:Connect(function()
    stopFlingLoop()
    ScreenGui:Destroy()
end)
-- Player added/removed events
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(function(player)
    if selectedPlayers[player.UserId] then
        selectedPlayers[player.UserId] = nil
    end
    refreshPlayerList()
    updateStatus()
end)
-- Initial setup
refreshPlayerList()
updateStatus()
-- Success notification
print("KILASIK's Ultimate Fling GUI loaded and ready!")
