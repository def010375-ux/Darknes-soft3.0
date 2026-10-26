--[[
    Darknes Soft | Xeno-Style UI
    Fly + ESP + Language
    
    Compatible with: Delta, Xeno and most executors that support Drawing API
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

--================ SETTINGS ================--
local Flying = false
local FlySpeed = 50
local BodyVelocity, BodyGyro = nil, nil
local CurrentLang = "RU"
local ESPEnabled = false

--================ GUI (Xeno Style) ================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarknesSoft"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Main Window
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 340)
Main.Position = UDim2.new(0.5, -160, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 35, 40)
MainStroke.Thickness = 1
MainStroke.Parent = Main

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Icon
local Icon = Instance.new("Frame")
Icon.Size = UDim2.new(0, 26, 0, 26)
Icon.Position = UDim2.new(0, 12, 0.5, -13)
Icon.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
Icon.BorderSizePixel = 0
Icon.Parent = TopBar

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 6)
IconCorner.Parent = Icon

local IconText = Instance.new("TextLabel")
IconText.Size = UDim2.new(1, 0, 1, 0)
IconText.BackgroundTransparency = 1
IconText.Text = "侍"
IconText.TextColor3 = Color3.fromRGB(220, 50, 60)
IconText.Font = Enum.Font.GothamBold
IconText.TextSize = 14
IconText.Parent = Icon

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 48, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Darknes Soft"
Title.TextColor3 = Color3.fromRGB(230, 230, 235)
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 185)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -24, 1, -58)
Content.Position = UDim2.new(0, 12, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Helper: Create Section
local function CreateSection(name, y)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Position = UDim2.new(0, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(120, 120, 130)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Content
    return label
end

-- Helper: Create Toggle
local function CreateToggle(text, y, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.Position = UDim2.new(0, 0, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
    frame.BorderSizePixel = 0
    frame.Parent = Content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 225)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 44, 0, 24)
    toggleBg.Position = UDim2.new(1, -56, 0.5, -12)
    toggleBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 3, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(180, 180, 185)
    circle.BorderSizePixel = 0
    circle.Parent = toggleBg

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local enabled = false

    local function setState(state)
        enabled = state
        if state then
            TweenService:Create(toggleBg, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 45, 55)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.15), {
                Position = UDim2.new(1, -21, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(toggleBg, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.15), {
                Position = UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(180, 180, 185)
            }):Play()
        end
        if callback then callback(state) end
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        setState(not enabled)
    end)

    return setState
end

-- Helper: Create Slider
local function CreateSlider(text, y, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 58)
    frame.Position = UDim2.new(0, 0, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
    frame.BorderSizePixel = 0
    frame.Parent = Content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 14, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(220, 220, 225)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -28, 0, 6)
    sliderBg.Position = UDim2.new(0, 14, 0, 38)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame

    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(200, 45, 55)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local sliding = false

    local function update(value)
        value = math.clamp(value, min, max)
        local percent = (value - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, -7, 0.5, -7)
        label.Text = text .. ": " .. math.floor(value)
        if callback then callback(value) end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local rel = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            update(min + rel * (max - min))
        end
    end)

    return update
end

--================ BUILD UI ================--
CreateSection("MOVEMENT", 0)
CreateToggle("Fly", 22, function(state)
    if state then
        if not Flying then
            Flying = true
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Velocity = Vector3.zero
            BodyVelocity.Parent = HumanoidRootPart

            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BodyGyro.P = 10000
            BodyGyro.Parent = HumanoidRootPart

            Humanoid.PlatformStand = true
        end
    else
        if Flying then
            Flying = false
            if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
            if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
            Humanoid.PlatformStand = false
        end
    end
end)

CreateSlider("Speed", 70, 10, 150, 50, function(v)
    FlySpeed = v
end)

CreateSection("VISUALS", 140)
CreateToggle("ESP (Box + Tracer + Name)", 162, function(state)
    ESPEnabled = state
end)

CreateSection("SETTINGS", 215)

local LangFrame = Instance.new("Frame")
LangFrame.Size = UDim2.new(1, 0, 0, 40)
LangFrame.Position = UDim2.new(0, 0, 0, 237)
LangFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
LangFrame.BorderSizePixel = 0
LangFrame.Parent = Content

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 8)
LangCorner.Parent = LangFrame

local LangLabel = Instance.new("TextLabel")
LangLabel.Size = UDim2.new(0.5, 0, 1, 0)
LangLabel.Position = UDim2.new(0, 14, 0, 0)
LangLabel.BackgroundTransparency = 1
LangLabel.Text = "Language"
LangLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
LangLabel.Font = Enum.Font.Gotham
LangLabel.TextSize = 14
LangLabel.TextXAlignment = Enum.TextXAlignment.Left
LangLabel.Parent = LangFrame

local LangBtn = Instance.new("TextButton")
LangBtn.Size = UDim2.new(0, 70, 0, 26)
LangBtn.Position = UDim2.new(1, -84, 0.5, -13)
LangBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
LangBtn.Text = "RU"
LangBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
LangBtn.Font = Enum.Font.GothamMedium
LangBtn.TextSize = 13
LangBtn.Parent = LangFrame

local LangBtnCorner = Instance.new("UICorner")
LangBtnCorner.CornerRadius = UDim.new(0, 6)
LangBtnCorner.Parent = LangBtn

LangBtn.MouseButton1Click:Connect(function()
    if CurrentLang == "RU" then
        CurrentLang = "EN"
        LangBtn.Text = "EN"
    else
        CurrentLang = "RU"
        LangBtn.Text = "RU"
    end
end)

--================ ESP SYSTEM ================--
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end

    local drawings = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        HealthBar = Drawing.new("Line"),
        HealthOutline = Drawing.new("Line")
    }

    drawings.Box.Thickness = 1.5
    drawings.Box.Filled = false
    drawings.Box.Color = Color3.fromRGB(200, 45, 55)
    drawings.Box.Visible = false

    drawings.Tracer.Thickness = 1.2
    drawings.Tracer.Color = Color3.fromRGB(200, 45, 55)
    drawings.Tracer.Visible = false

    drawings.Name.Size = 14
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Color = Color3.fromRGB(255, 255, 255)
    drawings.Name.Visible = false

    drawings.HealthOutline.Thickness = 3
    drawings.HealthOutline.Color = Color3.fromRGB(0, 0, 0)
    drawings.HealthOutline.Visible = false

    drawings.HealthBar.Thickness = 1.5
    drawings.HealthBar.Visible = false

    ESPObjects[player] = drawings
end

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, v in pairs(ESPObjects[player]) do
            pcall(function() v:Remove() end)
        end
        ESPObjects[player] = nil
    end
end

local function UpdateESP()
    for player, drawings in pairs(ESPObjects) do
        if not ESPEnabled 
            or not player.Character 
            or not player.Character:FindFirstChild("HumanoidRootPart") 
            or not player.Character:FindFirstChild("Humanoid") 
            or player.Character.Humanoid.Health <= 0 then
            
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
            drawings.Name.Visible = false
            drawings.HealthBar.Visible = false
            drawings.HealthOutline.Visible = false
            continue
        end

        local root = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

        if onScreen then
            local top = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 2.5, 0))
            local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
            local sizeY = math.abs(top.Y - bottom.Y)
            local sizeX = sizeY * 0.65
            local boxSize = Vector2.new(sizeX, sizeY)
            local boxPos = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)

            drawings.Box.Size = boxSize
            drawings.Box.Position = boxPos
            drawings.Box.Visible = true

            drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.Tracer.To = Vector2.new(pos.X, pos.Y + sizeY / 2)
            drawings.Tracer.Visible = true

            local dist = 0
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude)
            end
            drawings.Name.Text = player.Name .. " [" .. dist .. "m]"
            drawings.Name.Position = Vector2.new(pos.X, boxPos.Y - 16)
            drawings.Name.Visible = true

            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barHeight = sizeY * healthPercent
            local barX = boxPos.X - 6

            drawings.HealthOutline.From = Vector2.new(barX, boxPos.Y)
            drawings.HealthOutline.To = Vector2.new(barX, boxPos.Y + sizeY)
            drawings.HealthOutline.Visible = true

            drawings.HealthBar.From = Vector2.new(barX, boxPos.Y + (sizeY - barHeight))
            drawings.HealthBar.To = Vector2.new(barX, boxPos.Y + sizeY)
            drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 40)
            drawings.HealthBar.Visible = true
        else
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
            drawings.Name.Visible = false
            drawings.HealthBar.Visible = false
            drawings.HealthOutline.Visible = false
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    CreateESP(player)
end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)
RunService.RenderStepped:Connect(UpdateESP)

--================ FLY MOVEMENT ================--
RunService.RenderStepped:Connect(function()
    if Flying and BodyVelocity and BodyGyro and HumanoidRootPart then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

        if dir.Magnitude > 0.1 then
            BodyVelocity.Velocity = dir.Unit * FlySpeed
        else
            BodyVelocity.Velocity = Vector3.zero
        end
        BodyGyro.CFrame = cam.CFrame
    end
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    Flying = false
    ESPEnabled = false
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    if Humanoid then Humanoid.PlatformStand = false end

    for _, drawings in pairs(ESPObjects) do
        for _, v in pairs(drawings) do
            pcall(function() v:Remove() end)
        end
    end
    ScreenGui:Destroy()
end)

-- Respawn support
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    if Flying then
        task.wait(0.4)
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.Parent = HumanoidRootPart
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro.P = 10000
        BodyGyro.Parent = HumanoidRootPart
        Humanoid.PlatformStand = true
    end
end)

print("Darknes Soft | Xeno-Style UI loaded")
