-- NYAN UI Library - Пример использования
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Определение ссылки на репозиторий
local repo = 'https://raw.githubusercontent.com/ВАШ_ПОЛЬЗОВАТЕЛЬ/NYAN/main/'
-- Замените "ВАШ_ПОЛЬЗОВАТЕЛЬ" на ваше имя пользователя GitHub

-- Функция для загрузки модулей с GitHub
local function requireFromUrl(url)
    return loadstring(game:HttpGet(url))()
end

-- Загружаем основные модули библиотеки
local function LoadNyanLibrary()
    -- Создаем временное окружение для библиотеки
    local env = {}
    
    -- Загружаем основной модуль
    local NyanLibrary = requireFromUrl(repo..'NyanLibrary.lua')
    
    -- Устанавливаем ссылки на необходимые модули
    NyanLibrary._REPO_URL = repo
    NyanLibrary._requireFromUrl = requireFromUrl
    
    return NyanLibrary
end

-- Загружаем библиотеку
local NYAN = LoadNyanLibrary()

-- Пример использования библиотеки
local window = NYAN:CreateWindow({
    Title = "NYAN UI Library",
    Theme = "Nyan", -- Доступные темы: "Dark", "Light", "Dark Blue", "Purple", "Green", "Nyan"
    Size = {500, 350} -- Ширина, Высота
})

-- Создаем первую вкладку
local mainTab = window:AddTab({
    Title = "Главная",
    Icon = "rbxassetid://3926305904" -- ID иконки из Roblox Asset
})

-- Добавляем элементы на вкладку
mainTab:AddLabel({
    Text = "Добро пожаловать в NYAN UI!",
    Description = "Современная UI библиотека для Roblox"
})

mainTab:AddButton({
    Text = "Нажми меня!",
    Callback = function()
        NYAN.Notify({
            Title = "Успех!",
            Content = "Вы нажали кнопку!",
            Duration = 3
        })
    end
})

mainTab:AddToggle({
    Text = "Включить опцию",
    Default = false,
    Callback = function(value)
        print("Опция " .. (value and "включена" or "выключена"))
    end
})

mainTab:AddSlider({
    Text = "Скорость",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Установлена скорость: " .. value)
    end
})

-- Создаем вторую вкладку
local settingsTab = window:AddTab({
    Title = "Настройки",
    Icon = "rbxassetid://3926307971" -- Другая иконка
})

-- Добавляем элементы на вторую вкладку
settingsTab:AddDropdown({
    Text = "Выберите тему",
    Default = "Nyan",
    Options = {"Dark", "Light", "Dark Blue", "Purple", "Green", "Nyan"},
    Callback = function(selected)
        window:SetTheme(selected)
        NYAN.Notify({
            Title = "Тема изменена",
            Content = "Установлена тема: " .. selected,
            Duration = 2
        })
    end
})

settingsTab:AddTextbox({
    Text = "Введите имя",
    Default = "",
    Placeholder = "Ваше имя...",
    Callback = function(text)
        print("Введено имя: " .. text)
    end
})

settingsTab:AddKeybind({
    Text = "Переключить интерфейс",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        window:Toggle() -- Скрыть/показать интерфейс
    end
})

-- Показываем уведомление при запуске
NYAN.Notify({
    Title = "NYAN UI Library",
    Content = "Библиотека успешно загружена!",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})

-- Возвращаем библиотеку для использования в других скриптах
return NYAN
