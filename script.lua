-- AYF Script – Ultimate Edition with Player Image + Tabs (HOME, COMBAT, SETTINGS)
-- Works on Delta Executor (Mobile/PC)

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

-- ========== الإعدادات الأساسية ==========
local lockedTarget = nil
local aimbotActive = true
local autoShootActive = true
local currentSpeed = 50
local currentJump = 100

-- ========== دوال مساعدة ==========
local function isAlive(p)
    if not p or not p.Character then return false end
    local hum = p.Character:FindFirstChild("Humanoid")
    return hum and hum.Health > 0 and hum.Health <= hum.MaxHealth
end

local function findPlayer(partial)
    partial = string.lower(partial)
    for _, p in pairs(game.Players:GetPlayers()) do
        if string.find(string.lower(p.Name), partial, 1, true) or
           (p.DisplayName and string.find(string.lower(p.DisplayName), partial, 1, true)) then
            return p
        end
    end
    return nil
end

local function getAvatarImage(userId)
    return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150"
end

local function applyMovement()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        hum.WalkSpeed = currentSpeed
        hum.JumpPower = currentJump
    end
end

player.CharacterAdded:Connect(function() task.wait(0.5) applyMovement() end)
applyMovement()

-- ========== Aim Bot ==========
runService.RenderStepped:Connect(function()
    if aimbotActive and lockedTarget and isAlive(lockedTarget) then
        local head = lockedTarget.Character:FindFirstChild("Head")
        if head then
            local dir = (head.Position - camera.CFrame.Position).Unit
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, camera.CFrame.Position + dir)
        end
    end
end)

-- ========== Auto Shoot ==========
task.spawn(function()
    while true do
        if autoShootActive and lockedTarget and isAlive(lockedTarget) then
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
        task.wait(0.1)
    end
end)

-- ========== Teleport & Walk ==========
local function teleportToTarget()
    if lockedTarget and isAlive(lockedTarget) then
        local pos = lockedTarget.Character.HumanoidRootPart.Position
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Teleport", Text = "Moved to " .. lockedTarget.Name, Duration = 2})
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "No valid target", Duration = 2})
    end
end

local function walkToTarget()
    if lockedTarget and isAlive(lockedTarget) and player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            hum:MoveTo(lockedTarget.Character.HumanoidRootPart.Position)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Walking", Text = "Moving to " .. lockedTarget.Name, Duration = 2})
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "Cannot walk now", Duration = 2})
    end
end

-- ========== إنشاء الواجهة (GUI) ==========
local gui = Instance.new("ScreenGui")
gui.Name = "AYF_Ultimate"
gui.ResetOnSpawn = false
gui.Parent = player:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 480)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = gui

-- شريط العنوان (للسحب)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 25, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "💚 AYF ULTIMATE 💚"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- ========== التبويبات ==========
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 35)
tabContainer.Position = UDim2.new(0, 0, 0, 35)
tabContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
tabContainer.BorderSizePixel = 1
tabContainer.BorderColor3 = Color3.fromRGB(0, 100, 0)
tabContainer.Parent = mainFrame

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -70)
contentContainer.Position = UDim2.new(0, 0, 0, 70)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- ScrollingFrame لكل تبويب
local tabs = {"🏠 HOME", "⚔️ COMBAT", "⚙️ SETTINGS"}
local tabFrames = {}
local activeTab = 1

for i = 1, 3 do
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(1, 0, 1, 0)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 6
    sc.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
    sc.Visible = (i == 1)
    sc.Parent = contentContainer
    tabFrames[i] = sc
end

-- دوال مساعدة لإنشاء العناصر
local function addButton(parent, y, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return 46
end

local function addToggle(parent, y, text, isOn, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 90, 0) or Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = text .. (isOn and "  ✅ ON" or "  ❌ OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent
    local state = isOn
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 90, 0) or Color3.fromRGB(30, 30, 30)
        btn.Text = text .. (state and "  ✅ ON" or "  ❌ OFF")
        callback(state)
    end)
    return 46
end

local function addLabel(parent, y, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 28)
    lbl.Position = UDim2.new(0.05, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
    lbl.TextSize = 14
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return 36
end

-- ========== تبويب HOME ==========
local yHome = 10

-- صورة اللاعب
local imgFrame = Instance.new("Frame")
imgFrame.Size = UDim2.new(0, 60, 0, 60)
imgFrame.Position = UDim2.new(0.05, 0, 0, yHome)
imgFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
imgFrame.BorderSizePixel = 2
imgFrame.BorderColor3 = Color3.fromRGB(0, 200, 0)
imgFrame.Parent = tabFrames[1]

local targetImage = Instance.new("ImageLabel")
targetImage.Size = UDim2.new(1, -6, 1, -6)
targetImage.Position = UDim2.new(0, 3, 0, 3)
targetImage.BackgroundTransparency = 1
targetImage.Image = "rbxassetid://0"
targetImage.ImageColor3 = Color3.fromRGB(200, 200, 200)
targetImage.Parent = imgFrame

-- مربع إدخال الاسم
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.55, 0, 0, 38)
nameBox.Position = UDim2.new(0.25, 0, 0, yHome + 11)
nameBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
nameBox.BorderSizePixel = 2
nameBox.BorderColor3 = Color3.fromRGB(0, 200, 0)
nameBox.Text = ""
nameBox.PlaceholderText = "Partial name..."
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextSize = 14
nameBox.Font = Enum.Font.GothamSemibold
nameBox.Parent = tabFrames[1]

yHome = yHome + 70

-- أزرار Lock و Unlock
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0.44, 0, 0, 36)
lockBtn.Position = UDim2.new(0.05, 0, 0, yHome)
lockBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
lockBtn.BorderSizePixel = 2
lockBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
lockBtn.Text = "🔒 Lock"
lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lockBtn.TextSize = 14
lockBtn.Font = Enum.Font.GothamBold
lockBtn.Parent = tabFrames[1]

local unlockBtn = Instance.new("TextButton")
unlockBtn.Size = UDim2.new(0.44, 0, 0, 36)
unlockBtn.Position = UDim2.new(0.51, 0, 0, yHome)
unlockBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
unlockBtn.BorderSizePixel = 2
unlockBtn.BorderColor3 = Color3.fromRGB(200, 0, 0)
unlockBtn.Text = "🔓 Unlock"
unlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unlockBtn.TextSize = 14
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.Parent = tabFrames[1]
yHome = yHome + 46

-- حالة الهدف
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 28)
statusLabel.Position = UDim2.new(0.05, 0, 0, yHome)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔒 Target: none"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Parent = tabFrames[1]
yHome = yHome + 36

-- أزرار Teleport و Walk
yHome = yHome + addButton(tabFrames[1], yHome, "✨ Teleport to Target", teleportToTarget)
yHome = yHome + addButton(tabFrames[1], yHome, "🚶 Walk to Target", walkToTarget)

-- وظائف الأزرار
lockBtn.MouseButton1Click:Connect(function()
    local partial = nameBox.Text
    if partial == "" then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "Enter a name", Duration = 2})
        return
    end
    local target = findPlayer(partial)
    if target then
        lockedTarget = target
        targetImage.Image = getAvatarImage(target.UserId)
        targetImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
        statusLabel.Text = "🔒 Target: " .. target.Name
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Locked", Text = target.Name, Duration = 2})
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "Player not found", Duration = 2})
    end
end)

unlockBtn.MouseButton1Click:Connect(function()
    lockedTarget = nil
    targetImage.Image = "rbxassetid://0"
    targetImage.ImageColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.Text = "🔒 Target: none"
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Unlocked", Text = "Target cleared", Duration = 2})
end)

-- تحديث الحالة دورياً
task.spawn(function()
    while true do
        if lockedTarget and isAlive(lockedTarget) then
            statusLabel.Text = "🔒 Target: " .. (lockedTarget.DisplayName or lockedTarget.Name)
        elseif lockedTarget then
            statusLabel.Text = "💀 Target dead: " .. (lockedTarget.DisplayName or lockedTarget.Name)
        else
            statusLabel.Text = "🔒 Target: none"
        end
        task.wait(1)
    end
end)

tabFrames[1].CanvasSize = UDim2.new(0, 0, 0, yHome + 20)

-- ========== تبويب COMBAT ==========
local yCombat = 10
yCombat = yCombat + addToggle(tabFrames[2], yCombat, "🎯 Aim Bot", aimbotActive, function(v) aimbotActive = v end)
yCombat = yCombat + addToggle(tabFrames[2], yCombat, "🔫 Auto Shoot", autoShootActive, function(v) autoShootActive = v end)
yCombat = yCombat + addLabel(tabFrames[2], yCombat, "🏃 Speed Presets")
yCombat = yCombat + addButton(tabFrames[2], yCombat, "Speed 100", function() currentSpeed = 100 applyMovement() end)
yCombat = yCombat + addButton(tabFrames[2], yCombat, "Speed 50", function() currentSpeed = 50 applyMovement() end)
yCombat = yCombat + addButton(tabFrames[2], yCombat, "Speed 16 (Normal)", function() currentSpeed = 16 applyMovement() end)
yCombat = yCombat + addLabel(tabFrames[2], yCombat, "🦘 Jump Presets")
yCombat = yCombat + addButton(tabFrames[2], yCombat, "Jump 200", function() currentJump = 200 applyMovement() end)
yCombat = yCombat + addButton(tabFrames[2], yCombat, "Jump 100", function() currentJump = 100 applyMovement() end)
yCombat = yCombat + addButton(tabFrames[2], yCombat, "Jump 50 (Normal)", function() currentJump = 50 applyMovement() end)
tabFrames[2].CanvasSize = UDim2.new(0, 0, 0, yCombat + 20)

-- ========== تبويب SETTINGS ==========
local ySet = 10
ySet = ySet + addButton(tabFrames[3], ySet, "💬 Join Discord", function()
    setclipboard("https://discord.gg/a8KaMAjbN")
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Discord", Text = "Link copied!", Duration = 2})
end)
ySet = ySet + addButton(tabFrames[3], ySet, "🛑 Disable All", function()
    aimbotActive = false
    autoShootActive = false
    lockedTarget = nil
    targetImage.Image = "rbxassetid://0"
    statusLabel.Text = "🔒 Target: none"
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Disabled", Text = "All features off", Duration = 2})
end)
tabFrames[3].CanvasSize = UDim2.new(0, 0, 0, ySet + 20)

-- ========== أزرار التبويبات ==========
local tabButtons = {}
for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*120, 0, 0)
    btn.BackgroundColor3 = (i == activeTab) and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(0, 25, 0)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabContainer
    tabButtons[i] = btn
    btn.MouseButton1Click:Connect(function()
        tabFrames[activeTab].Visible = false
        tabButtons[activeTab].BackgroundColor3 = Color3.fromRGB(0, 25, 0)
        activeTab = i
        tabFrames[activeTab].Visible = true
        tabButtons[activeTab].BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    end)
end

-- ========== سحب القائمة ==========
local dragStart, startPos, dragging = nil, nil, false
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
titleBar.InputEnded:Connect(function() dragging = false end)
userInput.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ========== زر AYF الدائري ==========
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(0, 15, 0.5, -27.5)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openBtn.BackgroundTransparency = 0.1
openBtn.BorderSizePixel = 3
openBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
openBtn.Text = "AYF"
openBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
openBtn.TextScaled = true
openBtn.Font = Enum.Font.GothamBold
openBtn.ClipsDescendants = true
openBtn.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = openBtn

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- سحب زر AYF
local btnDragStart, btnStartPos, btnDragging = nil, nil, false
openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = openBtn.Position
    end
end)
openBtn.InputEnded:Connect(function() btnDragging = false end)
userInput.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        openBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)

-- إشعار بدء التشغيل
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ AYF ULTIMATE",
    Text = "Click the green AYF button. Lock a target to see their picture!",
    Duration = 5
})
