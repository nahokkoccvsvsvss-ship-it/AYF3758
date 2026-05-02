-- AYF Script – Tabs + Partial Name Search + Teleport/Walk
-- يعمل على Delta Executor

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local userInput = game:GetService("UserInputService")

-- ========== الإعدادات الأساسية ==========
local aimbotActive = true
local lockedTarget = nil
local currentSpeed = 50
local currentJump = 100
local targetImageLabel = nil

-- ========== دوال مساعدة ==========
local function getAvatarImage(userId)
    return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150"
end

local function isEnemy(p)
    if p == player then return false end
    if not p.Character then return false end
    if not p.Character:FindFirstChild("Humanoid") then return false end
    if p.Character.Humanoid.Health <= 0 then return false end
    if player.Team and p.Team and player.Team == p.Team then return false end
    return true
end

-- البحث عن لاعب بجزء من الاسم (غير حساس لحالة الأحرف)
local function findPlayerByPartialName(partial)
    local lowerPartial = string.lower(partial)
    for _, p in pairs(game.Players:GetPlayers()) do
        local name = string.lower(p.Name)
        local display = string.lower(p.DisplayName or "")
        if string.find(name, lowerPartial, 1, true) or string.find(display, lowerPartial, 1, true) then
            return p
        end
    end
    return nil
end

-- ========== Aim Bot ==========
local function getTarget()
    if lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("Head") and isEnemy(lockedTarget) then
        return lockedTarget.Character.Head
    else
        if lockedTarget then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🚫 هدفخرج", Text = lockedTarget.Name .. " مات أو غادر", Duration = 3})
            lockedTarget = nil
            if targetImageLabel then targetImageLabel.Image = "rbxassetid://0" end
        end
        local closestDist = 400
        local closestHead = nil
        local mousePos = Vector2.new(player:GetMouse().X, player:GetMouse().Y)
        for _, p in pairs(game.Players:GetPlayers()) do
            if isEnemy(p) and p.Character and p.Character:FindFirstChild("Head") then
                local pos, onScreen = camera:WorldToScreenPoint(p.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestHead = p.Character.Head
                    end
                end
            end
        end
        return closestHead
    end
end

runService.RenderStepped:Connect(function()
    if aimbotActive then
        local target = getTarget()
        if target then
            local dir = (target.Position - camera.CFrame.Position).Unit
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, camera.CFrame.Position + dir)
        end
    end
end)

-- ========== Speed & Jump ==========
local function applyMovement()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = currentSpeed
        player.Character.Humanoid.JumpPower = currentJump
    end
end
player.CharacterAdded:Connect(function() task.wait(0.5) applyMovement() end)
applyMovement()

-- ========== مراقبة خروج الهدف ==========
game.Players.PlayerRemoving:Connect(function(p)
    if lockedTarget == p then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🚫 هدفخرج", Text = p.Name .. " غادر السيرفر", Duration = 3})
        lockedTarget = nil
        if targetImageLabel then targetImageLabel.Image = "rbxassetid://0" end
    end
end)

-- ========== دوال التنقل ==========
local function teleportToTarget()
    if lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = lockedTarget.Character.HumanoidRootPart.Position
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "✨ تنقل", Text = "تم الانتقال إلى " .. lockedTarget.Name, Duration = 2})
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "⚠️ خطأ", Text = "لا يوجد هدف مقفول أو الهدف غير متاح", Duration = 2})
    end
end

local function walkToTarget()
    if lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart") and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            local targetPos = lockedTarget.Character.HumanoidRootPart.Position
            local distance = (targetPos - player.Character.HumanoidRootPart.Position).Magnitude
            local duration = distance / (humanoid.WalkSpeed + 10)
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = tweenService:Create(player.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})
            tween:Play()
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🚶 سير", Text = "جارٍ التوجه إلى " .. lockedTarget.Name, Duration = 2})
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "⚠️ خطأ", Text = "لا يمكن السير إلى الهدف حالياً", Duration = 2})
    end
end

-- ========== إنشاء الواجهة الأساسية ==========
local gui = Instance.new("ScreenGui")
gui.Name = "AYF_Tabs"
gui.ResetOnSpawn = false
gui.Parent = player:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 480)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = gui

-- شريط العنوان
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 25, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "💚 AYF SCRIPT 💚"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
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
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
tabContainer.BorderSizePixel = 1
tabContainer.BorderColor3 = Color3.fromRGB(0, 100, 0)
tabContainer.Parent = mainFrame

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -80)
contentContainer.Position = UDim2.new(0, 0, 0, 80)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
scrollingFrame.Parent = contentContainer

-- إنشاء محتويات التبويبات (3)
local tabContents = {}
for i = 1, 3 do
    local sc = Instance.new("ScrollingFrame")
    sc.Size = UDim2.new(1, 0, 1, 0)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 5
    sc.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
    sc.Visible = (i == 1)
    sc.Parent = scrollingFrame
    tabContents[i] = sc
end

-- دوال لإضافة العناصر (أزرار، toggles)
local function addButton(parent, y, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 40)
    btn.Position = UDim2.new(0.04, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return 50
end

local function addToggle(parent, y, text, isOn, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 40)
    btn.Position = UDim2.new(0.04, 0, 0, y)
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
    return 50
end

-- ========== تبويب HOME (البيت) ==========
local yHome = 15

-- مربع إدخال الاسم (مع دعم البحث بجزء من الاسم)
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.92, 0, 0, 40)
nameBox.Position = UDim2.new(0.04, 0, 0, yHome)
nameBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
nameBox.BorderSizePixel = 2
nameBox.BorderColor3 = Color3.fromRGB(0, 200, 0)
nameBox.Text = ""
nameBox.PlaceholderText = "✏️ اكتب جزءاً من اسم اللاعب..."
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextSize = 14
nameBox.Font = Enum.Font.GothamSemibold
nameBox.Parent = tabContents[1]
yHome = yHome + 50

-- إطار الصورة الصغير
local imgFrame = Instance.new("Frame")
imgFrame.Size = UDim2.new(0, 55, 0, 55)
imgFrame.Position = UDim2.new(0.04, 0, 0, yHome)
imgFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
imgFrame.BorderSizePixel = 2
imgFrame.BorderColor3 = Color3.fromRGB(0, 200, 0)
imgFrame.Parent = tabContents[1]

targetImageLabel = Instance.new("ImageLabel")
targetImageLabel.Size = UDim2.new(1, -6, 1, -6)
targetImageLabel.Position = UDim2.new(0, 3, 0, 3)
targetImageLabel.BackgroundTransparency = 1
targetImageLabel.Image = "rbxassetid://0"
targetImageLabel.ImageColor3 = Color3.fromRGB(200, 200, 200)
targetImageLabel.Parent = imgFrame

-- أزرار القفل وفك القفل (بجانب الصورة)
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0.45, 0, 0, 40)
lockBtn.Position = UDim2.new(0.25, 0, 0, yHome + 8)
lockBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 0)
lockBtn.BorderSizePixel = 2
lockBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
lockBtn.Text = "🔒 قفل"
lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lockBtn.TextSize = 14
lockBtn.Font = Enum.Font.GothamBold
lockBtn.Parent = tabContents[1]

local unlockBtn = Instance.new("TextButton")
unlockBtn.Size = UDim2.new(0.45, 0, 0, 40)
unlockBtn.Position = UDim2.new(0.72, 0, 0, yHome + 8)
unlockBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
unlockBtn.BorderSizePixel = 2
unlockBtn.BorderColor3 = Color3.fromRGB(200, 0, 0)
unlockBtn.Text = "🔓 فك"
unlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unlockBtn.TextSize = 14
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.Parent = tabContents[1]
yHome = yHome + 65

-- حالة الهدف
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.92, 0, 0, 25)
statusLabel.Position = UDim2.new(0.04, 0, 0, yHome)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔒 الهدف: لا يوجد"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Parent = tabContents[1]
yHome = yHome + 35

-- أزرار التنقل
yHome = yHome + addButton(tabContents[1], yHome, "✨ الانتقال الفوري إلى الهدف", teleportToTarget)
yHome = yHome + addButton(tabContents[1], yHome, "🚶 السير إلى الهدف", walkToTarget)

-- وظائف القفل (باستخدام البحث بجزء من الاسم)
lockBtn.MouseButton1Click:Connect(function()
    local partial = nameBox.Text
    if partial == "" then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "خطأ", Text = "أدخل جزءاً من اسم اللاعب", Duration = 2})
        return
    end
    local target = findPlayerByPartialName(partial)
    if target then
        lockedTarget = target
        targetImageLabel.Image = getAvatarImage(target.UserId)
        targetImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
        statusLabel.Text = "🔒 الهدف: " .. target.Name
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "✅ تم قفل", Text = target.Name, Duration = 2})
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "❌ خطأ", Text = "لا يوجد لاعب بهذا الاسم", Duration = 2})
    end
end)

unlockBtn.MouseButton1Click:Connect(function()
    lockedTarget = nil
    targetImageLabel.Image = "rbxassetid://0"
    targetImageLabel.ImageColor3 = Color3.fromRGB(150, 150, 150)
    statusLabel.Text = "🔒 الهدف: لا يوجد"
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🔓 فك القفل", Text = "عودة للوضع العادي", Duration = 2})
end)

-- تحديث حالة الهدف دورياً
coroutine.wrap(function()
    while true do
        if lockedTarget then
            statusLabel.Text = "🔒 الهدف: " .. (lockedTarget.DisplayName or lockedTarget.Name)
        else
            statusLabel.Text = "🔒 الهدف: لا يوجد"
        end
        wait(1)
    end
end)()

tabContents[1].CanvasSize = UDim2.new(0, 0, 0, yHome + 20)

-- ========== تبويب COMBAT (القتال) ==========
local yCombat = 15
yCombat = yCombat + addToggle(tabContents[2], yCombat, "🎯 Aim Bot", aimbotActive, function(v) aimbotActive = v end)
yCombat = yCombat + addButton(tabContents[2], yCombat, "🏃 Speed 100", function() currentSpeed = 100 applyMovement() end)
yCombat = yCombat + addButton(tabContents[2], yCombat, "🏃 Speed 50", function() currentSpeed = 50 applyMovement() end)
yCombat = yCombat + addButton(tabContents[2], yCombat, "🏃 Speed Normal (16)", function() currentSpeed = 16 applyMovement() end)
yCombat = yCombat + addButton(tabContents[2], yCombat, "🦘 Jump 200", function() currentJump = 200 applyMovement() end)
yCombat = yCombat + addButton(tabContents[2], yCombat, "🦘 Jump 100", function() currentJump = 100 applyMovement() end)
yCombat = yCombat + addButton(tabContents[2], yCombat, "🦘 Jump Normal (50)", function() currentJump = 50 applyMovement() end)
tabContents[2].CanvasSize = UDim2.new(0, 0, 0, yCombat + 20)

-- ========== تبويب SETTINGS (الإعدادات) ==========
local ySet = 15
ySet = ySet + addButton(tabContents[3], ySet, "💬 Join Discord", function()
    setclipboard("https://discord.gg/a8KaMAjbN")
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Discord", Text = "تم نسخ الرابط!", Duration = 2})
end)
ySet = ySet + addButton(tabContents[3], ySet, "🛑 تعطيل الكل", function()
    aimbotActive = false
    lockedTarget = nil
    targetImageLabel.Image = "rbxassetid://0"
    statusLabel.Text = "🔒 الهدف: لا يوجد"
end)
tabContents[3].CanvasSize = UDim2.new(0, 0, 0, ySet + 20)

-- ========== أزرار التبويبات ==========
local tabs = {"🏠 HOME", "⚔️ COMBAT", "⚙️ SETTINGS"}
local tabButtons = {}
for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 125, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*125, 0, 0)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(0, 25, 0)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabContainer
    tabButtons[i] = btn
    btn.MouseButton1Click:Connect(function()
        for j = 1, #tabContents do
            tabContents[j].Visible = (j == i)
            tabButtons[j].BackgroundColor3 = (j == i) and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(0, 25, 0)
        end
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
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 15, 0.5, -30)
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

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openBtn

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- سحب الزر
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

-- ========== إشعار بدء التشغيل ==========
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ AYF TABS READY",
    Text = "اضغط الزر الأخضر. يمكنك الآن البحث بجزء من الاسم (مثال: 'jo' يجد 'John').",
    Duration = 5
})
