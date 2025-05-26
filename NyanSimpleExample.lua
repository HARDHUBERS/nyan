-- NYAN UI Library - Простой пример загрузки
-- Автор: HARDHUBERS

-- Основные переменные для загрузки
local repo = 'https://raw.githubusercontent.com/HARDHUBERS/nyan/main/'
local modules = {}

-- Функция для загрузки модуля из репозитория
local function LoadModule(moduleName)
    if modules[moduleName] then
        return modules[moduleName]
    end
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(repo .. moduleName .. '.lua'))()
    end)
    
    if success then
        modules[moduleName] = result
        return result
    else
        warn('Не удалось загрузить модуль: ' .. moduleName)
        warn(result)
        return nil
    end
end

-- Инициализация библиотеки
local function InitializeNyan()
    -- Загрузка основных компонентов
    local NyanLibrary = LoadModule('NyanLibrary')
    local WindowCreator = LoadModule('WindowCreator')
    local Elements = LoadModule('Elements')
    local Themes = LoadModule('Themes')
    local Notification = LoadModule('Notification')
    local TabSystem = LoadModule('TabSystem')
    
    -- Если не удалось загрузить основной модуль, прекращаем выполнение
    if not NyanLibrary then
        warn('NYAN UI Library не может быть инициализирована')
        return nil
    end
    
    -- Создаем экземпляр библиотеки
    local NYAN = {}
    
    -- Примеры функций из библиотеки
    NYAN.CreateWindow = function(options)
        options = options or {}
        options.Title = options.Title or "NYAN UI"
        options.Theme = options.Theme or "Nyan"
        
        -- Здесь должен быть вызов настоящего CreateWindow из WindowCreator
        -- Поскольку у нас нет доступа к модулям сервера, создадим заглушку для примера
        local window = {
            AddTab = function(tabOptions)
                tabOptions = tabOptions or {}
                tabOptions.Title = tabOptions.Title or "Tab"
                
                -- Возвращаем заглушку вкладки
                return {
                    AddButton = function() end,
                    AddToggle = function() end,
                    AddSlider = function() end,
                    AddTextbox = function() end,
                    AddDropdown = function() end,
                    AddKeybind = function() end,
                    AddLabel = function() end
                }
            end,
            SetTheme = function(themeName) end,
            Toggle = function() end
        }
        
        return window
    end
    
    -- Функция для отображения уведомлений
    NYAN.Notify = function(options)
        options = options or {}
        options.Title = options.Title or "Уведомление"
        options.Content = options.Content or ""
        options.Duration = options.Duration or 3
        
        -- Здесь должен быть вызов настоящей системы уведомлений
        print("[NYAN] Notification: " .. options.Title .. " - " .. options.Content)
    end
    
    -- Возвращаем интерфейс библиотеки
    return NYAN
end

-- Создаем экземпляр библиотеки
local NYAN = InitializeNyan()

-- Проверяем, успешно ли инициализирована библиотека
if not NYAN then
    warn("NYAN UI Library не может быть загружена")
    return
end

-- Создаем демонстрационное окно
local window = NYAN.CreateWindow({
    Title = "NYAN Demo",
    Theme = "Nyan"
})

-- Создаем вкладку
local mainTab = window:AddTab({
    Title = "Главная"
})

-- Отображаем уведомление
NYAN.Notify({
    Title = "NYAN UI Library",
    Content = "Демо-версия успешно загружена!",
    Duration = 5
})

-- Возвращаем библиотеку для использования
return NYAN
