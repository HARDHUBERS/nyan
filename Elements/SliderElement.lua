-- NYAN UI Library - Slider Element

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local SliderElement = {}
SliderElement.__index = SliderElement

-- Animation constants
local HOVER_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local DRAG_TWEEN = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

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

-- Create a slider element
function SliderElement.new(parent, options)
    local self = setmetatable({}, SliderElement)
    
    -- Default options
    options = options or {}
    self.Text = options.Text or "Slider"
    self.Description = options.Description or ""
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = math.clamp(options.Default or 50, self.Min, self.Max)
    self.Increment = options.Increment or 1
    self.Suffix = options.Suffix or ""
    self.Callback = options.Callback or function() end
    self.Value = self.Default
    self.Parent = parent
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        AccentColor = Color3.fromRGB(255, 105, 180),
        ElementBorder = Color3.fromRGB(65, 65, 65)
    }
    self.Dragging = false
    
    -- Create the slider
    self:Create()
    
    return self
end

function SliderElement:Create()
    -- Main container
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Slider frame
    self.SliderFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Theme.ElementBackground,
        Parent = self.Container
    })
    
    -- Corner rounding
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.SliderFrame
    })
    
    -- Border
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Transparency = 0.5,
        Parent = self.SliderFrame
    })
    
    -- Slider text
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -120, 0, 14),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.SliderFrame
    })
    
    -- Value display
    self.ValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.fromOffset(50, 14),
        Position = UDim2.new(1, -60, 0, 10),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = tostring(self.Value) .. self.Suffix,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = self.SliderFrame
    })
    
    -- Description (if provided)
    if self.Description and self.Description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 12),
            Position = UDim2.new(0, 10, 0, 25),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.SliderFrame
        })
    end
    
    -- Slider bar background
    self.SliderBackground = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 1, -13),
        BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(0, 0, 0), 0.3),
        Parent = self.SliderFrame
    })
    
    -- Slider background corner
    local backgroundCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 3),
        Parent = self.SliderBackground
    })
    
    -- Slider fill (the colored part)
    self.SliderFill = CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = self.Theme.AccentColor,
        Parent = self.SliderBackground
    })
    
    -- Slider fill corner
    local fillCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 3),
        Parent = self.SliderFill
    })
    
    -- Slider knob (the draggable part)
    self.SliderKnob = CreateInstance("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = self.SliderFill
    })
    
    -- Knob corner
    local knobCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.SliderKnob
    })
    
    -- Knob shadow
    local knobShadow = CreateInstance("ImageLabel", {
        Size = UDim2.new(1, 4, 1, 4),
        Position = UDim2.fromOffset(-2, -2),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7912134082",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.6,
        Parent = self.SliderKnob
    })
    
    -- Setup animations and events
    self:SetupEvents()
    
    -- Set initial value
    self:SetValue(self.Value)
end

function SliderElement:SetupEvents()
    -- Hover effect
    self.SliderFrame.MouseEnter:Connect(function()
        TweenService:Create(
            self.SliderFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground:Lerp(self.Theme.AccentColor, 0.1)}
        ):Play()
    end)
    
    self.SliderFrame.MouseLeave:Connect(function()
        TweenService:Create(
            self.SliderFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground}
        ):Play()
    end)
    
    -- Slider functionality
    self.SliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            self:UpdateSlider(input.Position.X)
        end
    end)
    
    self.SliderBackground.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            self:UpdateSlider(input.Position.X)
        end
    end)
    
    -- Knob events for better UX
    self.SliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            
            -- Animation for pressed state
            TweenService:Create(
                self.SliderKnob, 
                DRAG_TWEEN, 
                {Size = UDim2.fromOffset(18, 18)}
            ):Play()
        end
    end)
    
    self.SliderKnob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
            
            -- Animation for released state
            TweenService:Create(
                self.SliderKnob, 
                DRAG_TWEEN, 
                {Size = UDim2.fromOffset(16, 16)}
            ):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
            
            -- Animation for released state
            TweenService:Create(
                self.SliderKnob, 
                DRAG_TWEEN, 
                {Size = UDim2.fromOffset(16, 16)}
            ):Play()
        end
    end)
end

function SliderElement:UpdateSlider(posX)
    local background = self.SliderBackground
    local fill = self.SliderFill
    local absoluteSize = background.AbsoluteSize.X
    local absolutePosition = background.AbsolutePosition.X
    
    -- Calculate relative position
    local position = math.clamp(posX - absolutePosition, 0, absoluteSize)
    local percent = position / absoluteSize
    
    -- Calculate the value based on the percent
    local rawValue = self.Min + ((self.Max - self.Min) * percent)
    
    -- Apply increment if needed
    if self.Increment > 0 then
        rawValue = math.floor(rawValue / self.Increment + 0.5) * self.Increment
    end
    
    -- Clamp and set value
    self:SetValue(math.clamp(rawValue, self.Min, self.Max))
end

function SliderElement:SetValue(value)
    -- Clamp the value between min and max
    value = math.clamp(value, self.Min, self.Max)
    
    -- Round to increment if needed
    if self.Increment > 0 then
        value = math.floor(value / self.Increment + 0.5) * self.Increment
    end
    
    -- Calculate the display value with precision
    local displayValue = math.floor(value * 100 + 0.5) / 100
    
    -- Update value and UI
    self.Value = value
    self.ValueLabel.Text = tostring(displayValue) .. self.Suffix
    
    -- Calculate the percentage for the UI
    local percent = (value - self.Min) / (self.Max - self.Min)
    
    -- Update the fill and knob positions
    self.SliderFill.Size = UDim2.fromScale(percent, 1)
    
    -- Call the callback
    self.Callback(value)
    
    return value
end

function SliderElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function SliderElement:SetDescription(description)
    self.Description = description
    
    if self.DescriptionLabel then
        self.DescriptionLabel.Text = description
    elseif description and description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 12),
            Position = UDim2.new(0, 10, 0, 25),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.SliderFrame
        })
    end
end

function SliderElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function SliderElement:Destroy()
    self.Container:Destroy()
end

return SliderElement
