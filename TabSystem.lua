-- NYAN UI Library - Tab System
-- Управляет созданием и переключением вкладок

local TweenService = game:GetService("TweenService")

local TabSystem = {}
TabSystem.__index = TabSystem

-- Animation constants
local TAB_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local SELECTOR_TWEEN = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

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

-- Create a new tab system
function TabSystem.new(window, tabContainer, contentContainer, theme)
    local self = setmetatable({}, TabSystem)
    
    self.Window = window
    self.TabContainer = tabContainer
    self.ContentContainer = contentContainer
    self.Theme = theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        AccentColor = Color3.fromRGB(255, 105, 180),
        ElementBorder = Color3.fromRGB(65, 65, 65),
        InactiveTab = Color3.fromRGB(45, 45, 45)
    }
    
    self.Tabs = {}
    self.TabCount = 0
    self.SelectedTab = nil
    
    -- Create tab selector indicator
    self.TabSelector = CreateInstance("Frame", {
        Size = UDim2.new(0, 3, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.Theme.AccentColor,
        BorderSizePixel = 0,
        Parent = self.TabContainer
    })
    
    -- Rounded corners for selector
    local selectorCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 2),
        Parent = self.TabSelector
    })
    
    return self
end

-- Create a new tab
function TabSystem.CreateTab(self, tabInfo)
    self.TabCount = self.TabCount + 1
    local tabIndex = self.TabCount
    
    -- Default tab info
    tabInfo = tabInfo or {}
    local title = tabInfo.Title or "Tab " .. tabIndex
    local icon = tabInfo.Icon or nil
    
    -- Create tab button
    local tabButton = CreateInstance("TextButton", {
        Size = UDim2.new(1, -10, 0, 36),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundColor3 = self.Theme.InactiveTab,
        BackgroundTransparency = 1, -- Start transparent
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = tabIndex,
        Parent = self.TabContainer
    })
    
    -- Tab rounded corners
    local tabCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = tabButton
    })
    
    -- Tab icon (if provided)
    if icon then
        local iconImage = CreateInstance("ImageLabel", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = self.Theme.TextColor,
            ImageTransparency = 0.4, -- Slightly faded when inactive
            Parent = tabButton
        })
    end
    
    -- Tab title
    local titleLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, icon and -40 or -20, 1, 0),
        Position = UDim2.new(0, icon and 40 or 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = title,
        TextColor3 = self.Theme.TextColor,
        TextTransparency = 0.4, -- Slightly faded when inactive
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabButton
    })
    
    -- Create content container for this tab
    local contentFrame = CreateInstance("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.AccentColor,
        ScrollBarImageTransparency = 0.5,
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
        CanvasSize = UDim2.fromScale(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false, -- Hidden by default
        Parent = self.ContentContainer
    })
    
    -- Element layout for content
    local layout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = contentFrame
    })
    
    -- Padding for content
    local padding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = contentFrame
    })
    
    -- Create tab object
    local tab = {
        Index = tabIndex,
        Title = title,
        Icon = icon,
        Button = tabButton,
        Content = contentFrame,
        Elements = {},
        ElementCount = 0
    }
    
    -- Tab button click handler
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tabIndex)
    end)
    
    -- Tab button hover effects
    tabButton.MouseEnter:Connect(function()
        if self.SelectedTab ~= tabIndex then
            TweenService:Create(
                tabButton, 
                TAB_TWEEN, 
                {BackgroundTransparency = 0.8}
            ):Play()
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.SelectedTab ~= tabIndex then
            TweenService:Create(
                tabButton, 
                TAB_TWEEN, 
                {BackgroundTransparency = 1}
            ):Play()
        end
    end)
    
    -- Store tab
    self.Tabs[tabIndex] = tab
    
    -- If this is the first tab, select it automatically
    if tabIndex == 1 then
        self:SelectTab(1)
    end
    
    -- Return tab interface
    return {
        -- Add elements to this tab
        AddElement = function(elementInstance)
            tab.ElementCount = tab.ElementCount + 1
            elementInstance.LayoutOrder = tab.ElementCount
            elementInstance.Parent = tab.Content
            table.insert(tab.Elements, elementInstance)
            return elementInstance
        end,
        
        -- Get tab information
        GetInfo = function()
            return {
                Index = tab.Index,
                Title = tab.Title,
                Icon = tab.Icon,
                ElementCount = tab.ElementCount
            }
        end,
        
        -- Select this tab
        Select = function()
            self:SelectTab(tabIndex)
        end
    }
end

-- Select a tab by index
function TabSystem.SelectTab(self, index)
    if not self.Tabs[index] then return end
    
    local previousTab = self.SelectedTab
    self.SelectedTab = index
    
    -- Hide previous tab content
    if previousTab and self.Tabs[previousTab] then
        self.Tabs[previousTab].Content.Visible = false
        
        -- Reset previous tab button
        TweenService:Create(
            self.Tabs[previousTab].Button, 
            TAB_TWEEN, 
            {BackgroundTransparency = 1}
        ):Play()
        
        -- Reset text and icon transparency
        for _, child in pairs(self.Tabs[previousTab].Button:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("ImageLabel") then
                TweenService:Create(
                    child, 
                    TAB_TWEEN, 
                    {TextTransparency = 0.4, ImageTransparency = 0.4}
                ):Play()
            end
        end
    end
    
    -- Show selected tab content
    self.Tabs[index].Content.Visible = true
    
    -- Update selected tab button
    TweenService:Create(
        self.Tabs[index].Button, 
        TAB_TWEEN, 
        {BackgroundTransparency = 0.7, BackgroundColor3 = self.Theme.ElementBackground}
    ):Play()
    
    -- Update text and icon transparency
    for _, child in pairs(self.Tabs[index].Button:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("ImageLabel") then
            TweenService:Create(
                child, 
                TAB_TWEEN, 
                {TextTransparency = 0, ImageTransparency = 0}
            ):Play()
        end
    end
    
    -- Animate tab selector
    local targetButton = self.Tabs[index].Button
    local targetPosition = UDim2.new(0, 0, 0, targetButton.AbsolutePosition.Y - self.TabContainer.AbsolutePosition.Y + 8)
    
    TweenService:Create(
        self.TabSelector, 
        SELECTOR_TWEEN, 
        {Position = targetPosition, Size = UDim2.new(0, 3, 0, targetButton.AbsoluteSize.Y - 16)}
    ):Play()
end

-- Apply a theme to the tab system
function TabSystem.ApplyTheme(self, theme)
    self.Theme = theme
    
    -- Update tab selector
    self.TabSelector.BackgroundColor3 = theme.AccentColor
    
    -- Update all tabs
    for _, tab in pairs(self.Tabs) do
        if self.SelectedTab == tab.Index then
            -- Selected tab
            tab.Button.BackgroundColor3 = theme.ElementBackground
            
            -- Update text and icons
            for _, child in pairs(tab.Button:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.TextColor3 = theme.TextColor
                elseif child:IsA("ImageLabel") then
                    child.ImageColor3 = theme.TextColor
                end
            end
        else
            -- Inactive tab
            tab.Button.BackgroundColor3 = theme.InactiveTab
            
            -- Update text and icons
            for _, child in pairs(tab.Button:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.TextColor3 = theme.TextColor
                elseif child:IsA("ImageLabel") then
                    child.ImageColor3 = theme.TextColor
                end
            end
        end
        
        -- Update scroll bars
        tab.Content.ScrollBarImageColor3 = theme.AccentColor
    end
end

return TabSystem
