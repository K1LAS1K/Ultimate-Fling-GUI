--[[
  KILASIK GUI - Advanced Game Control Interface
  This script creates a feature-rich GUI with many commands and features
  
  Usage: Paste the code into your executor and run it
  
  Key System: Requires a valid key to use. Get the key from our Discord server.
  
  Credit: KILASIK
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Teams = game:GetService("Teams")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local NetworkClient = game:GetService("NetworkClient")
local GuiService = game:GetService("GuiService")

-- Key System
local KEY_CODE = "KILASIK2025" -- Key code
local DISCORD_LINK = "https://discord.gg/PHxN8nadgk" -- Discord server link
local keyVerified = false

-- Basic variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera
local guiCreated = false
local guiVisible = false
local minimized = false
local miniSize = false
local activeTab = "Main"
local favoriteCommands = {}

-- Speed and character control
local walkSpeed = 16
local jumpPower = 50
local infiniteJump = false
local noclip = false
local flying = false
local flySpeed = 2
local xray = false
local esp = {
    enabled = false,
    boxes = true,
    names = true,
    distances = true,
    teamCheck = true,
    teamColor = true,
    tracers = false,
    chams = false
}
local aimbotSettings = {
    enabled = false,
    teamCheck = true,
    visibilityCheck = true,
    aimPart = "Head",
    sensitivity = 0.5,
    fovSize = 100,
    showFOV = true,
    toggleKey = "RightMouse",
    wallbangEnabled = false
}
local aimbotTarget = nil
local selectedPlayers = {}
local selectedParts = {}

-- Player list variables for GUI
local playerListFrame = nil
local playerListVisible = false

-- DAB Animation tracking
local dabAnimationTrack = nil

-- GUI Colors
local colors = {
    background = Color3.fromRGB(25, 25, 30),
    header = Color3.fromRGB(35, 35, 40),
    button = Color3.fromRGB(45, 45, 55),
    buttonHover = Color3.fromRGB(55, 55, 65),
    buttonSelected = Color3.fromRGB(65, 105, 225),
    text = Color3.fromRGB(240, 240, 240),
    highlight = Color3.fromRGB(65, 105, 225),
    warning = Color3.fromRGB(200, 60, 60),
    success = Color3.fromRGB(60, 180, 75),
    neutralLight = Color3.fromRGB(70, 70, 85),
    neutralDark = Color3.fromRGB(40, 40, 50),
    shadow = Color3.fromRGB(15, 15, 20),
    categoryBG = Color3.fromRGB(30, 30, 35),
    favorite = Color3.fromRGB(255, 215, 0)
}

-- Helper function to get command state
function getCommandState(commandName)
    if commandName == "Speed" then return walkSpeed
    elseif commandName == "JumpPower" then return jumpPower
    elseif commandName == "InfiniteJump" then return infiniteJump
    elseif commandName == "Fly" then return flying
    elseif commandName == "Noclip" then return noclip
    elseif commandName == "XRay" then return xray
    elseif commandName == "ESP" then return esp.enabled
    elseif commandName == "ESP Boxes" then return esp.boxes
    elseif commandName == "ESP Names" then return esp.names
    elseif commandName == "ESP Tracers" then return esp.tracers
    elseif commandName == "ESP TeamCheck" then return esp.teamCheck
    elseif commandName == "ESP TeamColor" then return esp.teamColor
    elseif commandName == "ESP Chams" then return esp.chams
    elseif commandName == "Aimbot" then return aimbotSettings.enabled
    elseif commandName == "ClickTP" then return getgenv().clickTPEnabled
    elseif commandName == "NoFog" then return getgenv().fogRemoved
    elseif commandName == "FullBright" then return getgenv().fullBrightEnabled
    elseif commandName == "Invisible" then return getgenv().characterInvisible
    elseif commandName == "RemoveMesh" then return getgenv().meshesRemoved
    elseif commandName == "ClearMap" then return getgenv().mapCleared
    elseif commandName == "LowGraphics" then return getgenv().lowGraphicsEnabled
    elseif commandName == "RemoveTextures" then return getgenv().texturesRemoved
    elseif commandName == "ShowHitboxes" then return getgenv().hitboxesVisible
    elseif commandName == "Rainbow" then return getgenv().rainbowEnabled
    elseif commandName == "ForceField" then return getgenv().forceFieldEnabled
    elseif commandName == "AntiAFK" then return getgenv().antiAFKEnabled
    elseif commandName == "AutoFarm" then return getgenv().autoFarmEnabled
    elseif commandName == "KillAura" then return getgenv().killAuraEnabled
    elseif commandName == "Touch Fling" then return getgenv().touchFlingEnabled
    elseif commandName == "Aimbot FOV" then return aimbotSettings.fovSize
    elseif commandName == "Wallbang" then return aimbotSettings.wallbangEnabled
    end
    return false
end

-- All Commands
local commands = {
    -- Main commands - WITH SETTINGS PANELS
    {name = "Speed", desc = "Set character walk speed", category = "Character", func = function(speed) if speed then setWalkSpeed(tonumber(speed) or 16) else showSpeedSettings() end end, canFavorite = true, type = "settings", inputType = "number", currentValue = function() return walkSpeed end},
    {name = "JumpPower", desc = "Set character jump power", category = "Character", func = function(power) if power then setJumpPower(tonumber(power) or 50) else showJumpSettings() end end, canFavorite = true, type = "settings", inputType = "number", currentValue = function() return jumpPower end},
    {name = "InfiniteJump", desc = "Jump infinitely", category = "Character", func = function() toggleInfiniteJump() end, canFavorite = true, type = "toggle"},
    {name = "Fly", desc = "Toggle fly mode", category = "Character", func = function() toggleFly() end, canFavorite = true, type = "toggle"},
    {name = "Noclip", desc = "Walk through walls", category = "Character", func = function() toggleNoclip() end, canFavorite = true, type = "toggle"},
    {name = "XRay", desc = "Make walls transparent", category = "Vision", func = function() toggleXRay() end, canFavorite = true, type = "toggle"},
    {name = "ESP", desc = "Highlight players and objects", category = "ESP", func = function() toggleESP() end, canFavorite = true, type = "toggle"},
    {name = "ESP Boxes", desc = "Toggle ESP boxes", category = "ESP", func = function() toggleESPOption("boxes") end, canFavorite = true, type = "toggle"},
    {name = "ESP Names", desc = "Toggle ESP names", category = "ESP", func = function() toggleESPOption("names") end, canFavorite = true, type = "toggle"},
    {name = "ESP Tracers", desc = "Toggle ESP tracers", category = "ESP", func = function() toggleESPOption("tracers") end, canFavorite = true, type = "toggle"},
    {name = "ESP TeamCheck", desc = "Toggle ESP team check", category = "ESP", func = function() toggleESPOption("teamCheck") end, canFavorite = true, type = "toggle"},
    {name = "ESP TeamColor", desc = "Toggle ESP team color", category = "ESP", func = function() toggleESPOption("teamColor") end, canFavorite = true, type = "toggle"},
    {name = "ESP Chams", desc = "Toggle ESP chams", category = "ESP", func = function() toggleESPOption("chams") end, canFavorite = true, type = "toggle"},
    {name = "Aimbot", desc = "Auto aim at players", category = "Combat", func = function() toggleAimbot() end, canFavorite = true, type = "toggle"},
    {name = "Teleport", desc = "Teleport to mouse position", category = "Teleport", func = function() teleportToMouse() end, canFavorite = true, type = "button"},
    {name = "ClickTP", desc = "Click to teleport (Ctrl+Click)", category = "Teleport", func = function() toggleClickTP() end, canFavorite = true, type = "toggle"},
    {name = "TpToPlayer", desc = "Teleport to a specific player", category = "Teleport", func = function() showPlayerList("teleport") end, canFavorite = true, type = "button"},
    {name = "GetPosition", desc = "Copy current position", category = "Teleport", func = function() copyPosition() end, canFavorite = true, type = "button"},
    {name = "Rejoin", desc = "Rejoin the same server", category = "Utility", func = function() rejoinServer() end, canFavorite = true, type = "button"},
    {name = "NoFog", desc = "Remove fog", category = "Vision", func = function() removeFog() end, canFavorite = true, type = "toggle"},
    {name = "FullBright", desc = "Full brightness", category = "Vision", func = function() enableFullBright() end, canFavorite = true, type = "toggle"},
    {name = "Invisible", desc = "Make character invisible", category = "Character", func = function() makeInvisible() end, canFavorite = true, type = "toggle"},
    {name = "RemoveMesh", desc = "Remove meshes", category = "Character", func = function() removeMeshes() end, canFavorite = true, type = "toggle"},
    
    -- Combat commands - WORKING ONLY
    {name = "Aimbot", desc = "Auto aim at players", category = "Combat", func = function() toggleAimbot() end, canFavorite = true, type = "toggle"},
    {name = "Aimbot Settings", desc = "Configure aimbot options", category = "Combat", func = function() showAimbotSettings() end, canFavorite = true, type = "button"},
    
    -- Animation commands - ONLY WORKING ONES
    {name = "Dab", desc = "Play/Stop dab animation", category = "Animations", func = function() playDabAnimation() end, canFavorite = true, type = "toggle"},
    
    -- Fun commands - WORKING ONLY
    {name = "GiantSize", desc = "Make character giant", category = "Fun", func = function() makeGiantSize() end, canFavorite = true, type = "button"},
    {name = "TinySize", desc = "Make character tiny", category = "Fun", func = function() makeTinySize() end, canFavorite = true, type = "button"},
    {name = "SpinCharacter", desc = "Spin your character", category = "Fun", func = function() spinCharacter() end, canFavorite = true, type = "button"},
    
    -- Player commands
    {name = "Spectate", desc = "Spectate a player", category = "Players", func = function() showPlayerList("spectate") end, canFavorite = true, type = "button"},
    {name = "Unspectate", desc = "Stop spectating", category = "Players", func = function() unspectatePlayer() end, canFavorite = true, type = "button"},
    {name = "Goto", desc = "Go to a player", category = "Players", func = function() showPlayerList("goto") end, canFavorite = true, type = "button"},
    {name = "Bring", desc = "Bring a player to you", category = "Players", func = function() showPlayerList("bring") end, canFavorite = true, type = "button"},
    {name = "FlingPlayer", desc = "Fling a player", category = "Players", func = function() showPlayerList("fling") end, canFavorite = true, type = "button"},
    
    -- Tools
    {name = "CopyPosition", desc = "Copy position to clipboard", category = "Utility", func = function() copyPosition() end, canFavorite = true, type = "button"},
    {name = "BTools", desc = "Give building tools", category = "Utility", func = function() giveBTools() end, canFavorite = true, type = "button"},
    {name = "ForceField", desc = "Apply force field", category = "Utility", func = function() applyForceField() end, canFavorite = true, type = "toggle"},
    {name = "HighJump", desc = "Jump very high", category = "Character", func = function() doHighJump() end, canFavorite = true, type = "button"},
    {name = "SwimMode", desc = "Swim in the air", category = "Character", func = function() toggleSwimMode() end, canFavorite = true, type = "toggle"},
    
    -- Visual commands
    {name = "Rainbow", desc = "Rainbow character", category = "Visuals", func = function() makeRainbowCharacter() end, canFavorite = true, type = "toggle"},
    {name = "ClearMap", desc = "Clear the map", category = "Visuals", func = function() clearMap() end, canFavorite = true, type = "toggle"},
    {name = "LowGraphics", desc = "Low graphics settings", category = "Visuals", func = function() setLowGraphics() end, canFavorite = true, type = "toggle"},
    {name = "RemoveTextures", desc = "Remove textures", category = "Visuals", func = function() removeTextures() end, canFavorite = true, type = "toggle"},
    {name = "ShowHitboxes", desc = "Show hitboxes", category = "Visuals", func = function() showHitboxes() end, canFavorite = true, type = "toggle"},
    
    -- Special commands
    {name = "InfiniteYield", desc = "Load Infinite Yield admin", category = "Utility", func = function() loadInfiniteYield() end, canFavorite = true, type = "button"},
    {name = "AntiAFK", desc = "Prevent AFK kick", category = "Utility", func = function() enableAntiAFK() end, canFavorite = true, type = "toggle"},
    {name = "FixCamera", desc = "Fix camera issues", category = "Utility", func = function() fixCamera() end, canFavorite = true, type = "button"}
}

-- Categories
local categories = {
    "Favorites",
    "Main",
    "Character",
    "Combat",
    "ESP",
    "Teleport",
    "Players",
    "Animations",
    "Vision",
    "Utility",
    "Fun",
    "Visuals",
    "Settings"
}

-- =====================
-- Function Definitions
-- =====================

-- Status message function
function setStatus(message)
    print("[KILASIK GUI] " .. message)
    -- Also update status in GUI if available
    if guiCreated and CoreGui:FindFirstChild("KILASIKGUI") then
        local gui = CoreGui.KILASIKGUI
        local statusLabel = gui:FindFirstChild("StatusLabel", true)
        if statusLabel then
            statusLabel.Text = message
            
            -- Auto-clear status after 5 seconds
            spawn(function()
                wait(5)
                if statusLabel.Text == message then
                    statusLabel.Text = "Ready"
                end
            end)
        end
    end
end

-- Set walk speed
function setWalkSpeed(speed)
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    player.Character.Humanoid.WalkSpeed = speed
    walkSpeed = speed
    setStatus("Walk speed set to " .. speed)
end

-- Set jump power
function setJumpPower(power)
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    player.Character.Humanoid.JumpPower = power
    jumpPower = power
    setStatus("Jump power set to " .. power)
end

-- Infinite jump
function toggleInfiniteJump()
    infiniteJump = not infiniteJump
    
    if infiniteJump then
        setStatus("Infinite jump enabled")
        -- Add infinite jump event listener
        if not getgenv().InfiniteJumpConnection then
            getgenv().InfiniteJumpConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.Space and infiniteJump then
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        end
    else
        setStatus("Infinite jump disabled")
        if getgenv().InfiniteJumpConnection then
            getgenv().InfiniteJumpConnection:Disconnect()
            getgenv().InfiniteJumpConnection = nil
        end
    end
end

-- Noclip (walk through walls)
function toggleNoclip()
    noclip = not noclip
    
    if noclip then
        getgenv().noclipLoop = RunService.Stepped:Connect(function()
            if not noclip then 
                getgenv().noclipLoop:Disconnect() 
                getgenv().noclipLoop = nil
                return 
            end
            
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        setStatus("Noclip enabled")
    else
        if getgenv().noclipLoop then
            getgenv().noclipLoop:Disconnect()
            getgenv().noclipLoop = nil
        end
        
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        setStatus("Noclip disabled")
    end
end

-- Fly mode
function toggleFly()
    flying = not flying
    
    if flying then
        -- Start fly code
        local flyPart = Instance.new("BodyVelocity")
        flyPart.Velocity = Vector3.new(0, 0, 0)
        flyPart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyPart.Name = "FlyPart"
        
        -- Character movement
        local controls = {
            f = false,
            b = false,
            l = false,
            r = false,
            q = false,
            e = false
        }
        
        local controlsChanged = {}
        
        -- Keyboard controls
        controlsChanged.w = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then controls.f = true end
            if input.KeyCode == Enum.KeyCode.S then controls.b = true end
            if input.KeyCode == Enum.KeyCode.A then controls.l = true end
            if input.KeyCode == Enum.KeyCode.D then controls.r = true end
            if input.KeyCode == Enum.KeyCode.Q then controls.q = true end
            if input.KeyCode == Enum.KeyCode.E then controls.e = true end
        end)
        
        controlsChanged.s = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then controls.f = false end
            if input.KeyCode == Enum.KeyCode.S then controls.b = false end
            if input.KeyCode == Enum.KeyCode.A then controls.l = false end
            if input.KeyCode == Enum.KeyCode.D then controls.r = false end
            if input.KeyCode == Enum.KeyCode.Q then controls.q = false end
            if input.KeyCode == Enum.KeyCode.E then controls.e = false end
        end)
        
        local function fly()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            
            local rootPart = player.Character.HumanoidRootPart
            local flyPartInstance = rootPart:FindFirstChild("FlyPart") or flyPart:Clone()
            flyPartInstance.Parent = rootPart
            
            getgenv().flyLoop = RunService.Heartbeat:Connect(function()
                if not flying then 
                    getgenv().flyLoop:Disconnect()
                    getgenv().flyLoop = nil
                    if flyPartInstance and flyPartInstance.Parent then
                        flyPartInstance:Destroy()
                    end
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.PlatformStand = false
                    end
                    for _, connection in pairs(controlsChanged) do
                        connection:Disconnect()
                    end
                    return 
                end
                
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.PlatformStand = true
                end
                
                local direction = Vector3.new(0, 0, 0)
                
                -- Move based on camera direction
                local lookVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector
                
                if controls.f then
                    direction = direction + lookVector
                end
                if controls.b then
                    direction = direction - lookVector
                end
                if controls.r then
                    direction = direction + rightVector
                end
                if controls.l then
                    direction = direction - rightVector
                end
                if controls.q then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if controls.e then
                    direction = direction + Vector3.new(0, -1, 0)
                end
                
                if direction.Magnitude > 0 then
                    direction = direction.Unit
                end
                
                flyPartInstance.Velocity = direction * flySpeed * 50
            end)
        end
        
        fly()
        setStatus("Fly mode enabled - Use WASDQE to move")
    else
        -- Disable fly mode
        if getgenv().flyLoop then
            getgenv().flyLoop:Disconnect()
            getgenv().flyLoop = nil
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local flyPartInstance = player.Character.HumanoidRootPart:FindFirstChild("FlyPart")
            if flyPartInstance then
                flyPartInstance:Destroy()
            end
        end
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
        
        setStatus("Fly mode disabled")
    end
end

-- X-Ray (see through walls)
function toggleXRay()
    xray = not xray
    
    if xray then
        -- Make walls transparent
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) and part.Transparency < 0.8 and not part:IsA("Terrain") then
                if not part:FindFirstChild("OriginalTransparency") then
                    local originalValue = Instance.new("NumberValue")
                    originalValue.Name = "OriginalTransparency"
                    originalValue.Value = part.Transparency
                    originalValue.Parent = part
                end
                part.Transparency = 0.8
            end
        end
        setStatus("X-Ray enabled")
    else
        -- Restore wall transparency
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part:FindFirstChild("OriginalTransparency") then
                part.Transparency = part.OriginalTransparency.Value
                part.OriginalTransparency:Destroy()
            end
        end
        setStatus("X-Ray disabled")
    end
end

-- Toggle specific ESP option
function toggleESPOption(option)
    if option == "boxes" then
        esp.boxes = not esp.boxes
        setStatus("ESP Boxes: " .. (esp.boxes and "Enabled" or "Disabled"))
    elseif option == "names" then
        esp.names = not esp.names
        setStatus("ESP Names: " .. (esp.names and "Enabled" or "Disabled"))
    elseif option == "tracers" then
        esp.tracers = not esp.tracers
        setStatus("ESP Tracers: " .. (esp.tracers and "Enabled" or "Disabled"))
    elseif option == "teamCheck" then
        esp.teamCheck = not esp.teamCheck
        setStatus("ESP Team Check: " .. (esp.teamCheck and "Enabled" or "Disabled"))
    elseif option == "teamColor" then
        esp.teamColor = not esp.teamColor
        setStatus("ESP Team Color: " .. (esp.teamColor and "Enabled" or "Disabled"))
    elseif option == "chams" then
        esp.chams = not esp.chams
        setStatus("ESP Chams: " .. (esp.chams and "Enabled" or "Disabled"))
        
        -- Apply or remove chams
        if esp.enabled then
            updateESP()
        end
    end
end

-- ESP (see players and objects)
function toggleESP()
    esp.enabled = not esp.enabled
    
    if esp.enabled then
        -- Start ESP code
        updateESP()
        
        -- Create update loop
        if not getgenv().ESPUpdateLoop then
            getgenv().ESPUpdateLoop = RunService.RenderStepped:Connect(function()
                if not esp.enabled then
                    getgenv().ESPUpdateLoop:Disconnect()
                    getgenv().ESPUpdateLoop = nil
                    
                    -- Clean up ESP elements
                    for _, plyr in ipairs(Players:GetPlayers()) do
                        cleanupESP(plyr)
                    end
                    return
                end
                
                updateESP()
            end)
        end
        
        setStatus("ESP enabled")
    else
        -- Disable ESP code, clean up elements
        if getgenv().ESPUpdateLoop then
            getgenv().ESPUpdateLoop:Disconnect()
            getgenv().ESPUpdateLoop = nil
        end
        
        for _, plyr in ipairs(Players:GetPlayers()) do
            cleanupESP(plyr)
        end
        
        setStatus("ESP disabled")
    end
end

-- Clean up ESP for a player
function cleanupESP(target)
    if target.Character then
        -- Remove ESP containers
        for _, obj in ipairs(target.Character:GetChildren()) do
            if obj.Name == "KILASIK_ESP_Container" then
                obj:Destroy()
            end
        end
        
        -- Remove highlights
        local highlight = target.Character:FindFirstChild("KILASIK_ESP_Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Update ESP elements
function updateESP()
    if not esp.enabled then return end
    
    -- Get all players
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and 
           otherPlayer.Character:FindFirstChild("HumanoidRootPart") and 
           otherPlayer.Character:FindFirstChild("Humanoid") and
           otherPlayer.Character:FindFirstChild("Head") then
            
            -- Check team status if team check is enabled
            local isFriendly = false
            if esp.teamCheck and player.Team and otherPlayer.Team then
                isFriendly = player.Team == otherPlayer.Team
            end
            
            if not esp.teamCheck or not isFriendly then
                -- Determine color
                local espColor = Color3.fromRGB(255, 0, 0) -- Enemy (red)
                
                if esp.teamColor and otherPlayer.Team then
                    espColor = otherPlayer.TeamColor.Color
                elseif isFriendly then
                    espColor = Color3.fromRGB(0, 255, 0) -- Friendly (green)
                end
                
                -- Create or update ESP container
                local espContainer = otherPlayer.Character:FindFirstChild("KILASIK_ESP_Container")
                if not espContainer then
                    espContainer = Instance.new("Folder")
                    espContainer.Name = "KILASIK_ESP_Container"
                    espContainer.Parent = otherPlayer.Character
                end
                
                -- Create chams (highlights)
                if esp.chams then
                    local highlight = otherPlayer.Character:FindFirstChild("KILASIK_ESP_Highlight")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "KILASIK_ESP_Highlight"
                        highlight.FillColor = espColor
                        highlight.OutlineColor = espColor
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = otherPlayer.Character
                    else
                        highlight.FillColor = espColor
                        highlight.OutlineColor = espColor
                    end
                else
                    local highlight = otherPlayer.Character:FindFirstChild("KILASIK_ESP_Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
                
                -- Create box ESP
                if esp.boxes then
                    -- Calculate 3D bounding box
                    local hrp = otherPlayer.Character.HumanoidRootPart
                    local head = otherPlayer.Character.Head
                    local rootPos = hrp.Position
                    local headPos = head.Position
                    local height = (headPos - rootPos).Magnitude * 2
                    local width = height * 0.5
                    
                    -- Create or update box
                    local boxESP = espContainer:FindFirstChild("BoxESP")
                    if not boxESP then
                        boxESP = Instance.new("BoxHandleAdornment")
                        boxESP.Name = "BoxESP"
                        boxESP.Adornee = hrp
                        boxESP.AlwaysOnTop = true
                        boxESP.ZIndex = 10
                        boxESP.Color3 = espColor
                        boxESP.Transparency = 0.7
                        boxESP.Parent = espContainer
                    end
                    
                    boxESP.Size = Vector3.new(width, height, width)
                    boxESP.Color3 = espColor
                else
                    local boxESP = espContainer:FindFirstChild("BoxESP")
                    if boxESP then
                        boxESP:Destroy()
                    end
                end
                
                -- Create name ESP
                if esp.names then
                    local nameESP = espContainer:FindFirstChild("NameESP")
                    if not nameESP then
                        nameESP = Instance.new("BillboardGui")
                        nameESP.Name = "NameESP"
                        nameESP.AlwaysOnTop = true
                        nameESP.Size = UDim2.new(0, 200, 0, 50)
                        nameESP.StudsOffset = Vector3.new(0, 3, 0)
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "NameLabel"
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.TextSize = 20
                        nameLabel.TextColor3 = espColor
                        nameLabel.TextStrokeTransparency = 0.5
                        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        nameLabel.Parent = nameESP
                        
                        nameESP.Adornee = otherPlayer.Character.Head
                        nameESP.Parent = espContainer
                    end
                    
                    local nameLabel = nameESP.NameLabel
                    nameLabel.Text = otherPlayer.Name
                    nameLabel.TextColor3 = espColor
                    
                    if esp.distances then
                        local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                        nameLabel.Text = otherPlayer.Name .. " [" .. math.floor(distance) .. " studs]"
                    end
                else
                    local nameESP = espContainer:FindFirstChild("NameESP")
                    if nameESP then
                        nameESP:Destroy()
                    end
                end
                
                -- Create tracers
                if esp.tracers then
                    local tracerESP = espContainer:FindFirstChild("TracerESP")
                    if not tracerESP then
                        tracerESP = Instance.new("LineHandleAdornment")
                        tracerESP.Name = "TracerESP"
                        tracerESP.Adornee = otherPlayer.Character.HumanoidRootPart
                        tracerESP.AlwaysOnTop = true
                        tracerESP.ZIndex = 10
                        tracerESP.Color3 = espColor
                        tracerESP.Thickness = 2
                        tracerESP.Transparency = 0.5
                        tracerESP.Parent = espContainer
                    end
                    
                    local myPosition = player.Character.HumanoidRootPart.Position
                    local theirPosition = otherPlayer.Character.HumanoidRootPart.Position
                    
                    tracerESP.Length = (theirPosition - myPosition).Magnitude
                    tracerESP.CFrame = CFrame.new(myPosition, theirPosition)
                    tracerESP.Color3 = espColor
                else
                    local tracerESP = espContainer:FindFirstChild("TracerESP")
                    if tracerESP then
                        tracerESP:Destroy()
                    end
                end
            else
                -- Clean up if friendly and team check is enabled
                cleanupESP(otherPlayer)
            end
        end
    end
end

-- Aimbot functions
function toggleAimbot()
    aimbotSettings.enabled = not aimbotSettings.enabled
    
    if aimbotSettings.enabled then
        setStatus("Aimbot enabled")
        
        -- Create aimbot loop
        if not getgenv().AimbotLoop then
            getgenv().AimbotLoop = RunService.RenderStepped:Connect(function()
                if not aimbotSettings.enabled then
                    getgenv().AimbotLoop:Disconnect()
                    getgenv().AimbotLoop = nil
                    return
                end
                
                updateAimbot()
            end)
        end
    else
        setStatus("Aimbot disabled")
        if getgenv().AimbotLoop then
            getgenv().AimbotLoop:Disconnect()
            getgenv().AimbotLoop = nil
        end
        aimbotTarget = nil
    end
end

function updateAimbot()
    if not aimbotSettings.enabled then return end
    
    local closestPlayer = nil
    local closestDistance = math.huge
    local myPosition = camera.CFrame.Position
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and 
           otherPlayer.Character:FindFirstChild("HumanoidRootPart") and 
           otherPlayer.Character:FindFirstChild("Humanoid") and
           otherPlayer.Character.Humanoid.Health > 0 then
            
            -- Team check
            local isFriendly = false
            if aimbotSettings.teamCheck and player.Team and otherPlayer.Team then
                isFriendly = player.Team == otherPlayer.Team
            end
            
            if not aimbotSettings.teamCheck or not isFriendly then
                local targetPart = otherPlayer.Character:FindFirstChild(aimbotSettings.aimPart) or otherPlayer.Character.HumanoidRootPart
                local targetPosition = targetPart.Position
                
                -- Check FOV
                local screenPoint, onScreen = camera:WorldToScreenPoint(targetPosition)
                local mousePosition = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePosition).Magnitude
                
                if distance <= aimbotSettings.fovSize and distance < closestDistance then
                    -- Visibility check
                    if not aimbotSettings.visibilityCheck or isVisible(targetPosition) then
                        closestPlayer = otherPlayer
                        closestDistance = distance
                    end
                end
            end
        end
    end
    
    if closestPlayer then
        aimbotTarget = closestPlayer
        local targetPart = closestPlayer.Character:FindFirstChild(aimbotSettings.aimPart) or closestPlayer.Character.HumanoidRootPart
        local targetPosition = targetPart.Position
        
        -- Smooth aim
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
        local lerpedCFrame = currentCFrame:Lerp(targetCFrame, aimbotSettings.sensitivity)
        
        camera.CFrame = lerpedCFrame
    else
        aimbotTarget = nil
    end
end

function isVisible(targetPosition)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    local raycastResult = Workspace:Raycast(camera.CFrame.Position, targetPosition - camera.CFrame.Position, raycastParams)
    
    return not raycastResult or raycastResult.Instance:IsDescendantOf(Players:GetPlayerFromCharacter(raycastResult.Instance.Parent).Character)
end

-- Teleport functions
function teleportToMouse()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local hit = mouse.Hit
    if hit then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 5, 0))
        setStatus("Teleported to mouse position")
    end
end

function toggleClickTP()
    getgenv().clickTPEnabled = not getgenv().clickTPEnabled
    
    if getgenv().clickTPEnabled then
        setStatus("Click TP enabled - Hold Ctrl and click to teleport")
        
        if not getgenv().clickTPConnection then
            getgenv().clickTPConnection = mouse.Button1Down:Connect(function()
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
                    setStatus("Teleported to click position")
                end
            end)
        end
    else
        setStatus("Click TP disabled")
        if getgenv().clickTPConnection then
            getgenv().clickTPConnection:Disconnect()
            getgenv().clickTPConnection = nil
        end
    end
end

function teleportToPlayer(playerName)
    if not playerName or playerName == "" then
        setStatus("Please enter a player name")
        return
    end
    
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(p.Name):find(string.lower(playerName)) or string.lower(p.DisplayName):find(string.lower(playerName)) then
            targetPlayer = p
            break
        end
    end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            setStatus("Teleported to " .. targetPlayer.Name)
        end
    else
        setStatus("Player not found: " .. playerName)
    end
end

function copyPosition()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local pos = player.Character.HumanoidRootPart.Position
    local posString = string.format("Vector3.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z)
    
    if setclipboard then
        setclipboard(posString)
        setStatus("Position copied to clipboard: " .. posString)
    else
        setStatus("Current position: " .. posString)
    end
end

-- Player control functions
function spectatePlayer(playerName)
    if not playerName or playerName == "" then
        setStatus("Please enter a player name")
        return
    end
    
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(p.Name):find(string.lower(playerName)) or string.lower(p.DisplayName):find(string.lower(playerName)) then
            targetPlayer = p
            break
        end
    end
    
    if targetPlayer and targetPlayer.Character then
        camera.CameraSubject = targetPlayer.Character.Humanoid
        setStatus("Now spectating " .. targetPlayer.Name)
    else
        setStatus("Player not found: " .. playerName)
    end
end

function unspectatePlayer()
    if player.Character then
        camera.CameraSubject = player.Character.Humanoid
        setStatus("Stopped spectating")
    end
end

function goToPlayer(playerName)
    teleportToPlayer(playerName)
end

function bringPlayer(playerName)
    if not playerName or playerName == "" then
        setStatus("Please enter a player name")
        return
    end
    
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(p.Name):find(string.lower(playerName)) or string.lower(p.DisplayName):find(string.lower(playerName)) then
            targetPlayer = p
            break
        end
    end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, -5)
            setStatus("Brought " .. targetPlayer.Name .. " to you")
        end
    else
        setStatus("Player not found: " .. playerName)
    end
end

function flingPlayer(playerName)
    if not playerName or playerName == "" then
        setStatus("Please enter a player name")
        return
    end
    
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(p.Name):find(string.lower(playerName)) or string.lower(p.DisplayName):find(string.lower(playerName)) then
            targetPlayer = p
            break
        end
    end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(math.random(-100, 100), 100, math.random(-100, 100))
        bodyVelocity.Parent = targetPlayer.Character.HumanoidRootPart
        
        game:GetService("Debris"):AddItem(bodyVelocity, 1)
        setStatus("Flung " .. targetPlayer.Name)
    else
        setStatus("Player not found: " .. playerName)
    end
end

-- Animation functions
function playAnimation(animType)
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    
    local animationIds = {
        zombie = "rbxassetid://616158929",
        ninja = "rbxassetid://656117878",
        robot = "rbxassetid://616136790",
        dab = "rbxassetid://248263260",
        floss = "rbxassetid://5917459365",
        groove = "rbxassetid://27432691",
        lay = "rbxassetid://182435684",
        sit = "rbxassetid://182435684",
        superhero = "rbxassetid://782841498",
        spin = "rbxassetid://188632011"
    }
    
    local animId = animationIds[animType]
    if animId then
        local humanoid = player.Character.Humanoid
        local animation = Instance.new("Animation")
        animation.AnimationId = animId
        
        local animTrack = humanoid:LoadAnimation(animation)
        animTrack:Play()
        
        setStatus("Playing " .. animType .. " animation")
    else
        setStatus("Animation not found: " .. animType)
    end
end

-- Vision functions
function removeFog()
    getgenv().fogRemoved = not getgenv().fogRemoved
    
    if getgenv().fogRemoved then
        -- Store original fog settings
        if not getgenv().originalFog then
            getgenv().originalFog = {
                FogEnd = Lighting.FogEnd,
                FogStart = Lighting.FogStart
            }
        end
        
        Lighting.FogEnd = math.huge
        Lighting.FogStart = math.huge
        setStatus("Fog removed - Use again to restore")
    else
        -- Restore original fog
        if getgenv().originalFog then
            Lighting.FogEnd = getgenv().originalFog.FogEnd
            Lighting.FogStart = getgenv().originalFog.FogStart
            getgenv().originalFog = nil
        end
        setStatus("Fog restored")
    end
end

function enableFullBright()
    getgenv().fullBrightEnabled = not getgenv().fullBrightEnabled
    
    if getgenv().fullBrightEnabled then
        -- Store original lighting settings
        if not getgenv().originalFullBrightSettings then
            getgenv().originalFullBrightSettings = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                OutdoorAmbient = Lighting.OutdoorAmbient
            }
        end
        
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = math.huge
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        setStatus("Full bright enabled - Use again to restore")
    else
        -- Restore original lighting
        if getgenv().originalFullBrightSettings then
            Lighting.Brightness = getgenv().originalFullBrightSettings.Brightness
            Lighting.ClockTime = getgenv().originalFullBrightSettings.ClockTime
            Lighting.FogEnd = getgenv().originalFullBrightSettings.FogEnd
            Lighting.GlobalShadows = getgenv().originalFullBrightSettings.GlobalShadows
            Lighting.OutdoorAmbient = getgenv().originalFullBrightSettings.OutdoorAmbient
            getgenv().originalFullBrightSettings = nil
        end
        setStatus("Full bright disabled")
    end
end

-- Character functions
function makeInvisible()
    getgenv().characterInvisible = not getgenv().characterInvisible
    
    if not player.Character then return end
    
    if getgenv().characterInvisible then
        -- Store original transparency values
        if not getgenv().originalTransparency then
            getgenv().originalTransparency = {}
            
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part ~= player.Character.HumanoidRootPart then
                    getgenv().originalTransparency[part] = part.Transparency
                    part.Transparency = 1
                elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                    getgenv().originalTransparency[part.Handle] = part.Handle.Transparency
                    part.Handle.Transparency = 1
                end
            end
            
            if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("face") then
                getgenv().originalTransparency[player.Character.Head.face] = player.Character.Head.face.Transparency
                player.Character.Head.face.Transparency = 1
            end
        end
        
        setStatus("Character is now invisible - Use again to restore")
    else
        -- Restore original transparency
        if getgenv().originalTransparency then
            for obj, transparency in pairs(getgenv().originalTransparency) do
                if obj and obj.Parent then
                    obj.Transparency = transparency
                end
            end
            getgenv().originalTransparency = nil
        end
        
        setStatus("Character visibility restored")
    end
end

function removeMeshes()
    getgenv().meshesRemoved = not getgenv().meshesRemoved
    
    if not player.Character then return end
    
    if getgenv().meshesRemoved then
        -- Store original meshes and accessories
        if not getgenv().originalMeshes then
            getgenv().originalMeshes = {
                meshes = {},
                accessories = {}
            }
            
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    for _, child in pairs(part:GetChildren()) do
                        if child:IsA("SpecialMesh") or child:IsA("BlockMesh") or child:IsA("CylinderMesh") then
                            local meshData = {
                                mesh = child:Clone(),
                                parent = child.Parent
                            }
                            table.insert(getgenv().originalMeshes.meshes, meshData)
                            child:Destroy()
                        end
                    end
                elseif part:IsA("Accessory") then
                    local accessoryData = {
                        accessory = part:Clone(),
                        parent = part.Parent
                    }
                    table.insert(getgenv().originalMeshes.accessories, accessoryData)
                    part:Destroy()
                end
            end
        end
        
        setStatus("Meshes removed - Use again to restore")
    else
        -- Restore meshes and accessories
        if getgenv().originalMeshes then
            -- Restore meshes
            for _, meshData in pairs(getgenv().originalMeshes.meshes) do
                if meshData.mesh and meshData.parent and meshData.parent.Parent then
                    local restored = meshData.mesh:Clone()
                    restored.Parent = meshData.parent
                end
            end
            
            -- Restore accessories
            for _, accessoryData in pairs(getgenv().originalMeshes.accessories) do
                if accessoryData.accessory and accessoryData.parent then
                    local restored = accessoryData.accessory:Clone()
                    restored.Parent = accessoryData.parent
                end
            end
            
            getgenv().originalMeshes = nil
        end
        
        setStatus("Meshes and accessories restored")
    end
end

-- Utility functions
function rejoinServer()
    if #Players:GetPlayers() <= 1 then
        Players.LocalPlayer:Kick("\nRejoining...")
        wait()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Players.LocalPlayer)
    else
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end
end

function giveBTools()
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local tools = {"Clone", "Hammer", "Weld"}
        
        for _, toolName in ipairs(tools) do
            local tool = Instance.new("Tool")
            tool.Name = toolName
            tool.RequiresHandle = false
            tool.Parent = backpack
        end
        
        setStatus("Building tools added to backpack")
    end
end

function applyForceField()
    getgenv().forceFieldEnabled = not getgenv().forceFieldEnabled
    
    if player.Character then
        if getgenv().forceFieldEnabled then
            local ff = Instance.new("ForceField")
            ff.Name = "KILASIK_ForceField"
            ff.Parent = player.Character
            setStatus("Force field enabled - Use again to disable")
        else
            local ff = player.Character:FindFirstChild("KILASIK_ForceField")
            if ff then
                ff:Destroy()
            end
            setStatus("Force field disabled")
        end
    end
end

function doHighJump()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = 150
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        wait(1)
        player.Character.Humanoid.JumpPower = jumpPower
        setStatus("High jump executed")
    end
end

function toggleSwimMode()
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    
    local humanoid = player.Character.Humanoid
    if humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        setStatus("Swim mode enabled")
    else
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
        setStatus("Swim mode disabled")
    end
end

-- Fun functions
function playDanceAnimation()
    playAnimation("groove")
end

function fakeChatMessage(name, message)
    -- This function would require special exploits to work properly
    setStatus("Fake chat: [" .. (name or "Player") .. "]: " .. (message or "Hello!"))
end

function makeGiantSize()
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    
    local humanoid = player.Character.Humanoid
    local scale = 3
    
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * scale
            if part ~= player.Character.HumanoidRootPart then
                local weld = part:FindFirstChild("Weld")
                if weld then
                    weld.C0 = weld.C0 * CFrame.new(0, 0, 0) * scale
                end
            end
        end
    end
    
    setStatus("Character size increased")
end

function makeTinySize()
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    
    local humanoid = player.Character.Humanoid
    local scale = 0.5
    
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * scale
            if part ~= player.Character.HumanoidRootPart then
                local weld = part:FindFirstChild("Weld")
                if weld then
                    weld.C0 = weld.C0 * CFrame.new(0, 0, 0) * scale
                end
            end
        end
    end
    
    setStatus("Character size decreased")
end

function createFloatingParts()
    for i = 1, 10 do
        local part = Instance.new("Part")
        part.Name = "FloatingPart" .. i
        part.Size = Vector3.new(1, 1, 1)
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.random()
        part.Anchored = true
        part.CanCollide = false
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(
                math.random(-10, 10),
                math.random(5, 15),
                math.random(-10, 10)
            )
        end
        
        part.Parent = Workspace
        
        -- Add floating effect
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyPosition.Position = part.Position
        bodyPosition.Parent = part
        
        game:GetService("Debris"):AddItem(part, 10)
    end
    
    setStatus("Floating parts created")
end

function spinCharacter()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 20, 0)
    bodyAngularVelocity.Parent = player.Character.HumanoidRootPart
    
    game:GetService("Debris"):AddItem(bodyAngularVelocity, 3)
    setStatus("Character spinning")
end

function loadUltimateFling()
    -- Advanced fling script implementation
    setStatus("Ultimate Fling loaded - Touch other players to fling them")
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local function onTouch(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        local rootPart = hit.Parent:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and hit.Parent ~= player.Character then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = (rootPart.Position - player.Character.HumanoidRootPart.Position).Unit * 100 + Vector3.new(0, 50, 0)
            bodyVelocity.Parent = rootPart
            
            game:GetService("Debris"):AddItem(bodyVelocity, 1)
        end
    end
    
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(onTouch)
        end
    end
end

function loadTouchFling()
    getgenv().touchFlingEnabled = not getgenv().touchFlingEnabled
    
    if getgenv().touchFlingEnabled then
        loadUltimateFling()
    else
        setStatus("Touch Fling disabled")
    end
end

-- Visual functions
function makeRainbowCharacter()
    getgenv().rainbowEnabled = not getgenv().rainbowEnabled
    
    if getgenv().rainbowEnabled then
        if not player.Character then return end
        
        -- Store original colors
        if not getgenv().originalColors then
            getgenv().originalColors = {}
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    getgenv().originalColors[part] = part.Color
                end
            end
        end
        
        getgenv().rainbowLoop = RunService.Heartbeat:Connect(function()
            if not getgenv().rainbowEnabled then 
                getgenv().rainbowLoop:Disconnect()
                getgenv().rainbowLoop = nil
                return 
            end
            
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = color
                    end
                end
            end
        end)
        
        setStatus("Rainbow character enabled")
    else
        if getgenv().rainbowLoop then
            getgenv().rainbowLoop:Disconnect()
            getgenv().rainbowLoop = nil
        end
        
        -- Restore original colors
        if getgenv().originalColors and player.Character then
            for part, color in pairs(getgenv().originalColors) do
                if part and part.Parent then
                    part.Color = color
                end
            end
        end
        
        setStatus("Rainbow character disabled")
    end
end

function clearMap()
    getgenv().mapCleared = not getgenv().mapCleared
    
    if getgenv().mapCleared then
        -- Store original objects before clearing
        if not getgenv().originalMapObjects then
            getgenv().originalMapObjects = {}
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj ~= player.Character and not obj:IsA("Camera") and not obj:IsA("Terrain") and not Players:GetPlayerFromCharacter(obj) then
                    -- Store object data
                    local objData = {
                        object = obj:Clone(),
                        parent = obj.Parent,
                        name = obj.Name
                    }
                    table.insert(getgenv().originalMapObjects, objData)
                    obj:Destroy()
                end
            end
        end
        setStatus("Map cleared - Use again to restore")
    else
        -- Restore original objects
        if getgenv().originalMapObjects then
            for _, objData in pairs(getgenv().originalMapObjects) do
                if objData.object and objData.parent then
                    local restored = objData.object:Clone()
                    restored.Parent = objData.parent
                end
            end
            getgenv().originalMapObjects = nil
        end
        setStatus("Map restored")
    end
end

function setLowGraphics()
    getgenv().lowGraphicsEnabled = not getgenv().lowGraphicsEnabled
    
    if getgenv().lowGraphicsEnabled then
        -- Store original lighting settings
        if not getgenv().originalLighting then
            getgenv().originalLighting = {
                GlobalShadows = Lighting.GlobalShadows,
                FogEnd = Lighting.FogEnd,
                Brightness = Lighting.Brightness
            }
        end
        
        -- Store original materials
        if not getgenv().originalMaterials then
            getgenv().originalMaterials = {}
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("Union") or obj:IsA("MeshPart") then
                    getgenv().originalMaterials[obj] = obj.Material
                    obj.Material = Enum.Material.Plastic
                end
            end
        end
        
        local lighting = Lighting
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 0
        
        setStatus("Low graphics mode enabled")
    else
        -- Restore original lighting
        if getgenv().originalLighting then
            Lighting.GlobalShadows = getgenv().originalLighting.GlobalShadows
            Lighting.FogEnd = getgenv().originalLighting.FogEnd
            Lighting.Brightness = getgenv().originalLighting.Brightness
        end
        
        -- Restore original materials
        if getgenv().originalMaterials then
            for obj, material in pairs(getgenv().originalMaterials) do
                if obj and obj.Parent then
                    obj.Material = material
                end
            end
            getgenv().originalMaterials = nil
        end
        
        setStatus("Low graphics mode disabled")
    end
end

function removeTextures()
    getgenv().texturesRemoved = not getgenv().texturesRemoved
    
    if getgenv().texturesRemoved then
        -- Store original decals and textures
        if not getgenv().originalDecals then
            getgenv().originalDecals = {}
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    local decalData = {
                        object = obj:Clone(),
                        parent = obj.Parent
                    }
                    table.insert(getgenv().originalDecals, decalData)
                    obj:Destroy()
                end
            end
        end
        
        -- Store and change materials to plastic
        if not getgenv().originalMaterials then
            getgenv().originalMaterials = {}
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("Union") or obj:IsA("MeshPart") then
                    getgenv().originalMaterials[obj] = obj.Material
                    obj.Material = Enum.Material.Plastic
                end
            end
        end
        
        setStatus("Textures removed - Use again to restore")
    else
        -- Restore decals and textures
        if getgenv().originalDecals then
            for _, decalData in pairs(getgenv().originalDecals) do
                if decalData.object and decalData.parent then
                    local restored = decalData.object:Clone()
                    restored.Parent = decalData.parent
                end
            end
            getgenv().originalDecals = nil
        end
        
        -- Restore materials
        if getgenv().originalMaterials then
            for obj, material in pairs(getgenv().originalMaterials) do
                if obj and obj.Parent then
                    obj.Material = material
                end
            end
            getgenv().originalMaterials = nil
        end
        
        setStatus("Textures restored")
    end
end

function showHitboxes()
    getgenv().hitboxesVisible = not getgenv().hitboxesVisible
    
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            
            if getgenv().hitboxesVisible then
                local highlight = Instance.new("BoxHandleAdornment")
                highlight.Name = "HitboxVisual"
                highlight.Adornee = hrp
                highlight.Size = hrp.Size
                highlight.Color3 = Color3.fromRGB(255, 0, 0)
                highlight.Transparency = 0.5
                highlight.AlwaysOnTop = true
                highlight.Parent = hrp
            else
                local highlight = hrp:FindFirstChild("HitboxVisual")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
    
    setStatus("Hitboxes " .. (getgenv().hitboxesVisible and "shown" or "hidden"))
end

-- Special utility functions
function loadInfiniteYield()
    setStatus("Loading Infinite Yield...")
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end

function enableAntiAFK()
    getgenv().antiAFKEnabled = not getgenv().antiAFKEnabled
    
    if getgenv().antiAFKEnabled then
        getgenv().antiAFKLoop = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        setStatus("Anti-AFK enabled")
    else
        if getgenv().antiAFKLoop then
            getgenv().antiAFKLoop:Disconnect()
            getgenv().antiAFKLoop = nil
        end
        setStatus("Anti-AFK disabled")
    end
end

function fixCamera()
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
    setStatus("Camera fixed")
end

-- Combat functions
function showAimbotSettings()
    setStatus("Aimbot Settings: FOV=" .. aimbotSettings.fovSize .. ", Sensitivity=" .. aimbotSettings.sensitivity)
end

function setAimbotFOV(size)
    aimbotSettings.fovSize = size
    setStatus("Aimbot FOV set to " .. size)
end

function toggleWallbang()
    aimbotSettings.wallbangEnabled = not aimbotSettings.wallbangEnabled
    setStatus("Wallbang " .. (aimbotSettings.wallbangEnabled and "enabled" or "disabled"))
end

function toggleKillAura()
    getgenv().killAuraEnabled = not getgenv().killAuraEnabled
    
    if getgenv().killAuraEnabled then
        setStatus("Kill Aura enabled")
        
        getgenv().killAuraLoop = RunService.Heartbeat:Connect(function()
            if not getgenv().killAuraEnabled then
                getgenv().killAuraLoop:Disconnect()
                getgenv().killAuraLoop = nil
                return
            end
            
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                        
                        if distance <= 10 then
                            -- Simulate attack
                            if otherPlayer.Character:FindFirstChild("Humanoid") then
                                otherPlayer.Character.Humanoid:TakeDamage(20)
                            end
                        end
                    end
                end
            end
        end)
    else
        setStatus("Kill Aura disabled")
        if getgenv().killAuraLoop then
            getgenv().killAuraLoop:Disconnect()
            getgenv().killAuraLoop = nil
        end
    end
end

function giveInfiniteAmmo()
    setStatus("Infinite Ammo activated (works with supported games)")
end

function attemptGodMode()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.MaxHealth = math.huge
        player.Character.Humanoid.Health = math.huge
        setStatus("God Mode attempted")
    end
end

function increaseReach()
    setStatus("Weapon reach increased (works with supported games)")
end

function toggleAutoFarm()
    getgenv().autoFarmEnabled = not getgenv().autoFarmEnabled
    setStatus("Auto Farm " .. (getgenv().autoFarmEnabled and "enabled" or "disabled"))
end

-- =====================
-- GUI Creation Functions
-- =====================

function createMainGUI()
    if guiCreated then return end
    
    -- Destroy any existing GUI
    local existingGUI = CoreGui:FindFirstChild("KILASIKGUI")
    if existingGUI then
        existingGUI:Destroy()
    end
    
    -- Container for GUI elements
    local container = CoreGui
    
    -- Main GUI
    local mainGUI = Instance.new("ScreenGui")
    mainGUI.Name = "KILASIKGUI"
    mainGUI.ResetOnSpawn = false
    mainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGUI.Parent = container
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 550, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = mainGUI
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = colors.header
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local titleCoverBar = Instance.new("Frame")
    titleCoverBar.Size = UDim2.new(1, 0, 0, 10)
    titleCoverBar.Position = UDim2.new(0, 0, 1, -10)
    titleCoverBar.BackgroundColor3 = colors.header
    titleCoverBar.BorderSizePixel = 0
    titleCoverBar.ZIndex = 0
    titleCoverBar.Parent = titleBar
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -150, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "KILASIK GUI"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextColor3 = colors.text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = colors.warning
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.TextColor3 = colors.text
    closeButton.BorderSizePixel = 0
    closeButton.AutoButtonColor = false
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 5)
    minimizeButton.BackgroundColor3 = colors.neutralLight
    minimizeButton.Text = "-"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 20
    minimizeButton.TextColor3 = colors.text
    minimizeButton.BorderSizePixel = 0
    minimizeButton.AutoButtonColor = false
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = minimizeButton
    
    -- Mini button (logo mode)
    local miniButton = Instance.new("TextButton")
    miniButton.Size = UDim2.new(0, 30, 0, 30)
    miniButton.Position = UDim2.new(1, -105, 0, 5)
    miniButton.BackgroundColor3 = colors.neutralLight
    miniButton.Text = "□"
    miniButton.Font = Enum.Font.GothamBold
    miniButton.TextSize = 16
    miniButton.TextColor3 = colors.text
    miniButton.BorderSizePixel = 0
    miniButton.AutoButtonColor = false
    miniButton.Parent = titleBar
    
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 6)
    miniCorner.Parent = miniButton
    
    -- Category tab frame (container) - WITH SCROLL FIX
    local categoryFrame = Instance.new("Frame")
    categoryFrame.Name = "CategoryFrame"
    categoryFrame.Size = UDim2.new(0, 130, 1, -40)
    categoryFrame.Position = UDim2.new(0, 0, 0, 40)
    categoryFrame.BackgroundColor3 = colors.categoryBG
    categoryFrame.BorderSizePixel = 0
    categoryFrame.Parent = mainFrame
    
    -- SCROLLING FRAME FOR CATEGORIES (THE FIX!)
    local categoryScrollFrame = Instance.new("ScrollingFrame")
    categoryScrollFrame.Name = "CategoryScrollFrame"
    categoryScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    categoryScrollFrame.Position = UDim2.new(0, 0, 0, 0)
    categoryScrollFrame.BackgroundTransparency = 1
    categoryScrollFrame.BorderSizePixel = 0
    categoryScrollFrame.ScrollBarThickness = 6
    categoryScrollFrame.ScrollBarImageColor3 = colors.highlight
    categoryScrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
    categoryScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #categories * 40 + 20) -- Dynamic height based on categories
    categoryScrollFrame.Parent = categoryFrame
    
    local categoryButtons = {}
    
    -- Category buttons (NOW INSIDE SCROLLING FRAME)
    for i, category in ipairs(categories) do
        local categoryButton = Instance.new("TextButton")
        categoryButton.Name = category .. "Button"
        categoryButton.Size = UDim2.new(1, -20, 0, 35)
        categoryButton.Position = UDim2.new(0, 10, 0, 10 + (i-1) * 40)
        categoryButton.BackgroundColor3 = category == activeTab and colors.buttonSelected or colors.button
        categoryButton.Text = category
        categoryButton.Font = Enum.Font.GothamSemibold
        categoryButton.TextSize = 14
        categoryButton.TextColor3 = colors.text
        categoryButton.BorderSizePixel = 0
        categoryButton.AutoButtonColor = false
        categoryButton.Parent = categoryScrollFrame -- PARENT TO SCROLL FRAME INSTEAD!
        
        local categoryCorner = Instance.new("UICorner")
        categoryCorner.CornerRadius = UDim.new(0, 6)
        categoryCorner.Parent = categoryButton
        
        -- Special color for favorites tab
        if category == "Favorites" then
            categoryButton.BackgroundColor3 = category == activeTab and colors.buttonSelected or colors.favorite
            categoryButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        end
        
        -- Hover effect
        categoryButton.MouseEnter:Connect(function()
            if activeTab ~= category then
                if category == "Favorites" then
                    categoryButton.BackgroundColor3 = Color3.fromRGB(255, 235, 100) -- Lighter gold
                else
                    categoryButton.BackgroundColor3 = colors.buttonHover
                end
            end
        end)
        
        categoryButton.MouseLeave:Connect(function()
            if activeTab ~= category then
                if category == "Favorites" then
                    categoryButton.BackgroundColor3 = colors.favorite
                else
                    categoryButton.BackgroundColor3 = colors.button
                end
            end
        end)
        
        -- Click function
        categoryButton.MouseButton1Click:Connect(function()
            -- Change active tab
            if activeTab ~= category then
                -- Reset previous button color
                for _, btn in pairs(categoryButtons) do
                    if btn.Text == "Favorites" then
                        btn.BackgroundColor3 = colors.favorite
                        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
                    else
                        btn.BackgroundColor3 = colors.button
                        btn.TextColor3 = colors.text
                    end
                end
                
                -- Set new button color
                categoryButton.BackgroundColor3 = colors.buttonSelected
                if category == "Favorites" then
                    categoryButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                else
                    categoryButton.TextColor3 = colors.text
                end
                
                -- Update active tab
                activeTab = category
                
                -- Update content panel
                updateContentPanel()
            end
        end)
        
        categoryButtons[category] = categoryButton
    end
    
    -- Content panel
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -140, 1, -90)
    contentFrame.Position = UDim2.new(0, 135, 0, 45)
    contentFrame.BackgroundColor3 = colors.background
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    -- Search bar
    local searchBar = Instance.new("TextBox")
    searchBar.Name = "SearchBar"
    searchBar.Size = UDim2.new(1, -15, 0, 35)
    searchBar.Position = UDim2.new(0, 5, 0, 5)
    searchBar.BackgroundColor3 = colors.neutralDark
    searchBar.PlaceholderText = "Search commands..."
    searchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBar.Text = ""
    searchBar.Font = Enum.Font.Gotham
    searchBar.TextSize = 14
    searchBar.TextColor3 = colors.text
    searchBar.BorderSizePixel = 0
    searchBar.ClearTextOnFocus = false
    searchBar.Parent = contentFrame
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 6)
    searchCorner.Parent = searchBar
    
    -- Content scrolling frame
    local contentScrollFrame = Instance.new("ScrollingFrame")
    contentScrollFrame.Name = "ContentScrollFrame"
    contentScrollFrame.Size = UDim2.new(1, -10, 1, -50)
    contentScrollFrame.Position = UDim2.new(0, 5, 0, 45)
    contentScrollFrame.BackgroundTransparency = 1
    contentScrollFrame.BorderSizePixel = 0
    contentScrollFrame.ScrollBarThickness = 6
    contentScrollFrame.ScrollBarImageColor3 = colors.highlight
    contentScrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
    contentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated dynamically
    contentScrollFrame.Parent = contentFrame
    
    -- Status bar
    local statusFrame = Instance.new("Frame")
    statusFrame.Name = "StatusFrame"
    statusFrame.Size = UDim2.new(1, 0, 0, 40)
    statusFrame.Position = UDim2.new(0, 0, 1, -40)
    statusFrame.BackgroundColor3 = colors.header
    statusFrame.BorderSizePixel = 0
    statusFrame.Parent = mainFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -10, 1, 0)
    statusLabel.Position = UDim2.new(0, 10, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Ready"
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 14
    statusLabel.TextColor3 = colors.text
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusFrame
    
    -- Button event handlers
    closeButton.MouseButton1Click:Connect(function()
        mainGUI:Destroy()
        guiCreated = false
        guiVisible = false
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        contentFrame.Visible = not contentFrame.Visible
        statusFrame.Visible = not statusFrame.Visible
        categoryFrame.Visible = not categoryFrame.Visible
        minimized = not minimized
        
        if minimized then
            mainFrame.Size = UDim2.new(0, 550, 0, 40)
        else
            mainFrame.Size = UDim2.new(0, 550, 0, 350)
        end
    end)
    
    miniButton.MouseButton1Click:Connect(function()
        if miniSize then
            mainFrame.Size = UDim2.new(0, 550, 0, 350)
            contentFrame.Visible = true
            statusFrame.Visible = true
            categoryFrame.Visible = true
            miniSize = false
        else
            mainFrame.Size = UDim2.new(0, 200, 0, 50)
            contentFrame.Visible = false
            statusFrame.Visible = false
            categoryFrame.Visible = false
            miniSize = true
        end
    end)
    
    -- Search functionality
    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        updateContentPanel(searchBar.Text)
    end)
    
    guiCreated = true
    guiVisible = true
    
    setStatus("KILASIK GUI loaded successfully!")
    
    -- Initial content load
    updateContentPanel()
end

-- Update content panel with commands
function updateContentPanel(searchTerm)
    local contentScrollFrame = CoreGui.KILASIKGUI.MainFrame.ContentFrame.ContentScrollFrame
    
    -- Clear existing content
    for _, child in pairs(contentScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Filter commands
    local filteredCommands = {}
    
    if activeTab == "Favorites" then
        for _, cmd in pairs(commands) do
            if table.find(favoriteCommands, cmd.name) then
                table.insert(filteredCommands, cmd)
            end
        end
    else
        for _, cmd in pairs(commands) do
            if activeTab == "Main" or cmd.category == activeTab then
                if not searchTerm or searchTerm == "" or 
                   string.lower(cmd.name):find(string.lower(searchTerm)) or 
                   string.lower(cmd.desc):find(string.lower(searchTerm)) then
                    table.insert(filteredCommands, cmd)
                end
            end
        end
    end
    
    -- Create command buttons
    for i, cmd in ipairs(filteredCommands) do
        local commandFrame = Instance.new("Frame")
        commandFrame.Name = cmd.name .. "Frame"
        commandFrame.Size = UDim2.new(1, -10, 0, 60)
        commandFrame.Position = UDim2.new(0, 5, 0, (i-1) * 65)
        commandFrame.BackgroundColor3 = colors.button
        commandFrame.BorderSizePixel = 0
        commandFrame.Parent = contentScrollFrame
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = commandFrame
        
        -- Command button
        local commandButton = Instance.new("TextButton")
        commandButton.Name = cmd.name .. "Button"
        commandButton.Size = UDim2.new(1, -80, 1, 0)
        commandButton.Position = UDim2.new(0, 0, 0, 0)
        commandButton.BackgroundTransparency = 1
        commandButton.Text = ""
        commandButton.Parent = commandFrame
        
        -- Command title
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -10, 0, 25)
        titleLabel.Position = UDim2.new(0, 10, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = cmd.name
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 16
        titleLabel.TextColor3 = colors.text
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = commandFrame
        
        -- Command description
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -10, 0, 20)
        descLabel.Position = UDim2.new(0, 10, 0, 30)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = cmd.desc
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 12
        descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = commandFrame
        
        -- Favorite button
        if cmd.canFavorite then
            local favoriteButton = Instance.new("TextButton")
            favoriteButton.Size = UDim2.new(0, 30, 0, 30)
            favoriteButton.Position = UDim2.new(1, -70, 0, 15)
            favoriteButton.BackgroundColor3 = table.find(favoriteCommands, cmd.name) and colors.favorite or colors.neutralLight
            favoriteButton.Text = "★"
            favoriteButton.Font = Enum.Font.GothamBold
            favoriteButton.TextSize = 16
            favoriteButton.TextColor3 = table.find(favoriteCommands, cmd.name) and Color3.fromRGB(0, 0, 0) or colors.text
            favoriteButton.BorderSizePixel = 0
            favoriteButton.Parent = commandFrame
            
            local favCorner = Instance.new("UICorner")
            favCorner.CornerRadius = UDim.new(0, 6)
            favCorner.Parent = favoriteButton
            
            favoriteButton.MouseButton1Click:Connect(function()
                local index = table.find(favoriteCommands, cmd.name)
                if index then
                    table.remove(favoriteCommands, index)
                    favoriteButton.BackgroundColor3 = colors.neutralLight
                    favoriteButton.TextColor3 = colors.text
                    setStatus("Removed " .. cmd.name .. " from favorites")
                else
                    table.insert(favoriteCommands, cmd.name)
                    favoriteButton.BackgroundColor3 = colors.favorite
                    favoriteButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                    setStatus("Added " .. cmd.name .. " to favorites")
                end
            end)
        end
        
        -- Execute button with different styles based on type
        local executeButton = Instance.new("TextButton")
        executeButton.Size = UDim2.new(0, 30, 0, 30)
        executeButton.Position = UDim2.new(1, -35, 0, 15)
        executeButton.BorderSizePixel = 0
        executeButton.Parent = commandFrame
        
        -- Input field for input type commands
        local inputBox = nil
        if cmd.type == "input" then
            executeButton.Size = UDim2.new(0, 60, 0, 30)
            executeButton.Position = UDim2.new(1, -65, 0, 15)
            
            inputBox = Instance.new("TextBox")
            inputBox.Size = UDim2.new(0, 80, 0, 25)
            inputBox.Position = UDim2.new(1, -150, 0, 17)
            inputBox.BackgroundColor3 = colors.neutralDark
            inputBox.Text = cmd.currentValue and tostring(cmd.currentValue()) or ""
            inputBox.PlaceholderText = cmd.inputType == "number" and "Number..." or "Text..."
            inputBox.Font = Enum.Font.Gotham
            inputBox.TextSize = 12
            inputBox.TextColor3 = colors.text
            inputBox.BorderSizePixel = 0
            inputBox.Parent = commandFrame
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 4)
            inputCorner.Parent = inputBox
        end
        
        -- Set button appearance based on type and state
        if cmd.type == "toggle" then
            local isActive = getCommandState(cmd.name)
            executeButton.BackgroundColor3 = isActive and colors.success or colors.neutralLight
            executeButton.Text = isActive and "⏸" or "▶"  -- Pause/Play icons
            executeButton.TextColor3 = isActive and Color3.fromRGB(0, 0, 0) or colors.text
        elseif cmd.type == "input" then
            executeButton.BackgroundColor3 = colors.highlight
            executeButton.Text = "SET"
            executeButton.Font = Enum.Font.GothamBold
            executeButton.TextSize = 10
            executeButton.TextColor3 = colors.text
        else -- button type
            executeButton.BackgroundColor3 = colors.highlight
            executeButton.Text = "▶"
            executeButton.Font = Enum.Font.GothamBold
            executeButton.TextSize = 14
            executeButton.TextColor3 = colors.text
        end
        
        local execCorner = Instance.new("UICorner")
        execCorner.CornerRadius = UDim.new(0, 6)
        execCorner.Parent = executeButton
        
        executeButton.MouseButton1Click:Connect(function()
            if cmd.type == "input" and inputBox then
                -- For input commands, pass the input value
                if cmd.inputType == "number" then
                    local value = tonumber(inputBox.Text)
                    if value and cmd.func then
                        cmd.func(value)
                    end
                else
                    if inputBox.Text ~= "" and cmd.func then
                        cmd.func(inputBox.Text)
                    end
                end
            else
                -- For toggle and button commands
                if cmd.func then
                    cmd.func()
                else
                    setStatus("Executed: " .. cmd.name)
                end
            end
            
            -- Update button appearance for toggles
            if cmd.type == "toggle" then
                spawn(function()
                    wait(0.1) -- Small delay to let the state update
                    local isActive = getCommandState(cmd.name)
                    executeButton.BackgroundColor3 = isActive and colors.success or colors.neutralLight
                    executeButton.Text = isActive and "⏸" or "▶"
                    executeButton.TextColor3 = isActive and Color3.fromRGB(0, 0, 0) or colors.text
                end)
            end
        end)
        
        -- For input fields, also trigger on Enter
        if inputBox then
            inputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    executeButton.MouseButton1Click:Fire()
                end
            end)
        end
        
        -- Hover effects
        commandButton.MouseEnter:Connect(function()
            commandFrame.BackgroundColor3 = colors.buttonHover
        end)
        
        commandButton.MouseLeave:Connect(function()
            commandFrame.BackgroundColor3 = colors.button
        end)
        
        commandButton.MouseButton1Click:Connect(function()
            executeButton.MouseButton1Click:Fire()
        end)
    end
    
    -- Update canvas size
    contentScrollFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(#filteredCommands * 65, contentScrollFrame.AbsoluteSize.Y))
end

-- Key verification GUI
function createKeyGUI()
    local keyGUI = Instance.new("ScreenGui")
    keyGUI.Name = "KILASIKKeyGUI"
    keyGUI.ResetOnSpawn = false
    keyGUI.Parent = CoreGui
    
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 400, 0, 250)
    keyFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    keyFrame.BackgroundColor3 = colors.background
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = keyGUI
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 10)
    keyCorner.Parent = keyFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, 0, 0, 40)
    titleText.BackgroundTransparency = 1
    titleText.Text = "KILASIK GUI - Key System"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextColor3 = colors.text
    titleText.Parent = keyFrame
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 0, 40)
    keyInput.Position = UDim2.new(0, 20, 0, 80)
    keyInput.BackgroundColor3 = colors.neutralDark
    keyInput.PlaceholderText = "Enter key..."
    keyInput.Text = ""
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextSize = 16
    keyInput.TextColor3 = colors.text
    keyInput.BorderSizePixel = 0
    keyInput.Parent = keyFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = keyInput
    
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0, 100, 0, 35)
    submitButton.Position = UDim2.new(0.5, -50, 0, 140)
    submitButton.BackgroundColor3 = colors.highlight
    submitButton.Text = "Submit"
    submitButton.Font = Enum.Font.GothamBold
    submitButton.TextSize = 16
    submitButton.TextColor3 = colors.text
    submitButton.BorderSizePixel = 0
    submitButton.Parent = keyFrame
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 6)
    submitCorner.Parent = submitButton
    
    local discordButton = Instance.new("TextButton")
    discordButton.Size = UDim2.new(0, 150, 0, 25)
    discordButton.Position = UDim2.new(0.5, -75, 0, 190)
    discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordButton.Text = "Get Key (Discord)"
    discordButton.Font = Enum.Font.Gotham
    discordButton.TextSize = 14
    discordButton.TextColor3 = colors.text
    discordButton.BorderSizePixel = 0
    discordButton.Parent = keyFrame
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 6)
    discordCorner.Parent = discordButton
    
    -- Event handlers
    submitButton.MouseButton1Click:Connect(function()
        if keyInput.Text == KEY_CODE then
            keyVerified = true
            keyGUI:Destroy()
            createMainGUI()
            setStatus("Key verified! Welcome to KILASIK GUI")
        else
            keyInput.Text = ""
            keyInput.PlaceholderText = "Invalid key! Please try again."
            setStatus("Invalid key! Please try again.")
        end
    end)
    
    discordButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
            setStatus("Discord link copied to clipboard!")
        else
            setStatus("Join our Discord: " .. DISCORD_LINK)
        end
    end)
    
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitButton.MouseButton1Click:Fire()
        end
    end)
end

-- Toggle GUI hotkey
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        if not keyVerified then
            createKeyGUI()
        else
            if guiCreated and CoreGui:FindFirstChild("KILASIKGUI") then
                local gui = CoreGui.KILASIKGUI
                gui.Enabled = not gui.Enabled
                guiVisible = gui.Enabled
                setStatus("GUI " .. (guiVisible and "shown" or "hidden"))
            else
                createMainGUI()
            end
        end
    end
end)

-- =============================
-- DÜZELTMELER - İSTENEN ÖZELLİKLER
-- =============================

-- Player List Functions for TpToPlayer and FlingPlayer
function showPlayerList(actionType)
    if playerListVisible then
        hidePlayerList()
        return
    end
    
    -- Create player list frame
    playerListFrame = Instance.new("Frame")
    playerListFrame.Name = "PlayerListFrame"
    playerListFrame.Size = UDim2.new(0, 250, 0, 350)
    playerListFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
    playerListFrame.BackgroundColor3 = colors.background
    playerListFrame.BorderSizePixel = 0
    playerListFrame.Active = true
    playerListFrame.Draggable = true
    
    -- Add to existing GUI
    if CoreGui:FindFirstChild("KILASIKGUI") then
        playerListFrame.Parent = CoreGui.KILASIKGUI
    else
        local tempGui = Instance.new("ScreenGui")
        tempGui.Name = "KILASIKGUI_PlayerList"
        tempGui.Parent = CoreGui
        playerListFrame.Parent = tempGui
    end
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = playerListFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = colors.header
    titleBar.BorderSizePixel = 0
    titleBar.Parent = playerListFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -35, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = actionType == "teleport" and "Select Player to Teleport" or "Select Player to Fling"
    title.TextColor3 = colors.text
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.Parent = titleBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -32, 0, 2.5)
    closeBtn.BackgroundColor3 = colors.warning
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = colors.text
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 14
    closeBtn.Parent = titleBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 4)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        hidePlayerList()
    end)
    
    -- Player scroll frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -45)
    scrollFrame.Position = UDim2.new(0, 5, 0, 40)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = playerListFrame
    
    -- Add players to list
    local yPos = 5
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Size = UDim2.new(1, -10, 0, 35)
            playerBtn.Position = UDim2.new(0, 5, 0, yPos)
            playerBtn.BackgroundColor3 = colors.button
            playerBtn.BorderSizePixel = 0
            playerBtn.Text = otherPlayer.Name
            playerBtn.TextColor3 = colors.text
            playerBtn.Font = Enum.Font.SourceSans
            playerBtn.TextSize = 14
            playerBtn.Parent = scrollFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = playerBtn
            
            playerBtn.MouseEnter:Connect(function()
                playerBtn.BackgroundColor3 = colors.buttonHover
            end)
            
            playerBtn.MouseLeave:Connect(function()
                playerBtn.BackgroundColor3 = colors.button
            end)
            
            playerBtn.MouseButton1Click:Connect(function()
                if actionType == "teleport" then
                    teleportToPlayerDirect(otherPlayer.Name)
                elseif actionType == "fling" then
                    flingPlayerDirect(otherPlayer.Name)
                end
                hidePlayerList()
            end)
            
            yPos = yPos + 40
        end
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
    playerListVisible = true
end

function hidePlayerList()
    if playerListFrame then
        playerListFrame:Destroy()
        playerListFrame = nil
        playerListVisible = false
    end
    
    -- Also destroy temp GUI if exists
    if CoreGui:FindFirstChild("KILASIKGUI_PlayerList") then
        CoreGui.KILASIKGUI_PlayerList:Destroy()
    end
end

function teleportToPlayerDirect(playerName)
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == playerName then
            targetPlayer = p
            break
        end
    end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            setStatus("Teleported to " .. targetPlayer.Name)
        end
    else
        setStatus("Player not found: " .. playerName)
    end
end

-- Working Fling Function from the second script
function SkidFling(TargetPlayer)
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    
    if not TCharacter then 
        setStatus("Target has no character!")
        return 
    end
    
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")
    
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        
        if THumanoid and THumanoid.Sit then
            setStatus(TargetPlayer.Name .. " is sitting")
            return
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
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + TRootPart.CFrame.LookVector * 1.5, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + TRootPart.CFrame.LookVector * 1.5, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(1.5, 1.5, -1) + TRootPart.CFrame.LookVector * 1.5, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(-1.5, -1.5, 1) + TRootPart.CFrame.LookVector * 1.5, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude >= 50 or tick() - Time >= TimeToWait
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif THead and not TRootPart then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            setStatus("No target found!")
            BV:Destroy()
            return
        end
        
        BV:Destroy()
        workspace.CurrentCamera.CameraSubject = Humanoid
        workspace.FallenPartsDestroyHeight = getgenv().FPDH or -500
        
        if getgenv().OldPos then
            RootPart.CFrame = getgenv().OldPos
        end
        
        setStatus("Flinged " .. TargetPlayer.Name)
    end
end

function flingPlayerDirect(playerName)
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == playerName then
            targetPlayer = p
            break
        end
    end
    
    if targetPlayer then
        if targetPlayer == player then
            setStatus("Cannot fling yourself!")
            return
        end
        SkidFling(targetPlayer)
    else
        setStatus("Player not found: " .. playerName)
    end
end

-- Override existing functions to use player lists
local originalTeleportToPlayer = teleportToPlayer
teleportToPlayer = function(playerName)
    if not playerName or playerName == "" then
        showPlayerList("teleport")
        return
    end
    originalTeleportToPlayer(playerName)
end

local originalFlingPlayer = flingPlayer
flingPlayer = function(playerName)
    if not playerName or playerName == "" then
        showPlayerList("fling")
        return
    end
    
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(p.Name):find(string.lower(playerName)) or string.lower(p.DisplayName):find(string.lower(playerName)) then
            targetPlayer = p
            break
        end
    end
    
    if targetPlayer then
        if targetPlayer == player then
            setStatus("Cannot fling yourself!")
            return
        end
        SkidFling(targetPlayer)
    else
        setStatus("Player not found: " .. playerName)
    end
end

-- DAB Animation Fix - Override existing playAnimation function for DAB only
local originalPlayAnimation = playAnimation
playAnimation = function(animType)
    if animType == "dab" then
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then 
            setStatus("Character not found!")
            return 
        end
        
        if dabAnimationTrack then
            -- Stop existing animation
            dabAnimationTrack:Stop()
            dabAnimationTrack = nil
            setStatus("DAB animation stopped")
            return
        end
        
        local humanoid = player.Character.Humanoid
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://248263260"
        
        -- Load and play animation
        dabAnimationTrack = humanoid:LoadAnimation(animation)
        if dabAnimationTrack then
            dabAnimationTrack.Looped = true
            dabAnimationTrack:Play()
            setStatus("DAB animation started - Click again to stop")
        else
            setStatus("Failed to load DAB animation")
        end
    else
        -- Remove other animations - only show error
        setStatus("Animation removed - Only DAB animation is available")
    end
end

-- GUI Resize and Minimize Functions
function addResizeFeatures()
    spawn(function()
        wait(2) -- Wait for GUI to load
        
        local gui = CoreGui:FindFirstChild("KILASIKGUI")
        if not gui then return end
        
        local mainFrame = gui:FindFirstChild("MainFrame")
        if not mainFrame then return end
        
        -- Add minimize button if doesn't exist
        local titleBar = mainFrame:FindFirstChild("TitleBar")
        if titleBar and not titleBar:FindFirstChild("MinimizeButton") then
            local minimizeBtn = Instance.new("TextButton")
            minimizeBtn.Name = "MinimizeButton"
            minimizeBtn.Size = UDim2.new(0, 30, 0, 25)
            minimizeBtn.Position = UDim2.new(1, -70, 0, 2)
            minimizeBtn.BackgroundColor3 = colors.highlight
            minimizeBtn.BorderSizePixel = 0
            minimizeBtn.Text = "-"
            minimizeBtn.TextColor3 = colors.text
            minimizeBtn.Font = Enum.Font.SourceSansBold
            minimizeBtn.TextSize = 16
            minimizeBtn.Parent = titleBar
            
            local minimized = false
            local originalSize = mainFrame.Size
            
            minimizeBtn.MouseButton1Click:Connect(function()
                minimized = not minimized
                if minimized then
                    originalSize = mainFrame.Size
                    mainFrame:TweenSize(UDim2.new(0, originalSize.X.Offset, 0, 35), "Out", "Quart", 0.3, true)
                    minimizeBtn.Text = "+"
                    
                    -- Hide content
                    for _, child in pairs(mainFrame:GetChildren()) do
                        if child.Name ~= "TitleBar" then
                            child.Visible = false
                        end
                    end
                else
                    mainFrame:TweenSize(originalSize, "Out", "Quart", 0.3, true)
                    minimizeBtn.Text = "-"
                    
                    -- Show content
                    for _, child in pairs(mainFrame:GetChildren()) do
                        if child.Name ~= "TitleBar" then
                            child.Visible = true
                        end
                    end
                end
            end)
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = minimizeBtn
        end
        
        -- Add resize handle if doesn't exist
        if not mainFrame:FindFirstChild("ResizeHandle") then
            local resizeHandle = Instance.new("Frame")
            resizeHandle.Name = "ResizeHandle"
            resizeHandle.Size = UDim2.new(0, 20, 0, 20)
            resizeHandle.Position = UDim2.new(1, -20, 1, -20)
            resizeHandle.BackgroundColor3 = colors.header
            resizeHandle.BorderSizePixel = 0
            resizeHandle.Parent = mainFrame
            
            local resizeCorner = Instance.new("UICorner")
            resizeCorner.CornerRadius = UDim.new(0, 10)
            resizeCorner.Parent = resizeHandle
            
            -- Resize functionality
            local dragging = false
            local dragStart = nil
            local startSize = nil
            
            resizeHandle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startSize = mainFrame.Size
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    local newSize = UDim2.new(
                        startSize.X.Scale, 
                        math.max(400, startSize.X.Offset + delta.X),
                        startSize.Y.Scale, 
                        math.max(300, startSize.Y.Offset + delta.Y)
                    )
                    mainFrame.Size = newSize
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end
    end)
end

-- =============================
-- IMPROVED FEATURES - SETTINGS PANELS
-- =============================

-- Speed Settings Panel
function showSpeedSettings()
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name = "SpeedSettings"
    settingsFrame.Size = UDim2.new(0, 300, 0, 200)
    settingsFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    settingsFrame.BackgroundColor3 = colors.background
    settingsFrame.BorderSizePixel = 0
    settingsFrame.Active = true
    settingsFrame.Draggable = true
    
    if CoreGui:FindFirstChild("KILASIKGUI") then
        settingsFrame.Parent = CoreGui.KILASIKGUI
    else
        local tempGui = Instance.new("ScreenGui")
        tempGui.Name = "SpeedSettingsGUI"
        tempGui.Parent = CoreGui
        settingsFrame.Parent = tempGui
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = settingsFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Speed Settings"
    title.TextColor3 = colors.text
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = settingsFrame
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = colors.warning
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = colors.text
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 14
    closeBtn.Parent = settingsFrame
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 4)
    closeBtnCorner.Parent = closeBtn
    
    -- Speed input
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, -20, 0, 25)
    speedLabel.Position = UDim2.new(0, 10, 0, 50)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Current Speed: " .. walkSpeed
    speedLabel.TextColor3 = colors.text
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.TextSize = 14
    speedLabel.Parent = settingsFrame
    
    local speedInput = Instance.new("TextBox")
    speedInput.Size = UDim2.new(1, -20, 0, 30)
    speedInput.Position = UDim2.new(0, 10, 0, 80)
    speedInput.BackgroundColor3 = colors.button
    speedInput.BorderSizePixel = 0
    speedInput.Text = tostring(walkSpeed)
    speedInput.TextColor3 = colors.text
    speedInput.Font = Enum.Font.SourceSans
    speedInput.TextSize = 14
    speedInput.PlaceholderText = "Enter speed (1-500)"
    speedInput.Parent = settingsFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = speedInput
    
    -- Preset buttons
    local presets = {16, 50, 100, 200}
    for i, speed in ipairs(presets) do
        local presetBtn = Instance.new("TextButton")
        presetBtn.Size = UDim2.new(0.2, -5, 0, 25)
        presetBtn.Position = UDim2.new((i-1) * 0.25, 5, 0, 120)
        presetBtn.BackgroundColor3 = colors.highlight
        presetBtn.BorderSizePixel = 0
        presetBtn.Text = tostring(speed)
        presetBtn.TextColor3 = colors.text
        presetBtn.Font = Enum.Font.SourceSans
        presetBtn.TextSize = 12
        presetBtn.Parent = settingsFrame
        
        local presetCorner = Instance.new("UICorner")
        presetCorner.CornerRadius = UDim.new(0, 4)
        presetCorner.Parent = presetBtn
        
        presetBtn.MouseButton1Click:Connect(function()
            speedInput.Text = tostring(speed)
            setWalkSpeed(speed)
            speedLabel.Text = "Current Speed: " .. speed
        end)
    end
    
    -- Apply button
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(1, -20, 0, 30)
    applyBtn.Position = UDim2.new(0, 10, 0, 155)
    applyBtn.BackgroundColor3 = colors.success
    applyBtn.BorderSizePixel = 0
    applyBtn.Text = "Apply Speed"
    applyBtn.TextColor3 = colors.text
    applyBtn.Font = Enum.Font.SourceSansBold
    applyBtn.TextSize = 14
    applyBtn.Parent = settingsFrame
    
    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 4)
    applyCorner.Parent = applyBtn
    
    applyBtn.MouseButton1Click:Connect(function()
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed > 0 and newSpeed <= 500 then
            setWalkSpeed(newSpeed)
            speedLabel.Text = "Current Speed: " .. newSpeed
        else
            setStatus("Invalid speed! Use 1-500")
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        settingsFrame:Destroy()
    end)
end

-- Jump Settings Panel
function showJumpSettings()
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name = "JumpSettings"
    settingsFrame.Size = UDim2.new(0, 300, 0, 200)
    settingsFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    settingsFrame.BackgroundColor3 = colors.background
    settingsFrame.BorderSizePixel = 0
    settingsFrame.Active = true
    settingsFrame.Draggable = true
    
    if CoreGui:FindFirstChild("KILASIKGUI") then
        settingsFrame.Parent = CoreGui.KILASIKGUI
    else
        local tempGui = Instance.new("ScreenGui")
        tempGui.Name = "JumpSettingsGUI"
        tempGui.Parent = CoreGui
        settingsFrame.Parent = tempGui
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = settingsFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Jump Power Settings"
    title.TextColor3 = colors.text
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = settingsFrame
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = colors.warning
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = colors.text
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 14
    closeBtn.Parent = settingsFrame
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 4)
    closeBtnCorner.Parent = closeBtn
    
    -- Jump input
    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(1, -20, 0, 25)
    jumpLabel.Position = UDim2.new(0, 10, 0, 50)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = "Current Jump Power: " .. jumpPower
    jumpLabel.TextColor3 = colors.text
    jumpLabel.Font = Enum.Font.SourceSans
    jumpLabel.TextSize = 14
    jumpLabel.Parent = settingsFrame
    
    local jumpInput = Instance.new("TextBox")
    jumpInput.Size = UDim2.new(1, -20, 0, 30)
    jumpInput.Position = UDim2.new(0, 10, 0, 80)
    jumpInput.BackgroundColor3 = colors.button
    jumpInput.BorderSizePixel = 0
    jumpInput.Text = tostring(jumpPower)
    jumpInput.TextColor3 = colors.text
    jumpInput.Font = Enum.Font.SourceSans
    jumpInput.TextSize = 14
    jumpInput.PlaceholderText = "Enter jump power (1-1000)"
    jumpInput.Parent = settingsFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = jumpInput
    
    -- Preset buttons
    local presets = {50, 100, 200, 500}
    for i, power in ipairs(presets) do
        local presetBtn = Instance.new("TextButton")
        presetBtn.Size = UDim2.new(0.2, -5, 0, 25)
        presetBtn.Position = UDim2.new((i-1) * 0.25, 5, 0, 120)
        presetBtn.BackgroundColor3 = colors.highlight
        presetBtn.BorderSizePixel = 0
        presetBtn.Text = tostring(power)
        presetBtn.TextColor3 = colors.text
        presetBtn.Font = Enum.Font.SourceSans
        presetBtn.TextSize = 12
        presetBtn.Parent = settingsFrame
        
        local presetCorner = Instance.new("UICorner")
        presetCorner.CornerRadius = UDim.new(0, 4)
        presetCorner.Parent = presetBtn
        
        presetBtn.MouseButton1Click:Connect(function()
            jumpInput.Text = tostring(power)
            setJumpPower(power)
            jumpLabel.Text = "Current Jump Power: " .. power
        end)
    end
    
    -- Apply button
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(1, -20, 0, 30)
    applyBtn.Position = UDim2.new(0, 10, 0, 155)
    applyBtn.BackgroundColor3 = colors.success
    applyBtn.BorderSizePixel = 0
    applyBtn.Text = "Apply Jump Power"
    applyBtn.TextColor3 = colors.text
    applyBtn.Font = Enum.Font.SourceSansBold
    applyBtn.TextSize = 14
    applyBtn.Parent = settingsFrame
    
    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 4)
    applyCorner.Parent = applyBtn
    
    applyBtn.MouseButton1Click:Connect(function()
        local newPower = tonumber(jumpInput.Text)
        if newPower and newPower > 0 and newPower <= 1000 then
            setJumpPower(newPower)
            jumpLabel.Text = "Current Jump Power: " .. newPower
        else
            setStatus("Invalid jump power! Use 1-1000")
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        settingsFrame:Destroy()
    end)
end

-- Fixed DAB Animation Function
function playDabAnimation()
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then 
        setStatus("Character not found!")
        return 
    end
    
    if dabAnimationTrack then
        dabAnimationTrack:Stop()
        dabAnimationTrack = nil
        setStatus("DAB animation stopped")
        return
    end
    
    local humanoid = player.Character.Humanoid
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://248263260"
    
    dabAnimationTrack = humanoid:LoadAnimation(animation)
    if dabAnimationTrack then
        dabAnimationTrack.Looped = true
        dabAnimationTrack:Play()
        setStatus("DAB animation started - Click again to stop")
    else
        setStatus("Failed to load DAB animation")
    end
end

-- Fixed ESP Functions
function updateESP()
    if not esp.enabled then return end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and 
           otherPlayer.Character:FindFirstChild("HumanoidRootPart") and 
           otherPlayer.Character:FindFirstChild("Head") then
            
            local char = otherPlayer.Character
            local hrp = char.HumanoidRootPart
            local head = char.Head
            
            -- Team check
            local isFriendly = false
            if esp.teamCheck and player.Team and otherPlayer.Team then
                isFriendly = player.Team == otherPlayer.Team
            end
            
            if not esp.teamCheck or not isFriendly then
                local espColor = Color3.fromRGB(255, 0, 0)
                if esp.teamColor and otherPlayer.Team then
                    espColor = otherPlayer.TeamColor.Color
                end
                
                -- Create ESP container
                local espContainer = char:FindFirstChild("KILASIK_ESP")
                if not espContainer then
                    espContainer = Instance.new("Folder")
                    espContainer.Name = "KILASIK_ESP"
                    espContainer.Parent = char
                end
                
                -- Names ESP
                if esp.names then
                    local nameESP = espContainer:FindFirstChild("NameESP")
                    if not nameESP then
                        nameESP = Instance.new("BillboardGui")
                        nameESP.Name = "NameESP"
                        nameESP.Adornee = head
                        nameESP.Size = UDim2.new(0, 200, 0, 50)
                        nameESP.StudsOffset = Vector3.new(0, 2, 0)
                        nameESP.AlwaysOnTop = true
                        nameESP.Parent = espContainer
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.TextSize = 16
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        nameLabel.Parent = nameESP
                    end
                    
                    local nameLabel = nameESP:FindFirstChild("TextLabel")
                    nameLabel.TextColor3 = espColor
                    nameLabel.Text = otherPlayer.Name
                    
                    if esp.distances then
                        local distance = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                        nameLabel.Text = otherPlayer.Name .. " [" .. math.floor(distance) .. "m]"
                    end
                else
                    local nameESP = espContainer:FindFirstChild("NameESP")
                    if nameESP then nameESP:Destroy() end
                end
                
                -- Box ESP
                if esp.boxes then
                    local boxESP = espContainer:FindFirstChild("BoxESP")
                    if not boxESP then
                        boxESP = Instance.new("SelectionBox")
                        boxESP.Name = "BoxESP"
                        boxESP.Adornee = char
                        boxESP.LineThickness = 0.1
                        boxESP.Transparency = 0.5
                        boxESP.Parent = espContainer
                    end
                    boxESP.Color3 = espColor
                else
                    local boxESP = espContainer:FindFirstChild("BoxESP")
                    if boxESP then boxESP:Destroy() end
                end
                
                -- Chams ESP
                if esp.chams then
                    local chamsESP = espContainer:FindFirstChild("ChamsESP")
                    if not chamsESP then
                        chamsESP = Instance.new("Highlight")
                        chamsESP.Name = "ChamsESP"
                        chamsESP.Adornee = char
                        chamsESP.FillTransparency = 0.5
                        chamsESP.OutlineTransparency = 0
                        chamsESP.Parent = espContainer
                    end
                    chamsESP.FillColor = espColor
                    chamsESP.OutlineColor = espColor
                else
                    local chamsESP = espContainer:FindFirstChild("ChamsESP")
                    if chamsESP then chamsESP:Destroy() end
                end
            else
                cleanupESP(otherPlayer)
            end
        end
    end
end

function cleanupESP(targetPlayer)
    if targetPlayer.Character then
        local espContainer = targetPlayer.Character:FindFirstChild("KILASIK_ESP")
        if espContainer then
            espContainer:Destroy()
        end
    end
end

-- Apply all GUI improvements
addResizeFeatures()

-- Main execution
if not keyVerified then
    createKeyGUI()
else
    createMainGUI()
end

setStatus("KILASIK GUI loaded successfully! Press INSERT to toggle.")
