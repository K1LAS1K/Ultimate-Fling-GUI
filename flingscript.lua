--[[
KILASIK's Multi-Target Fling Exploit
Features:
- Select multiple targets at once
- Continuous fling (even after respawn)
- Change targets while flinging is active
- One-shot powerful fling that sends players flying
]]
-- Initialize Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
-- Create Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KilasikMultiFlingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
-- Title
local Title = Instance.new("TextLabel")
Title.Text = "KILASIK'S MULTI-FLING"
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = TitleBar
-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar
-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Select players to fling"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame
-- Player List Container
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Position = UDim2.new(0, 10, 0, 70)
PlayerListFrame.Size = UDim2.new(1, -20, 0, 180)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Parent = MainFrame
-- Player List ScrollFrame
local PlayerScrollFrame = Instance.new("ScrollingFrame")
PlayerScrollFrame.Position = UDim2.new(0, 5, 0, 5)
PlayerScrollFrame.Size = UDim2.new(1, -10, 1, -10)
PlayerScrollFrame.BackgroundTransparency = 1
PlayerScrollFrame.BorderSizePixel = 0
PlayerScrollFrame.ScrollBarThickness = 6
PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollFrame.Parent = PlayerListFrame
-- Control Buttons
local StartButton = Instance.new("TextButton")
StartButton.Position = UDim2.new(0, 10, 0, 260)
StartButton.Size = UDim2.new(0.5, -15, 0, 35)
StartButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
StartButton.Text = "START FLING"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.SourceSansBold
StartButton.TextSize = 16
StartButton.BorderSizePixel = 0
StartButton.Parent = MainFrame
local StopButton = Instance.new("TextButton")
StopButton.Position = UDim2.new(0.5, 5, 0, 260)
StopButton.Size = UDim2.new(0.5, -15, 0, 35)
StopButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
StopButton.Text = "STOP FLING"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.TextSize = 16
StopButton.BorderSizePixel = 0
StopButton.Parent = MainFrame
-- Select/Deselect All Buttons
local SelectAllButton = Instance.new("TextButton")
SelectAllButton.Position = UDim2.new(0, 10, 0, 305)
SelectAllButton.Size = UDim2.new(0.5, -15, 0, 30)
SelectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SelectAllButton.Text = "SELECT ALL"
SelectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllButton.Font = Enum.Font.SourceSans
SelectAllButton.TextSize = 14
SelectAllButton.BorderSizePixel = 0
SelectAllButton.Parent = MainFrame
local DeselectAllButton = Instance.new("TextButton")
DeselectAllButton.Position = UDim2.new(0.5, 5, 0, 305)
DeselectAllButton.Size = UDim2.new(0.5, -15, 0, 30)
DeselectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DeselectAllButton.Text = "DESELECT ALL"
DeselectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeselectAllButton.Font = Enum.Font.SourceSans
DeselectAllButton.TextSize = 14
DeselectAllButton.BorderSizePixel = 0
DeselectAllButton.Parent = MainFrame
-- Variables
local flingActive = false
local selectedPlayers = {}
local playerCheckboxes = {}
-- Function to populate player list
local function refreshPlayerList()
    -- Clear existing items
    for _, item in pairs(PlayerScrollFrame:GetChildren()) do
        item:Destroy()
    end
    playerCheckboxes = {}
    
    -- Get all players and sort by name
    local playerList = Players:GetPlayers()
    table.sort(playerList, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    -- Create checkboxes for each player
    local yPos = 5
    for _, player in ipairs(playerList) do
        if player ~= LocalPlayer then -- Don't include yourself
            -- Player entry frame
            local playerFrame = Instance.new("Frame")
            playerFrame.Size = UDim2.new(1, -5, 0, 30)
            playerFrame.Position = UDim2.new(0, 0, 0, yPos)
            playerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            playerFrame.BorderSizePixel = 0
            playerFrame.Parent = PlayerScrollFrame
            
            -- Checkbox
            local checkbox = Instance.new("TextButton")
            checkbox.Size = UDim2.new(0, 30, 0, 30)
            checkbox.Position = UDim2.new(0, 0, 0, 0)
            checkbox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            checkbox.BorderSizePixel = 0
            checkbox.Text = ""
            checkbox.Parent = playerFrame
            
            -- Checkmark (initially hidden)
            local checkmark = Instance.new("TextLabel")
            checkmark.Size = UDim2.new(1, 0, 1, 0)
            checkmark.BackgroundTransparency = 1
            checkmark.Text = "✓"
            checkmark.TextColor3 = Color3.fromRGB(0, 255, 0)
            checkmark.Font = Enum.Font.SourceSansBold
            checkmark.TextSize = 24
            checkmark.Visible = selectedPlayers[player.UserId] ~= nil
            checkmark.Parent = checkbox
            
            -- Player name
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -40, 1, 0)
            nameLabel.Position = UDim2.new(0, 40, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.SourceSans
            nameLabel.TextSize = 16
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = playerFrame
            
            -- Checkbox functionality
            checkbox.MouseButton1Click:Connect(function()
                if selectedPlayers[player.UserId] then
                    selectedPlayers[player.UserId] = nil
                    checkmark.Visible = false
                else
                    selectedPlayers[player.UserId] = player
                    checkmark.Visible = true
                end
                updateStatus()
            end)
            
            -- Store reference to checkbox
            playerCheckboxes[player.UserId] = {
                frame = playerFrame,
                checkmark = checkmark
            }
            
            yPos = yPos + 35
        end
    end
    
    -- Update scrolling frame canvas size
    PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end
-- Function to count selected players
local function countSelectedPlayers()
    local count = 0
    for _ in pairs(selectedPlayers) do
        count = count + 1
    end
    return count
end
-- Function to update status label
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
-- Function to select or deselect all players
local function selectAll(select)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local checkbox = playerCheckboxes[player.UserId]
            if checkbox then
                if select then
                    selectedPlayers[player.UserId] = player
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
-- Main fling function
local function flingPlayer(player)
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return -- Skip invalid players
    end
    
    local targetRoot = player.Character.HumanoidRootPart
    
    -- Create velocity to fling the player
    local velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    velocity.P = math.huge
    
    -- Random but strong direction
    local direction = Vector3.new(
        math.random(-50, 50), 
        math.random(80, 100), -- More upward force
        math.random(-50, 50)
    ).Unit * 9999999 -- Maximum power
    
    velocity.Velocity = direction
    velocity.Parent = targetRoot
    
    -- Add spin effect
    local spin = Instance.new("BodyAngularVelocity")
    spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    spin.AngularVelocity = Vector3.new(
        math.random(-50, 50),
        math.random(-50, 50),
        math.random(-50, 50)
    )
    spin.P = math.huge
    spin.Parent = targetRoot
    
    -- Clean up after brief delay
    spawn(function()
        wait(0.5) -- Short delay to avoid instantly destroying it
        if velocity and velocity.Parent then
            velocity:Destroy()
        end
        if spin and spin.Parent then
            spin:Destroy()
        end
    end)
end
-- Connection for continuous flinging
local flingConnection = nil
-- Start flinging function
local function startFlinging()
    if flingActive then return end
    
    if countSelectedPlayers() == 0 then
        StatusLabel.Text = "No players selected!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(1)
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusLabel.Text = "Select players to fling"
        return
    end
    
    flingActive = true
    updateStatus()
    
    -- Start continuous fling loop
    flingConnection = RunService.Heartbeat:Connect(function()
        for userId, player in pairs(selectedPlayers) do
            -- Check if player is still in game
            if player.Parent == nil then
                selectedPlayers[userId] = nil
                local checkbox = playerCheckboxes[userId]
                if checkbox then
                    checkbox.checkmark.Visible = false
                end
                continue
            end
            
            -- Fling the player
            flingPlayer(player)
        end
        
        -- Update status periodically
        if (os.clock() % 1) < 0.1 then
            updateStatus()
        end
    end)
end
-- Stop flinging function
local function stopFlinging()
    if not flingActive then return end
    
    flingActive = false
    if flingConnection then
        flingConnection:Disconnect()
        flingConnection = nil
    end
    
    updateStatus()
end
-- Player added/removed events
Players.PlayerAdded:Connect(function()
    refreshPlayerList()
end)
Players.PlayerRemoving:Connect(function(player)
    if selectedPlayers[player.UserId] then
        selectedPlayers[player.UserId] = nil
        updateStatus()
    end
    refreshPlayerList()
end)
-- Connect buttons
StartButton.MouseButton1Click:Connect(startFlinging)
StopButton.MouseButton1Click:Connect(stopFlinging)
SelectAllButton.MouseButton1Click:Connect(function() selectAll(true) end)
DeselectAllButton.MouseButton1Click:Connect(function() selectAll(false) end)
CloseButton.MouseButton1Click:Connect(function()
    stopFlinging()
    ScreenGui:Destroy()
end)
-- Initial setup
refreshPlayerList()
updateStatus()
-- Print success message
print("KILASIK's Multi-Target Fling Exploit loaded!")
