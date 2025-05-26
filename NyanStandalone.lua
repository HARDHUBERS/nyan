-- NYAN UI Library - Автономная версия (Часть 1: основы)
-- Автор: HARDHUBERS
-- Эта версия содержит все компоненты в одном файле для простой загрузки через loadstring

-- Сервисы Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

-- Утилиты
local function CreateInstance(className, properties, children)
    local instance = Instance.new(className)
    
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    
    return instance
end

-- Основные анимации
local HOVER_TWEEN = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local CLICK_TWEEN = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TOGGLE_TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Цветовые утилиты
local ColorUtils = {}

function ColorUtils.ToHSV(color)
    local h, s, v = color:ToHSV()
    return {h = h, s = s, v = v}
end

function ColorUtils.FromHSV(hsv)
    return Color3.fromHSV(hsv.h, hsv.s, hsv.v)
end

function ColorUtils.Darken(color, amount)
    local h, s, v = color:ToHSV()
    return Color3.fromHSV(h, s, math.max(0, v - amount))
end

function ColorUtils.Lighten(color, amount)
    local h, s, v = color:ToHSV()
    return Color3.fromHSV(h, s, math.min(1, v + amount))
end

function ColorUtils.Mix(color1, color2, ratio)
    ratio = math.clamp(ratio, 0, 1)
    return Color3.new(
        color1.R + (color2.R - color1.R) * ratio,
        color1.G + (color2.G - color1.G) * ratio,
        color1.B + (color2.B - color1.B) * ratio
    )
end

-- Система тем
local Themes = {}

-- Тема "Dark"
Themes.Dark = {
    WindowBackground = Color3.fromRGB(30, 30, 30),
    WindowBorder = Color3.fromRGB(40, 40, 40),
    TitleBackground = Color3.fromRGB(25, 25, 25),
    ElementBackground = Color3.fromRGB(45, 45, 45),
    ElementBorder = Color3.fromRGB(55, 55, 55),
    TextColor = Color3.fromRGB(240, 240, 240),
    SubTextColor = Color3.fromRGB(170, 170, 170),
    AccentColor = Color3.fromRGB(85, 170, 255),
    NotificationBackground = Color3.fromRGB(35, 35, 35),
    InactiveTab = Color3.fromRGB(40, 40, 40)
}

-- Тема "Light"
Themes.Light = {
    WindowBackground = Color3.fromRGB(230, 230, 230),
    WindowBorder = Color3.fromRGB(210, 210, 210),
    TitleBackground = Color3.fromRGB(235, 235, 235),
    ElementBackground = Color3.fromRGB(245, 245, 245),
    ElementBorder = Color3.fromRGB(220, 220, 220),
    TextColor = Color3.fromRGB(40, 40, 40),
    SubTextColor = Color3.fromRGB(80, 80, 80),
    AccentColor = Color3.fromRGB(0, 120, 215),
    NotificationBackground = Color3.fromRGB(250, 250, 250),
    InactiveTab = Color3.fromRGB(225, 225, 225)
}

-- Тема "Dark Blue"
Themes["Dark Blue"] = {
    WindowBackground = Color3.fromRGB(25, 30, 40),
    WindowBorder = Color3.fromRGB(35, 40, 50),
    TitleBackground = Color3.fromRGB(20, 25, 35),
    ElementBackground = Color3.fromRGB(35, 45, 60),
    ElementBorder = Color3.fromRGB(45, 55, 70),
    TextColor = Color3.fromRGB(240, 240, 240),
    SubTextColor = Color3.fromRGB(170, 180, 190),
    AccentColor = Color3.fromRGB(65, 130, 255),
    NotificationBackground = Color3.fromRGB(30, 35, 45),
    InactiveTab = Color3.fromRGB(30, 40, 55)
}

-- Тема "Purple"
Themes.Purple = {
    WindowBackground = Color3.fromRGB(35, 30, 45),
    WindowBorder = Color3.fromRGB(45, 40, 55),
    TitleBackground = Color3.fromRGB(30, 25, 40),
    ElementBackground = Color3.fromRGB(50, 40, 65),
    ElementBorder = Color3.fromRGB(60, 50, 75),
    TextColor = Color3.fromRGB(240, 240, 240),
    SubTextColor = Color3.fromRGB(180, 170, 190),
    AccentColor = Color3.fromRGB(170, 85, 255),
    NotificationBackground = Color3.fromRGB(40, 35, 50),
    InactiveTab = Color3.fromRGB(45, 35, 60)
}

-- Тема "Green"
Themes.Green = {
    WindowBackground = Color3.fromRGB(30, 40, 30),
    WindowBorder = Color3.fromRGB(40, 50, 40),
    TitleBackground = Color3.fromRGB(25, 35, 25),
    ElementBackground = Color3.fromRGB(40, 55, 40),
    ElementBorder = Color3.fromRGB(50, 65, 50),
    TextColor = Color3.fromRGB(240, 240, 240),
    SubTextColor = Color3.fromRGB(180, 190, 180),
    AccentColor = Color3.fromRGB(85, 200, 85),
    NotificationBackground = Color3.fromRGB(35, 45, 35),
    InactiveTab = Color3.fromRGB(35, 50, 35)
}

-- Тема "Nyan"
Themes.Nyan = {
    WindowBackground = Color3.fromRGB(30, 30, 35),
    WindowBorder = Color3.fromRGB(40, 40, 45),
    TitleBackground = Color3.fromRGB(25, 25, 30),
    ElementBackground = Color3.fromRGB(45, 45, 50),
    ElementBorder = Color3.fromRGB(55, 55, 60),
    TextColor = Color3.fromRGB(240, 240, 245),
    SubTextColor = Color3.fromRGB(180, 180, 190),
    AccentColor = Color3.fromRGB(255, 105, 180), -- Розовый Nyan
    NotificationBackground = Color3.fromRGB(35, 35, 40),
    InactiveTab = Color3.fromRGB(40, 40, 45)
}

-- Функция для применения темы
function Themes.ApplyTheme(themeName, objects)
    local theme = Themes[themeName] or Themes.Dark
    
    for _, obj in pairs(objects or {}) do
        if obj.ApplyTheme then
            obj:ApplyTheme(theme)
        end
    end
    
    return theme
end

-- Глобальный объект NYAN библиотеки
local NYAN = {
    Themes = Themes,
    ColorUtils = ColorUtils
}

-- Система уведомлений
local NotificationSystem = {}

-- Анимации уведомлений
local APPEAR_TWEEN = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local DISAPPEAR_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

-- Инициализация системы уведомлений
function NotificationSystem.Init(theme)
    if NotificationSystem.Initialized then
        return NotificationSystem
    end
    
    NotificationSystem.Initialized = true
    NotificationSystem.Theme = theme or Themes.Nyan
    NotificationSystem.ActiveNotifications = {}
    NotificationSystem.NotificationCount = 0
    
    -- Создаем ScreenGui для уведомлений
    local screenGui = CreateInstance("ScreenGui", {
        Name = "NyanNotifications",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Используем защиту GUI если возможно
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        screenGui.Parent = gethui()
    else
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Контейнер для уведомлений
    local container = CreateInstance("Frame", {
        Name = "NotificationContainer",
        Size = UDim2.new(0, 280, 1, 0),
        Position = UDim2.new(1, -300, 0, 0),
        BackgroundTransparency = 1,
        Parent = screenGui
    })
    
    -- Лейаут для уведомлений
    local layout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = container
    })
    
    -- Добавляем отступ
    local padding = CreateInstance("UIPadding", {
        PaddingBottom = UDim.new(0, 20),
        Parent = container
    })
    
    NotificationSystem.ScreenGui = screenGui
    NotificationSystem.Container = container
    
    return NotificationSystem
end

-- Создание нового уведомления
function NotificationSystem.Notify(options)
    if not NotificationSystem.Initialized then
        NotificationSystem.Init(options.Theme)
    end
    
    options = options or {}
    local title = options.Title or "Уведомление"
    local content = options.Content or ""
    local duration = options.Duration or 5 -- секунд
    local subContent = options.SubContent or nil
    local icon = options.Icon or nil
    
    -- Создаем уведомление
    local notification = {}
    NotificationSystem.NotificationCount = NotificationSystem.NotificationCount + 1
    notification.Id = NotificationSystem.NotificationCount
    
    -- Основной фрейм
    notification.Frame = CreateInstance("Frame", {
        Size = UDim2.new(0, 260, 0, subContent and 80 or 60),
        BackgroundColor3 = NotificationSystem.Theme.NotificationBackground,
        BackgroundTransparency = 0.1,
        Position = UDim2.new(1, 300, 0, 0), -- Начинаем за пределами экрана
        LayoutOrder = notification.Id,
        Parent = NotificationSystem.Container
    })
    
    -- Скругленные углы
    local corner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = notification.Frame
    })
    
    -- Рамка
    local stroke = CreateInstance("UIStroke", {
        Color = NotificationSystem.Theme.AccentColor,
        Thickness = 1.5,
        Transparency = 0.7,
        Parent = notification.Frame
    })
    
    -- Заголовок
    local titleLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, icon and -60 or -20, 0, 26),
        Position = UDim2.new(0, icon and 50 or 10, 0, 5),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = NotificationSystem.Theme.TextColor,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification.Frame
    })
    
    -- Иконка (если указана)
    if icon then
        local iconImage = CreateInstance("ImageLabel", {
            Size = UDim2.fromOffset(32, 32),
            Position = UDim2.fromOffset(10, 10),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = NotificationSystem.Theme.AccentColor,
            Parent = notification.Frame
        })
    end
    
    -- Содержимое
    local contentLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, subContent and 20 or 30),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = NotificationSystem.Theme.TextColor,
        TextTransparency = 0.2,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification.Frame
    })
    
    -- Дополнительное содержимое (если указано)
    if subContent then
        local subContentLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 55),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = subContent,
            TextColor3 = NotificationSystem.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notification.Frame
        })
    end
    
    -- Прогресс-бар (для отображения времени жизни уведомления)
    local progressBarBackground = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 3),
        Position = UDim2.new(0, 10, 1, -5),
        BackgroundColor3 = NotificationSystem.Theme.AccentColor,
        BackgroundTransparency = 0.8,
        Parent = notification.Frame
    })
    
    local progressBarCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = progressBarBackground
    })
    
    local progressBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = NotificationSystem.Theme.AccentColor,
        Parent = progressBarBackground
    })
    
    local progressBarCorner2 = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = progressBar
    })
    
    -- Анимируем появление уведомления
    local appearTween = TweenService:Create(
        notification.Frame,
        APPEAR_TWEEN,
        {Position = UDim2.new(0, 0, 0, 0)}
    )
    
    appearTween:Play()
    
    -- Анимируем прогресс-бар
    if duration and duration > 0 then
        local progressTween = TweenService:Create(
            progressBar,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {Size = UDim2.new(0, 0, 1, 0)}
        )
        
        progressTween:Play()
        
        -- Настраиваем автоматическое удаление
        task.delay(duration, function()
            NotificationSystem.Remove(notification)
        end)
    end
    
    -- Сохраняем уведомление
    table.insert(NotificationSystem.ActiveNotifications, notification)
    
    -- Возвращаем объект уведомления
    return notification
end

-- Удаление уведомления
function NotificationSystem.Remove(notification)
    -- Ищем уведомление в активном списке
    local index = table.find(NotificationSystem.ActiveNotifications, notification)
    if not index then return end
    
    -- Удаляем из списка
    table.remove(NotificationSystem.ActiveNotifications, index)
    
    -- Анимируем исчезновение
    local disappearTween = TweenService:Create(
        notification.Frame,
        DISAPPEAR_TWEEN,
        {Position = UDim2.new(1, 300, 0, 0), BackgroundTransparency = 1}
    )
    
    disappearTween:Play()
    
    -- Уничтожаем после анимации
    disappearTween.Completed:Connect(function()
        notification.Frame:Destroy()
    end)
end

-- Удаление всех уведомлений
function NotificationSystem.ClearAll()
    for _, notification in pairs(NotificationSystem.ActiveNotifications) do
        NotificationSystem.Remove(notification)
    end
end

-- Применение темы к системе уведомлений
function NotificationSystem.ApplyTheme(theme)
    NotificationSystem.Theme = theme
    
    -- Обновляем активные уведомления
    for _, notification in pairs(NotificationSystem.ActiveNotifications) do
        notification.Frame.BackgroundColor3 = theme.NotificationBackground
        
        -- Ищем и обновляем метки и прогресс-бары
        for _, child in pairs(notification.Frame:GetDescendants()) do
            if child:IsA("TextLabel") then
                child.TextColor3 = theme.TextColor
            elseif child:IsA("UIStroke") then
                child.Color = theme.AccentColor
            elseif child:IsA("Frame") and child.Name ~= "NotificationContainer" then
                if child.BackgroundTransparency < 0.5 then
                    child.BackgroundColor3 = theme.AccentColor
                end
            end
        end
    end
end

-- Подключаем систему уведомлений к NYAN
NYAN.Notify = function(options)
    if not NotificationSystem.Initialized then
        NotificationSystem.Init(options and options.Theme)
    end
    return NotificationSystem.Notify(options)
end

-- Экспортируем систему уведомлений
NYAN.NotificationSystem = NotificationSystem

-- Основные элементы UI

-- Кнопка
local ButtonElement = {}
ButtonElement.__index = ButtonElement

function ButtonElement.new(parent, options)
    local self = setmetatable({}, ButtonElement)
    
    -- Настройки по умолчанию
    options = options or {}
    self.Text = options.Text or "Button"
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        ElementBorder = Color3.fromRGB(65, 65, 65),
        AccentColor = Color3.fromRGB(255, 105, 180)
    }
    
    -- Создаем кнопку
    self:Create()
    
    return self
end

function ButtonElement:Create()
    -- Основной контейнер
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Фрейм кнопки
    self.ButtonFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Theme.ElementBackground,
        BorderSizePixel = 0,
        Parent = self.Container
    })
    
    -- Скругленные углы
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.ButtonFrame
    })
    
    -- Рамка
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Parent = self.ButtonFrame
    })
    
    -- Текст кнопки
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.ButtonFrame
    })
    
    -- Кнопка для взаимодействия
    self.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = self.ButtonFrame
    })
    
    -- Обработчики событий
    self.Button.MouseButton1Click:Connect(function()
        self:Click()
    end)
    
    self.Button.MouseEnter:Connect(function()
        self:Hover(true)
    end)
    
    self.Button.MouseLeave:Connect(function()
        self:Hover(false)
    end)
    
    -- Объект твина для эффекта наведения
    self.HoverTween = nil
    self.ClickTween = nil
end

function ButtonElement:Click()
    -- Эффект нажатия
    if self.ClickTween then
        self.ClickTween:Cancel()
    end
    
    self.ClickTween = TweenService:Create(
        self.ButtonFrame,
        CLICK_TWEEN,
        {BackgroundColor3 = ColorUtils.Darken(self.Theme.ElementBackground, 0.1)}
    )
    
    self.ClickTween:Play()
    
    -- Возврат к исходному цвету после нажатия
    self.ClickTween.Completed:Connect(function()
        if self.HoverState then
            -- Вернуться к состоянию наведения
            self.ClickTween = TweenService:Create(
                self.ButtonFrame,
                CLICK_TWEEN,
                {BackgroundColor3 = ColorUtils.Lighten(self.Theme.ElementBackground, 0.05)}
            )
        else
            -- Вернуться к обычному состоянию
            self.ClickTween = TweenService:Create(
                self.ButtonFrame,
                CLICK_TWEEN,
                {BackgroundColor3 = self.Theme.ElementBackground}
            )
        end
        
        self.ClickTween:Play()
    end)
    
    -- Вызов коллбэка
    self.Callback()
end

function ButtonElement:Hover(state)
    self.HoverState = state
    
    -- Отменяем предыдущий твин
    if self.HoverTween then
        self.HoverTween:Cancel()
    end
    
    -- Создаем новый твин
    if state then
        self.HoverTween = TweenService:Create(
            self.ButtonFrame,
            HOVER_TWEEN,
            {BackgroundColor3 = ColorUtils.Lighten(self.Theme.ElementBackground, 0.05)}
        )
    else
        self.HoverTween = TweenService:Create(
            self.ButtonFrame,
            HOVER_TWEEN,
            {BackgroundColor3 = self.Theme.ElementBackground}
        )
    end
    
    self.HoverTween:Play()
end

function ButtonElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function ButtonElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function ButtonElement:ApplyTheme(theme)
    self.Theme = theme
    self.ButtonFrame.BackgroundColor3 = theme.ElementBackground
    self.TextLabel.TextColor3 = theme.TextColor
    
    -- Обновляем рамку
    for _, child in pairs(self.ButtonFrame:GetChildren()) do
        if child:IsA("UIStroke") then
            child.Color = theme.ElementBorder
        end
    end
end

function ButtonElement:Destroy()
    self.Container:Destroy()
end

-- Переключатель
local ToggleElement = {}
ToggleElement.__index = ToggleElement

function ToggleElement.new(parent, options)
    local self = setmetatable({}, ToggleElement)
    
    -- Настройки по умолчанию
    options = options or {}
    self.Text = options.Text or "Toggle"
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Enabled = options.Default or false
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        ElementBorder = Color3.fromRGB(65, 65, 65),
        AccentColor = Color3.fromRGB(255, 105, 180)
    }
    
    -- Создаем переключатель
    self:Create()
    
    return self
end

function ToggleElement:Create()
    -- Основной контейнер
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Фрейм переключателя
    self.ToggleFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Theme.ElementBackground,
        BorderSizePixel = 0,
        Parent = self.Container
    })
    
    -- Скругленные углы
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.ToggleFrame
    })
    
    -- Рамка
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Parent = self.ToggleFrame
    })
    
    -- Текст переключателя
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -54, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.ToggleFrame
    })
    
    -- Индикатор переключателя (фон)
    self.ToggleIndicator = CreateInstance("Frame", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -50, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = self.Enabled and self.Theme.AccentColor or ColorUtils.Darken(self.Theme.ElementBackground, 0.05),
        BorderSizePixel = 0,
        Parent = self.ToggleFrame
    })
    
    -- Скругленные углы для индикатора
    local indicatorCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.ToggleIndicator
    })
    
    -- Кружок переключателя
    self.ToggleCircle = CreateInstance("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(self.Enabled and 1 or 0, self.Enabled and -18 or 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = self.ToggleIndicator
    })
    
    -- Скругленные углы для кружка
    local circleCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.ToggleCircle
    })
    
    -- Кнопка для взаимодействия
    self.Button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = self.ToggleFrame
    })
    
    -- Обработчики событий
    self.Button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    self.Button.MouseEnter:Connect(function()
        self:Hover(true)
    end)
    
    self.Button.MouseLeave:Connect(function()
        self:Hover(false)
    end)
    
    -- Объект твина для эффекта наведения
    self.HoverTween = nil
end

function ToggleElement:Toggle(state)
    if state ~= nil then
        self.Enabled = state
    else
        self.Enabled = not self.Enabled
    end
    
    -- Анимируем индикатор
    TweenService:Create(
        self.ToggleIndicator,
        TOGGLE_TWEEN,
        {BackgroundColor3 = self.Enabled and self.Theme.AccentColor or ColorUtils.Darken(self.Theme.ElementBackground, 0.05)}
    ):Play()
    
    -- Анимируем кружок
    TweenService:Create(
        self.ToggleCircle,
        TOGGLE_TWEEN,
        {Position = UDim2.new(self.Enabled and 1 or 0, self.Enabled and -18 or 2, 0.5, 0)}
    ):Play()
    
    -- Вызов коллбэка
    self.Callback(self.Enabled)
    
    return self.Enabled
end

function ToggleElement:Hover(state)
    -- Отменяем предыдущий твин
    if self.HoverTween then
        self.HoverTween:Cancel()
    end
    
    -- Создаем новый твин
    if state then
        self.HoverTween = TweenService:Create(
            self.ToggleFrame,
            HOVER_TWEEN,
            {BackgroundColor3 = ColorUtils.Lighten(self.Theme.ElementBackground, 0.05)}
        )
    else
        self.HoverTween = TweenService:Create(
            self.ToggleFrame,
            HOVER_TWEEN,
            {BackgroundColor3 = self.Theme.ElementBackground}
        )
    end
    
    self.HoverTween:Play()
end

function ToggleElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function ToggleElement:SetState(state)
    if self.Enabled ~= state then
        self:Toggle(state)
    end
    return self.Enabled
end

function ToggleElement:GetState()
    return self.Enabled
end

function ToggleElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function ToggleElement:ApplyTheme(theme)
    self.Theme = theme
    self.ToggleFrame.BackgroundColor3 = theme.ElementBackground
    self.TextLabel.TextColor3 = theme.TextColor
    
    -- Обновляем индикатор
    self.ToggleIndicator.BackgroundColor3 = self.Enabled and theme.AccentColor or ColorUtils.Darken(theme.ElementBackground, 0.05)
    
    -- Обновляем рамку
    for _, child in pairs(self.ToggleFrame:GetChildren()) do
        if child:IsA("UIStroke") then
            child.Color = theme.ElementBorder
        end
    end
end

function ToggleElement:Destroy()
    self.Container:Destroy()
end

-- Ползунок (Слайдер)
local SliderElement = {}
SliderElement.__index = SliderElement

function SliderElement.new(parent, options)
    local self = setmetatable({}, SliderElement)
    
    -- Настройки по умолчанию
    options = options or {}
    self.Text = options.Text or "Slider"
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or self.Min
    self.Suffix = options.Suffix or ""
    self.Increment = options.Increment or 1
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Value = math.clamp(self.Default, self.Min, self.Max)
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        ElementBorder = Color3.fromRGB(65, 65, 65),
        AccentColor = Color3.fromRGB(255, 105, 180),
        SliderBackground = Color3.fromRGB(40, 40, 40)
    }
    
    -- Создаем ползунок
    self:Create()
    
    return self
end

function SliderElement:Create()
    -- Основной контейнер
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Фрейм ползунка
    self.SliderFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Theme.ElementBackground,
        BorderSizePixel = 0,
        Parent = self.Container
    })
    
    -- Скругленные углы
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.SliderFrame
    })
    
    -- Рамка
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Parent = self.SliderFrame
    })
    
    -- Текст ползунка
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -16, 0, 20),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.SliderFrame
    })
    
    -- Значение ползунка
    self.ValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -60, 0, 6),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = tostring(self.Value) .. self.Suffix,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = self.SliderFrame
    })
    
    -- Фоновая полоса ползунка
    self.SliderBackground = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 0, 34),
        BackgroundColor3 = self.Theme.SliderBackground,
        BorderSizePixel = 0,
        Parent = self.SliderFrame
    })
    
    -- Скругление фоновой полосы
    local sliderBackgroundCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.SliderBackground
    })
    
    -- Заполненная часть ползунка
    self.SliderFill = CreateInstance("Frame", {
        Size = UDim2.new(self:GetPercentage(), 0, 1, 0),
        BackgroundColor3 = self.Theme.AccentColor,
        BorderSizePixel = 0,
        Parent = self.SliderBackground
    })
    
    -- Скругление заполненной части
    local sliderFillCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.SliderFill
    })
    
    -- Кнопка ползунка
    self.SliderButton = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = self.SliderBackground
    })
    
    -- Кружок ползунка (указатель)
    self.SliderCircle = CreateInstance("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(self:GetPercentage(), 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = self.SliderBackground
    })
    
    -- Скругление кружка
    local circleCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.SliderCircle
    })
    
    -- Обработчики событий
    self.SliderButton.MouseButton1Down:Connect(function()
        self.Dragging = true
        self:UpdateFromMouse()
    end)
    
    self.SliderButton.MouseEnter:Connect(function()
        self:Hover(true)
    end)
    
    self.SliderButton.MouseLeave:Connect(function()
        self:Hover(false)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.Dragging then
            self.Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
            self:UpdateFromMouse()
        end
    end)
    
    -- Объект твина для эффекта наведения
    self.HoverTween = nil
end

function SliderElement:GetPercentage()
    return (self.Value - self.Min) / (self.Max - self.Min)
end

function SliderElement:UpdateFromMouse()
    local mouse = UserInputService:GetMouseLocation()
    local sliderPos = self.SliderBackground.AbsolutePosition
    local sliderSize = self.SliderBackground.AbsoluteSize
    
    local percent = math.clamp((mouse.X - sliderPos.X) / sliderSize.X, 0, 1)
    self:SetValue(self.Min + (self.Max - self.Min) * percent)
end

function SliderElement:SetValue(value)
    local oldValue = self.Value
    
    -- Округление до инкремента
    value = math.floor((value - self.Min) / self.Increment + 0.5) * self.Increment + self.Min
    
    -- Ограничение значения
    self.Value = math.clamp(value, self.Min, self.Max)
    
    -- Обновление текста значения
    self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
    
    -- Обновление визуальных элементов
    local percent = self:GetPercentage()
    self.SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    self.SliderCircle.Position = UDim2.new(percent, 0, 0.5, 0)
    
    -- Вызов коллбэка только если значение изменилось
    if oldValue ~= self.Value then
        self.Callback(self.Value)
    end
    
    return self.Value
end

function SliderElement:Hover(state)
    -- Отменяем предыдущий твин
    if self.HoverTween then
        self.HoverTween:Cancel()
    end
    
    -- Создаем новый твин
    if state then
        self.HoverTween = TweenService:Create(
            self.SliderFrame,
            HOVER_TWEEN,
            {BackgroundColor3 = ColorUtils.Lighten(self.Theme.ElementBackground, 0.05)}
        )
    else
        self.HoverTween = TweenService:Create(
            self.SliderFrame,
            HOVER_TWEEN,
            {BackgroundColor3 = self.Theme.ElementBackground}
        )
    end
    
    self.HoverTween:Play()
end

function SliderElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function SliderElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function SliderElement:SetLimits(min, max)
    self.Min = min
    self.Max = max
    self:SetValue(self.Value) -- Пересчитываем значение с новыми лимитами
end

function SliderElement:ApplyTheme(theme)
    self.Theme = theme
    self.SliderFrame.BackgroundColor3 = theme.ElementBackground
    self.TextLabel.TextColor3 = theme.TextColor
    self.ValueLabel.TextColor3 = theme.TextColor
    self.SliderBackground.BackgroundColor3 = theme.SliderBackground or ColorUtils.Darken(theme.ElementBackground, 0.1)
    self.SliderFill.BackgroundColor3 = theme.AccentColor
    
    -- Обновляем рамку
    for _, child in pairs(self.SliderFrame:GetChildren()) do
        if child:IsA("UIStroke") then
            child.Color = theme.ElementBorder
        end
    end
end

function SliderElement:Destroy()
    self.Container:Destroy()
end

-- Текстовое поле
local TextboxElement = {}
TextboxElement.__index = TextboxElement

function TextboxElement.new(parent, options)
    local self = setmetatable({}, TextboxElement)
    
    -- Настройки по умолчанию
    options = options or {}
    self.Text = options.Text or "Textbox"
    self.Placeholder = options.Placeholder or "Enter text..."
    self.Default = options.Default or ""
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.NumericOnly = options.NumericOnly or false
    self.MaxLength = options.MaxLength or 50
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        ElementBorder = Color3.fromRGB(65, 65, 65),
        AccentColor = Color3.fromRGB(255, 105, 180),
        InputBackground = Color3.fromRGB(40, 40, 40),
        PlaceholderColor = Color3.fromRGB(150, 150, 150)
    }
    
    -- Создаем текстовое поле
    self:Create()
    
    return self
end

function TextboxElement:Create()
    -- Основной контейнер
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Фрейм текстового поля
    self.TextboxFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Theme.ElementBackground,
        BorderSizePixel = 0,
        Parent = self.Container
    })
    
    -- Скругленные углы
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.TextboxFrame
    })
    
    -- Рамка
    self.Stroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Parent = self.TextboxFrame
    })
    
    -- Текст заголовка
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -16, 0, 20),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TextboxFrame
    })
    
    -- Фон поля ввода
    self.InputBackground = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 10, 0, 26),
        BackgroundColor3 = self.Theme.InputBackground or ColorUtils.Darken(self.Theme.ElementBackground, 0.1),
        BorderSizePixel = 0,
        Parent = self.TextboxFrame
    })
    
    -- Скругление фона поля ввода
    local inputBackgroundCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = self.InputBackground
    })
    
    -- Поле ввода
    self.Textbox = CreateInstance("TextBox", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = self.Default,
        PlaceholderText = self.Placeholder,
        TextColor3 = self.Theme.TextColor,
        PlaceholderColor3 = self.Theme.PlaceholderColor or ColorUtils.Darken(self.Theme.TextColor, 0.3),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClipsDescendants = true,
        ClearTextOnFocus = false,
        Parent = self.InputBackground
    })
    
    -- Обработчики событий
    self.Textbox.Focused:Connect(function()
        self:OnFocus(true)
    end)
    
    self.Textbox.FocusLost:Connect(function(enterPressed)
        self:OnFocus(false)
        self.Callback(self.Textbox.Text, enterPressed)
    end)
    
    self.Textbox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = self.Textbox.Text
        
        -- Проверка на числовой ввод если нужно
        if self.NumericOnly then
            text = text:gsub("[^%d%.%-]", "")
            
            -- Удаляем множественные точки и минусы
            local decimalCount = 0
            local minusCount = 0
            local cleanedText = ""
            
            for i = 1, #text do
                local char = text:sub(i, i)
                
                if char == "." then
                    if decimalCount == 0 then
                        cleanedText = cleanedText .. char
                        decimalCount = decimalCount + 1
                    end
                elseif char == "-" then
                    if minusCount == 0 and i == 1 then
                        cleanedText = cleanedText .. char
                        minusCount = minusCount + 1
                    end
                else
                    cleanedText = cleanedText .. char
                end
            end
            
            text = cleanedText
        end
        
        -- Ограничение длины
        if self.MaxLength > 0 and text:len() > self.MaxLength then
            text = text:sub(1, self.MaxLength)
        end
        
        -- Если текст изменился, обновляем
        if text ~= self.Textbox.Text then
            self.Textbox.Text = text
        end
    end)
    
    -- Объект твина для эффектов
    self.FocusTween = nil
end

function TextboxElement:OnFocus(focused)
    -- Отменяем предыдущий твин
    if self.FocusTween then
        self.FocusTween:Cancel()
    end
    
    -- Создаем новый твин
    if focused then
        self.FocusTween = TweenService:Create(
            self.Stroke,
            HOVER_TWEEN,
            {Color = self.Theme.AccentColor}
        )
    else
        self.FocusTween = TweenService:Create(
            self.Stroke,
            HOVER_TWEEN,
            {Color = self.Theme.ElementBorder}
        )
    end
    
    self.FocusTween:Play()
end

function TextboxElement:SetText(text)
    self.Textbox.Text = text or ""
end

function TextboxElement:GetText()
    return self.Textbox.Text
end

function TextboxElement:SetPlaceholder(placeholder)
    self.Placeholder = placeholder or ""
    self.Textbox.PlaceholderText = self.Placeholder
end

function TextboxElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function TextboxElement:ApplyTheme(theme)
    self.Theme = theme
    self.TextboxFrame.BackgroundColor3 = theme.ElementBackground
    self.TextLabel.TextColor3 = theme.TextColor
    self.Textbox.TextColor3 = theme.TextColor
    self.Textbox.PlaceholderColor3 = theme.PlaceholderColor or ColorUtils.Darken(theme.TextColor, 0.3)
    self.InputBackground.BackgroundColor3 = theme.InputBackground or ColorUtils.Darken(theme.ElementBackground, 0.1)
    self.Stroke.Color = theme.ElementBorder
end

function TextboxElement:Destroy()
    self.Container:Destroy()
end

-- Выпадающий список
local DropdownElement = {}
DropdownElement.__index = DropdownElement

function DropdownElement.new(parent, options)
    local self = setmetatable({}, DropdownElement)
    
    -- Настройки по умолчанию
    options = options or {}
    self.Text = options.Text or "Dropdown"
    self.Options = options.Options or {}
    self.Default = options.Default or nil
    self.MultiSelect = options.MultiSelect or false
    self.MaxVisibleItems = options.MaxVisibleItems or 5
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Selected = self.MultiSelect and {} or (self.Default or nil)
    self.Open = false
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        ElementBorder = Color3.fromRGB(65, 65, 65),
        AccentColor = Color3.fromRGB(255, 105, 180),
        DropdownBackground = Color3.fromRGB(40, 40, 40),
        SelectedOptionColor = Color3.fromRGB(70, 70, 70),
        ArrowColor = Color3.fromRGB(200, 200, 200)
    }
    
    -- Применяем значение по умолчанию
    if self.MultiSelect and self.Default then
        if type(self.Default) == "table" then
            for _, option in pairs(self.Default) do
                self.Selected[option] = true
            end
        elseif type(self.Default) == "string" then
            self.Selected[self.Default] = true
        end
    end
    
    -- Создаем выпадающий список
    self:Create()
    
    return self
end

function DropdownElement:Create()
    -- Основной контейнер
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Parent = self.Parent
    })
    
    -- Фрейм выпадающего списка
    self.DropdownFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = self.Theme.ElementBackground,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.Container
    })
    
    -- Скругленные углы
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.DropdownFrame
    })
    
    -- Рамка
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Parent = self.DropdownFrame
    })
    
    -- Текст заголовка
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -16, 0, 20),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.DropdownFrame
    })
    
    -- Создаем поле выбора
    self.SelectionBox = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 10, 0, 26),
        BackgroundColor3 = self.Theme.DropdownBackground or ColorUtils.Darken(self.Theme.ElementBackground, 0.1),
        BorderSizePixel = 0,
        Parent = self.DropdownFrame
    })
    
    -- Скругление поля выбора
    local selectionBoxCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = self.SelectionBox
    })
    
    -- Текст выбранного значения
    self.SelectedLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = self:GetSelectionText(),
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = self.SelectionBox
    })
    
    -- Стрелка
    self.Arrow = CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031091004", -- Изображение стрелки вниз
        ImageColor3 = self.Theme.ArrowColor,
        Parent = self.SelectionBox
    })
    
    -- Кнопка для взаимодействия
    self.DropdownButton = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = self.SelectionBox
    })
    
    -- Создаем контейнер для опций
    self.OptionsContainer = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 0), -- Начальная высота 0
        Position = UDim2.new(0, 10, 0, 52),
        BackgroundColor3 = self.Theme.DropdownBackground or ColorUtils.Darken(self.Theme.ElementBackground, 0.1),
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.AccentColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.DropdownFrame
    })
    
    -- Скругление контейнера опций
    local optionsContainerCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = self.OptionsContainer
    })
    
    -- Лейаут для опций
    local optionsLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.OptionsContainer
    })
    
    -- Отступы для опций
    local optionsPadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 2),
        Parent = self.OptionsContainer
    })
    
    -- Создаем опции
    self:PopulateOptions()
    
    -- Обработчики событий
    self.DropdownButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    self.DropdownButton.MouseEnter:Connect(function()
        self:Hover(true)
    end)
    
    self.DropdownButton.MouseLeave:Connect(function()
        self:Hover(false)
    end)
    
    -- Закрываем список при клике вне его
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local position = input.Position
            local dropdownFrame = self.DropdownFrame
            
            if self.Open and position and not (
                position.X >= dropdownFrame.AbsolutePosition.X and
                position.X <= dropdownFrame.AbsolutePosition.X + dropdownFrame.AbsoluteSize.X and
                position.Y >= dropdownFrame.AbsolutePosition.Y and
                position.Y <= dropdownFrame.AbsolutePosition.Y + dropdownFrame.AbsoluteSize.Y
            ) then
                self:Toggle(false)
            end
        end
    end)
    
    -- Объекты твинов для эффектов
    self.HoverTween = nil
end

-- Получение текста выбранных элементов
function DropdownElement:GetSelectionText()
    if self.MultiSelect then
        local selectedOptions = {}
        local count = 0
        
        for option, selected in pairs(self.Selected) do
            if selected then
                table.insert(selectedOptions, option)
                count = count + 1
            end
        end
        
        if count == 0 then
            return "None"
        elseif count == 1 then
            return selectedOptions[1]
        else
            return selectedOptions[1] .. " (+" .. (count - 1) .. ")"
        end
    else
        return self.Selected or "None"
    end
end

-- Создание элементов списка
function DropdownElement:PopulateOptions()
    -- Очищаем существующие опции
    for _, child in pairs(self.OptionsContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Создаем новые опции
    for i, option in ipairs(self.Options) do
        local optionButton = CreateInstance("TextButton", {
            Size = UDim2.new(1, -4, 0, 30),
            BackgroundColor3 = self:IsSelected(option) and 
                ColorUtils.Lighten(self.Theme.SelectedOptionColor or self.Theme.DropdownBackground, 0.1) or 
                self.Theme.DropdownBackground,
            BackgroundTransparency = 0,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = i,
            Parent = self.OptionsContainer
        })
        
        -- Скругление опции
        local optionCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = optionButton
        })
        
        -- Текст опции
        local optionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = option,
            TextColor3 = self.Theme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = optionButton
        })
        
        -- Индикатор выбора для мультивыбора
        if self.MultiSelect then
            local checkBox = CreateInstance("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -26, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = self:IsSelected(option) and self.Theme.AccentColor or self.Theme.ElementBackground,
                BorderSizePixel = 0,
                Parent = optionButton
            })
            
            local checkBoxCorner = CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = checkBox
            })
            
            if self:IsSelected(option) then
                local checkMark = CreateInstance("ImageLabel", {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://6031094667", -- Изображение галочки
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = checkBox
                })
            end
        end
        
        -- Обработчик нажатия
        optionButton.MouseButton1Click:Connect(function()
            self:SelectOption(option)
        end)
        
        -- Эффекты наведения
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(
                optionButton,
                HOVER_TWEEN,
                {BackgroundColor3 = ColorUtils.Lighten(optionButton.BackgroundColor3, 0.1)}
            ):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(
                optionButton,
                HOVER_TWEEN,
                {BackgroundColor3 = self:IsSelected(option) and 
                    ColorUtils.Lighten(self.Theme.SelectedOptionColor or self.Theme.DropdownBackground, 0.1) or 
                    self.Theme.DropdownBackground}
            ):Play()
        end)
    end
end

-- Проверка, выбрана ли опция
function DropdownElement:IsSelected(option)
    if self.MultiSelect then
        return self.Selected[option] == true
    else
        return self.Selected == option
    end
end

-- Выбор опции
function DropdownElement:SelectOption(option)
    if self.MultiSelect then
        self.Selected[option] = not self.Selected[option]
    else
        self.Selected = option
        self:Toggle(false) -- Закрываем список при выборе в обычном режиме
    end
    
    -- Обновляем текст
    self.SelectedLabel.Text = self:GetSelectionText()
    
    -- Обновляем список опций
    self:PopulateOptions()
    
    -- Вызываем коллбэк
    if self.MultiSelect then
        local selectedOptions = {}
        for opt, selected in pairs(self.Selected) do
            if selected then
                table.insert(selectedOptions, opt)
            end
        end
        self.Callback(selectedOptions)
    else
        self.Callback(self.Selected)
    end
end

-- Открытие/закрытие выпадающего списка
function DropdownElement:Toggle(state)
    if state ~= nil then
        self.Open = state
    else
        self.Open = not self.Open
    end
    
    -- Обновляем размер фрейма
    self:UpdateSize()
    
    -- Поворачиваем стрелку
    local rotation = self.Open and 180 or 0
    TweenService:Create(
        self.Arrow,
        TOGGLE_TWEEN,
        {Rotation = rotation}
    ):Play()
    
    -- Показываем/скрываем опции
    self.OptionsContainer.Visible = self.Open
end

-- Обновление размера выпадающего списка
function DropdownElement:UpdateSize()
    -- Рассчитываем высоту контейнера опций
    local itemHeight = 32 -- Высота каждой опции с отступом
    local numItems = math.min(#self.Options, self.MaxVisibleItems)
    local optionsHeight = numItems * itemHeight
    
    -- Анимируем изменение размера
    if self.Open then
        -- Размер фрейма списка
        TweenService:Create(
            self.DropdownFrame,
            TOGGLE_TWEEN,
            {Size = UDim2.new(1, 0, 0, 50 + optionsHeight + 4)}
        ):Play()
        
        -- Размер контейнера опций
        TweenService:Create(
            self.OptionsContainer,
            TOGGLE_TWEEN,
            {Size = UDim2.new(1, -20, 0, optionsHeight)}
        ):Play()
    else
        -- Сжимаем фрейм списка
        TweenService:Create(
            self.DropdownFrame,
            TOGGLE_TWEEN,
            {Size = UDim2.new(1, 0, 0, 50)}
        ):Play()
        
        -- Сжимаем контейнер опций
        TweenService:Create(
            self.OptionsContainer,
            TOGGLE_TWEEN,
            {Size = UDim2.new(1, -20, 0, 0)}
        ):Play()
    end
end

-- Эффект наведения
function DropdownElement:Hover(state)
    -- Отменяем предыдущий твин
    if self.HoverTween then
        self.HoverTween:Cancel()
    end
    
    -- Создаем новый твин
    if state then
        self.HoverTween = TweenService:Create(
            self.SelectionBox,
            HOVER_TWEEN,
            {BackgroundColor3 = ColorUtils.Lighten(self.Theme.DropdownBackground, 0.1)}
        )
    else
        self.HoverTween = TweenService:Create(
            self.SelectionBox,
            HOVER_TWEEN,
            {BackgroundColor3 = self.Theme.DropdownBackground}
        )
    end
    
    self.HoverTween:Play()
end

-- Установка текста заголовка
function DropdownElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

-- Установка опций
function DropdownElement:SetOptions(options)
    self.Options = options or {}
    
    -- Если выбранный элемент отсутствует в новом списке, сбрасываем выбор
    if not self.MultiSelect then
        -- Проверяем, есть ли выбранный элемент в новом списке
        local found = false
        for _, option in ipairs(self.Options) do
            if option == self.Selected then
                found = true
                break
            end
        end
        
        if not found then
            self.Selected = nil
        end
    else
        -- Для мультивыбора удаляем отсутствующие элементы
        local newSelected = {}
        for option, selected in pairs(self.Selected) do
            if selected then
                local found = false
                for _, newOption in ipairs(self.Options) do
                    if newOption == option then
                        found = true
                        break
                    end
                end
                
                if found then
                    newSelected[option] = true
                end
            end
        end
        
        self.Selected = newSelected
    end
    
    -- Обновляем текст и список опций
    self.SelectedLabel.Text = self:GetSelectionText()
    self:PopulateOptions()
    
    -- Обновляем размер если список открыт
    if self.Open then
        self:UpdateSize()
    end
end

-- Установка выбранного значения
function DropdownElement:SetValue(value)
    if self.MultiSelect then
        if type(value) == "table" then
            local newSelected = {}
            for _, option in ipairs(value) do
                newSelected[option] = true
            end
            self.Selected = newSelected
        else
            self.Selected = {[value] = true}
        end
    else
        self.Selected = value
    end
    
    -- Обновляем текст и список опций
    self.SelectedLabel.Text = self:GetSelectionText()
    self:PopulateOptions()
end

-- Получение выбранного значения
function DropdownElement:GetValue()
    if self.MultiSelect then
        local selectedOptions = {}
        for option, selected in pairs(self.Selected) do
            if selected then
                table.insert(selectedOptions, option)
            end
        end
        return selectedOptions
    else
        return self.Selected
    end
end

-- Установка коллбэка
function DropdownElement:SetCallback(callback)
    self.Callback = callback or function() end
end

-- Применение темы
function DropdownElement:ApplyTheme(theme)
    self.Theme = theme
    self.DropdownFrame.BackgroundColor3 = theme.ElementBackground
    self.TextLabel.TextColor3 = theme.TextColor
    self.SelectedLabel.TextColor3 = theme.TextColor
    self.Arrow.ImageColor3 = theme.ArrowColor or ColorUtils.Darken(theme.TextColor, 0.2)
    self.SelectionBox.BackgroundColor3 = theme.DropdownBackground or ColorUtils.Darken(theme.ElementBackground, 0.1)
    self.OptionsContainer.BackgroundColor3 = theme.DropdownBackground or ColorUtils.Darken(theme.ElementBackground, 0.1)
    self.OptionsContainer.ScrollBarImageColor3 = theme.AccentColor
    
    -- Обновляем рамку
    for _, child in pairs(self.DropdownFrame:GetChildren()) do
        if child:IsA("UIStroke") then
            child.Color = theme.ElementBorder
        end
    end
    
    -- Обновляем опции
    self:PopulateOptions()
end

-- Уничтожение элемента
function DropdownElement:Destroy()
    self.Container:Destroy()
end

-- Экспортируем элементы в глобальный объект NYAN
NYAN.Elements = {
    Button = ButtonElement,
    Toggle = ToggleElement,
    Slider = SliderElement,
    Textbox = TextboxElement,
    Dropdown = DropdownElement
}

-- Компонент создания окна
local WindowCreator = {}
WindowCreator.__index = WindowCreator

-- Анимации окна
local WINDOW_APPEAR_TWEEN = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local WINDOW_DISAPPEAR_TWEEN = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local WINDOW_DRAG_TWEEN = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Создание нового окна
function WindowCreator.new(options)
    local self = setmetatable({}, WindowCreator)
    
    -- Настройки по умолчанию
    options = options or {}
    self.Title = options.Title or "NYAN UI"
    self.Size = options.Size or {450, 350} -- Ширина, Высота
    self.Position = options.Position or {0.5, 0.5} -- X, Y (относительно центра)
    self.Theme = options.Theme and Themes[options.Theme] or Themes.Nyan
    self.Resizable = options.Resizable ~= false
    self.Draggable = options.Draggable ~= false
    self.MinSize = options.MinSize or {350, 250}
    self.MaxSize = options.MaxSize or {800, 600}
    
    -- Состояние окна
    self.Visible = true
    self.Dragging = false
    self.Resizing = false
    self.DragOffset = Vector2.new(0, 0)
    self.Tabs = {}
    self.TabCount = 0
    self.Elements = {}
    self.SelectedTab = nil
    
    -- Создаем окно
    self:Create()
    
    return self
end

function WindowCreator:Create()
    -- Создание ScreenGui
    self.ScreenGui = CreateInstance("ScreenGui", {
        Name = "NyanUI_" .. self.Title:gsub("[^%w]", ""),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Используем защиту GUI если возможно
    if syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
        self.ScreenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        self.ScreenGui.Parent = gethui()
    else
        self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Основной контейнер
    self.Container = CreateInstance("Frame", {
        Size = UDim2.fromOffset(self.Size[1], self.Size[2]),
        Position = UDim2.fromScale(self.Position[1], self.Position[2]),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.WindowBackground,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    
    -- Скругленные углы
    local containerCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self.Container
    })
    
    -- Тень
    local containerShadow = CreateInstance("ImageLabel", {
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.fromOffset(-15, -15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993", -- Замените на подходящий ID тени
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(30, 30, 30, 30),
        ZIndex = 0,
        Parent = self.Container
    })
    
    -- Рамка
    local containerStroke = CreateInstance("UIStroke", {
        Color = self.Theme.WindowBorder,
        Thickness = 1.5,
        Parent = self.Container
    })
    
    -- Верхняя панель
    self.TitleBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.TitleBackground,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = self.Container
    })
    
    -- Скругление верхней панели (только верхние углы)
    local titleBarCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self.TitleBar
    })
    
    -- Исправление скругления внизу
    local titleBarFix = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -5),
        BackgroundColor3 = self.Theme.TitleBackground,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = self.TitleBar
    })
    
    -- Заголовок окна
    self.TitleLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -35, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
        Parent = self.TitleBar
    })
    
    -- Кнопки управления
    self.ControlButtons = CreateInstance("Frame", {
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -65, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = self.TitleBar
    })
    
    -- Кнопка закрытия
    self.CloseButton = CreateInstance("ImageButton", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, -20, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031094678", -- Замените на подходящий ID кнопки закрытия
        ImageColor3 = self.Theme.TextColor,
        ImageTransparency = 0.2,
        ZIndex = 3,
        Parent = self.ControlButtons
    })
    
    -- Кнопка скрытия
    self.MinimizeButton = CreateInstance("ImageButton", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031090990", -- Замените на подходящий ID кнопки свернуть
        ImageColor3 = self.Theme.TextColor,
        ImageTransparency = 0.2,
        ZIndex = 3,
        Parent = self.ControlButtons
    })
    
    -- Контейнер для вкладок (слева)
    self.TabContainer = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(0, 120, 1, -35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = ColorUtils.Darken(self.Theme.WindowBackground, 0.05),
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.AccentColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = self.Container
    })
    
    -- Лейаут для вкладок
    local tabLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.TabContainer
    })
    
    -- Отступы для вкладок
    local tabPadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = self.TabContainer
    })
    
    -- Основной контейнер содержимого
    self.ContentContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -120, 1, -35),
        Position = UDim2.new(0, 120, 0, 35),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.Container
    })
    
    -- Создаем систему вкладок
    self.TabSystem = require(script.Parent.TabSystem).new(self, self.TabContainer, self.ContentContainer, self.Theme)
    
    -- Обработчики для кнопок
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Перетаскивание окна
    if self.Draggable then
        self.TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self.Dragging = true
                self.DragOffset = input.Position - self.Container.AbsolutePosition
            end
        end)
        
        self.TitleBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self.Dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
                local newPosition = UDim2.fromOffset(
                    input.Position.X - self.DragOffset.X,
                    input.Position.Y - self.DragOffset.Y
                )
                
                -- Используем твин для плавного перемещения
                TweenService:Create(
                    self.Container,
                    WINDOW_DRAG_TWEEN,
                    {Position = newPosition}
                ):Play()
            end
        end)
    end
    
    -- Показываем окно с анимацией
    self:Show()
    
end

-- Показ окна с анимацией
function WindowCreator:Show()
    -- Сброс прозрачности
    self.Container.BackgroundTransparency = 1
    self.TitleBar.BackgroundTransparency = 1
    
    -- Анимация появления
    TweenService:Create(
        self.Container,
        WINDOW_APPEAR_TWEEN,
        {BackgroundTransparency = 0}
    ):Play()
    
    TweenService:Create(
        self.TitleBar,
        WINDOW_APPEAR_TWEEN,
        {BackgroundTransparency = 0}
    ):Play()
    
    self.Visible = true
end

-- Скрытие окна с анимацией
function WindowCreator:Hide()
    -- Анимация исчезновения
    local containerTween = TweenService:Create(
        self.Container,
        WINDOW_DISAPPEAR_TWEEN,
        {BackgroundTransparency = 1}
    )
    
    local titleBarTween = TweenService:Create(
        self.TitleBar,
        WINDOW_DISAPPEAR_TWEEN,
        {BackgroundTransparency = 1}
    )
    
    containerTween:Play()
    titleBarTween:Play()
    
    -- После завершения анимации скрываем окно
    containerTween.Completed:Connect(function()
        if not self.Visible then
            self.ScreenGui.Enabled = false
        end
    end)
    
    self.Visible = false
end

-- Переключение видимости окна
function WindowCreator:Toggle()
    if self.Visible then
        self:Hide()
    else
        self.ScreenGui.Enabled = true
        self:Show()
    end
end

-- Закрытие окна
function WindowCreator:Close()
    -- Анимация закрытия
    local containerTween = TweenService:Create(
        self.Container,
        WINDOW_DISAPPEAR_TWEEN,
        {BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0)}
    )
    
    containerTween:Play()
    
    -- Уничтожаем интерфейс после анимации
    containerTween.Completed:Connect(function()
        self.ScreenGui:Destroy()
    end)
end

-- Добавление новой вкладки
function WindowCreator:AddTab(options)
    self.TabCount = self.TabCount + 1
    local tab = self.TabSystem:CreateTab(options)
    self.Tabs[self.TabCount] = tab
    
    if self.TabCount == 1 then
        self.SelectedTab = 1
    end
    
    return tab
end

-- Установка темы
function WindowCreator:SetTheme(themeName)
    if not Themes[themeName] then
        warn("Theme '" .. themeName .. "' not found. Using default theme.")
        themeName = "Nyan"
    end
    
    self.Theme = Themes[themeName]
    
    -- Обновляем элементы окна
    self.Container.BackgroundColor3 = self.Theme.WindowBackground
    self.TitleBar.BackgroundColor3 = self.Theme.TitleBackground
    self.TitleLabel.TextColor3 = self.Theme.TextColor
    self.CloseButton.ImageColor3 = self.Theme.TextColor
    self.MinimizeButton.ImageColor3 = self.Theme.TextColor
    self.TabContainer.BackgroundColor3 = ColorUtils.Darken(self.Theme.WindowBackground, 0.05)
    self.TabContainer.ScrollBarImageColor3 = self.Theme.AccentColor
    
    -- Обновляем рамку
    for _, child in pairs(self.Container:GetChildren()) do
        if child:IsA("UIStroke") then
            child.Color = self.Theme.WindowBorder
        end
    end
    
    -- Обновляем систему вкладок
    self.TabSystem:ApplyTheme(self.Theme)
    
    -- Обновляем все элементы
    local elements = {}
    for _, tab in pairs(self.Tabs) do
        for _, element in pairs(tab.Elements) do
            table.insert(elements, element)
        end
    end
    
    Themes.ApplyTheme(themeName, elements)
    
    return self.Theme
end

-- Уведомление
function WindowCreator:Notify(options)
    return NYAN.Notify(options)
end

-- Добавляем создание окна к глобальному объекту NYAN
NYAN.CreateWindow = function(options)
    return WindowCreator.new(options)
end

-- Экспортируем библиотеку
return NYAN
