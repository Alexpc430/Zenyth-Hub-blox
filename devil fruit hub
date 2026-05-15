-- // ZENYTH DEBUGGER HUB - VILLA DEV EDITION (FRUIT EDITION)
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // 1. LIMPIEZA
if PlayerGui:FindFirstChild("ZenythFruitHub") then 
    PlayerGui.ZenythFruitHub:Destroy() 
end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "ZenythFruitHub"
sg.ResetOnSpawn = false

-- // 2. INTERFAZ PRINCIPAL (Estilo Morado Transparente)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 330, 0, 310) -- Un poco más alto para meter las nuevas opciones
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

-- Título Superior Izquierda
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -80, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zenyth V1 - Fruit Hunter"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Contenedor de Toggles (Scroll por si agregas más en el futuro)
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

-- LOGO DE MINIMIZADO ("Z")
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

-- // SISTEMA DE ARRASTRE FLUIDO (MÓVIL Y PC)
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- // 3. LÓGICA DE DETECCIÓN Y TELETRANSPORTE
local ActivarESP = false
local MetodoTween = false
local ESP_Folder = Instance.new("Folder", sg)
ESP_Folder.Name = "Zenyth_ESP_Storage"

-- Buscador de frutas inteligente en el Workspace
local function obtenerFrutaMasCercana()
    local frutaCercana = nil
    local menorDistancia = math.huge
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, v in pairs(workspace:GetDescendants()) do
        -- Busca si el nombre contiene "fruit", "Fruit" o "Devil"
        if v:IsA("BasePart") or v:IsA("Model") then
            local nombre = string.lower(v.Name)
            if string.find(nombre, "fruit") or string.find(nombre, "devil") then
                local pos = v:IsA("BasePart") and v.Position or v:GetPivot().Position
                local dist = (char.HumanoidRootPart.Position - pos).Magnitude
                
                if dist < menorDistancia then
                    menorDistancia = dist
                    frutaCercana = v
                end
            end
        end
    end
    return frutaCercana, menorDistancia
end

-- Función de Teletransporte Integrada
local function ejecutarTeleport()
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local fruta, dist = obtenerFrutaMasCercana()
    if notfruta then 
        warn("❌ No se encontraron frutas en el mapa actualmente.")
        return 
    end
    
    local destinoPos = fruta:IsA("BasePart") and fruta.CFrame or fruta:GetPivot()
    -- Colocamos al jugador un poquito arriba de la fruta para no bugearse con el suelo
    local destinoAjustado = destinoPos * CFrame.new(0, 3, 0) 

    if MetodoTween then
        -- Modo de deslizamiento suave (Seguro anti-kick)
        local velocidad = 150 -- Studs por segundo
        local tiempo = dist / velocidad
        local info = TweenInfo.new(tiempo, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, info, {CFrame = destinoAjustado})
        
        -- Detener velocidades físicas mientras dura el viaje para que no caiga
        root.Velocity = Vector3.new(0,0,0)
        tween:Play()
    else
        -- Modo Instantáneo Seguro (Conserva estabilidad física)
        root.Velocity = Vector3.new(0,0,0)
        root.CFrame = destinoAjustado
    end
end

-- Bucle del Sistema ESP (Distancia y nombres flotantes)
RunService.RenderStepped:Connect(function()
    ESP_Folder:ClearAllChildren()
    if not ActivarESP or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local miPos = Player.Character.HumanoidRootPart.Position
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            local nombre = v.Name
            local nombreLower = string.lower(nombre)
            
            if string.find(nombreLower, "fruit") or string.find(nombreLower, "devil") then
                local pos = v:IsA("BasePart") and v.Position or v:GetPivot().Position
                local dist = math.floor((miPos - pos).Magnitude)
                
                -- Crear el Tag visual encima de la fruta
                local AdorneePart = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart", true)
                if AdorneePart then
                    local bgui = Instance.new("BillboardGui", ESP_Folder)
                    bgui.Adornee = AdorneePart
                    bgui.Size = UDim2.new(0, 200, 0, 50)
                    bgui.AlwaysOnTop = true
                    bgui.ExtentsOffset = Vector3.new(0, 3, 0)
                    
                    local txt = Instance.new("TextLabel", bgui)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "🍎 " .. nombre .. "\n[" .. tostring(dist) .. "m]"
                    txt.TextColor3 = Color3.fromRGB(200, 120, 255) -- Color morado neón
                    txt.Font = Enum.Font.GothamBold
                    txt.TextSize = 14
                    txt.TextStrokeTransparency = 0.2
                end
            end
        end
    end
end)

-- // 4. COMPONENTES INTERNOS (CREADOR DE BOTONES Y TOGGLES)
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
        toggleState = not toggleState
        local targetPos = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = toggleState and Color3.fromRGB(150, 100, 255) or Color3.fromRGB(30, 20, 45)
        
        TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
        TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        
        callback(toggleState)
    end)
end

local function createActionButton(name, callback)
    local ActionBtn = Instance.new("TextButton", Container)
    ActionBtn.Size = UDim2.new(1, -5, 0, 45)
    ActionBtn.BackgroundColor3 = Color3.fromRGB(100, 65, 165) -- Color de acción destacado
    ActionBtn.Text = name
    ActionBtn.Font = Enum.Font.GothamBold
    ActionBtn.TextColor3 = Color3.new(1, 1, 1)
    ActionBtn.TextSize = 14
    ActionBtn.Active = true
    Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 8)
    
    ActionBtn.MouseButton1Click:Connect(callback)
end

-- Generar Controles en el Menú
createToggle("Ver Frutas (ESP + Distancia)", function(state)
    ActivarESP = state
end)

createToggle("Modo Deslizar / Tween (On=Suave)", function(state)
    MetodoTween = state
end)

createActionButton("⚡ TELEPORT A LA FRUTA", function()
    ejecutarTeleport()
end)

-- Botón Cerrar (X)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "×"
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(200, 150, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 22
Close.Active = true
Close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Botón Minimizar (-)
local Minimize = Instance.new("TextButton", Main)
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -65, 0, 5)
Minimize.Text = "-"
Minimize.BackgroundTransparency = 1
Minimize.TextColor3 = Color3.fromRGB(200, 150, 255)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 22
Minimize.Active = true

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniBtn.Visible = true
end)

MiniBtn.MouseButton1Click:Connect(function()
    MiniBtn.Visible = false
    Main.Visible = true
end)

-- // 5. ANIMACIÓN INICIAL DE ENTRADA
local OriginalPosition = Main.Position
Main.Position = UDim2.new(OriginalPosition.X.Scale, OriginalPosition.X.Offset, 0, -350)
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = OriginalPosition}):Play()
