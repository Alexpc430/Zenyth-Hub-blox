-- // ZENYTH DEBUGGER HUB - VILLA DEV EDITION (FRUIT EDITION V4 - MÁXIMA PRECISIÓN)
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Control de ejecución para detener todo al cerrar
local ScriptActivo = true

-- // 1. LIMPIEZA PREVIA
if PlayerGui:FindFirstChild("ZenythFruitHub") then 
    PlayerGui.ZenythFruitHub:Destroy() 
end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZenythFruitHub"
sg.ResetOnSpawn = false

-- // SISTEMA DE NOTIFICACIONES
local NotifContainer = Instance.new("Frame", sg)
NotifContainer.Size = UDim2.new(0, 260, 0.6, 0)
NotifContainer.Position = UDim2.new(1, -270, 0.3, 0)
NotifContainer.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local function EnviarNotificacion(nombreFruta, distancia)
    if not ScriptActivo then return end
    local Notif = Instance.new("Frame", NotifContainer)
    Notif.Size = UDim2.new(1, 0, 0, 60)
    Notif.BackgroundColor3 = Color3.fromRGB(30, 15, 45)
    Notif.BackgroundTransparency = 1
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Notif)
    Stroke.Color = Color3.fromRGB(180, 130, 255)
    Stroke.Thickness = 1.5
    Stroke.Transparency = 1

    local Txt = Instance.new("TextLabel", Notif)
    Txt.Size = UDim2.new(1, -20, 1, 0)
    Txt.Position = UDim2.new(0, 10, 0, 0)
    Txt.BackgroundTransparency = 1
    Txt.Text = "🌟 ¡" .. nombreFruta .. " en el suelo!\nDistancia: " .. tostring(math.floor(distancia)) .. "m"
    Txt.TextColor3 = Color3.fromRGB(255, 220, 100)
    Txt.Font = Enum.Font.GothamBlack
    Txt.TextSize = 14
    Txt.TextXAlignment = Enum.TextXAlignment.Left
    Txt.TextTransparency = 1

    TweenService:Create(Notif, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(Stroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    TweenService:Create(Txt, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    task.delay(6, function()
        if not Notif then return end
        local outTween = TweenService:Create(Notif, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        TweenService:Create(Stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
        TweenService:Create(Txt, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        outTween:Play()
        outTween.Completed:Wait()
        if Notif and Notif.Parent then Notif:Destroy() end
    end)
end

-- // 2. INTERFAZ PRINCIPAL
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 330, 0, 310)
Main.Position = UDim2.new(0.5, -165, 0.5, -155)
Main.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(120, 90, 180)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -80, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zenyth V4 - Fruit Legit Hunter"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 350)
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(120, 90, 180)

local UIListLayout = Instance.new("UIListLayout", Container)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local MiniBtn = Instance.new("TextButton", sg)
MiniBtn.Size = UDim2.new(0, 45, 0, 45)
MiniBtn.Position = UDim2.new(0, 25, 0, 65)
MiniBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
MiniBtn.BackgroundTransparency = 0.15
MiniBtn.Text = "Z"
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextColor3 = Color3.fromRGB(200, 150, 255)
MiniBtn.TextSize = 20
MiniBtn.Active = true
MiniBtn.Visible = false
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)
local MiniStroke = Instance.new("UIStroke", MiniBtn)
MiniStroke.Thickness = 1.5
MiniStroke.Color = Color3.fromRGB(140, 100, 210)

-- ARRASTRE FLUIDO
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- // 3. LÓGICA DE DETECCIÓN ULTRA-FILTRADA
local ActivarESP = false
local MetodoTween = false
local ActivarAutoTP = false
local ESP_Folder = Instance.new("Folder", sg)
ESP_Folder.Name = "Zenyth_ESP_Storage"

local FrutasPermitidas = {
    "portal", "pain", "lightning", "buddha", "gravity", "mammoth", "t-rex",
    "dough", "spirit", "tiger", "yeti", "kitsune", "control", "dragon"
}

local FrutasRegistradas = {}

local function esFrutaValida(v)
    -- FILTRO 1: No es un jugador ni un NPC (evita falsos positivos como el Boss Control o gente con la fruta equipada)
    if v:FindFirstChild("Humanoid") or v:FindFirstChild("Health") then return false end
    if v.Parent and (v.Parent:FindFirstChild("Humanoid") or v.Parent:FindFirstChild("Health")) then return false end
    if v.Parent and v.Parent.Parent and (v.Parent.Parent:FindFirstChild("Humanoid") or v.Parent.Parent:FindFirstChild("Health")) then return false end
    
    -- FILTRO 2: No puede estar dentro de la mochila (Backpack) de nadie
    if v:FindFirstAncestorOfClass("Backpack") then return false end

    -- FILTRO 3: Debe ser un Modelo o una Herramienta suelta en el Workspace
    if not (v:IsA("Model") or v:IsA("Tool") or v:IsA("BasePart")) then return false end

    local nombreLower = string.lower(v.Name)
    
    -- FILTRO 4: Buscar coincidencia exacta con nuestra lista
    for _, frutaReq in ipairs(FrutasPermitidas) do
        if string.find(nombreLower, frutaReq) then
            return true
        end
    end
    
    return false
end

-- Escáner inteligente anti-NPC (Cada 3 segundos)
task.spawn(function()
    while ScriptActivo and task.wait(3) do
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local miPos = char.HumanoidRootPart.Position

        pcall(function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if not ScriptActivo then break end
                
                if not FrutasRegistradas[v] and esFrutaValida(v) then
                    local AdorneePart = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart", true)
                    if not AdorneePart then continue end

                    local pos = AdorneePart.Position
                    local dist = (miPos - pos).Magnitude
                    
                    EnviarNotificacion(v.Name, dist)

                    local bgui = Instance.new("BillboardGui", ESP_Folder)
                    bgui.Adornee = AdorneePart
                    bgui.Size = UDim2.new(0, 200, 0, 50)
                    bgui.AlwaysOnTop = true
                    bgui.ExtentsOffset = Vector3.new(0, 3, 0)
                    bgui.Enabled = ActivarESP
                    
                    local txt = Instance.new("TextLabel", bgui)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(200, 120, 255)
                    txt.Font = Enum.Font.GothamBold
                    txt.TextSize = 14
                    txt.TextStrokeTransparency = 0.2
                    txt.Text = "🍎 " .. v.Name .. "\n[...]"

                    FrutasRegistradas[v] = {Gui = bgui, Texto = txt, CorePart = AdorneePart}
                end
            end
        end)
    end
end)

-- Bucle de Teleport e Interfaz (60 FPS pero optimizado)
local RenderConnection
RenderConnection = RunService.RenderStepped:Connect(function()
    if not ScriptActivo then
        if RenderConnection then RenderConnection:Disconnect() end
        return
    end

    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local miPos = root.Position

    local menorDistancia = math.huge
    local frutaDestino = nil

    -- 1. Actualizar Textos de Distancia y limpiar frutas desaparecidas
    for frutaObj, data in pairs(FrutasRegistradas) do
        -- Si la fruta ya no es válida o la agarraron, se borra de inmediato
        if not frutaObj or not frutaObj.Parent or not data.CorePart or not data.CorePart.Parent or frutaObj:FindFirstAncestorOfClass("Backpack") or (frutaObj.Parent and frutaObj.Parent:FindFirstChild("Humanoid")) then
            if data.Gui then data.Gui:Destroy() end
            FrutasRegistradas[frutaObj] = nil
            continue
        end

        if data.Gui then data.Gui.Enabled = ActivarESP end

        local dist = (miPos - data.CorePart.Position).Magnitude
        if ActivarESP then
            data.Texto.Text = "🍎 " .. frutaObj.Name .. "\n[" .. tostring(math.floor(dist)) .. "m]"
        end

        -- Guardamos la más cercana para el Auto-TP
        if dist < menorDistancia then
            menorDistancia = dist
            frutaDestino = data.CorePart
        end
    end

    -- 2. Sistema Auto-TP (On / Off)
    if ActivarAutoTP and frutaDestino then
        local destinoAjustado = frutaDestino.CFrame * CFrame.new(0, 3, 0)
        if MetodoTween then
            -- Deslizamiento suave continuo
            local velocidad = 130
            local tiempo = menorDistancia / velocidad
            if tiempo < 0.1 then tiempo = 0.1 end
            TweenService:Create(root, TweenInfo.new(tiempo, Enum.EasingStyle.Linear), {CFrame = destinoAjustado}):Play()
            root.Velocity = Vector3.new(0,0,0)
        else
            -- Teleport directo e instantáneo
            root.Velocity = Vector3.new(0,0,0)
            root.CFrame = destinoAjustado
        end
    end
end)

-- // 4. CREADOR DE CONTROLES
local function createToggle(name, callback)
    local toggleState = false
    local BtnFrame = Instance.new("TextButton", Container)
    BtnFrame.Size = UDim2.new(1, -5, 0, 45)
    BtnFrame.BackgroundColor3 = Color3.fromRGB(50, 35, 75)
    BtnFrame.Text = ""
    BtnFrame.Active = true
    BtnFrame.AutoButtonColor = false
    Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", BtnFrame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Track = Instance.new("Frame", BtnFrame)
    Track.Size = UDim2.new(0, 40, 0, 20)
    Track.Position = UDim2.new(1, -55, 0.5, -10)
    Track.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Track)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    BtnFrame.MouseButton1Click:Connect(function()
        if not ScriptActivo then return end
        toggleState = not toggleState
        local targetPos = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = toggleState and Color3.fromRGB(150, 100, 255) or Color3.fromRGB(30, 20, 45)
        
        TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
        TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        
        callback(toggleState)
    end)
end

-- Toggles de Configuración
createToggle("Ver Frutas (ESP Suelo)", function(state)
    ActivarESP = state
end)

createToggle("Modo Deslizar / Tween (On=Suave)", function(state)
    MetodoTween = state
end)

createToggle("🚀 AUTO TELEPORT (On / Off)", function(state)
    ActivarAutoTP = state
end)

-- Botón Cerrar (X) - LIMPIA TODO DE LA MEMORIA Y SE APAGA
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "×"
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(200, 150, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 22
Close.MouseButton1Click:Connect(function() 
    ScriptActivo = false -- Detiene los bucles por completo
    ActivarAutoTP = false
    ActivarESP = false
    
    -- Limpieza física del juego
    if RenderConnection then RenderConnection:Disconnect() end
    for _, data in pairs(FrutasRegistradas) do
        if data.Gui then data.Gui:Destroy() end
    end
    FrutasRegistradas = {}
    sg:Destroy() 
end)

-- Botón Minimizar (-)
local Minimize = Instance.new("TextButton", Main)
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -65, 0, 5)
Minimize.Text = "-"
Minimize.BackgroundTransparency = 1
Minimize.TextColor3 = Color3.fromRGB(200, 150, 255)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 22
Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniBtn.Visible = true
end)

MiniBtn.MouseButton1Click:Connect(function()
    MiniBtn.Visible = false
    Main.Visible = true
end)

-- Animación de Entrada
local OriginalPosition = Main.Position
Main.Position = UDim2.new(OriginalPosition.X.Scale, OriginalPosition.X.Offset, 0, -350)
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = OriginalPosition}):Play()
