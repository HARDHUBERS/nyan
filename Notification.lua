-- NYAN UI Library - Notification System

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local NotificationSystem = {}

-- Animation constants
local APPEAR_TWEEN = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local DISAPPEAR_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

-- Utility function
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

-- Initialize the notification system
function NotificationSystem.Init(theme)
    if NotificationSystem.Initialized then
        return NotificationSystem
    end
    
    NotificationSystem.Initialized = true
    NotificationSystem.Theme = theme or {
        NotificationBackground = Color3.fromRGB(35, 35, 35),
        TextColor = Color3.fromRGB(255, 255, 255),
        AccentColor = Color3.fromRGB(255, 105, 180)
    }
    NotificationSystem.ActiveNotifications = {}
    NotificationSystem.NotificationCount = 0
    
    -- Create ScreenGui for notifications
    local screenGui = CreateInstance("ScreenGui", {
        Name = "NyanNotifications",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Use gethui if possible for better security
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        screenGui.Parent = gethui()
    else
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Container for notifications
    local container = CreateInstance("Frame", {
        Name = "NotificationContainer",
        Size = UDim2.new(0, 280, 1, 0),
        Position = UDim2.new(1, -300, 0, 0),
        BackgroundTransparency = 1,
        Parent = screenGui
    })
    
    -- Layout for notifications
    local layout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = container
    })
    
    -- Add padding
    local padding = CreateInstance("UIPadding", {
        PaddingBottom = UDim.new(0, 20),
        Parent = container
    })
    
    NotificationSystem.ScreenGui = screenGui
    NotificationSystem.Container = container
    
    return NotificationSystem
end

-- Create a new notification
function NotificationSystem.Notify(options)
    if not NotificationSystem.Initialized then
        NotificationSystem.Init()
    end
    
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 5 -- seconds
    local subContent = options.SubContent or nil
    local icon = options.Icon or nil
    
    -- Create notification
    local notification = {}
    NotificationSystem.NotificationCount = NotificationSystem.NotificationCount + 1
    notification.Id = NotificationSystem.NotificationCount
    
    -- Main frame
    notification.Frame = CreateInstance("Frame", {
        Size = UDim2.new(0, 260, 0, subContent and 80 or 60),
        BackgroundColor3 = NotificationSystem.Theme.NotificationBackground,
        BackgroundTransparency = 0.1,
        Position = UDim2.new(1, 300, 0, 0), -- Start off-screen
        LayoutOrder = notification.Id,
        Parent = NotificationSystem.Container
    })
    
    -- Corners
    local corner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = notification.Frame
    })
    
    -- Border
    local stroke = CreateInstance("UIStroke", {
        Color = NotificationSystem.Theme.AccentColor,
        Thickness = 1.5,
        Transparency = 0.7,
        Parent = notification.Frame
    })
    
    -- Title
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
    
    -- Icon (if provided)
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
    
    -- Content
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
    
    -- Sub-content (if provided)
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
    
    -- Progress bar (for duration)
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
    
    -- Animate notification in
    local appearTween = TweenService:Create(
        notification.Frame,
        APPEAR_TWEEN,
        {Position = UDim2.new(0, 0, 0, 0)}
    )
    
    appearTween:Play()
    
    -- Animate progress bar
    if duration and duration > 0 then
        local progressTween = TweenService:Create(
            progressBar,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {Size = UDim2.new(0, 0, 1, 0)}
        )
        
        progressTween:Play()
        
        -- Set up auto-removal
        task.delay(duration, function()
            NotificationSystem.Remove(notification)
        end)
    end
    
    -- Store notification
    table.insert(NotificationSystem.ActiveNotifications, notification)
    
    -- Return notification object
    return notification
end

-- Remove a notification
function NotificationSystem.Remove(notification)
    -- Find notification in active list
    local index = table.find(NotificationSystem.ActiveNotifications, notification)
    if not index then return end
    
    -- Remove from list
    table.remove(NotificationSystem.ActiveNotifications, index)
    
    -- Animate out
    local disappearTween = TweenService:Create(
        notification.Frame,
        DISAPPEAR_TWEEN,
        {Position = UDim2.new(1, 300, 0, 0), BackgroundTransparency = 1}
    )
    
    disappearTween:Play()
    
    -- Destroy after animation
    disappearTween.Completed:Connect(function()
        notification.Frame:Destroy()
    end)
end

-- Remove all notifications
function NotificationSystem.ClearAll()
    for _, notification in pairs(NotificationSystem.ActiveNotifications) do
        NotificationSystem.Remove(notification)
    end
end

-- Apply a theme to the notification system
function NotificationSystem.ApplyTheme(theme)
    NotificationSystem.Theme = theme
    
    -- Update active notifications
    for _, notification in pairs(NotificationSystem.ActiveNotifications) do
        notification.Frame.BackgroundColor3 = theme.NotificationBackground
        
        -- Find and update labels and progress bars
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

return NotificationSystem
