-- ========== سكربت قفل الاشتراك مع قائمة تجديد ==========

local player = game.Players.LocalPlayer
local discordLink = "https://discord.gg/PKBQENppX" -- رابط الديسكورد حقك

-- ========== القائمة الرئيسية (قفل الاشتراك) ==========
local gui = Instance.new("ScreenGui")
gui.Name = "SubscriptionLock"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui") or game:GetService("CoreGui")

-- الخلفية
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.6
overlay.Parent = gui

-- الإطار الرئيسي
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 280)
frame.Position = UDim2.new(0.5, -200, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
frame.BackgroundTransparency = 0.05
frame.ClipsDescendants = true
frame.Parent = overlay

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- الأيقونة
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0.5, -30, 0, 15)
icon.BackgroundTransparency = 1
icon.Text = "⚠️"
icon.TextColor3 = Color3.fromRGB(255, 100, 100)
icon.TextSize = 50
icon.Font = Enum.Font.GothamBold
icon.Parent = frame

-- العنوان
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 20, 0, 80)
title.BackgroundTransparency = 1
title.Text = "❗ اشتراكك منتهي ❗"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- الرسالة
local message = Instance.new("TextLabel")
message.Size = UDim2.new(1, -40, 0, 40)
message.Position = UDim2.new(0, 20, 0, 125)
message.BackgroundTransparency = 1
message.Text = "يرجى الضغط على زر التجديد للاطلاع على طريقة إعادة الاشتراك"
message.TextColor3 = Color3.fromRGB(200, 200, 200)
message.TextSize = 13
message.Font = Enum.Font.GothamSemibold
message.TextWrapped = true
message.TextXAlignment = Enum.TextXAlignment.Center
message.Parent = frame

-- زر التجديد (يفتح قائمة التجديد)
local renewBtn = Instance.new("TextButton")
renewBtn.Size = UDim2.new(0, 200, 0, 45)
renewBtn.Position = UDim2.new(0.5, -100, 0, 185)
renewBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
renewBtn.BorderSizePixel = 1
renewBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
renewBtn.Text = "🔄 تجديد الاشتراك"
renewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
renewBtn.TextSize = 16
renewBtn.Font = Enum.Font.GothamBold
renewBtn.Parent = frame

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(0, 8)
cornerBtn.Parent = renewBtn

-- زر إغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 80, 0, 35)
closeBtn.Position = UDim2.new(0.5, -40, 0, 240)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "إغلاق"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.Parent = frame

local cornerClose = Instance.new("UICorner")
cornerClose.CornerRadius = UDim.new(0, 8)
cornerClose.Parent = closeBtn

-- ========== القائمة المنبثقة للتجديد ==========
local function showRenewGUI()
    local renewGui = Instance.new("ScreenGui")
    renewGui.Name = "RenewGUI"
    renewGui.Parent = player:WaitForChild("PlayerGui") or game:GetService("CoreGui")
    
    -- خلفية
    local renewOverlay = Instance.new("Frame")
    renewOverlay.Size = UDim2.new(1, 0, 1, 0)
    renewOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    renewOverlay.BackgroundTransparency = 0.7
    renewOverlay.Parent = renewGui
    
    -- الإطار
    local renewFrame = Instance.new("Frame")
    renewFrame.Size = UDim2.new(0, 350, 0, 320)
    renewFrame.Position = UDim2.new(0.5, -175, 0.5, -160)
    renewFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    renewFrame.BorderSizePixel = 2
    renewFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
    renewFrame.BackgroundTransparency = 0.05
    renewFrame.Parent = renewOverlay
    
    local renewCorner = Instance.new("UICorner")
    renewCorner.CornerRadius = UDim.new(0, 10)
    renewCorner.Parent = renewFrame
    
    -- عنوان القائمة
    local renewTitle = Instance.new("TextLabel")
    renewTitle.Size = UDim2.new(1, 0, 0, 45)
    renewTitle.Position = UDim2.new(0, 0, 0, 0)
    renewTitle.BackgroundColor3 = Color3.fromRGB(0, 80, 100)
    renewTitle.Text = "🔄 طريقة تجديد الاشتراك"
    renewTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    renewTitle.TextSize = 18
    renewTitle.Font = Enum.Font.GothamBold
    renewTitle.Parent = renewFrame
    
    -- نص التعليمات
    local instructions = Instance.new("TextLabel")
    instructions.Size = UDim2.new(0.9, 0, 0, 100)
    instructions.Position = UDim2.new(0.05, 0, 0, 60)
    instructions.BackgroundTransparency = 1
    instructions.Text = "1️⃣ انضم إلى سيرفر الديسكورد\n2️⃣ اذهب إلى قناة #الاشتراك\n3️⃣ اتبع التعليمات للحصول على كود التفعيل\n4️⃣ أدخل الكود لتفعيل السكربت"
    instructions.TextColor3 = Color3.fromRGB(220, 220, 220)
    instructions.TextSize = 14
    instructions.Font = Enum.Font.GothamSemibold
    instructions.TextXAlignment = Enum.TextXAlignment.Left
    instructions.TextWrapped = true
    instructions.Parent = renewFrame
    
    -- رابط الديسكورد
    local discordFrame = Instance.new("Frame")
    discordFrame.Size = UDim2.new(0.9, 0, 0, 45)
    discordFrame.Position = UDim2.new(0.05, 0, 0, 170)
    discordFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    discordFrame.BorderSizePixel = 1
    discordFrame.BorderColor3 = Color3.fromRGB(100, 100, 150)
    discordFrame.Parent = renewFrame
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 6)
    discordCorner.Parent = discordFrame
    
    local discordText = Instance.new("TextLabel")
    discordText.Size = UDim2.new(0.7, 0, 1, 0)
    discordText.Position = UDim2.new(0, 10, 0, 0)
    discordText.BackgroundTransparency = 1
    discordText.Text = discordLink
    discordText.TextColor3 = Color3.fromRGB(150, 150, 255)
    discordText.TextSize = 12
    discordText.Font = Enum.Font.GothamSemibold
    discordText.TextXAlignment = Enum.TextXAlignment.Left
    discordText.Parent = discordFrame
    
    -- زر نسخ الرابط
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
    copyBtn.Position = UDim2.new(0.73, 0, 0.1, 0)
    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
    copyBtn.Text = "📋 نسخ"
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.TextSize = 12
    copyBtn.Font = Enum.Font.GothamSemibold
    copyBtn.Parent = discordFrame
    
    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 4)
    copyCorner.Parent = copyBtn
    
    copyBtn.MouseButton1Click:Connect(function()
        setclipboard(discordLink)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ تم النسخ",
            Text = "تم نسخ رابط الديسكورد",
            Duration = 2
        })
    end)
    
    -- زر إغلاق القائمة
    local closeRenewBtn = Instance.new("TextButton")
    closeRenewBtn.Size = UDim2.new(0, 100, 0, 35)
    closeRenewBtn.Position = UDim2.new(0.5, -50, 0, 270)
    closeRenewBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    closeRenewBtn.BorderSizePixel = 0
    closeRenewBtn.Text = "إغلاق"
    closeRenewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeRenewBtn.TextSize = 14
    closeRenewBtn.Font = Enum.Font.GothamSemibold
    closeRenewBtn.Parent = renewFrame
    
    local closeRenewCorner = Instance.new("UICorner")
    closeRenewCorner.CornerRadius = UDim.new(0, 8)
    closeRenewCorner.Parent = closeRenewBtn
    
    closeRenewBtn.MouseButton1Click:Connect(function()
        renewGui:Destroy()
    end)
end

-- ========== أحداث الأزرار ==========
renewBtn.MouseButton1Click:Connect(function()
    showRenewGUI()
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- إشعار عند ظهور القائمة
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚠️ تنبيه",
    Text = "اشتراكك منتهي، يرجى إعادة الاشتراك",
    Duration = 5
})
