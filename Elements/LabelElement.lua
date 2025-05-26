-- NYAN UI Library - Label Element

local LabelElement = {}
LabelElement.__index = LabelElement

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

-- Create a label element
function LabelElement.new(parent, options)
    local self = setmetatable({}, LabelElement)
    
    -- Default options
    options = options or {}
    self.Text = options.Text or "Label"
    self.Description = options.Description or ""
    self.TextSize = options.TextSize or 14
    self.DescriptionTextSize = options.DescriptionTextSize or 12
    self.Alignment = options.Alignment or Enum.TextXAlignment.Left
    self.Parent = parent
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        AccentColor = Color3.fromRGB(255, 105, 180),
        ElementBorder = Color3.fromRGB(65, 65, 65)
    }
    
    -- Create the label
    self:Create()
    
    return self
end

function LabelElement:Create()
    -- Main container
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, self.Description ~= "" and 40 or 30),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Label frame
    self.LabelFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Theme.ElementBackground,
        BackgroundTransparency = 0.9, -- More transparent than interactive elements
        Parent = self.Container
    })
    
    -- Corner rounding
    local uiCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.LabelFrame
    })
    
    -- Label text
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, self.TextSize + 2),
        Position = UDim2.new(0, 10, 0, self.Description ~= "" and 8 or (40 - self.TextSize) / 2),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = self.TextSize,
        TextXAlignment = self.Alignment,
        Parent = self.LabelFrame
    })
    
    -- Description (if provided)
    if self.Description and self.Description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, self.DescriptionTextSize + 2),
            Position = UDim2.new(0, 10, 0, self.TextSize + 10),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = self.DescriptionTextSize,
            TextXAlignment = self.Alignment,
            TextWrapped = true,
            Parent = self.LabelFrame
        })
    end
    
    -- Auto resize based on content
    self:UpdateSize()
end

function LabelElement:UpdateSize()
    -- Calculate container height based on content
    local height = 30 -- Minimum height
    
    if self.Description and self.Description ~= "" then
        -- Calculate description text height
        local textService = game:GetService("TextService")
        local textSize = self.DescriptionLabel.TextSize
        local frameWidth = self.LabelFrame.AbsoluteSize.X - 20 -- Padding
        
        local textBounds = textService:GetTextSize(
            self.Description,
            textSize,
            self.DescriptionLabel.Font,
            Vector2.new(frameWidth, 1000)
        )
        
        height = self.TextSize + 10 + textBounds.Y + 10 -- Title height + padding + description height + padding
    end
    
    -- Update container size
    self.Container.Size = UDim2.new(1, 0, 0, math.max(30, height))
end

function LabelElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
    self:UpdateSize()
end

function LabelElement:SetDescription(description)
    self.Description = description
    
    if self.DescriptionLabel then
        self.DescriptionLabel.Text = description
    elseif description and description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, self.DescriptionTextSize + 2),
            Position = UDim2.new(0, 10, 0, self.TextSize + 10),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = self.DescriptionTextSize,
            TextXAlignment = self.Alignment,
            TextWrapped = true,
            Parent = self.LabelFrame
        })
    end
    
    self:UpdateSize()
end

function LabelElement:SetAlignment(alignment)
    self.Alignment = alignment
    self.TextLabel.TextXAlignment = alignment
    
    if self.DescriptionLabel then
        self.DescriptionLabel.TextXAlignment = alignment
    end
end

function LabelElement:SetTextSize(textSize, descriptionTextSize)
    self.TextSize = textSize or self.TextSize
    self.DescriptionTextSize = descriptionTextSize or self.DescriptionTextSize
    
    self.TextLabel.TextSize = self.TextSize
    self.TextLabel.Size = UDim2.new(1, -20, 0, self.TextSize + 2)
    
    if self.DescriptionLabel then
        self.DescriptionLabel.TextSize = self.DescriptionTextSize
        self.DescriptionLabel.Size = UDim2.new(1, -20, 0, self.DescriptionTextSize + 2)
        self.DescriptionLabel.Position = UDim2.new(0, 10, 0, self.TextSize + 10)
    end
    
    self:UpdateSize()
end

function LabelElement:ApplyTheme(theme)
    self.Theme = theme
    self.TextLabel.TextColor3 = theme.TextColor
    
    if self.DescriptionLabel then
        self.DescriptionLabel.TextColor3 = theme.TextColor
    end
    
    self.LabelFrame.BackgroundColor3 = theme.ElementBackground
end

function LabelElement:Destroy()
    self.Container:Destroy()
end

return LabelElement
