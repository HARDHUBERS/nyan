-- NYAN UI Library - Button Element

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ButtonElement = {}
ButtonElement.__index = ButtonElement

-- Animation constants
local HOVER_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local CLICK_TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

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

-- Create a button element
function ButtonElement.new(parent, options)
    local self = setmetatable({}, ButtonElement)
    
    -- Default options
    options = options or {}
    self.Text = options.Text or "Button"
    self.Description = options.Description or ""
    self.Callback = options.Callback or function() end
    self.Icon = options.Icon or nil
    self.Parent = parent
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        AccentColor = Color3.fromRGB(255, 105, 180),
        ElementBorder = Color3.fromRGB(65, 65, 65)
    }
    
    -- Create the button
    self:Create()
    
    return self
end

function ButtonElement:Create()
    -- Main container
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Button frame
    self.ButtonFrame = CreateInstance("TextButton", {
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
        Parent = self.ButtonFrame
    })
    
    -- Border
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Transparency = 0.5,
        Parent = self.ButtonFrame
    })
    
    -- Icon (if provided)
    if self.Icon then
        self.IconLabel = CreateInstance("ImageLabel", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = self.Icon,
            ImageColor3 = self.Theme.TextColor,
            Parent = self.ButtonFrame
        })
    end
    
    -- Button text
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, self.Icon and -40 or -20, 0, 14),
        Position = UDim2.new(0, self.Icon and 40 or 10, 0.5, -7),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.ButtonFrame
    })
    
    -- Description (if provided)
    if self.Description and self.Description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, self.Icon and -40 or -20, 0, 12),
            Position = UDim2.new(0, self.Icon and 40 or 10, 0.5, 7),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.ButtonFrame
        })
    end
    
    -- Ripple effect container
    self.RippleContainer = CreateInstance("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.ButtonFrame
    })
    
    -- Setup animations and events
    self:SetupEvents()
end

function ButtonElement:SetupEvents()
    -- Hover effect
    self.ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(
            self.ButtonFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground:Lerp(self.Theme.AccentColor, 0.1)}
        ):Play()
    end)
    
    self.ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(
            self.ButtonFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground}
        ):Play()
    end)
    
    -- Click effect
    self.ButtonFrame.MouseButton1Down:Connect(function()
        TweenService:Create(
            self.ButtonFrame, 
            CLICK_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground:Lerp(self.Theme.AccentColor, 0.2)}
        ):Play()
    end)
    
    self.ButtonFrame.MouseButton1Up:Connect(function()
        TweenService:Create(
            self.ButtonFrame, 
            CLICK_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground:Lerp(self.Theme.AccentColor, 0.1)}
        ):Play()
    end)
    
    -- Ripple effect
    self.ButtonFrame.MouseButton1Down:Connect(function(x, y)
        local ripple = CreateInstance("Frame", {
            Position = UDim2.fromOffset(x - self.ButtonFrame.AbsolutePosition.X, y - self.ButtonFrame.AbsolutePosition.Y),
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
        
        local maxSize = math.max(self.ButtonFrame.AbsoluteSize.X, self.ButtonFrame.AbsoluteSize.Y) * 2
        
        TweenService:Create(
            ripple, 
            TweenInfo.new(0.5), 
            {Size = UDim2.fromOffset(maxSize, maxSize), BackgroundTransparency = 1}
        ):Play()
        
        game:GetService("Debris"):AddItem(ripple, 0.5)
    end)
    
    -- Callback
    self.ButtonFrame.MouseButton1Click:Connect(function()
        self.Callback()
    end)
end

function ButtonElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function ButtonElement:SetDescription(description)
    self.Description = description
    
    if self.DescriptionLabel then
        self.DescriptionLabel.Text = description
    elseif description and description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, self.Icon and -40 or -20, 0, 12),
            Position = UDim2.new(0, self.Icon and 40 or 10, 0.5, 7),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.ButtonFrame
        })
    end
end

function ButtonElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function ButtonElement:Destroy()
    self.Container:Destroy()
end

return ButtonElement
