-- AYF | Aimbot Pro - مع علامة دايموند دوارة
-- شغال على دلتا وموبايل

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local players = game:GetService("Players")

-- ========== الإعدادات ==========
local currentTarget = nil
local aimbotActive = true
local smoothness = 0.12
local spinSpeed = 6
local fovRadius = 200
local showFOV = true

-- ========== دوال مساعدة ==========
local function isAlive(p)
    if not p or not p.Character then return false end
    local hum = p.Character:FindFirstChild("Humanoid")
    return hum and hum.Health > 0
end

-- دالة جلب أقرب لاعب
local function getClosestPlayer()
    local closest = nil
    local closestDist = math.huge
    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    
    for _, p in pairs(players:GetPlayers()) do
        if p ~= player and isAlive(p) then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (myPos.Position - char.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = p
                end
            end
        end
    end
    return closest
end

-- تحديث الهدف تلقائياً
local function updateTarget()
    local closest = getClosestPlayer()
    if closest then
        currentTarget = closest
    else
        currentTarget = nil
    end
end

-- ========== دائرة الرسم ==========
local Drawing = nil
pcall(function() Drawing = require(6946391387) end)
if not Drawing then
    pcall(function() Drawing = game:GetService("CoreGui").RobloxGui.Modules.Common.Drawing end)
end

local fovCircle = nil
if Drawing then
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Radius = fovRadius
    fovCircle.Thickness = 2
    fovCircle.Color = Color3.fromRGB(0, 255, 0)
    fovCircle.Filled = false
    fovCircle.NumSides = 60
end

local function updateFOVCircle()
    if not fovCircle then return end
    local mouse = player:GetMouse()
    fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
    fovCircle.Visible = showFOV and aimbotActive
    fovCircle.Radius = fovRadius
end

-- ========== Aim Bot ==========
runService.RenderStepped:Connect(function(deltaTime)
    updateFOVCircle()
    
    if not currentTarget or not isAlive(currentTarget) then
        updateTarget()
    end
    
    if not aimbotActive or not currentTarget or not isAlive(currentTarget) then
        return
    end
    
    local head = currentTarget.Character:FindFirstChild("Head")
    if not head then return end
    
    local targetPos = head.Position
    local cameraPos = camera.CFrame.Position
    local targetDirection = (targetPos - cameraPos).Unit
    local currentDirection = camera.CFrame.LookVector
    
    local maxAnglePerFrame = math.rad(spinSpeed) * (deltaTime * 60)
    local dot = currentDirection:Dot(targetDirection)
    local angle = math.acos(math.clamp(dot, -1, 1))
    
    local t = math.min(1, smoothness * (deltaTime * 60))
    local newDirection = currentDirection:Lerp(targetDirection, t)
    
    camera.CFrame = CFrame.lookAt(cameraPos, cameraPos + newDirection)
end)

-- ========== إنشاء الواجهة ==========
local gui = Instance.new("ScreenGui")
gui.Name = "AYF_Aimbot"
gui.ResetOnSpawn = false
gui.Parent = player:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

-- ========== زر AYF الدائري مع علامة دايموند دوارة فوقه ==========
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(0, 70, 0, 95)
buttonContainer.Position = UDim2.new(0, 10, 0.5, -47)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = gui

-- العلامة ♦ (دايموند) دوارة
local diamond = Instance.new("TextLabel")
diamond.Size = UDim2.new(0, 25, 0, 25)
diamond.Position = UDim2.new(0.5, -12.5, 0, -5)
diamond.BackgroundTransparency = 1
diamond.Text = "♦"
diamond.TextColor3 = Color3.fromRGB(0, 255, 0)
diamond.TextSize = 22
diamond.Font = Enum.Font.GothamBold
diamond.Parent = buttonContainer

-- دوران العلامة (Spin)
local spinAngle = 0
runService.RenderStepped:Connect(function()
    spinAngle = spinAngle + 8
    diamond.Rotation = spinAngle
end)

-- الزر الدائري AYF
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(0.5, -27.5, 0, 15)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openBtn.BackgroundTransparency = 0.1
openBtn.BorderSizePixel = 3
openBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
openBtn.Text = "AYF"
openBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
openBtn.TextScaled = true
openBtn.Font = Enum.Font.GothamBold
openBtn.Parent = buttonContainer

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = openBtn

-- ========== القائمة الرئيسية ==========
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = gui

-- شريط العنوان
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 30, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎯 AYF | Aimbot Pro 🎯"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- محتوى قابل للتمرير
local sc = Instance.new("ScrollingFrame")
sc.Size = UDim2.new(1, 0, 1, -40)
sc.Position = UDim2.new(0, 0, 0, 40)
sc.BackgroundTransparency = 1
sc.BorderSizePixel = 0
sc.ScrollBarThickness = 6
sc.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
sc.Parent = mainFrame

local function addLabel(text, y, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 28)
    lbl.Position = UDim2.new(0.05, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(0, 255, 0)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sc
    return 34
end

local function addButton(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 50, 0)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = sc
    btn.MouseButton1Click:Connect(callback)
    return 46
end

local function addToggle(text, y, isOn, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = text .. (isOn and "  ✅ ON" or "  ❌ OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = sc
    local state = isOn
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(40, 40, 40)
        btn.Text = text .. (state and "  ✅ ON" or "  ❌ OFF")
        callback(state)
    end)
    return 46
end

local function addSlider(text, y, minVal, maxVal, currentVal, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.55, 0, 0, 28)
    lbl.Position = UDim2.new(0.05, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. string.format("%.2f", currentVal)
    lbl.TextColor3 = Color3.fromRGB(150, 255, 150)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sc
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.25, 0, 0, 32)
    box.Position = UDim2.new(0.7, 0, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.fromRGB(0, 200, 0)
    box.Text = tostring(currentVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 13
    box.Font = Enum.Font.GothamSemibold
    box.Parent = sc
    
    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            local newVal = math.clamp(num, minVal, maxVal)
            box.Text = string.format("%.2f", newVal)
            lbl.Text = text .. ": " .. string.format("%.2f", newVal)
            callback(newVal)
        else
            box.Text = tostring(currentVal)
        end
    end)
    return 42
end

-- ========== بناء الواجهة ==========
local y = 10

-- رسالة الترحيب والدسكورد
y = y + addLabel("━━━━━━━━━━━━━━━━━━━━━━", y, Color3.fromRGB(0, 255, 0))
y = y + addLabel("💚 حياك في سيرفر الدسكورد 💚", y, Color3.fromRGB(0, 255, 255))
y = y + addLabel("اشترك عشان تصلك التحديثات", y, Color3.fromRGB(200, 200, 200))
y = y + addButton("📢 انضم للسيرفر (نسخ الرابط)", y, Color3.fromRGB(0, 70, 150), function()
    setclipboard("https://discord.gg/a8KaMAjbN")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ تم النسخ",
        Text = "رابط الدسكورد تم نسخه!",
        Duration = 3
    })
end)
y = y + 10
y = y + addLabel("━━━━━━━━━━━━━━━━━━━━━━", y, Color3.fromRGB(0, 255, 0))

-- معلومات الهدف الحالي
y = y + addLabel("🎯 الهدف الحالي:", y, Color3.fromRGB(0, 255, 200))

local targetNameLabel = Instance.new("TextLabel")
targetNameLabel.Size = UDim2.new(0.9, 0, 0, 35)
targetNameLabel.Position = UDim2.new(0.05, 0, 0, y)
targetNameLabel.BackgroundColor3 = Color3.fromRGB(0, 30, 0)
targetNameLabel.BorderSizePixel = 2
targetNameLabel.BorderColor3 = Color3.fromRGB(0, 200, 0)
targetNameLabel.Text = "جاري البحث عن أقرب لاعب..."
targetNameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
targetNameLabel.TextSize = 13
targetNameLabel.Font = Enum.Font.GothamBold
targetNameLabel.Parent = sc
y = y + 45

-- ========== قائمة كتابة الملاحظة ==========
y = y + addLabel("━━━━━━━━━━━━━━━━━━━━━━", y, Color3.fromRGB(0, 255, 0))
y = y + addLabel("📝 اكتب ملاحظتك:", y, Color3.fromRGB(255, 200, 0))

local noteBox = Instance.new("TextBox")
noteBox.Size = UDim2.new(0.9, 0, 0, 60)
noteBox.Position = UDim2.new(0.05, 0, 0, y)
noteBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
noteBox.BorderSizePixel = 2
noteBox.BorderColor3 = Color3.fromRGB(0, 200, 0)
noteBox.PlaceholderText = "اكتب أي شيء هنا... ستظهر في سيرفر الدسكورد"
noteBox.Text = ""
noteBox.TextColor3 = Color3.fromRGB(255, 255, 255)
noteBox.TextSize = 13
noteBox.Font = Enum.Font.GothamSemibold
noteBox.TextWrapped = true
noteBox.Parent = sc
y = y + 70

-- زر إرسال الملاحظة
local sendNoteBtn = Instance.new("TextButton")
sendNoteBtn.Size = UDim2.new(0.9, 0, 0, 38)
sendNoteBtn.Position = UDim2.new(0.05, 0, 0, y)
sendNoteBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 150)
sendNoteBtn.BorderSizePixel = 2
sendNoteBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
sendNoteBtn.Text = "💬 إرسال الملاحظة للسيرفر"
sendNoteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendNoteBtn.TextSize = 13
sendNoteBtn.Font = Enum.Font.GothamBold
sendNoteBtn.Parent = sc

sendNoteBtn.MouseButton1Click:Connect(function()
    local note = noteBox.Text
    if note == "" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "⚠️ تنبيه",
            Text = "اكتب ملاحظة أولاً",
            Duration = 2
        })
        return
    end
    
    local message = "【AYF Aimbot Pro】\nاللاعب: " .. player.Name .. "\nالملاحظة: " .. note .. "\nالهدف الحالي: " .. (currentTarget and currentTarget.Name or "لا يوجد")
    setclipboard(message)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ تم الإرسال",
        Text = "ملاحظتك تم نسخها، الصقها في سيرفر الدسكورد",
        Duration = 4
    })
    
    noteBox.Text = ""
end)
y = y + 48

-- إعدادات الـ Aimbot
y = y + addLabel("━━━━━━━━━━━━━━━━━━━━━━", y, Color3.fromRGB(0, 255, 0))
y = y + addLabel("⚙️ إعدادات Aimbot", y, Color3.fromRGB(0, 255, 100))

y = y + addToggle("🎯 تشغيل Aim Bot", y, aimbotActive, function(v) aimbotActive = v end)
y = y + addSlider("🌀 سرعة اللف", y, 1, 15, spinSpeed, function(v) spinSpeed = v end)
y = y + addSlider("✨ نعومة التتبع", y, 0.05, 0.4, smoothness, function(v) smoothness = v end)
y = y + addSlider("🔵 نصف قطر الدائرة", y, 50, 400, fovRadius, function(v) 
    fovRadius = v
    if fovCircle then fovCircle.Radius = v end
end)

y = y + addToggle("👁️ إظهار دائرة المدى", y, showFOV, function(v) 
    showFOV = v
    if not v and fovCircle then fovCircle.Visible = false end
end)

y = y + addLabel("━━━━━━━━━━━━━━━━━━━━━━", y, Color3.fromRGB(0, 255, 0))
y = y + addLabel("📖 عن السكربت:", y, Color3.fromRGB(255, 200, 0))
y = y + addLabel("• يختار أقرب لاعب تلقائياً", y, Color3.fromRGB(200, 200, 200))
y = y + addLabel("• إذا مات الهدف ينتقل لغيره", y, Color3.fromRGB(200, 200, 200))
y = y + addLabel("• علامة ♦ دوراة فوق زر AYF", y, Color3.fromRGB(200, 200, 200))
y = y + 30

sc.CanvasSize = UDim2.new(0, 0, 0, y + 40)

-- تحديث اسم الهدف في الواجهة
task.spawn(function()
    while true do
        if currentTarget and isAlive(currentTarget) then
            targetNameLabel.Text = "🎯 " .. currentTarget.Name .. " (حي)"
            targetNameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif currentTarget then
            targetNameLabel.Text = "💀 " .. currentTarget.Name .. " (ميت - جاري البحث عن غيره)"
            targetNameLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
        else
            targetNameLabel.Text = "🔍 لا يوجد لاعبين قريبين"
            targetNameLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
        end
        task.wait(0.5)
    end
end)

-- ========== سحب القائمة ==========
local dragStart, startPos, dragging = nil, nil, false
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
titleBar.InputEnded:Connect(function() dragging = false end)
userInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- سحب الزر الدائري مع العلامة
local containerDragStart, containerStartPos, containerDragging = nil, nil, false
buttonContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        containerDragging = true
        containerDragStart = input.Position
        containerStartPos = buttonContainer.Position
    end
end)
buttonContainer.InputEnded:Connect(function() containerDragging = false end)
userInput.InputChanged:Connect(function(input)
    if containerDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - containerDragStart
        buttonContainer.Position = UDim2.new(containerStartPos.X.Scale, containerStartPos.X.Offset + delta.X, containerStartPos.Y.Scale, containerStartPos.Y.Offset + delta.Y)
    end
end)

-- فتح وإغلاق القائمة
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- إشعار بدء التشغيل
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🎯 AYF Aimbot Pro",
    Text = "علامة ♦ تدور فوق الزر | يختار أقرب لاعب تلقائياً",
    Duration = 5
})
