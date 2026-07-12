-- ╔══════════════════════════════════════════════╗

-- ║ No Safety II script by Mahir ║

-- ║ Mahir Scripts ║

-- ║ Version 1.6.0 ║

-- ╚══════════════════════════════════════════════╝



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local UserInputService = game:GetService("UserInputService")

local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer



-- ── State ───────────────────────────────────────────────────

local State = {
  
    boxfarm = false,
  
    espEnabled = false,
  
    reachEnabled = false,
  
    reachValue = 15,
  
    infStamina = false,
  
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



-- ── Shop & Stamina Logic ────────────────────────────────────

local function buyItem(npcName, itemId)
  
    local npc = workspace:FindFirstChild(npcName)
  
    if npc then
    
        local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
    
        if prompt then
      
            fireproximityprompt(prompt)
      
            task.wait(0.2)
      
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("PurchaseItem", true)
      
            if remote and remote:IsA("RemoteEvent") then
        
                remote:FireServer(itemId)
        
      end
      
    end
    
  end
  
end



RunService.Heartbeat:Connect(function()
    
    if State.infStamina and LocalPlayer.Character then
      
        local stats = LocalPlayer.Character:FindFirstChild("Stats")
      
        if stats and stats:FindFirstChild("Stamina") then
        
            stats.Stamina.Value = 100
        
      end
      
    end
    
  end)



-- ── UI Construction ─────────────────────────────────────────

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

ScreenGui.Name = "MahirHub"



local Main = Instance.new("Frame", ScreenGui)

Main.Size = UDim2.new(0, 450, 0, 300)

Main.Position = UDim2.new(0.5, -225, 0.5, -150)

Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

makeCorner(Main)



local Title = Instance.new("TextLabel", Main)

Title.Size = UDim2.new(1, 0, 0, 40)

Title.Text = "MAHIR HUB | NO SAFETY 2"

Title.TextColor3 = Color3.fromRGB(255, 255, 255)

Title.BackgroundTransparency = 1

Title.Font = Enum.Font.GothamBold

Title.TextSize = 18



local Container = Instance.new("ScrollingFrame", Main)

Container.Size = UDim2.new(1, -20, 1, -60)

Container.Position = UDim2.new(0, 10, 0, 50)

Container.BackgroundTransparency = 1

Container.CanvasSize = UDim2.new(0, 0, 2, 0)

Container.ScrollBarThickness = 2



local function createToggle(name, stateKey, callback)
  
    local btn = Instance.new("TextButton", Container)
  
    btn.Size = UDim2.new(1, 0, 0, 40)
  
    btn.BackgroundColor3 = State[stateKey] and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(40, 40, 40)
  
    btn.Text = name .. ": " .. (State[stateKey] and "ON" or "OFF")
  
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
  
    btn.Font = Enum.Font.Gotham
  
    btn.TextSize = 14
  
    makeCorner(btn, 6)
  

  
    btn.MouseButton1Click:Connect(function()
      
        State[stateKey] = not State[stateKey]
      
        btn.Text = name .. ": " .. (State[stateKey] and "ON" or "OFF")
      
        tween(btn, {BackgroundColor3 = State[stateKey] and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(40, 40, 40)})
      
        if callback then callback(State[stateKey]) end
      
    end)
  
end



createToggle("Infinite Stamina", "infStamina")



local ShopTitle = Instance.new("TextLabel", Container)

ShopTitle.Size = UDim2.new(1, 0, 0, 30)

ShopTitle.Text = "SHOP ACTIONS"

ShopTitle.TextColor3 = Color3.fromRGB(200, 200, 200)

ShopTitle.BackgroundTransparency = 1

ShopTitle.Font = Enum.Font.GothamBold



local function createShopBtn(name, npc, id)
  
    local btn = Instance.new("TextButton", Container)
  
    btn.Size = UDim2.new(1, 0, 0, 35)
  
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
  
    btn.Text = "Buy " .. name
  
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
  
    makeCorner(btn, 4)
  
    btn.MouseButton1Click:Connect(function()
      
        buyItem(npc, id)
      
    end)
  
end



createShopBtn("Seeds (Isaac)", "Isaac", "Seeds")

createShopBtn("Soil (Isaac)", "Isaac", "Soil")

createShopBtn("Knife (Aldo)", "Aldo", "Knife")



local LogBtn = Instance.new("TextButton", Main)

LogBtn.Size = UDim2.new(0, 60, 0, 25)

LogBtn.Position = UDim2.new(1, -70, 0, 10)

LogBtn.Text = "LOG"

LogBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

LogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

makeCorner(LogBtn, 4)



LogBtn.MouseButton1Click:Connect(function()
    
    print("--- CHANGELOG v1.6.0 ---")
    
    print("- Fixed Shop Stock (Isaac/Aldo)")
    
    print("- Added 




























































