-- ╔══════════════════════════════════════════════╗
-- ║          No Safety II script by Mahir        ║
-- ║                 Mahir Scripts                ║
-- ║                 Version 1.6.3                ║
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
    walkSpeed    = 16,
    jumpPower    = 50,
}

local espObjects = {}

-- ── Utility ─────────────────────────────────────────────────
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

-- ── Features Logic ──────────────────────────────────────────

-- 1. Infinite Stamina (Fixed)
local function fixStamina()
    if not State.infStamina then return end
    local char = LocalPlayer.Character
    if char then
        local stats = char:FindFirstChild("Stats") or char:FindFirstChild("Data")
        if stats then
            for _, v in pairs(stats:GetChildren()) do
                if v:IsA("ValueBase") and (v.Name:lower():find("stamina") or v.Name:lower():find("energy")) then
                    v.Value = 100
                end
            end
        end
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("ValueBase") and (v.Name:lower():find("stamina") or v.Name:lower():find("energy")) then
                v.Value = 100
            end
        end
    end
end
RunService.Heartbeat:Connect(fixStamina)

-- 2. ESP
local function createESP(part, name)
    if espObjects[part] then return end
    local bg = Instance.new("BillboardGui", part)
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 100, 0, 20)
    bg.Name = "MahirESP"
    
    local tl = Instance.new("TextLabel", bg)
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.Text = name
    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tl.TextStrokeTransparency = 0
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 12
    
    espObjects[part] = bg
end

local function updateESP()
    for part, bg in pairs(espObjects) do
        bg.Enabled = State.espEnabled
    end
end

-- 3. Box Farm
local function doBoxFarm()
    if not State.boxfarm then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("box") or v.Name:lower():find("crate") then
            local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                fireproximityprompt(prompt)
            end
        end
    end
end

-- 4. Shop Logic (Fixed)
local function autoShop(npcName, itemName)
    local npc = workspace:FindFirstChild(npcName)
    if not npc then 
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == npcName and v:IsA("Model") then npc = v break end
        end
    end
    if npc then
        local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            fireproximityprompt(prompt)
            task.wait(0.2)
            for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("buy") or r.Name:lower():find("purchase")) then
                    pcall(function() r:FireServer(itemName) end)
                end
            end
        end
    end
end

-- ── UI Construction ─────────────────────────────────────────
local gui = Instance.new("ScreenGui")
gui.Name = "MahirScripts"
gui.ResetOnSpawn = false
local ok_cg = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not ok_cg then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 340, 0, 450)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
makeCorner(Main, 12)
makeStroke(Main, Color3.fromRGB(255, 255, 255), 1)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "MAHIR HUB | FULL RESTORED"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createToggle(name, stateKey, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = State[stateKey] and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(30, 30, 40)
    btn.Text = name .. ": " .. (State[stateKey] and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    makeCorner(btn, 8)
    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        btn.Text = name .. ": " .. (State[stateKey] and "ON" or "OFF")
        btn.BackgroundColor3 = State[stateKey] and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(30, 30, 40)
        if callback then callback() end
    end)
end

-- ── Adding All Features ──
createToggle("Infinite Stamina", "infStamina")
createToggle("Box Farm", "boxfarm")
createToggle("ESP Enabled", "espEnabled", updateESP)

local SliderLabel = Instance.new("TextLabel", Scroll)
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.Text = "--- SHOP ACTIONS ---"
SliderLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Font = Enum.Font.GothamBold
SliderLabel.TextSize = 12

local function createAction(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    makeCorner(btn, 8)
    btn.MouseButton1Click:Connect(callback)
end

createAction("Buy Seeds (Isaac)", function() autoShop("Isaac", "Seeds") end)
createAction("Buy Soil (Isaac)", function() autoShop("Isaac", "Soil") end)
createAction("Buy Knife (Aldo)", function() autoShop("Aldo", "Knife") end)

-- Main Loops
task.spawn(function()
    while task.wait(1) do
        doBoxFarm()
    end
end)

-- Dragging
local dragging, dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("Mahir Hub v1.6.3 Full Restored Loaded!")
