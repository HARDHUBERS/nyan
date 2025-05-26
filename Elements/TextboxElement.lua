-- NYAN UI Library - Textbox Element

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local TextboxElement = {}
TextboxElement.__index = TextboxElement

-- Animation constants
local HOVER_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local FOCUS_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

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

-- Create a textbox element
function TextboxElement.new(parent, options)
    local self = setmetatable({}, TextboxElement)
    
    -- Default options
    options = options or {}
    self.Text = options.Text or "Textbox"
    self.Description = options.Description or ""
    self.Placeholder = options.Placeholder or "Enter text..."
    self.Default = options.Default or ""
    self.Callback = options.Callback or function() end
    self.ClearOnFocus = options.ClearOnFocus ~= nil and options.ClearOnFocus or true
    self.MaxLength = options.MaxLength or 0 -- 0 means no limit
    self.Numeric = options.Numeric or false
    self.Value = self.Default
    self.Parent = parent
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        AccentColor = Color3.fromRGB(255, 105, 180),
        ElementBorder = Color3.fromRGB(65, 65, 65)
    }
    
    -- Create the textbox
    self:Create()
    
    return self
end

function TextboxElement:Create()
    -- Main container
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Textbox frame
    self.TextboxFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Theme.ElementBackground,
        Parent = self.Container
    })
    
    -- Corner rounding
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.TextboxFrame
    })
    
    -- Border
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Transparency = 0.5,
        Parent = self.TextboxFrame
    })
    
    -- Textbox label
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0.5, -10, 0, 14),
        Position = UDim2.new(0, 10, 0.5, -7),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TextboxFrame
    })
    
    -- Description (if provided)
    if self.Description and self.Description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0.5, -10, 0, 12),
            Position = UDim2.new(0, 10, 0.5, 7),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.TextboxFrame
        })
    end
    
    -- Textbox input container
    self.InputContainer = CreateInstance("Frame", {
        Size = UDim2.new(0.5, -20, 0, 26),
        Position = UDim2.new(0.5, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(0, 0, 0), 0.2),
        Parent = self.TextboxFrame
    })
    
    -- Input container corner
    local inputCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = self.InputContainer
    })
    
    -- Input container border
    local inputStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Transparency = 0.7,
        Parent = self.InputContainer
    })
    
    -- Textbox input
    self.TextBox = CreateInstance("TextBox", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = self.Default,
        PlaceholderText = self.Placeholder,
        TextColor3 = self.Theme.TextColor,
        PlaceholderColor3 = self.Theme.TextColor:Lerp(Color3.new(0, 0, 0), 0.5),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = self.ClearOnFocus,
        ClipsDescendants = true,
        Parent = self.InputContainer
    })
    
    -- Focus indicator
    self.FocusIndicator = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = self.Theme.AccentColor,
        BackgroundTransparency = 1,
        Parent = self.InputContainer
    })
    
    -- Setup animations and events
    self:SetupEvents()
    
    -- Set initial value
    self:SetValue(self.Value)
end

function TextboxElement:SetupEvents()
    -- Hover effect
    self.TextboxFrame.MouseEnter:Connect(function()
        TweenService:Create(
            self.TextboxFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground:Lerp(self.Theme.AccentColor, 0.1)}
        ):Play()
    end)
    
    self.TextboxFrame.MouseLeave:Connect(function()
        TweenService:Create(
            self.TextboxFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground}
        ):Play()
    end)
    
    -- Focus effects
    self.TextBox.Focused:Connect(function()
        TweenService:Create(
            self.InputContainer, 
            FOCUS_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(1, 1, 1), 0.05)}
        ):Play()
        
        TweenService:Create(
            self.FocusIndicator, 
            FOCUS_TWEEN, 
            {BackgroundTransparency = 0}
        ):Play()
        
        -- Update the border
        TweenService:Create(
            self.InputContainer:FindFirstChildOfClass("UIStroke"), 
            FOCUS_TWEEN, 
            {Color = self.Theme.AccentColor, Transparency = 0.3}
        ):Play()
    end)
    
    self.TextBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(
            self.InputContainer, 
            FOCUS_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(0, 0, 0), 0.2)}
        ):Play()
        
        TweenService:Create(
            self.FocusIndicator, 
            FOCUS_TWEEN, 
            {BackgroundTransparency = 1}
        ):Play()
        
        -- Reset the border
        TweenService:Create(
            self.InputContainer:FindFirstChildOfClass("UIStroke"), 
            FOCUS_TWEEN, 
            {Color = self.Theme.ElementBorder, Transparency = 0.7}
        ):Play()
        
        -- Set the value and callback
        self:SetValue(self.TextBox.Text)
        self.Callback(self.Value, enterPressed)
    end)
    
    -- Process text input
    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = self.TextBox.Text
        
        -- Apply max length if needed
        if self.MaxLength > 0 and #text > self.MaxLength then
            text = string.sub(text, 1, self.MaxLength)
            self.TextBox.Text = text
        end
        
        -- Apply numeric filter if needed
        if self.Numeric then
            -- Only allow numbers and decimal point
            local numericOnly = string.gsub(text, "[^%d%.]", "")
            
            -- Handle special cases (multiple decimal points, etc.)
            local decimalCount = 0
            for i = 1, #numericOnly do
                if string.sub(numericOnly, i, i) == "." then
                    decimalCount = decimalCount + 1
                end
            end
            
            if decimalCount > 1 then
                -- Keep only the first decimal point
                local parts = string.split(numericOnly, ".")
                numericOnly = parts[1] .. "."
                for i = 2, #parts do
                    numericOnly = numericOnly .. parts[i]
                end
            end
            
            if numericOnly ~= text then
                self.TextBox.Text = numericOnly
                text = numericOnly
            end
        end
        
        -- Update the internal value without triggering the callback
        self.Value = text
    end)
end

function TextboxElement:SetValue(value)
    if self.Numeric then
        -- Try to convert to number
        local num = tonumber(value)
        if num then
            value = tostring(num)
        else
            value = ""
        end
    end
    
    -- Apply max length if needed
    if self.MaxLength > 0 and #value > self.MaxLength then
        value = string.sub(value, 1, self.MaxLength)
    end
    
    self.Value = value
    self.TextBox.Text = value
    
    return value
end

function TextboxElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function TextboxElement:SetDescription(description)
    self.Description = description
    
    if self.DescriptionLabel then
        self.DescriptionLabel.Text = description
    elseif description and description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0.5, -10, 0, 12),
            Position = UDim2.new(0, 10, 0.5, 7),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.TextboxFrame
        })
    end
end

function TextboxElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function TextboxElement:Destroy()
    self.Container:Destroy()
end

return TextboxElement
