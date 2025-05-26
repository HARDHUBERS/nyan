-- NYAN UI Library - Themes
-- Предустановленные темы для UI библиотеки

local Themes = {}

-- Темная тема (по умолчанию)
Themes.Dark = {
    Background = Color3.fromRGB(30, 30, 30),      -- Основной фон окна
    Card = Color3.fromRGB(40, 40, 40),            -- Фон для карточек/контейнеров
    TopBar = Color3.fromRGB(50, 50, 50),          -- Верхняя панель окна
    ElementBackground = Color3.fromRGB(55, 55, 55), -- Фон для элементов UI
    ElementBorder = Color3.fromRGB(65, 65, 65),   -- Рамки элементов
    InactiveTab = Color3.fromRGB(45, 45, 45),     -- Неактивные вкладки
    TabSelector = Color3.fromRGB(40, 40, 40),     -- Область выбора вкладок
    TextColor = Color3.fromRGB(255, 255, 255),    -- Основной цвет текста
    SubTextColor = Color3.fromRGB(180, 180, 180), -- Цвет второстепенного текста
    AccentColor = Color3.fromRGB(255, 105, 180),  -- Акцентный цвет (Nyan Pink по умолчанию)
    NotificationBackground = Color3.fromRGB(35, 35, 35), -- Фон уведомлений
    SliderBackground = Color3.fromRGB(35, 35, 35) -- Фон для слайдеров
}

-- Светлая тема
Themes.Light = {
    Background = Color3.fromRGB(240, 240, 240),
    Card = Color3.fromRGB(250, 250, 250),
    TopBar = Color3.fromRGB(230, 230, 230),
    ElementBackground = Color3.fromRGB(220, 220, 220),
    ElementBorder = Color3.fromRGB(200, 200, 200),
    InactiveTab = Color3.fromRGB(230, 230, 230),
    TabSelector = Color3.fromRGB(240, 240, 240),
    TextColor = Color3.fromRGB(50, 50, 50),
    SubTextColor = Color3.fromRGB(100, 100, 100),
    AccentColor = Color3.fromRGB(255, 105, 180),
    NotificationBackground = Color3.fromRGB(245, 245, 245),
    SliderBackground = Color3.fromRGB(210, 210, 210)
}

-- Тёмно-синяя тема
Themes.DarkBlue = {
    Background = Color3.fromRGB(20, 25, 40),
    Card = Color3.fromRGB(30, 35, 50),
    TopBar = Color3.fromRGB(35, 40, 60),
    ElementBackground = Color3.fromRGB(40, 45, 65),
    ElementBorder = Color3.fromRGB(50, 55, 75),
    InactiveTab = Color3.fromRGB(30, 35, 55),
    TabSelector = Color3.fromRGB(25, 30, 50),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(180, 190, 210),
    AccentColor = Color3.fromRGB(100, 180, 255),
    NotificationBackground = Color3.fromRGB(25, 30, 45),
    SliderBackground = Color3.fromRGB(30, 35, 55)
}

-- Фиолетовая тема
Themes.Purple = {
    Background = Color3.fromRGB(40, 30, 60),
    Card = Color3.fromRGB(50, 40, 70),
    TopBar = Color3.fromRGB(55, 45, 80),
    ElementBackground = Color3.fromRGB(60, 50, 90),
    ElementBorder = Color3.fromRGB(70, 60, 100),
    InactiveTab = Color3.fromRGB(50, 40, 75),
    TabSelector = Color3.fromRGB(45, 35, 65),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(200, 190, 220),
    AccentColor = Color3.fromRGB(200, 120, 255),
    NotificationBackground = Color3.fromRGB(45, 35, 65),
    SliderBackground = Color3.fromRGB(50, 40, 75)
}

-- Зелёная тема
Themes.Green = {
    Background = Color3.fromRGB(25, 40, 35),
    Card = Color3.fromRGB(35, 50, 45),
    TopBar = Color3.fromRGB(40, 60, 50),
    ElementBackground = Color3.fromRGB(45, 65, 55),
    ElementBorder = Color3.fromRGB(55, 75, 65),
    InactiveTab = Color3.fromRGB(35, 55, 45),
    TabSelector = Color3.fromRGB(30, 50, 40),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(190, 210, 200),
    AccentColor = Color3.fromRGB(100, 230, 160),
    NotificationBackground = Color3.fromRGB(30, 45, 40),
    SliderBackground = Color3.fromRGB(35, 55, 45)
}

-- Розовая тема (Nyan)
Themes.Nyan = {
    Background = Color3.fromRGB(40, 30, 45),
    Card = Color3.fromRGB(50, 40, 55),
    TopBar = Color3.fromRGB(55, 45, 60),
    ElementBackground = Color3.fromRGB(60, 50, 65),
    ElementBorder = Color3.fromRGB(70, 60, 75),
    InactiveTab = Color3.fromRGB(50, 40, 55),
    TabSelector = Color3.fromRGB(45, 35, 50),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(210, 200, 220),
    AccentColor = Color3.fromRGB(255, 105, 180),
    NotificationBackground = Color3.fromRGB(45, 35, 50),
    SliderBackground = Color3.fromRGB(50, 40, 55)
}

-- Список всех доступных тем для удобного доступа
Themes.Names = {"Dark", "Light", "DarkBlue", "Purple", "Green", "Nyan"}

-- Функция для применения темы к элементам
function Themes.ApplyTheme(themeName, elements)
    local theme = Themes[themeName] or Themes.Dark
    
    for _, element in pairs(elements) do
        if element.ApplyTheme then
            element:ApplyTheme(theme)
        end
    end
    
    return theme
end

-- Функция для смешивания двух тем (для создания пользовательских тем)
function Themes.MixThemes(theme1Name, theme2Name, mixRatio)
    mixRatio = mixRatio or 0.5
    
    local theme1 = Themes[theme1Name] or Themes.Dark
    local theme2 = Themes[theme2Name] or Themes.Light
    local mixedTheme = {}
    
    for key, color1 in pairs(theme1) do
        if typeof(color1) == "Color3" and theme2[key] then
            mixedTheme[key] = color1:Lerp(theme2[key], mixRatio)
        else
            mixedTheme[key] = color1
        end
    end
    
    return mixedTheme
end

-- Функция для создания пользовательской темы
function Themes.CreateCustomTheme(baseName, modifications)
    local baseTheme = Themes[baseName] or Themes.Dark
    local customTheme = table.clone(baseTheme)
    
    for key, value in pairs(modifications) do
        customTheme[key] = value
    end
    
    return customTheme
end

return Themes
