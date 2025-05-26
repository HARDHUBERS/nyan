-- NYAN UI Library - Toggle Element

local TweenService = game:GetService("TweenService")

local ToggleElement = {}
ToggleElement.__index = ToggleElement

-- Animation constants
local TOGGLE_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local HOVER_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

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

-- Create a toggle element
function ToggleElement.new(parent, options)
    local self = setmetatable({}, ToggleElement)
    
    -- Default options
    options = options or {}
    self.Text = options.Text or "Toggle"
    self.Description = options.Description or ""
    self.Callback = options.Callback or function() end
    self.Default = options.Default or false
    self.Value = self.Default
    self.Parent = parent
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        AccentColor = Color3.fromRGB(255, 105, 180),
        ElementBorder = Color3.fromRGB(65, 65, 65)
    }
    
    -- Create the toggle
    self:Create()
    
    return self
end

function ToggleElement:Create()
    -- Main container
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Toggle frame
    self.ToggleFrame = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Theme.ElementBackground,
        AutoButtonColor = false,
        Font = Enum.Font.SourceSans,
        Text = "", -- We'll use a separate label for the text
        TextSize = 14,
        Parent = self.Container
    })
    
    -- Corner rounding
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.ToggleFrame
    })
    
    -- Border
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Transparency = 0.5,
        Parent = self.ToggleFrame
    })
    
    -- Toggle text
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 0, 14),
        Position = UDim2.new(0, 10, 0.5, -7),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.ToggleFrame
    })
    
    -- Description (if provided)
    if self.Description and self.Description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -60, 0, 12),
            Position = UDim2.new(0, 10, 0.5, 7),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.ToggleFrame
        })
    end
    
    -- Toggle indicator container
    self.ToggleContainer = CreateInstance("Frame", {
        Size = UDim2.fromOffset(44, 22),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(0, 0, 0), 0.3),
        Parent = self.ToggleFrame
    })
    
    -- Toggle container corner
    local toggleCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 11),
        Parent = self.ToggleContainer
    })
    
    -- Toggle indicator (the circle that moves)
    self.ToggleIndicator = CreateInstance("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = self.ToggleContainer
    })
    
    -- Indicator corner
    local indicatorCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.ToggleIndicator
    })
    
    -- Ripple effect container
    self.RippleContainer = CreateInstance("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.ToggleFrame
    })
    
    -- Setup animations and events
    self:SetupEvents()
    
    -- Set initial state
    self:SetValue(self.Value)
end

function ToggleElement:SetupEvents()
    -- Hover effect
    self.ToggleFrame.MouseEnter:Connect(function()
        TweenService:Create(
            self.ToggleFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground:Lerp(self.Theme.AccentColor, 0.1)}
        ):Play()
    end)
    
    self.ToggleFrame.MouseLeave:Connect(function()
        TweenService:Create(
            self.ToggleFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground}
        ):Play()
    end)
    
    -- Toggle functionality
    self.ToggleFrame.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
        self.Callback(self.Value)
    end)
    
    -- Ripple effect
    self.ToggleFrame.MouseButton1Down:Connect(function(x, y)
        local ripple = CreateInstance("Frame", {
            Position = UDim2.fromOffset(x - self.ToggleFrame.AbsolutePosition.X, y - self.ToggleFrame.AbsolutePosition.Y),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.7,
            Parent = self.RippleContainer
        })
        
        local uiCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = ripple
        })
        
        local maxSize = math.max(self.ToggleFrame.AbsoluteSize.X, self.ToggleFrame.AbsoluteSize.Y) * 2
        
        TweenService:Create(
            ripple, 
            TweenInfo.new(0.5), 
            {Size = UDim2.fromOffset(maxSize, maxSize), BackgroundTransparency = 1}
        ):Play()
        
        game:GetService("Debris"):AddItem(ripple, 0.5)
    end)
end

function ToggleElement:SetValue(value)
    self.Value = value
    
    -- Position tween
    TweenService:Create(
        self.ToggleIndicator, 
        TOGGLE_TWEEN, 
        {Position = UDim2.new(0, self.Value and 24 or 2, 0.5, 0)}
    ):Play()
    
    -- Color tweens
    TweenService:Create(
        self.ToggleContainer, 
        TOGGLE_TWEEN, 
        {BackgroundColor3 = self.Value and self.Theme.AccentColor or self.Theme.ElementBackground:Lerp(Color3.new(0, 0, 0), 0.3)}
    ):Play()
    
    -- Optional animation for indicator
    TweenService:Create(
        self.ToggleIndicator, 
        TOGGLE_TWEEN, 
        {
            BackgroundColor3 = self.Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200),
            Size = UDim2.fromOffset(self.Value and 18 or 16, self.Value and 18 or 16)
        }
    ):Play()
    
    return self.Value
end

function ToggleElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function ToggleElement:SetDescription(description)
    self.Description = description
    
    if self.DescriptionLabel then
        self.DescriptionLabel.Text = description
    elseif description and description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -60, 0, 12),
            Position = UDim2.new(0, 10, 0.5, 7),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.ToggleFrame
        })
    end
end

function ToggleElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function ToggleElement:Destroy()
    self.Container:Destroy()
end

return ToggleElement
