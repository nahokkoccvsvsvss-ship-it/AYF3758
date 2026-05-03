-- ========== سكربت قفل الاشتراك ==========
-- يظهر للمستخدم رسالة أن اشتراكه انتهى

local player = game.Players.LocalPlayer

-- إنشاء الواجهة الرئيسية
local gui = Instance.new("ScreenGui")
gui.Name = "SubscriptionLock"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui") or game:GetService("CoreGui")

-- الإطار الخلفي (خلفية سوداء شفافة)
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.6
overlay.Parent = gui

-- الإطار الرئيسي للرسالة
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 250)
frame.Position = UDim2.new(0.5, -200, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
frame.BackgroundTransparency = 0.05
frame.ClipsDescendants = true
frame.Parent = overlay

-- زوايا دائرية (اختياري)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- الأيقونة (تحذير)
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0.5, -30, 0, 20)
icon.BackgroundTransparency = 1
icon.Text = "⚠️"
icon.TextColor3 = Color3.fromRGB(255, 100, 100)
icon.TextSize = 50
icon.Font = Enum.Font.GothamBold
icon.Parent = frame

-- عنوان الرسالة
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 20, 0, 90)
title.BackgroundTransparency = 1
title.Text = "❗ اشتراكك منتهي ❗"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- نص الرسالة التفصيلية
local message = Instance.new("TextLabel")
message.Size = UDim2.new(1, -40, 0, 50)
message.Position = UDim2.new(0, 20, 0, 135)
message.BackgroundTransparency = 1
message.Text = "يرجى إعادة الاشتراك للاستمرار في استخدام السكربت."
message.TextColor3 = Color3.fromRGB(200, 200, 200)
message.TextSize = 14
message.Font = Enum.Font.GothamSemibold
message.TextWrapped = true
message.TextXAlignment = Enum.TextXAlignment.Center
message.Parent = frame

-- زر إعادة الاشتراك
local subscribeBtn = Instance.new("TextButton")
subscribeBtn.Size = UDim2.new(0, 150, 0, 40)
subscribeBtn.Position = UDim2.new(0.5, -160, 0, 195)
subscribeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
subscribeBtn.BorderSizePixel = 1
subscribeBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
subscribeBtn.Text = "🔄 إعادة الاشتراك"
subscribeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
subscribeBtn.TextSize = 14
subscribeBtn.Font = Enum.Font.GothamSemibold
subscribeBtn.Parent = frame

-- زر إغلاق (خروج)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 100, 0, 40)
closeBtn.Position = UDim2.new(0.5, 60, 0, 195)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "✕ إغلاق"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.Parent = frame

-- زوايا دائرية للأزرار
local cornerBtn1 = Instance.new("UICorner")
cornerBtn1.CornerRadius = UDim.new(0, 8)
cornerBtn1.Parent = subscribeBtn

local cornerBtn2 = Instance.new("UICorner")
cornerBtn2.CornerRadius = UDim.new(0, 8)
cornerBtn2.Parent = closeBtn

-- وظيفة زر إعادة الاشتراك (عدل الرابط حسب سيرفر الديسكورد حقك)
subscribeBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/رابط_سيرفرك")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔗 رابط الاشتراك",
        Text = "تم نسخ الرابط!",
        Duration = 3
    })
end)

-- وظيفة زر الإغلاق (يغلق القائمة)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- إشعار عند ظهور القائمة
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚠️ تنبيه",
    Text = "اشتراكك منتهي، يرجى إعادة الاشتراك",
    Duration = 5
})
