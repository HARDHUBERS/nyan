-- NYAN UI Library - Dropdown Element

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local DropdownElement = {}
DropdownElement.__index = DropdownElement

-- Animation constants
local HOVER_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local DROPDOWN_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

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

-- Create a dropdown element
function DropdownElement.new(parent, options)
    local self = setmetatable({}, DropdownElement)
    
    -- Default options
    options = options or {}
    self.Text = options.Text or "Dropdown"
    self.Description = options.Description or ""
    self.Items = options.Items or {}
    self.Default = options.Default or nil
    self.MultiSelect = options.MultiSelect or false
    self.MaxVisibleItems = options.MaxVisibleItems or 6
    self.Callback = options.Callback or function() end
    self.Parent = parent
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        AccentColor = Color3.fromRGB(255, 105, 180),
        ElementBorder = Color3.fromRGB(65, 65, 65)
    }
    
    -- Setup internal values
    if self.MultiSelect then
        self.Value = {}
        if type(self.Default) == "table" then
            for _, item in ipairs(self.Default) do
                self.Value[item] = true
            end
        end
    else
        self.Value = self.Default
    end
    
    self.Open = false
    self.ItemButtons = {}
    
    -- Create the dropdown
    self:Create()
    
    return self
end

function DropdownElement:Create()
    -- Main container
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Dropdown frame
    self.DropdownFrame = CreateInstance("TextButton", {
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
        Parent = self.DropdownFrame
    })
    
    -- Border
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Transparency = 0.5,
        Parent = self.DropdownFrame
    })
    
    -- Dropdown text
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -60, 0, 14),
        Position = UDim2.new(0, 10, 0.5, -7),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.DropdownFrame
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
            Parent = self.DropdownFrame
        })
    end
    
    -- Selected value display
    self.ValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 120, 0, 14),
        Position = UDim2.new(1, -40, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = self:GetDisplayText(),
        TextColor3 = self.Theme.TextColor,
        TextTransparency = 0.2,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = self.DropdownFrame
    })
    
    -- Dropdown arrow
    self.ArrowLabel = CreateInstance("ImageLabel", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7072706318", -- Down arrow icon
        ImageColor3 = self.Theme.TextColor,
        Parent = self.DropdownFrame
    })
    
    -- Create dropdown items container
    self.ItemsContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0), -- Will be resized when opened
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = self.Theme.ElementBackground,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Parent = self.Container
    })
    
    -- Item container corner
    local itemsCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = self.ItemsContainer
    })
    
    -- Item container border
    local itemsStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Transparency = 0.5,
        Parent = self.ItemsContainer
    })
    
    -- Shadow for the dropdown
    local itemsShadow = CreateInstance("ImageLabel", {
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.fromOffset(-10, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7912134082",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = 9,
        Parent = self.ItemsContainer
    })
    
    -- Scrolling frame for items
    self.ScrollFrame = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.AccentColor,
        ScrollBarImageTransparency = 0.5,
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
        ZIndex = 10,
        Parent = self.ItemsContainer
    })
    
    -- List layout for items
    local listLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.ScrollFrame
    })
    
    -- Padding for items
    local listPadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = self.ScrollFrame
    })
    
    -- Create all item buttons
    self:CreateItems()
    
    -- Setup animations and events
    self:SetupEvents()
    
    -- Set initial value
    self:UpdateValueLabel()
end

function DropdownElement:CreateItems()
    -- Clear existing items
    for _, button in pairs(self.ItemButtons) do
        button:Destroy()
    end
    self.ItemButtons = {}
    
    -- Create new items
    for i, item in ipairs(self.Items) do
        self:CreateItem(item, i)
    end
    
    -- Update the scroll frame canvas size
    self:UpdateCanvasSize()
end

function DropdownElement:CreateItem(item, index)
    local isSelected = self.MultiSelect and self.Value[item] or self.Value == item
    
    -- Item button
    local itemButton = CreateInstance("TextButton", {
        Size = UDim2.new(1, -10, 0, 30),
        BackgroundColor3 = isSelected and self.Theme.AccentColor:Lerp(self.Theme.ElementBackground, 0.5) or self.Theme.ElementBackground:Lerp(Color3.new(1, 1, 1), 0.05),
        BackgroundTransparency = 0,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextSize = 14,
        LayoutOrder = index,
        ZIndex = 11,
        Parent = self.ScrollFrame
    })
    
    -- Item corner
    local itemCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = itemButton
    })
    
    -- Item text
    local itemText = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = tostring(item),
        TextColor3 = self.Theme.TextColor,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
        Parent = itemButton
    })
    
    -- Selection indicator (checkmark for multi-select or dot for single select)
    local indicator = CreateInstance("ImageLabel", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = self.MultiSelect and "rbxassetid://7072706318" or "rbxassetid://7072724538", -- Checkmark or dot
        ImageColor3 = self.Theme.TextColor,
        ImageTransparency = isSelected and 0 or 1,
        ZIndex = 11,
        Parent = itemButton
    })
    
    -- Selection highlighting
    if isSelected then
        if self.MultiSelect then
            -- For multi-select, add a visual checkmark
            indicator.Image = "rbxassetid://7072706318" -- Checkmark
            indicator.ImageTransparency = 0
        else
            -- For single select, use a dot
            indicator.Image = "rbxassetid://7072724538" -- Dot
            indicator.ImageTransparency = 0
        end
    end
    
    -- Item hover effect
    itemButton.MouseEnter:Connect(function()
        TweenService:Create(
            itemButton, 
            HOVER_TWEEN, 
            {BackgroundColor3 = isSelected 
                and self.Theme.AccentColor:Lerp(self.Theme.ElementBackground, 0.3) 
                or self.Theme.ElementBackground:Lerp(Color3.new(1, 1, 1), 0.1)}
        ):Play()
    end)
    
    itemButton.MouseLeave:Connect(function()
        TweenService:Create(
            itemButton, 
            HOVER_TWEEN, 
            {BackgroundColor3 = isSelected 
                and self.Theme.AccentColor:Lerp(self.Theme.ElementBackground, 0.5) 
                or self.Theme.ElementBackground:Lerp(Color3.new(1, 1, 1), 0.05)}
        ):Play()
    end)
    
    -- Item click event
    itemButton.MouseButton1Click:Connect(function()
        self:SelectItem(item)
    end)
    
    -- Store the button
    self.ItemButtons[item] = {
        Button = itemButton,
        Text = itemText,
        Indicator = indicator,
        IsSelected = isSelected
    }
end

function DropdownElement:SelectItem(item)
    if self.MultiSelect then
        -- Toggle the selection
        self.Value[item] = not self.Value[item]
        
        -- Update the button appearance
        local itemData = self.ItemButtons[item]
        if itemData then
            itemData.IsSelected = self.Value[item]
            
            -- Update visual state
            TweenService:Create(
                itemData.Button, 
                HOVER_TWEEN, 
                {BackgroundColor3 = itemData.IsSelected 
                    and self.Theme.AccentColor:Lerp(self.Theme.ElementBackground, 0.3) 
                    or self.Theme.ElementBackground:Lerp(Color3.new(1, 1, 1), 0.1)}
            ):Play()
            
            TweenService:Create(
                itemData.Indicator, 
                HOVER_TWEEN, 
                {ImageTransparency = itemData.IsSelected and 0 or 1}
            ):Play()
        end
    else
        -- Single select
        if self.Value ~= item then
            -- Update previous selection
            if self.Value and self.ItemButtons[self.Value] then
                local prevItemData = self.ItemButtons[self.Value]
                prevItemData.IsSelected = false
                
                TweenService:Create(
                    prevItemData.Button, 
                    HOVER_TWEEN, 
                    {BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(1, 1, 1), 0.05)}
                ):Play()
                
                TweenService:Create(
                    prevItemData.Indicator, 
                    HOVER_TWEEN, 
                    {ImageTransparency = 1}
                ):Play()
            end
            
            -- Set new selection
            self.Value = item
            
            -- Update button appearance
            local itemData = self.ItemButtons[item]
            if itemData then
                itemData.IsSelected = true
                
                TweenService:Create(
                    itemData.Button, 
                    HOVER_TWEEN, 
                    {BackgroundColor3 = self.Theme.AccentColor:Lerp(self.Theme.ElementBackground, 0.3)}
                ):Play()
                
                TweenService:Create(
                    itemData.Indicator, 
                    HOVER_TWEEN, 
                    {ImageTransparency = 0}
                ):Play()
            end
            
            -- Close the dropdown for single select
            self:Toggle(false)
        else
            -- Deselect if clicking the same item
            self.Value = nil
            
            -- Update button appearance
            local itemData = self.ItemButtons[item]
            if itemData then
                itemData.IsSelected = false
                
                TweenService:Create(
                    itemData.Button, 
                    HOVER_TWEEN, 
                    {BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(1, 1, 1), 0.05)}
                ):Play()
                
                TweenService:Create(
                    itemData.Indicator, 
                    HOVER_TWEEN, 
                    {ImageTransparency = 1}
                ):Play()
            end
            
            -- Close the dropdown
            self:Toggle(false)
        end
    end
    
    -- Update the value label
    self:UpdateValueLabel()
    
    -- Fire callback
    self.Callback(self.Value)
end

function DropdownElement:UpdateCanvasSize()
    -- Calculate the total height of all items
    local totalHeight = 0
    local itemCount = #self.Items
    
    if itemCount > 0 then
        -- Each item is 30 pixels high with 2 pixels padding
        totalHeight = (itemCount * 32) + 10 -- Adding padding at top and bottom
    end
    
    -- Update the canvas size
    self.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    
    -- Calculate the container height
    local containerHeight = math.min(totalHeight, self.MaxVisibleItems * 32 + 10)
    self.ContainerHeight = containerHeight
end

function DropdownElement:Toggle(forceState)
    if forceState ~= nil then
        self.Open = forceState
    else
        self.Open = not self.Open
    end
    
    -- Update visibility and size
    self.ItemsContainer.Visible = self.Open
    
    -- Animate the container size
    TweenService:Create(
        self.ItemsContainer, 
        DROPDOWN_TWEEN, 
        {Size = UDim2.new(1, 0, 0, self.Open and self.ContainerHeight or 0)}
    ):Play()
    
    -- Rotate the arrow
    TweenService:Create(
        self.ArrowLabel, 
        DROPDOWN_TWEEN, 
        {Rotation = self.Open and 180 or 0}
    ):Play()
    
    -- Change the main frame style when open
    TweenService:Create(
        self.DropdownFrame, 
        DROPDOWN_TWEEN, 
        {BackgroundColor3 = self.Open 
            and self.Theme.ElementBackground:Lerp(self.Theme.AccentColor, 0.05) 
            or self.Theme.ElementBackground}
    ):Play()
    
    -- Change the border style when open
    TweenService:Create(
        self.DropdownFrame:FindFirstChildOfClass("UIStroke"), 
        DROPDOWN_TWEEN, 
        {Color = self.Open and self.Theme.AccentColor or self.Theme.ElementBorder}
    ):Play()
end

function DropdownElement:GetDisplayText()
    if self.MultiSelect then
        local selected = {}
        local count = 0
        
        for item, isSelected in pairs(self.Value) do
            if isSelected then
                table.insert(selected, tostring(item))
                count = count + 1
            end
        end
        
        if count == 0 then
            return "None"
        elseif count <= 2 then
            return table.concat(selected, ", ")
        else
            return count .. " selected"
        end
    else
        return self.Value and tostring(self.Value) or "None"
    end
end

function DropdownElement:UpdateValueLabel()
    self.ValueLabel.Text = self:GetDisplayText()
end

function DropdownElement:SetupEvents()
    -- Hover effect
    self.DropdownFrame.MouseEnter:Connect(function()
        if not self.Open then
            TweenService:Create(
                self.DropdownFrame, 
                HOVER_TWEEN, 
                {BackgroundColor3 = self.Theme.ElementBackground:Lerp(self.Theme.AccentColor, 0.1)}
            ):Play()
        end
    end)
    
    self.DropdownFrame.MouseLeave:Connect(function()
        if not self.Open then
            TweenService:Create(
                self.DropdownFrame, 
                HOVER_TWEEN, 
                {BackgroundColor3 = self.Theme.ElementBackground}
            ):Play()
        end
    end)
    
    -- Toggle dropdown
    self.DropdownFrame.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Close dropdown when clicking elsewhere
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local position = input.Position
            
            -- Check if the click is outside the dropdown
            if self.Open then
                local dropdownPos = self.DropdownFrame.AbsolutePosition
                local dropdownSize = self.DropdownFrame.AbsoluteSize
                local itemsPos = self.ItemsContainer.AbsolutePosition
                local itemsSize = self.ItemsContainer.AbsoluteSize
                
                local inMainFrame = position.X >= dropdownPos.X and position.X <= dropdownPos.X + dropdownSize.X and
                                  position.Y >= dropdownPos.Y and position.Y <= dropdownPos.Y + dropdownSize.Y
                
                local inItemsContainer = position.X >= itemsPos.X and position.X <= itemsPos.X + itemsSize.X and
                                       position.Y >= itemsPos.Y and position.Y <= itemsPos.Y + itemsSize.Y
                
                if not inMainFrame and not inItemsContainer then
                    self:Toggle(false)
                end
            end
        end
    end)
end

function DropdownElement:SetItems(items)
    self.Items = items or {}
    self:CreateItems()
    self:UpdateValueLabel()
end

function DropdownElement:SetValue(value)
    if self.MultiSelect then
        self.Value = {}
        
        if type(value) == "table" then
            -- Convert to lookup table
            for _, item in pairs(value) do
                self.Value[item] = true
            end
        end
    else
        self.Value = value
    end
    
    -- Update item buttons
    for item, itemData in pairs(self.ItemButtons) do
        local isSelected = self.MultiSelect and self.Value[item] or self.Value == item
        itemData.IsSelected = isSelected
        
        itemData.Button.BackgroundColor3 = isSelected 
            and self.Theme.AccentColor:Lerp(self.Theme.ElementBackground, 0.5) 
            or self.Theme.ElementBackground:Lerp(Color3.new(1, 1, 1), 0.05)
        
        itemData.Indicator.ImageTransparency = isSelected and 0 or 1
    end
    
    self:UpdateValueLabel()
    self.Callback(self.Value)
end

function DropdownElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function DropdownElement:SetDescription(description)
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
            Parent = self.DropdownFrame
        })
    end
end

function DropdownElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function DropdownElement:Destroy()
    self.Container:Destroy()
end

return DropdownElement
