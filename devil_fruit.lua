local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local TargetGui = (pcall(function() return CoreGui:GetChildren() end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

-- // 1. GERMANEJO DE MEMORIA Y ESTADOS
local ZenythMemory = {
    Connections = {},
    RegisteredFruits = {},
    IsActive = true,
    Settings = { ESP = false, TweenTP = false, AutoTP = false }
}

local function DisconnectAll()
    ZenythMemory.IsActive = false
    for _, connection in ipairs(ZenythMemory.Connections) do
        if connection.Connected then connection:Disconnect() end
    end
    table.clear(ZenythMemory.Connections)
    table.clear(ZenythMemory.RegisteredFruits)
    
    if TargetGui:FindFirstChild("ZenythFruitHub_PRO") then
        TargetGui.ZenythFruitHub_PRO:Destroy()
    end
end

DisconnectAll() -- Limpieza preventiva para evitar superposiciones

-- // 2. INTERFAZ GRÁFICA (UI) CON LED RGB
local sg = Instance.new("ScreenGui", TargetGui)
sg.Name = "ZenythFruitHub_PRO"
sg.ResetOnSpawn = false

-- CONTENEDOR DE NOTIFICACIONES
local NotifContainer = Instance.new("Frame", sg)
NotifContainer.Size = UDim2.new(0, 250, 0.7, 0)
NotifContainer.Position = UDim2.new(1, -270, 0.15, 0)
NotifContainer.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local function ShowNotification(fruitName)
    if not ZenythMemory.IsActive then return end
    
    local Notif = Instance.new("Frame", NotifContainer)
    Notif.Size = UDim2.new(1, 0, 0, 50)
    Notif.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
    Notif.BackgroundTransparency = 0.2
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 8)

    local NStroke = Instance.new("UIStroke", Notif)
    NStroke.Color = Color3.fromRGB(0, 255, 255)
    NStroke.Thickness = 1.5

    local Icon = Instance.new("TextLabel", Notif)
    Icon.Size = UDim2.new(0, 40, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = "⚡"
    Icon.TextColor3 = Color3.fromRGB(0, 255, 255)
    Icon.Font = Enum.Font.GothamBlack
    Icon.TextSize = 18

    local Txt = Instance.new("TextLabel", Notif)
    Txt.Size = UDim2.new(1, -40, 1, 0)
    Txt.Position = UDim2.new(0, 40, 0, 0)
    Txt.BackgroundTransparency = 1
    Txt.Text = "¡Nueva " .. fruitName .. " detectada!"
    Txt.TextColor3 = Color3.new(1, 1, 1)
    Txt.Font = Enum.Font.GothamMedium
    Txt.TextSize = 13
    Txt.TextXAlignment = Enum.TextXAlignment.Left

    task.delay(6, function()
        if Notif and Notif.Parent then Notif:Destroy() end
    end)
end

-- VENTANA PRINCIPAL
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 340, 0, 330)
Main.Position = UDim2.new(0.5, -170, 0.5, -165)
Main.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- EFECTO LED RGB CONTINUO
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2.5
Stroke.Color = Color3.new(1, 1, 1)

local Gradient = Instance.new("UIGradient", Stroke)
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 127)),   
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 127))    
})

table.insert(ZenythMemory.Connections, RunService.RenderStepped:Connect(function(deltaTime)
    Gradient.Rotation = (Gradient.Rotation + (120 * deltaTime)) % 360
end))

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -40, 0, 45)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZENYTH V6.2 ✦ FRUIT LEGIT"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 250)
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Arrastre del Menú
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
Main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
table.insert(ZenythMemory.Connections, UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end))

-- // 3. LÓGICA DE EVENTOS (EVENT-DRIVEN DETECTION)
local ESP_Folder = Instance.new("Folder", sg)
ESP_Folder.Name = "Zenyth_Render_Engine"

local ValidFruits = {
    "portal", "pain", "lightning", "buddha", "gravity", "mammoth", "t-rex",
    "dough", "spirit", "tiger", "yeti", "kitsune", "control", "dragon"
}

local function IsValidFruitTarget(obj)
    if not (obj:IsA("Model") or obj:IsA("Tool")) then return false end
    if obj:FindFirstChildOfClass("Humanoid") or obj:FindFirstChild("Health") then return false end
    
    local lowerName = string.lower(obj.Name)
    for _, fruitName in ipairs(ValidFruits) do
        if string.find(lowerName, fruitName) then return true end
    end
    return false
end

local function RegisterFruit(obj, isNewSpawn)
    if ZenythMemory.RegisteredFruits[obj] then return end
    if not IsValidFruitTarget(obj) then return end

    local corePart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
    if not corePart then return end

    local bgui = Instance.new("BillboardGui", ESP_Folder)
    bgui.Adornee = corePart
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.AlwaysOnTop = true
    bgui.ExtentsOffset = Vector3.new(0, 2, 0)
    bgui.Enabled = ZenythMemory.Settings.ESP
    
    local txt = Instance.new("TextLabel", bgui)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(0, 255, 255)
    txt.Font = Enum.Font.GothamBlack
    txt.TextSize = 13
    txt.TextStrokeTransparency = 0
    txt.Text = "⚡ " .. obj.Name

    ZenythMemory.RegisteredFruits[obj] = { UI = bgui, Text = txt, Part = corePart }
    
    if isNewSpawn then
        ShowNotification(obj.Name)
    end
end

-- Suscripción limpia a eventos del motor
table.insert(ZenythMemory.Connections, workspace.ChildAdded:Connect(function(child)
    task.defer(function() RegisterFruit(child, true) end) 
end))

local bloxFruitsFolder = workspace:FindFirstChild("Fruit") or workspace:FindFirstChild("Fruits")
if bloxFruitsFolder then
    table.insert(ZenythMemory.Connections, bloxFruitsFolder.ChildAdded:Connect(function(child)
        task.defer(function() RegisterFruit(child, true) end)
    end))
end

-- Escaneo de inicio de sesión único
task.spawn(function()
    for _, v in ipairs(workspace:GetChildren()) do RegisterFruit(v, false) end
    if bloxFruitsFolder then
        for _, v in ipairs(bloxFruitsFolder:GetChildren()) do RegisterFruit(v, false) end
    end
end)

-- // 4. CONTROLADOR DE FÍSICAS REPETITIVAS (HEARTBEAT)
table.insert(ZenythMemory.Connections, RunService.Heartbeat:Connect(function()
    if not ZenythMemory.IsActive then return end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local myPos = root and root.Position

    local closestDist = math.huge
    local targetPart = nil

    for obj, data in pairs(ZenythMemory.RegisteredFruits) do
        if not obj or not obj.Parent or not data.Part or not data.Part.Parent or obj.Parent:FindFirstChildOfClass("Humanoid") then
            if data.UI then data.UI:Destroy() end
            ZenythMemory.RegisteredFruits[obj] = nil
            continue
        end

        data.UI.Enabled = ZenythMemory.Settings.ESP

        if myPos then
            local dist = (myPos - data.Part.Position).Magnitude
            if ZenythMemory.Settings.ESP then
                data.Text.Text = "⚡ " .. obj.Name .. "\n[" .. math.floor(dist) .. "m]"
            end

            if dist < closestDist then
                closestDist = dist
                targetPart = data.Part
            end
        end
    end

    if ZenythMemory.Settings.AutoTP and targetPart and root then
        local targetCFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
        root.Velocity = Vector3.new(0, 0, 0) 
        
        if ZenythMemory.Settings.TweenTP then
            TweenService:Create(root, TweenInfo.new(closestDist / 150, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
        else
            root.CFrame = targetCFrame
        end
    end
end))

-- // 5. COMPONENTES DE CONTROL
local function createToggle(name, settingKey)
    local BtnFrame = Instance.new("TextButton", Container)
    BtnFrame.Size = UDim2.new(1, -5, 0, 45)
    BtnFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
    BtnFrame.Text = ""
    Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)
    
    local StrokeBtn = Instance.new("UIStroke", BtnFrame)
    StrokeBtn.Color = Color3.fromRGB(50, 40, 70)

    local Label = Instance.new("TextLabel", BtnFrame)
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Track = Instance.new("Frame", BtnFrame)
    Track.Size = UDim2.new(0, 40, 0, 20)
    Track.Position = UDim2.new(1, -55, 0.5, -10)
    Track.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Track)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    BtnFrame.MouseButton1Click:Connect(function()
        ZenythMemory.Settings[settingKey] = not ZenythMemory.Settings[settingKey]
        local state = ZenythMemory.Settings[settingKey]
        
        TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(Track, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(15, 10, 20)}):Play()
    end)
end

createToggle("Visor de Frutas (ESP)", "ESP")
createToggle("Deslizamiento Bypass (Tween)", "TweenTP")
createToggle("🚀 AUTO-TP A LA FRUTA", "AutoTP")

-- BOTÓN DE CIERRE LIMPIO (X)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 7)
Close.Text = "✖"
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(255, 50, 100)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.MouseButton1Click:Connect(DisconnectAll)

-- ANIMACIÓN DE ENTRADA CORREGIDA
Main.Position = UDim2.new(0.5, -170, 0.6, -165)
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -170, 0.5, -165)}):Play()
