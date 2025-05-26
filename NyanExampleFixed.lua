-- NYAN UI Library - Простой пример с исправленной системой вкладок
-- Используйте этот код для тестирования библиотеки

-- Загружаем автономную версию библиотеки
local NYAN = loadstring(game:HttpGet('https://raw.githubusercontent.com/HARDHUBERS/nyan/main/NyanStandalone.lua'))()

-- Создаем окно
local window = NYAN:CreateWindow({
    Title = "NYAN UI Demo",
    Theme = "Nyan", -- Темы: "Dark", "Light", "Dark Blue", "Purple", "Green", "Nyan"
    Size = {450, 300}
})

-- Создаем первую вкладку (Главная)
local mainTab = window:AddTab("Главная")

-- Добавляем элементы на главную вкладку
mainTab:AddButton({
    Text = "Нажми меня",
    Callback = function()
        NYAN:Notify("Уведомление", "Кнопка была нажата!", 3)
    end
})

mainTab:AddToggle({
    Text = "Включить функцию",
    Default = false,
    Callback = function(value)
        NYAN:Notify("Переключатель", "Состояние: " .. (value and "Включено" or "Выключено"), 3)
    end
})

mainTab:AddSlider({
    Text = "Настройка скорости",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "%",
    Callback = function(value)
        print("Выбрано значение: " .. value)
    end
})

-- Создаем вторую вкладку (Настройки)
local settingsTab = window:AddTab("Настройки")

-- Переменные для хранения настроек
local settings = {
    theme = "Nyan",
    transparency = 0,
    notificationDuration = 3
}

-- Добавляем выпадающий список для выбора темы
settingsTab:AddDropdown({
    Text = "Тема интерфейса",
    Default = settings.theme,
    Options = {"Dark", "Light", "Dark Blue", "Purple", "Green", "Nyan"},
    Callback = function(value)
        settings.theme = value
        window:SetTheme(value)
        NYAN:Notify("Настройки", "Тема изменена на " .. value, 2)
    end
})

-- Добавляем слайдер для прозрачности интерфейса
settingsTab:AddSlider({
    Text = "Прозрачность",
    Min = 0,
    Max = 90,
    Default = settings.transparency,
    Suffix = "%",
    Callback = function(value)
        settings.transparency = value
        window:SetTransparency(value / 100)
    end
})

-- Добавляем слайдер для длительности уведомлений
settingsTab:AddSlider({
    Text = "Длительность уведомлений",
    Min = 1,
    Max = 10,
    Default = settings.notificationDuration,
    Suffix = " сек",
    Callback = function(value)
        settings.notificationDuration = value
        NYAN:Notify("Настройки", "Длительность уведомлений изменена", value)
    end
})

-- Добавляем кнопку для сброса настроек
settingsTab:AddButton({
    Text = "Сбросить настройки",
    Callback = function()
        -- Восстанавливаем начальные настройки
        settings = {
            theme = "Nyan",
            transparency = 0,
            notificationDuration = 3
        }
        
        -- Применяем настройки к интерфейсу
        window:SetTheme(settings.theme)
        window:SetTransparency(settings.transparency / 100)
        
        NYAN:Notify("Настройки", "Настройки сброшены до значений по умолчанию", 3)
    end
})

-- Добавляем информационную метку
settingsTab:AddLabel({
    Text = "О библиотеке",
    Description = "NYAN UI - Современная UI библиотека для Roblox.\nРазработана HARDHUBERS, 2025."
})
