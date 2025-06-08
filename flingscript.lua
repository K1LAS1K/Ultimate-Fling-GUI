--[[
    KILASIK's Multi-Target Fling Exploit
    Based on the working fling mechanism from zqyDSUWX
    Features:
    - Select multiple targets
    - Continuous flinging until stopped
    - Preserves player mobility (no teleporting to targets)
    - Flings targets very far
    - Compatible with JJSploit, Synapse X, etc.
]]
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KilasikFlingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")
-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
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
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "KILASIK'S MULTI-FLING"
Title.TextColor3 = Color3.fromRGB(255, 80, 80)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = TitleBar
-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar
-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Select targets to fling"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 16
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame
-- Player Selection Frame
local SelectionFrame = Instance.new("Frame")
SelectionFrame.Position = UDim2.new(0, 10, 0, 70)
SelectionFrame.Size = UDim2.new(1, -20, 0, 200)
SelectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SelectionFrame.BorderSizePixel = 0
SelectionFrame.Parent = MainFrame
-- Player List ScrollFrame
local PlayerScrollFrame = Instance.new("ScrollingFrame")
PlayerScrollFrame.Position = UDim2.new(0, 5, 0, 5)
PlayerScrollFrame.Size = UDim2.new(1, -10, 1, -10)
PlayerScrollFrame.BackgroundTransparency = 1
PlayerScrollFrame.BorderSizePixel = 0
PlayerScrollFrame.ScrollBarThickness = 6
PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollFrame.Parent = SelectionFrame
-- Start Fling Button
local StartButton = Instance.new("TextButton")
StartButton.Position = UDim2.new(0, 10, 0, 280)
StartButton.Size = UDim2.new(0.5, -15, 0, 40)
StartButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
StartButton.BorderSizePixel = 0
StartButton.Text = "START FLING"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.SourceSansBold
StartButton.TextSize = 18
StartButton.Parent = MainFrame
-- Stop Fling Button
local StopButton = Instance.new("TextButton")
StopButton.Position = UDim2.new(0.5, 5, 0, 280)
StopButton.Size = UDim2.new(0.5, -15, 0, 40)
StopButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
StopButton.BorderSizePixel = 0
StopButton.Text = "STOP FLING"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.TextSize = 18
StopButton.Parent = MainFrame
-- Select/Deselect Buttons
local SelectAllButton = Instance.new("TextButton")
SelectAllButton.Position = UDim2.new(0, 10, 0, 330)
SelectAllButton.Size = UDim2.new(0.5, -15, 0, 30)
SelectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SelectAllButton.BorderSizePixel = 0
SelectAllButton.Text = "SELECT ALL"
SelectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllButton.Font = Enum.Font.SourceSans
SelectAllButton.TextSize = 14
SelectAllButton.Parent = MainFrame
local DeselectAllButton = Instance.new("TextButton")
DeselectAllButton.Position = UDim2.new(0.5, 5, 0, 330)
DeselectAllButton.Size = UDim2.new(0.5, -15, 0, 30)
DeselectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DeselectAllButton.BorderSizePixel = 0
DeselectAllButton.Text = "DESELECT ALL"
DeselectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeselectAllButton.Font = Enum.Font.SourceSans
DeselectAllButton.TextSize = 14
DeselectAllButton.Parent = MainFrame
-- Variables
local SelectedTargets = {}
local PlayerCheckboxes = {}
local FlingActive = false
local FlingConnection = nil
getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight
-- Function to update player list
local function RefreshPlayerList()
    -- Clear existing player entries
    for _, child in pairs(PlayerScrollFrame:GetChildren()) do
        child:Destroy()
    end
    PlayerCheckboxes = {}
    
    -- Get players and sort them
    local PlayerList = Players:GetPlayers()
    table.sort(PlayerList, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    -- Create entries for each player
    local yPosition = 5
    for _, player in ipairs(PlayerList) do
        if player ~= Player then -- Don't include yourself
            -- Create player entry frame
            local PlayerEntry = Instance.new("Frame")
            PlayerEntry.Size = UDim2.new(1, -10, 0, 30)
            PlayerEntry.Position = UDim2.new(0, 5, 0, yPosition)
            PlayerEntry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            PlayerEntry.BorderSizePixel = 0
            PlayerEntry.Parent = PlayerScrollFrame
            
            -- Create checkbox
            local Checkbox = Instance.new("TextButton")
            Checkbox.Size = UDim2.new(0, 24, 0, 24)
            Checkbox.Position = UDim2.new(0, 3, 0.5, -12)
            Checkbox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            Checkbox.BorderSizePixel = 0
            Checkbox.Text = ""
            Checkbox.Parent = PlayerEntry
            
            -- Checkmark (initially invisible)
            local Checkmark = Instance.new("TextLabel")
            Checkmark.Size = UDim2.new(1, 0, 1, 0)
            Checkmark.BackgroundTransparency = 1
            Checkmark.Text = "✓"
            Checkmark.TextColor3 = Color3.fromRGB(0, 255, 0)
            Checkmark.TextSize = 18
            Checkmark.Font = Enum.Font.SourceSansBold
            Checkmark.Visible = SelectedTargets[player.Name] ~= nil
            Checkmark.Parent = Checkbox
            
            -- Player name label
            local NameLabel = Instance.new("TextLabel")
            NameLabel.Size = UDim2.new(1, -35, 1, 0)
            NameLabel.Position = UDim2.new(0, 30, 0, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = player.Name
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 16
            NameLabel.Font = Enum.Font.SourceSans
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            NameLabel.Parent = PlayerEntry
            
            -- Make entire entry clickable
            local ClickArea = Instance.new("TextButton")
            ClickArea.Size = UDim2.new(1, 0, 1, 0)
            ClickArea.BackgroundTransparency = 1
            ClickArea.Text = ""
            ClickArea.ZIndex = 2
            ClickArea.Parent = PlayerEntry
            
            -- Selection toggle on click
            ClickArea.MouseButton1Click:Connect(function()
                if SelectedTargets[player.Name] then
                    SelectedTargets[player.Name] = nil
                    Checkmark.Visible = false
                else
                    SelectedTargets[player.Name] = player
                    Checkmark.Visible = true
                end
                
                UpdateStatus()
            end)
            
            -- Store reference to this player's UI
            PlayerCheckboxes[player.Name] = {
                Entry = PlayerEntry,
                Checkmark = Checkmark
            }
            
            yPosition = yPosition + 35
        end
    end
    
    -- Update scrollframe canvas size
    PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition + 5)
end
-- Count selected targets
local function CountSelectedTargets()
    local count = 0
    for _ in pairs(SelectedTargets) do
        count = count + 1
    end
    return count
end
-- Update status display
local function UpdateStatus()
    local count = CountSelectedTargets()
    if FlingActive then
        StatusLabel.Text = "Flinging " .. count .. " target(s)"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    else
        StatusLabel.Text = count .. " target(s) selected" 
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end
-- Function to select/deselect all players
local function ToggleAllPlayers(select)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            local checkboxData = PlayerCheckboxes[player.Name]
            if checkboxData then
                if select then
                    SelectedTargets[player.Name] = player
                    checkboxData.Checkmark.Visible = true
                else
                    SelectedTargets[player.Name] = nil
                    checkboxData.Checkmark.Visible = false
                end
            end
        end
    end
    
    UpdateStatus()
end
-- Show notification
local function Message(Title, Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = Title,
        Text = Text,
        Duration = Time or 5
    })
end
-- The fling function from zqyDSUWX
local function SkidFling(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end
    
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle
    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        
        if THumanoid and THumanoid.Sit then
            return Message("Error", TargetPlayer.Name .. " is sitting", 2)
        end
        
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0
            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                end
            until Time + TimeToWait < tick() or not FlingActive
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart then
            SFBasePart(TRootPart)
        elseif THead then
            SFBasePart(THead)
        elseif Handle then
            SFBasePart(Handle)
        else
            return Message("Error", TargetPlayer.Name .. " has no valid parts", 2)
        end
        
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        
        -- Reset character position
        if getgenv().OldPos then
            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        end
    else
        return Message("Error", "Your character is not ready", 2)
    end
end
-- Start flinging selected targets
local function StartFling()
    if FlingActive then return end
    
    local count = CountSelectedTargets()
    if count == 0 then
        StatusLabel.Text = "No targets selected!"
        wait(1)
        StatusLabel.Text = "Select targets to fling"
        return
    end
    
    FlingActive = true
    UpdateStatus()
    Message("Started", "Flinging " .. count .. " targets", 2)
    
    -- Start flinger in separate thread
    spawn(function()
        while FlingActive do
            local validTargets = {}
            
            -- Process all targets first to determine which are valid
            for name, player in pairs(SelectedTargets) do
                if player and player.Parent then
                    validTargets[name] = player
                else
                    -- Remove players who left
                    SelectedTargets[name] = nil
                    local checkbox = PlayerCheckboxes[name]
                    if checkbox then
                        checkbox.Checkmark.Visible = false
                    end
                end
            end
            
            -- Then attempt to fling each valid target
            for _, player in pairs(validTargets) do
                if FlingActive then
                    SkidFling(player)
                    -- Brief wait between targets to allow movement to reset
                    wait(0.1)
                else
                    break
                end
            end
            
            -- Update status periodically
            UpdateStatus()
            
            -- Wait a moment before starting next fling cycle
            wait(0.5)
        end
    end)
end
-- Stop flinging
local function StopFling()
    if not FlingActive then return end
    
    FlingActive = false
    
    UpdateStatus()
    Message("Stopped", "Fling has been stopped", 2)
end
-- Set up button connections
StartButton.MouseButton1Click:Connect(StartFling)
StopButton.MouseButton1Click:Connect(StopFling)
SelectAllButton.MouseButton1Click:Connect(function() ToggleAllPlayers(true) end)
DeselectAllButton.MouseButton1Click:Connect(function() ToggleAllPlayers(false) end)
CloseButton.MouseButton1Click:Connect(function()
    StopFling()
    ScreenGui:Destroy()
end)
-- Handle player joining/leaving
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(function(player)
    if SelectedTargets[player.Name] then
        SelectedTargets[player.Name] = nil
    end
    RefreshPlayerList()
    UpdateStatus()
end)
-- Initialize
RefreshPlayerList()
UpdateStatus()
-- Success message
Message("Loaded", "KILASIK's Multi-Target Fling GUI loaded!", 3)
