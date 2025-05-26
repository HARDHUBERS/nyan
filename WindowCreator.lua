-- NYAN UI Library - Window Creator
-- Handles creating the main window GUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local WindowCreator = {}

-- Constants
local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local SHADOW_OFFSET = 4

-- Utility functions
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

-- Creates a window shadow
local function CreateShadow(parent, offset)
    local shadow = CreateInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Size = UDim2.new(1, offset * 2, 1, offset * 2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        ZIndex = -1,
        Parent = parent
    })
    
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = shadow
    })
    
    local blur = CreateInstance("BlurEffect", {
        Size = 20,
        Parent = shadow
    })
    
    return shadow
end

-- Creates the draggable title bar
local function CreateTitleBar(parent, window)
    local theme = window.Theme
    
    local titleBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.TopBar,
        BorderSizePixel = 0,
        Parent = parent
    })
    
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = titleBar
    })
    
    -- Only round the top corners
    local frameUnround = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.fromScale(0, 0.5),
        BackgroundColor3 = theme.TopBar,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = titleBar
    })
    
    -- Title
    local title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextColor3 = theme.TextColor,
        TextSize = 16,
        Text = window.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    -- Buttons
    local buttonsHolder = CreateInstance("Frame", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -110, 0, 0),
        BackgroundTransparency = 1,
        Parent = titleBar
    })
    
    local buttonsLayout = CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = buttonsHolder
    })
    
    -- Minimize button
    local minimizeButton = CreateInstance("ImageButton", {
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7072719338", -- You can use a different minimize icon
        ImageColor3 = theme.TextColor,
        LayoutOrder = 1,
        Parent = buttonsHolder
    })
    
    -- Close button
    local closeButton = CreateInstance("ImageButton", {
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7072725342", -- You can use a different close icon
        ImageColor3 = theme.TextColor,
        LayoutOrder = 2,
        Parent = buttonsHolder
    })
    
    -- Make the window draggable
    local dragging, dragStart, startPos = false, nil, nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            
            TweenService:Create(parent, TweenInfo.new(0.1), {
                Position = targetPos
            }):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Minimize and close functionality
    minimizeButton.MouseButton1Click:Connect(function()
        window:Minimize()
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        window:Close()
    end)
    
    return titleBar
end

-- Creates the tab selector area
local function CreateTabSelector(parent, window)
    local theme = window.Theme
    
    local tabSelector = CreateInstance("Frame", {
        Size = UDim2.new(0, 150, 1, -40),
        Position = UDim2.fromOffset(0, 40),
        BackgroundColor3 = theme.InactiveTab,
        BorderSizePixel = 0,
        Parent = parent
    })
    
    -- Only round the bottom-left corner
    local uiCornerBottomLeft = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = tabSelector
    })
    
    local frameUnroundTop = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.fromScale(0, 0),
        BackgroundColor3 = theme.InactiveTab,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = tabSelector
    })
    
    local frameUnroundRight = CreateInstance("Frame", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.fromScale(0.5, 0),
        BackgroundColor3 = theme.InactiveTab,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = tabSelector
    })
    
    -- Scroll for tabs
    local scrollFrame = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromOffset(5, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.AccentColor,
        CanvasSize = UDim2.fromScale(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = tabSelector
    })
    
    local listLayout = CreateInstance("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = scrollFrame
    })
    
    -- Logo/Brand at the top
    local logoContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 60),
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Parent = scrollFrame
    })
    
    local logo = CreateInstance("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextColor3 = theme.AccentColor,
        TextSize = 24,
        Text = "NYAN",
        Parent = logoContainer
    })
    
    return {
        Frame = tabSelector,
        ScrollFrame = scrollFrame,
        ListLayout = listLayout
    }
end

-- Creates the content area
local function CreateContentArea(parent, window)
    local theme = window.Theme
    
    local contentArea = CreateInstance("Frame", {
        Size = UDim2.new(1, -150, 1, -40),
        Position = UDim2.fromOffset(150, 40),
        BackgroundColor3 = theme.Card,
        BorderSizePixel = 0,
        Parent = parent
    })
    
    -- Only round the bottom-right corner
    local uiCornerBottomRight = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = contentArea
    })
    
    local frameUnroundTop = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.fromScale(0, 0),
        BackgroundColor3 = theme.Card,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = contentArea
    })
    
    local frameUnroundLeft = CreateInstance("Frame", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.fromScale(0, 0),
        BackgroundColor3 = theme.Card,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = contentArea
    })
    
    -- Container for tab content
    local tabContent = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        Parent = contentArea
    })
    
    return {
        Frame = contentArea,
        TabContent = tabContent
    }
end

-- Create the actual window
function WindowCreator:Create(window)
    local theme = window.Theme
    local screenGui = CreateInstance("ScreenGui", {
        Name = "NyanUI_" .. window.Title,
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
    
    -- Main container
    local mainContainer = CreateInstance("Frame", {
        Size = window.Size,
        Position = window.Position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Parent = screenGui
    })
    
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = mainContainer
    })
    
    -- Add shadow
    local shadow = CreateShadow(mainContainer, SHADOW_OFFSET)
    
    -- Create the title bar
    local titleBar = CreateTitleBar(mainContainer, window)
    
    -- Create tab selector
    local tabSelector = CreateTabSelector(mainContainer, window)
    
    -- Create content area
    local contentArea = CreateContentArea(mainContainer, window)
    
    -- Add window methods
    function window:Minimize()
        window.Minimized = not window.Minimized
        
        local targetSize = window.Minimized and UDim2.new(0, window.Size.X.Offset, 0, 40) or window.Size
        
        TweenService:Create(mainContainer, TWEEN_INFO, {
            Size = targetSize
        }):Play()
        
        tabSelector.Frame.Visible = not window.Minimized
        contentArea.Frame.Visible = not window.Minimized
    end
    
    function window:Close()
        local fadeTween = TweenService:Create(screenGui, TWEEN_INFO, {
            Transparency = 1
        })
        
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end
    
    -- Store GUI references
    window.GUI = {
        ScreenGui = screenGui,
        MainContainer = mainContainer,
        TitleBar = titleBar,
        TabSelector = tabSelector,
        ContentArea = contentArea,
        Shadow = shadow
    }
    
    return window
end

return WindowCreator
