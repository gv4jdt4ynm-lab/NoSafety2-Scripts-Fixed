-- ╔══════════════════════════════════════════════╗
-- ║          No Safety II script by Mahir        ║
-- ║                 Mahir Scripts                ║
-- ║                 Version 1.6.1                ║
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
    autoBuy      = false,
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

-- ── Improved Stamina Logic ──────────────────────────────────
-- Searching for stamina in multiple common locations
local function fixStamina()
    if not State.infStamina then return end
    
    -- Check Character for "Stats" folder or direct values
    local char = LocalPlayer.Character
    if char then
        -- Method 1: Common Stats folder
        local stats = char:FindFirstChild("Stats") or char:FindFirstChild("Data")
        if stats then
            for _, v in pairs(stats:GetChildren()) do
                if v:IsA("NumberValue") or v:IsA("IntValue") then
                    if v.Name:lower():find("stamina") or v.Name:lower():find("energy") or v.Name:lower():find("sprint") then
                        v.Value = 100
                    end
                end
            end
        end
        
        -- Method 2: Direct children of character (some games do this)
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                if v.Name:lower():find("stamina") or v.Name:lower():find("energy") then
                    v.Value = 100
                end
            end
        end
    end
    
    -- Method 3: PlayerGui bars (some games store value in a script variable, we can't touch that easily, 
    -- but we can try to find the ObjectValue if it exists)
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then
        local staminaGui = pgui:FindFirstChild("Stamina", true) or pgui:FindFirstChild("Energy", true)
        if staminaGui and staminaGui:FindFirstChildWhichIsA("ValueBase", true) then
            local val = staminaGui:FindFirstChildWhichIsA("ValueBase", true)
            if val.Name:lower():find("stamina") or val.Name:lower():find("val") then
                val.Value = 100
            end
        end
    end
end

RunService.Heartbeat:Connect(fixStamina)

-- ── Improved Shop Logic ─────────────────────────────────────
-- No Safety 2 often uses ProximityPrompts that fire a RemoteEvent.
-- We will try to find the remote by scanning the NPC's interactions.
local function autoShop(npcName, itemName)
    local npc = workspace:FindFirstChild(npcName)
    if not npc then 
        -- Try searching for NPC in folders
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == npcName and v:IsA("Model") then
                npc = v
                break
            end
        end
    end

    if npc then
        local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            fireproximityprompt(prompt)
            task.wait(0.3)
            
            -- Scan ReplicatedStorage for any purchase-related remotes
            -- Many games use "BuyItem", "Purchase", or even obfuscated names.
            -- We'll try to find the most likely candidate.
            local remotes = {}
            for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if r:IsA("RemoteEvent") then
                    local n = r.Name:lower()
                    if n:find("buy") or n:find("purchase") or n:find("shop") or n:find("item") then
                        table.insert(remotes, r)
                    end
                end
            end
            
            -- Fire the first 3 likely candidates (brute force approach if exact name unknown)
            for _, remote in ipairs(remotes) do
                pcall(function()
                    remote:FireServer(itemName)
                end)
            end
        end
    end
end

-- ── UI Construction ─────────────────────────────────────────
local gui = Instance.new("ScreenGui")
gui.Name           = "MahirScripts"
gui.ResetOnSpawn   = false
gui.DisplayOrder   = 999
local ok_cg = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not ok_cg then gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame", gui)
Main.Size              = UDim2.new(0, 360, 0, 400)
Main.Position          = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint       = Vector2.new(0.5, 0.5)
Main.BackgroundColor3  = Color3.fromRGB(12, 12, 15)
makeCorner(Main, 12)
makeStroke(Main, Color3.fromRGB(255, 255, 255), 1)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MAHIR HUB | NO SAFETY 2 (FIXED)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 2

local function createToggle(name, stateKey)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = State[stateKey] and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(30, 30, 35)
    btn.Text = name .. ": " .. (State[stateKey] and "ENABLED" or "DISABLED")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    makeCorner(btn, 8)
    
    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        btn.Text = name .. ": " .. (State[stateKey] and "ENABLED" or "DISABLED")
        tween(btn, {BackgroundColor3 = State[stateKey] and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(30, 30, 35)})
    end)
end

createToggle("Infinite Stamina", "infStamina")

local Divider = Instance.new("Frame", Container)
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Divider.BorderSizePixel = 0

local ShopLabel = Instance.new("TextLabel", Container)
ShopLabel.Size = UDim2.new(1, 0, 0, 30)
ShopLabel.Text = "SHOP ACTIONS (ISAAC / ALDO)"
ShopLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
ShopLabel.BackgroundTransparency = 1
ShopLabel.Font = Enum.Font.GothamBold
ShopLabel.TextSize = 12

local function createShopBtn(name, npc, item)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = "Buy " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    makeCorner(btn, 6)
    btn.MouseButton1Click:Connect(function()
        autoShop(npc, item)
    end)
end

createShopBtn("Seeds (Isaac)", "Isaac", "Seeds")
createShopBtn("Soil (Isaac)", "Isaac", "Soil")
createShopBtn("Knife (Aldo)", "Aldo", "Knife")

-- Dragging logic
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

print("Mahir Hub v1.6.1 Loaded!")
