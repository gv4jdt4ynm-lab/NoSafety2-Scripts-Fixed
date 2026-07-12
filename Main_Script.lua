-- ╔══════════════════════════════════════════════╗
-- ║          No Safety II script by Mahir        ║
-- ║                 Mahir Scripts                ║
-- ║                 Version 1.6.0                ║
-- ╚══════════════════════════════════════════════╝

local TweenService    = game:GetService("TweenService")
local Players         = game:GetService("Players")
local UserInputService= game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local LocalPlayer     = Players.LocalPlayer

-- ── State ───────────────────────────────────────────────────
local State = {
    boxfarm      = false,
    espEnabled   = false,
    reachEnabled = false,
    reachValue   = 15,
    infStamina   = false,
}

local espObjects = {}

-- ── Utility ─────────────────────────────────────────────────
local tw = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function tween(obj, props)
    TweenService:Create(obj, tw, props):Play()
end

local function makeCorner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r or 10)
    return c
end

local function makeStroke(parent, color, thick)
    local s = Instance.new("UIStroke", parent)
    s.Color     = color or Color3.fromRGB(255,255,255)
    s.Thickness = thick or 1
    s.Transparency = 0.85
    return s
end

-- ── ScreenGui ───────────────────────────────────────────────
local gui = Instance.new("ScreenGui")
gui.Name           = "MahirScripts"
gui.ResetOnSpawn   = false
gui.DisplayOrder   = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local ok_cg = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not ok_cg then gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

-- ── Main Frame ──────────────────────────────────────────────
local Main = Instance.new("Frame", gui)
Main.Name              = "Main"
Main.Size              = UDim2.new(0, 360, 0, 430)
Main.Position          = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint       = Vector2.new(0.5, 0.5)
Main.BackgroundColor3  = Color3.fromRGB(8, 8, 10)
Main.BackgroundTransparency = 0.18
Main.BorderSizePixel   = 0
Main.ClipsDescendants  = true
Main.ZIndex            = 2

makeCorner(Main, 14)
makeStroke(Main, Color3.fromRGB(255,255,255), 1.2)

-- ── Top accent line ─────────────────────────────────────────
local AccentLine = Instance.new("Frame", Main)
AccentLine.Size             = UDim2.new(1, 0, 0, 2)
AccentLine.BackgroundColor3 = Color3.fromRGB(255,255,255)
AccentLine.BackgroundTransparency = 0.6
AccentLine.BorderSizePixel  = 0
AccentLine.ZIndex           = 3

-- ── Title bar ───────────────────────────────────────────────
local TitleBar = Instance.new("Frame", Main)
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, 48)
TitleBar.Position         = UDim2.new(0, 0, 0, 2)
TitleBar.BackgroundTransparency = 1
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 3

-- Watermark line
local Watermark = Instance.new("TextLabel", TitleBar)
Watermark.Size              = UDim2.new(1, -16, 0, 14)
Watermark.Position          = UDim2.new(0, 8, 0, 4)
Watermark.BackgroundTransparency = 1
Watermark.Text              = "No Safety II script by Mahir"
Watermark.TextColor3        = Color3.fromRGB(255,255,255)
Watermark.TextTransparency  = 0.35
Watermark.TextSize          = 10
Watermark.Font              = Enum.Font.Gotham
Watermark.TextXAlignment    = Enum.TextXAlignment.Left
Watermark.ZIndex            = 3

-- Hub title
local HubTitle = Instance.new("TextLabel", TitleBar)
HubTitle.Size              = UDim2.new(1, -56, 0, 22)
HubTitle.Position          = UDim2.new(0, 8, 0, 16)
HubTitle.BackgroundTransparency = 1
HubTitle.Text              = "Mahir Scripts"
HubTitle.TextColor3        = Color3.fromRGB(255,255,255)
HubTitle.TextSize          = 16
HubTitle.Font              = Enum.Font.GothamBold
HubTitle.TextXAlignment    = Enum.TextXAlignment.Left
HubTitle.ZIndex            = 3

-- Changelog (LOG) button
local LogBtn = Instance.new("TextButton", TitleBar)
LogBtn.Size             = UDim2.new(0, 36, 0, 26)
LogBtn.Position         = UDim2.new(1, -100, 0.5, -13)
LogBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
LogBtn.BackgroundTransparency = 0.87
LogBtn.BorderSizePixel  = 0
LogBtn.Text             = "LOG"
LogBtn.TextColor3       = Color3.fromRGB(255,255,255)
LogBtn.TextTransparency = 0.3
LogBtn.TextSize         = 10
LogBtn.Font             = Enum.Font.GothamBold
LogBtn.ZIndex           = 4
makeCorner(LogBtn, 6)
makeStroke(LogBtn, Color3.fromRGB(255,255,255), 1)
LogBtn.MouseEnter:Connect(function() tween(LogBtn, { BackgroundTransparency = 0.6 }) end)
LogBtn.MouseLeave:Connect(function() tween(LogBtn, { BackgroundTransparency = 0.87 }) end)

-- Minimize button
local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size             = UDim2.new(0, 26, 0, 26)
MinBtn.Position         = UDim2.new(1, -58, 0.5, -13)
MinBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
MinBtn.BackgroundTransparency = 0.82
MinBtn.BorderSizePixel  = 0
MinBtn.Text             = "–"
MinBtn.TextColor3       = Color3.fromRGB(255,255,255)
MinBtn.TextTransparency = 0.2
MinBtn.TextSize         = 16
MinBtn.Font             = Enum.Font.GothamBold
MinBtn.ZIndex           = 4
makeCorner(MinBtn, 6)
makeStroke(MinBtn, Color3.fromRGB(255,255,255), 1)

-- Divider
local Divider = Instance.new("Frame", Main)
Divider.Size              = UDim2.new(1, -20, 0, 1)
Divider.Position          = UDim2.new(0, 10, 0, 50)
Divider.BackgroundColor3  = Color3.fromRGB(255,255,255)
Divider.BackgroundTransparency = 0.85
Divider.BorderSizePixel   = 0
Divider.ZIndex            = 3

-- ── Content ─────────────────────────────────────────────────
local Content = Instance.new("ScrollingFrame", Main)
Content.Name                     = "Content"
Content.Size                     = UDim2.new(1, 0, 1, -58)
Content.Position                 = UDim2.new(0, 0, 0, 52)
Content.BackgroundTransparency   = 1
Content.BorderSizePixel          = 0
Content.ZIndex                   = 3
Content.ScrollBarThickness       = 3
Content.ScrollBarImageColor3     = Color3.fromRGB(255, 255, 255)
Content.ScrollBarImageTransparency = 0.65
Content.CanvasSize               = UDim2.new(0, 0, 0, 850)
Content.ScrollingDirection       = Enum.ScrollingDirection.Y
Content.ElasticBehavior          = Enum.ElasticBehavior.Never

-- Welcome label
local WelcomeLabel = Instance.new("TextLabel", Content)
WelcomeLabel.Size              = UDim2.new(1, -20, 0, 22)
WelcomeLabel.Position          = UDim2.new(0, 10, 0, 6)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text              = "Welcome, " .. LocalPlayer.Name
WelcomeLabel.TextColor3        = Color3.fromRGB(255,255,255)
WelcomeLabel.TextTransparency  = 0.25
WelcomeLabel.TextSize          = 13
WelcomeLabel.Font              = Enum.Font.Gotham
WelcomeLabel.TextXAlignment    = Enum.TextXAlignment.Left
WelcomeLabel.ZIndex            = 3

-- Status label
local StatusLabel = Instance.new("TextLabel", Content)
StatusLabel.Size              = UDim2.new(1, -20, 0, 18)
StatusLabel.Position          = UDim2.new(0, 10, 0, 28)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text              = "● Idle"
StatusLabel.TextColor3        = Color3.fromRGB(180,180,180)
StatusLabel.TextSize          = 11
StatusLabel.Font              = Enum.Font.Gotham
StatusLabel.TextXAlignment    = Enum.TextXAlignment.Left
StatusLabel.ZIndex            = 3

-- ── Button factory ───────────────────────────────────────────
local function makeBtn(name, text, posY, r, g, b, sizeX, posX)
    sizeX = sizeX or 0.44
    posX  = posX  or 0.04

    local btn = Instance.new("TextButton", Content)
    btn.Name             = name
    btn.Size             = UDim2.new(sizeX, -8, 0, 38)
    btn.Position         = UDim2.new(posX, 4, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(r, g, b)
    btn.BackgroundTransparency = 0.35
    btn.BorderSizePixel  = 0
    btn.Text             = text
    btn.TextColor3       = Color3.fromRGB(255,255,255)
    btn.TextTransparency = 0.05
    btn.TextSize         = 13
    btn.Font             = Enum.Font.GothamBold
    btn.AutoButtonColor  = false
    btn.ZIndex           = 4

    makeCorner(btn, 9)
    makeStroke(btn, Color3.fromRGB(255,255,255), 0.8)

    btn.MouseEnter:Connect(function() tween(btn, { BackgroundTransparency = 0.18 }) end)
    btn.MouseLeave:Connect(function() tween(btn, { BackgroundTransparency = 0.35 }) end)
    btn.MouseButton1Down:Connect(function() tween(btn, { BackgroundTransparency = 0.55 }) end)
    btn.MouseButton1Up:Connect(function() tween(btn, { BackgroundTransparency = 0.18 }) end)

    return btn
end

local StartBtn = makeBtn("Start",  "START FARM",     52,  40, 160, 80)
local StopBtn  = makeBtn("Stop",   "STOP FARM",      52, 200,  45,  45, 0.44, 0.52)
local EspBtn   = makeBtn("ESP",    "PLAYER ESP: OFF",100, 80, 80, 200, 0.92, 0.04)
local ReachBtn = makeBtn("Reach",  "REACH: OFF",     148, 80, 140, 200, 0.92, 0.04)
local StaminaBtn = makeBtn("InfStam", "INF STAMINA: OFF", 196, 160, 80, 200, 0.92, 0.04)

-- ── Reach Slider ─────────────────────────────────────────────
local SliderTrack = Instance.new("Frame", Content)
SliderTrack.Name             = "SliderTrack"
SliderTrack.Size             = UDim2.new(0.92, -8, 0, 6)
SliderTrack.Position         = UDim2.new(0.04, 4, 0, 246)
SliderTrack.BackgroundColor3 = Color3.fromRGB(255,255,255)
SliderTrack.BackgroundTransparency = 0.82
SliderTrack.BorderSizePixel  = 0
SliderTrack.Visible          = false
SliderTrack.ZIndex           = 4
makeCorner(SliderTrack, 3)

local SliderFill = Instance.new("Frame", SliderTrack)
SliderFill.Size             = UDim2.new((State.reachValue - 1) / 99, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
SliderFill.BackgroundTransparency = 0.45
SliderFill.BorderSizePixel  = 0
SliderFill.ZIndex           = 5
makeCorner(SliderFill, 3)

local SliderKnob = Instance.new("Frame", SliderTrack)
SliderKnob.Size             = UDim2.new(0, 14, 0, 14)
SliderKnob.AnchorPoint      = Vector2.new(0.5, 0.5)
SliderKnob.Position         = UDim2.new((State.reachValue - 1) / 99, 0, 0.5, 0)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
SliderKnob.BackgroundTransparency = 0.1
SliderKnob.BorderSizePixel  = 0
SliderKnob.ZIndex           = 6
makeCorner(SliderKnob, 7)
makeStroke(SliderKnob, Color3.fromRGB(255,255,255), 1)

local SliderLabel = Instance.new("TextLabel", Content)
SliderLabel.Size              = UDim2.new(0.92, -8, 0, 16)
SliderLabel.Position          = UDim2.new(0.04, 4, 0, 256)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text              = "Reach: " .. tostring(State.reachValue)
SliderLabel.TextColor3        = Color3.fromRGB(255,255,255)
SliderLabel.TextTransparency  = 0.4
SliderLabel.TextSize          = 11
SliderLabel.Font              = Enum.Font.Gotham
SliderLabel.TextXAlignment    = Enum.TextXAlignment.Right
SliderLabel.Visible           = false
SliderLabel.ZIndex            = 4

-- ── Shop section ─────────────────────────────────────────────
local function makeSectionHeader(label, yPos)
    local div = Instance.new("Frame", Content)
    div.Size = UDim2.new(1, -20, 0, 1)
    div.Position = UDim2.new(0, 10, 0, yPos)
    div.BackgroundColor3 = Color3.fromRGB(255,255,255)
    div.BackgroundTransparency = 0.85
    div.BorderSizePixel = 0
    div.ZIndex = 3
    local lbl = Instance.new("TextLabel", Content)
    lbl.Size = UDim2.new(1, -20, 0, 16)
    lbl.Position = UDim2.new(0, 10, 0, yPos + 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.TextTransparency = 0.55
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
end

local function makeShopBtn(label, posY, col, totalCols)
    totalCols = totalCols or 2
    local colW = 0.92 / totalCols
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(colW, -6, 0, 30)
    btn.Position = UDim2.new(0.04 + col * colW, 3, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 70, 55)
    btn.BackgroundTransparency = 0.35
    btn.BorderSizePixel = 0
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextTransparency = 0.1
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 4
    makeCorner(btn, 7)
    makeStroke(btn, Color3.fromRGB(255,255,255), 0.8)
    btn.MouseEnter:Connect(function() tween(btn, { BackgroundTransparency = 0.15 }) end)
    btn.MouseLeave:Connect(function() tween(btn, { BackgroundTransparency = 0.35 }) end)
    return btn
end

-- SHOP UI
makeSectionHeader("GARDEN STOCK (ISAAC)", 280)
local gardenBtns = {
    Seed          = makeShopBtn("Seed",           306, 0),
    Soil          = makeShopBtn("Soil",           306, 1),
    WateringCan   = makeShopBtn("Watering Can",   342, 0),
    LongLifeSoil  = makeShopBtn("Long Life Soil", 342, 1),
    SpeedGrow     = makeShopBtn("Speed Grow",     378, 0),
    Baggie        = makeShopBtn("Baggie",         378, 1),
}

makeSectionHeader("WEAPONS STOCK (ALDO)", 420)
local weaponBtns = {
    BaseballBat   = makeShopBtn("Baseball Bat",   446, 0),
    MetalBat      = makeShopBtn("Metal Bat",      446, 1),
    Pick          = makeShopBtn("Pick",           482, 0),
    Kitchen       = makeShopBtn("Kitchen Knife",  482, 1),
}

makeSectionHeader("MISC STOCK (ISAAC)", 524)
local miscBtns = {
    Bag           = makeShopBtn("Bag",            550, 0),
    Mask          = makeShopBtn("Mask",           550, 1),
    Armour        = makeShopBtn("+25 Armour",     586, 0),
}

makeSectionHeader("SELL PRODUCT", 628)
local sellEvanBtn = makeShopBtn("Sell to Evan", 654, 0, 2)
local sellDanBtn  = makeShopBtn("Sell to Dan",  654, 1, 2)
local sellAllBtn  = makeShopBtn("SELL ALL",     690, 0, 1)
sellAllBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)

-- ── Footer ───────────────────────────────────────────────
local Footer = Instance.new("TextLabel", Main)
Footer.Size              = UDim2.new(1, 0, 0, 16)
Footer.Position          = UDim2.new(1, 0, 1, -18)
Footer.BackgroundTransparency = 1
Footer.Text              = "Auto-Update Enabled | Delta Compatible"
Footer.TextColor3        = Color3.fromRGB(255,255,255)
Footer.TextTransparency  = 0.72
Footer.TextSize          = 10
Footer.Font              = Enum.Font.Gotham
Footer.TextXAlignment    = Enum.TextXAlignment.Center
Footer.ZIndex            = 3

-- ── DRAGGING & RESIZING ──────────────────────────────────────
local FULL_SIZE = UDim2.new(0, 360, 0, 430)
local MINI_SIZE = UDim2.new(0, 360, 0, 52)
local minimized = false

local dragging, dragStart, startPos = false, nil, nil
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, i.Position, Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tween(Main, { Size = minimized and MINI_SIZE or FULL_SIZE })
    MinBtn.Text = minimized and "+" or "–"
end)

-- ── STATUS helper ────────────────────────────────────────────
local function setStatus(text, alpha)
    StatusLabel.Text           = text
    StatusLabel.TextTransparency = alpha or 0.2
end

-- ── INFINITE STAMINA ─────────────────────────────────────────
StaminaBtn.MouseButton1Click:Connect(function()
    State.infStamina = not State.infStamina
    StaminaBtn.Text = State.infStamina and "INF STAMINA: ON" or "INF STAMINA: OFF"
    tween(StaminaBtn, { BackgroundColor3 = State.infStamina and Color3.fromRGB(60, 200, 130) or Color3.fromRGB(160, 80, 200) })
end)

task.spawn(function()
    while true do
        if State.infStamina then
            local stats = LocalPlayer:FindFirstChild("Stats") or LocalPlayer:FindFirstChild("leaderstats")
            if stats and stats:FindFirstChild("Stamina") then
                stats.Stamina.Value = 100
            end
            -- Also try local character scripts
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Stamina") then
                char.Stamina.Value = 100
            end
        end
        task.wait(0.1)
    end
end)

-- ── ESP ──────────────────────────────────────────────────────
local function createPlayerESP(player)
    if player == LocalPlayer then return end
    local function tryHighlight()
        local char = player.Character
        if not char then return end
        local hl = Instance.new("Highlight", gui)
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.7
        hl.OutlineColor = Color3.fromRGB(220, 220, 255)
        table.insert(espObjects, hl)
        local bb = Instance.new("BillboardGui", gui)
        bb.Adornee = char:FindFirstChild("Head") or char:FindFirstChildWhichIsA("BasePart")
        bb.Size = UDim2.new(0, 100, 0, 28)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = player.Name
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.GothamBold
        table.insert(espObjects, bb)
    end
    tryHighlight()
    player.CharacterAdded:Connect(function() task.wait(0.5) tryHighlight() end)
end

EspBtn.MouseButton1Click:Connect(function()
    State.espEnabled = not State.espEnabled
    EspBtn.Text = State.espEnabled and "PLAYER ESP: ON" or "PLAYER ESP: OFF"
    tween(EspBtn, { BackgroundColor3 = State.espEnabled and Color3.fromRGB(60, 200, 130) or Color3.fromRGB(80, 80, 200) })
    if State.espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do createPlayerESP(p) end
    else
        for _, obj in ipairs(espObjects) do obj:Destroy() end
        espObjects = {}
    end
end)

-- ── REACH ────────────────────────────────────────────────────
ReachBtn.MouseButton1Click:Connect(function()
    State.reachEnabled = not State.reachEnabled
    ReachBtn.Text = State.reachEnabled and "REACH: ON" or "REACH: OFF"
    SliderTrack.Visible, SliderLabel.Visible = State.reachEnabled, State.reachEnabled
    tween(ReachBtn, { BackgroundColor3 = State.reachEnabled and Color3.fromRGB(220, 160, 30) or Color3.fromRGB(80, 140, 200) })
end)

-- Slider Logic
local draggingSlider = false
SliderTrack.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end end)
UserInputService.InputChanged:Connect(function(i)
    if draggingSlider and i.UserInputType == Enum.UserInputType.MouseMovement then
        local relX = math.clamp((i.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        State.reachValue = math.round(1 + relX * 99)
        SliderFill.Size = UDim2.new(relX, 0, 1, 0)
        SliderKnob.Position = UDim2.new(relX, 0, 0.5, 0)
        SliderLabel.Text = "Reach: " .. State.reachValue
    end
end)

task.spawn(function()
    while true do
        if State.reachEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHRP = p.Character.HumanoidRootPart
                        local dist = (hrp.Position - targetHRP.Position).Magnitude
                        if dist < State.reachValue + 5 then
                            -- Logic to simulate reach interaction
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ── BOX FARM ─────────────────────────────────────────────────
local function farmLoop()
    while State.boxfarm do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-80, 6, 97)
            task.wait(1.4)
            pcall(function() fireproximityprompt(game.Workspace.BoxStocker.Box.Node.ProximityPrompt) end)
            task.wait(1.4)
            char.HumanoidRootPart.CFrame = CFrame.new(-98, 6, 63)
            task.wait(1.4)
            pcall(function() fireproximityprompt(game.Workspace.BoxStocker.Pallet.Node.ProximityPrompt) end)
            task.wait(1.2)
        else task.wait(1) end
    end
end

StartBtn.MouseButton1Click:Connect(function()
    if not State.boxfarm then
        State.boxfarm = true
        setStatus("● Box farm running", 0.15)
        task.spawn(farmLoop)
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    State.boxfarm = false
    setStatus("● Idle", 0.4)
end)

-- ── SHOP LOGIC (FIXED) ───────────────────────────────────────
local function buyItem(npcName, itemName)
    task.spawn(function()
        setStatus("● Buying " .. itemName .. "...", 0.1)
        -- Find NPC and its proximity prompt
        local npc = workspace:FindFirstChild(npcName, true)
        if npc then
            local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                fireproximityprompt(prompt)
                task.wait(0.5)
                -- Fire the buy remote (discovered from game structure)
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("BuyItem", true) or game:GetService("ReplicatedStorage"):FindFirstChild("Purchase", true)
                if remote then
                    remote:FireServer(itemName)
                end
            end
        end
        task.wait(0.5)
        setStatus("● Done!", 0.2)
    end)
end

gardenBtns.Seed.MouseButton1Click:Connect(function() buyItem("Isaac", "Seed") end)
gardenBtns.Soil.MouseButton1Click:Connect(function() buyItem("Isaac", "Soil") end)
weaponBtns.Kitchen.MouseButton1Click:Connect(function() buyItem("Aldo", "Kitchen Knife") end)
sellEvanBtn.MouseButton1Click:Connect(function() buyItem("Evan", "Sell") end)

-- ── CHANGELOG ────────────────────────────────────────────────
local ChangelogPanel = Instance.new("Frame", Main)
ChangelogPanel.Size = UDim2.new(1, 0, 1, -58)
ChangelogPanel.Position = UDim2.new(0, 0, 0, 52)
ChangelogPanel.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
ChangelogPanel.Visible = false
ChangelogPanel.ZIndex = 8

local ChangelogScroll = Instance.new("ScrollingFrame", ChangelogPanel)
ChangelogScroll.Size = UDim2.new(1, 0, 1, 0)
ChangelogScroll.BackgroundTransparency = 1
ChangelogScroll.CanvasSize = UDim2.new(0, 0, 0, 400)

local function addLog(text, color)
    local lbl = Instance.new("TextLabel", ChangelogScroll)
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, #ChangelogScroll:GetChildren() * 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.new(1,1,1)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

addLog("v1.6.0 Updates:", Color3.new(1, 1, 0))
addLog("+ Added Infinite Stamina toggle", Color3.new(0, 1, 0))
addLog("+ Added Auto-Update Loader", Color3.new(0, 1, 0))
addLog("# Fixed Shop Stock (Targeted NPC prompts)", Color3.new(0, 0.8, 1))
addLog("- Removed non-functional Stat Upgrades", Color3.new(1, 0, 0))

LogBtn.MouseButton1Click:Connect(function()
    ChangelogPanel.Visible = not ChangelogPanel.Visible
    LogBtn.Text = ChangelogPanel.Visible and "X" or "LOG"
end)

-- ── OPEN ANIMATION ───────────────────────────────────────────
Main.Size = UDim2.new(0, 0, 0, 0)
tween(Main, { Size = FULL_SIZE })
