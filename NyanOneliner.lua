-- NYAN UI Library - Максимально простой пример
-- Этот файл должен гарантированно работать через loadstring

-- Создаем окно
local window = {
    Title = "NYAN UI",
    Theme = "Nyan",
    Size = {450, 300}
}

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NYAN_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Защита GUI если возможно
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Создаем основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(window.Size[1], window.Size[2])
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Добавляем скругление углов
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Создаем заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Скругление для заголовка
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Исправление скругления внизу заголовка
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 10)
TitleFix.Position = UDim2.new(0, 0, 1, -5)
TitleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 0
TitleFix.Parent = TitleBar

-- Текст заголовка
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -35, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = window.Title
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Создаем приветственное сообщение
local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, -40, 0, 30)
WelcomeLabel.Position = UDim2.new(0, 20, 0, 50)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Font = Enum.Font.GothamBold
WelcomeLabel.Text = "NYAN UI Library успешно загружена!"
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
WelcomeLabel.TextSize = 18
WelcomeLabel.Parent = MainFrame

-- Создаем описание
local DescriptionLabel = Instance.new("TextLabel")
DescriptionLabel.Size = UDim2.new(1, -40, 0, 60)
DescriptionLabel.Position = UDim2.new(0, 20, 0, 90)
DescriptionLabel.BackgroundTransparency = 1
DescriptionLabel.Font = Enum.Font.Gotham
DescriptionLabel.Text = "Полная версия библиотеки доступна в репозитории GitHub. Для использования всех функций импортируйте NyanStandalone.lua напрямую."
DescriptionLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
DescriptionLabel.TextSize = 14
DescriptionLabel.TextWrapped = true
DescriptionLabel.Parent = MainFrame

-- Создаем кнопку
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -40, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 160)
Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Button.BorderSizePixel = 0
Button.Font = Enum.Font.GothamSemibold
Button.Text = "Нажми меня!"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 14
Button.Parent = MainFrame

-- Скругление для кнопки
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = Button

-- Обработка нажатия на кнопку
Button.MouseButton1Click:Connect(function()
    -- Анимация нажатия
    Button.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    Button.Text = "Работает!"
    
    -- Возвращаем исходный цвет через секунду
    task.delay(1, function()
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        Button.Text = "Нажми меня!"
    end)
end)

-- Делаем окно перетаскиваемым
local dragging = false
local dragOffset = Vector2.new(0, 0)

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragOffset = input.Position - MainFrame.AbsolutePosition
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        MainFrame.Position = UDim2.fromOffset(
            input.Position.X - dragOffset.X,
            input.Position.Y - dragOffset.Y
        )
    end
end)

-- Добавляем уведомление
local function CreateNotification(title, content, duration)
    -- Создаем фрейм уведомления
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 260, 0, 80)
    NotifFrame.Position = UDim2.new(1, 300, 0.8, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    NotifFrame.BackgroundTransparency = 0.1
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = ScreenGui
    
    -- Скругление углов
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotifFrame
    
    -- Заголовок
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -20, 0, 26)
    NotifTitle.Position = UDim2.new(0, 10, 0, 5)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifTitle.TextSize = 16
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = NotifFrame
    
    -- Текст уведомления
    local NotifContent = Instance.new("TextLabel")
    NotifContent.Size = UDim2.new(1, -20, 0, 40)
    NotifContent.Position = UDim2.new(0, 10, 0, 30)
    NotifContent.BackgroundTransparency = 1
    NotifContent.Font = Enum.Font.Gotham
    NotifContent.Text = content
    NotifContent.TextColor3 = Color3.fromRGB(220, 220, 220)
    NotifContent.TextSize = 14
    NotifContent.TextWrapped = true
    NotifContent.TextXAlignment = Enum.TextXAlignment.Left
    NotifContent.Parent = NotifFrame
    
    -- Прогресс-бар
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(1, -20, 0, 3)
    ProgressBar.Position = UDim2.new(0, 10, 1, -5)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = NotifFrame
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = ProgressBar
    
    -- Анимация появления
    local TweenIn = game:GetService("TweenService"):Create(
        NotifFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -280, 0.8, 0)}
    )
    TweenIn:Play()
    
    -- Анимация прогресс-бара
    local ProgressTween = game:GetService("TweenService"):Create(
        ProgressBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 0, 3)}
    )
    ProgressTween:Play()
    
    -- Анимация исчезновения после заданного времени
    task.delay(duration, function()
        local TweenOut = game:GetService("TweenService"):Create(
            NotifFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {Position = UDim2.new(1, 300, 0.8, 0)}
        )
        TweenOut:Play()
        
        TweenOut.Completed:Connect(function()
            NotifFrame:Destroy()
        end)
    end)
end

-- Показываем приветственное уведомление
task.delay(1, function()
    CreateNotification("NYAN UI", "Библиотека успешно загружена!", 5)
end)

-- Возвращаем указатель на окно для последующего использования
return {
    MainFrame = MainFrame,
    CreateNotification = CreateNotification
}
