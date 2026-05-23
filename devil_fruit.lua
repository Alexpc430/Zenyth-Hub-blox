-- // ZENYTH V7 EXTREME ENGINE - KERNEL LEVEL FRUIT DETECTOR
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local TargetGui = (pcall(function() return CoreGui:GetChildren() end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

-- // 1. GESTOR DE MEMORIA Y ESTADOS ABSOLUTOS
local ZenythKernel = {
    Pointers = {},
    Cache = {},
    Active = true,
    Flags = { ESP = false, TweenTP = false, AutoTP = false }
}

local function KillProcess()
    ZenythKernel.Active = false
    for _, conn in ipairs(ZenythKernel.Pointers) do
        if conn.Connected then conn:Disconnect() end
    end
    table.clear(ZenythKernel.Pointers)
    table.clear(ZenythKernel.Cache)
    
    if TargetGui:FindFirstChild("Zenyth_V7_Core") then
        TargetGui.Zenyth_V7_Core:Destroy()
    end
end

KillProcess() -- Pre-limpieza de threads huérfanos

-- // 2. GUI CON MOTOR RENDER LED
local sg = Instance.new("ScreenGui", TargetGui)
sg.Name = "Zenyth_V7_Core"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 340, 0, 340)
Main.Position = UDim2.new(0.5, -170, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(12, 8, 18)
Main.BorderSizePixel = 0
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Borde RGB Mutante (RenderStepped)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
Stroke.Color = Color3.new(1, 1, 1)

local Gradient = Instance.new("UIGradient", Stroke)
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 80)),    -- Carmesí
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 200)), -- Cyan Brillante
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 80))     
})

table.insert(ZenythKernel.Pointers, RunService.RenderStepped:Connect(function(dt)
    Gradient.Rotation = (Gradient.Rotation + (90 * dt)) % 360
end))

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -40, 0, 45)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZENYTH V7 ✦ KERNEL MODE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Lógica de arrastre de ventana matemático puro
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
table.insert(ZenythKernel.Pointers, UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end))

-- // 3. EL FILTRO PERFECTO (LA MAGIA DE BAJO NIVEL)
local ESP_Engine = Instance.new("Folder", sg)
ESP_Engine.Name = "RenderEngine"

local TargetSignatures = {
    "portal", "pain", "lightning", "buddha", "gravity", "mammoth", "t-rex",
    "dough", "spirit", "tiger", "yeti", "kitsune", "control", "dragon", "fruit"
}

-- Esta es la función maestra: evalúa la firma en memoria, no solo el nombre.
local function ValidateObjectSignature(obj)
    -- 1. Verificación de Entidad: Si tiene vida o humanoide, muere aquí.
    if obj:FindFirstChildWhichIsA("Humanoid") or obj:FindFirstChild("HumanoidRootPart") then return false end
    
    -- 2. Verificación de Físicas Recogibles: TODO lo que se recoge en Roblox tiene un "Handle".
    local handle = obj:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return false end

    -- 3. Verificación de Clase: O es una herramienta soltada, o un modelo.
    if not (obj:IsA("Tool") or obj:IsA("Model")) then return false end

    -- 4. Verificación de Nombre.
    local lowerName = string.lower(obj.Name)
    for _, sig in ipairs(TargetSignatures) do
        if string.find(lowerName, sig) then return true, handle end
    end
    
    return false, nil
end

local function MapFruit(obj)
    if ZenythKernel.Cache[obj] then return end
    
    local isValid, corePart = ValidateObjectSignature(obj)
    if not isValid or not corePart then return end

    local bgui = Instance.new("BillboardGui", ESP_Engine)
    bgui.Adornee = corePart
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.AlwaysOnTop = true
    bgui.Enabled = ZenythKernel.Flags.ESP
    
    local txt = Instance.new("TextLabel", bgui)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(0, 255, 200)
    txt.Font = Enum.Font.GothamBlack
    txt.TextSize = 13
    txt.TextStrokeTransparency = 0.3
    txt.Text = "🍎 " .. obj.Name

    ZenythKernel.Cache[obj] = { GUI = bgui, Text = txt, Core = corePart }
end

-- Hookeamos al motor de físicas de Roblox. 0 loops while.
table.insert(ZenythKernel.Pointers, workspace.ChildAdded:Connect(function(child)
    task.defer(function() MapFruit(child) end) 
end))

local FruitFolders = {workspace:FindFirstChild("Fruit"), workspace:FindFirstChild("Fruits")}
for _, folder in ipairs(FruitFolders) do
    if folder then
        table.insert(ZenythKernel.Pointers, folder.ChildAdded:Connect(function(child)
            task.defer(function() MapFruit(child) end)
        end))
    end
end

-- Escaneo Pre-Hook
task.spawn(function()
    for _, v in ipairs(workspace:GetChildren()) do MapFruit(v) end
    for _, folder in ipairs(FruitFolders) do
        if folder then for _, v in ipairs(folder:GetChildren()) do MapFruit(v) end end
    end
end)

-- // 4. THREAD DE CÁLCULO VECTORIAL (HEARTBEAT)
table.insert(ZenythKernel.Pointers, RunService.Heartbeat:Connect(function()
    if not ZenythKernel.Active then return end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local myPos = root.Position

    local closestDist = math.huge
    local targetNode = nil

    for obj, data in pairs(ZenythKernel.Cache) do
        -- Control de destrucción segura
        if not obj or not obj.Parent or not data.Core or not data.Core.Parent then
            if data.GUI then data.GUI:Destroy() end
            ZenythKernel.Cache[obj] = nil
            continue
        end

        data.GUI.Enabled = ZenythKernel.Flags.ESP

        local dist = (myPos - data.Core.Position).Magnitude
        if ZenythKernel.Flags.ESP then
            data.Text.Text = "🍎 " .. obj.Name .. "\n[" .. math.floor(dist) .. "m]"
        end

        if dist < closestDist then
            closestDist = dist
            targetNode = data.Core
        end
    end

    -- Ejecución de TP Bypass
    if ZenythKernel.Flags.AutoTP and targetNode then
        -- Mantenemos la velocidad lineal en 0 para que el servidor no detecte noclip o caída extrema
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        local targetCFrame = targetNode.CFrame * CFrame.new(0, 2.5, 0)
        
        if ZenythKernel.Flags.TweenTP then
            TweenService:Create(root, TweenInfo.new(closestDist / 200, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
        else
            root.CFrame = targetCFrame
        end
    end
end))

-- // 5. COMPONENTES UI MODULARES
local function createModule(name, key)
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, -5, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 15, 28)
    Btn.Text = ""
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel", Btn)
    Lbl.Size = UDim2.new(0, 200, 1, 0)
    Lbl.Position = UDim2.new(0, 15, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("Frame", Btn)
    Switch.Size = UDim2.new(0, 36, 0, 18)
    Switch.Position = UDim2.new(1, -50, 0.5, -9)
    Switch.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Orb = Instance.new("Frame", Switch)
    Orb.Size = UDim2.new(0, 14, 0, 14)
    Orb.Position = UDim2.new(0, 2, 0.5, -7)
    Orb.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Orb).CornerRadius = UDim.new(1, 0)

    Btn.MouseButton1Click:Connect(function()
        ZenythKernel.Flags[key] = not ZenythKernel.Flags[key]
        local state = ZenythKernel.Flags[key]
        
        TweenService:Create(Orb, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.25), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(10, 8, 15)}):Play()
        TweenService:Create(Lbl, TweenInfo.new(0.25), {TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)}):Play()
    end)
end

createModule("Visión Radar (ESP)", "ESP")
createModule("Bypass Movimiento (Tween)", "TweenTP")
createModule("🚀 AUTO RECOLECTOR", "AutoTP")

-- BOTÓN DE MUERTE DEL PROCESO
local KillBtn = Instance.new("TextButton", Main)
KillBtn.Size = UDim2.new(0, 30, 0, 30)
KillBtn.Position = UDim2.new(1, -35, 0, 7)
KillBtn.Text = "✖"
KillBtn.BackgroundTransparency = 1
KillBtn.TextColor3 = Color3.fromRGB(255, 0, 80)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.TextSize = 16
KillBtn.MouseButton1Click:Connect(KillProcess)

-- INYECCIÓN VISUAL
Main.Position = UDim2.new(0.5, -170, 0.6, -170)
Main.GroupTransparency = 1
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -170, 0.5, -170)}):Play()
local fadeFix = Instance.new("CanvasGroup", sg) -- Fix nativo para GroupTransparency global
fadeFix.Size = UDim2.new(1,0,1,0); fadeFix.BackgroundTransparency = 1; Main.Parent = fadeFix
TweenService:Create(fadeFix, TweenInfo.new(0.5), {GroupTransparency = 0}):Play()
