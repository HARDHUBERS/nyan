-- NYAN UI Library - Keybind Element

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local KeybindElement = {}
KeybindElement.__index = KeybindElement

-- Animation constants
local HOVER_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local LISTENING_TWEEN = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

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

-- Input name conversion
local InputNameMap = {
    [Enum.KeyCode.Unknown] = "None",
    [Enum.KeyCode.LeftControl] = "LCtrl",
    [Enum.KeyCode.RightControl] = "RCtrl",
    [Enum.KeyCode.LeftAlt] = "LAlt",
    [Enum.KeyCode.RightAlt] = "RAlt",
    [Enum.KeyCode.LeftShift] = "LShift",
    [Enum.KeyCode.RightShift] = "RShift",
    [Enum.KeyCode.Return] = "Enter",
    [Enum.UserInputType.MouseButton1] = "Mouse1",
    [Enum.UserInputType.MouseButton2] = "Mouse2",
    [Enum.UserInputType.MouseButton3] = "Mouse3"
}

local function GetInputName(input)
    if input == nil then
        return "None"
    elseif typeof(input) == "EnumItem" then
        if InputNameMap[input] then
            return InputNameMap[input]
        elseif input.EnumType == Enum.KeyCode then
            return input.Name
        elseif input.EnumType == Enum.UserInputType then
            return input.Name
        end
    end
    
    return tostring(input)
end

-- Create a keybind element
function KeybindElement.new(parent, options)
    local self = setmetatable({}, KeybindElement)
    
    -- Default options
    options = options or {}
    self.Text = options.Text or "Keybind"
    self.Description = options.Description or ""
    self.Default = options.Default or Enum.KeyCode.Unknown
    self.Mode = options.Mode or "Toggle" -- Toggle, Hold, Always
    self.Callback = options.Callback or function() end
    self.ChangedCallback = options.ChangedCallback or function() end
    self.Parent = parent
    self.Theme = options.Theme or {
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(55, 55, 55),
        AccentColor = Color3.fromRGB(255, 105, 180),
        ElementBorder = Color3.fromRGB(65, 65, 65)
    }
    
    -- State variables
    self.Value = self.Default
    self.IsActive = false
    self.IsListening = false
    self.DisplayName = GetInputName(self.Value)
    
    -- Create the keybind
    self:Create()
    
    return self
end

function KeybindElement:Create()
    -- Main container
    self.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = self.Parent
    })
    
    -- Keybind frame
    self.KeybindFrame = CreateInstance("TextButton", {
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
        Parent = self.KeybindFrame
    })
    
    -- Border
    local uiStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Transparency = 0.5,
        Parent = self.KeybindFrame
    })
    
    -- Keybind text
    self.TextLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -110, 0, 14),
        Position = UDim2.new(0, 10, 0.5, -7),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Text,
        TextColor3 = self.Theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.KeybindFrame
    })
    
    -- Description (if provided)
    if self.Description and self.Description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -110, 0, 12),
            Position = UDim2.new(0, 10, 0.5, 7),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.KeybindFrame
        })
    end
    
    -- Keybind button
    self.KeybindButton = CreateInstance("TextButton", {
        Size = UDim2.new(0, 80, 0, 24),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(0, 0, 0), 0.2),
        Font = Enum.Font.Gotham,
        Text = self.DisplayName,
        TextColor3 = self.Theme.TextColor,
        TextSize = 12,
        Parent = self.KeybindFrame
    })
    
    -- Keybind button corner
    local buttonCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = self.KeybindButton
    })
    
    -- Keybind button border
    local buttonStroke = CreateInstance("UIStroke", {
        Color = self.Theme.ElementBorder,
        Thickness = 1,
        Transparency = 0.7,
        Parent = self.KeybindButton
    })
    
    -- Setup animations and events
    self:SetupEvents()
end

function KeybindElement:SetupEvents()
    -- Hover effect
    self.KeybindFrame.MouseEnter:Connect(function()
        TweenService:Create(
            self.KeybindFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground:Lerp(self.Theme.AccentColor, 0.1)}
        ):Play()
    end)
    
    self.KeybindFrame.MouseLeave:Connect(function()
        TweenService:Create(
            self.KeybindFrame, 
            HOVER_TWEEN, 
            {BackgroundColor3 = self.Theme.ElementBackground}
        ):Play()
    end)
    
    -- Keybind button hover
    self.KeybindButton.MouseEnter:Connect(function()
        if not self.IsListening then
            TweenService:Create(
                self.KeybindButton, 
                HOVER_TWEEN, 
                {BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(0, 0, 0), 0.1)}
            ):Play()
        end
    end)
    
    self.KeybindButton.MouseLeave:Connect(function()
        if not self.IsListening then
            TweenService:Create(
                self.KeybindButton, 
                HOVER_TWEEN, 
                {BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(0, 0, 0), 0.2)}
            ):Play()
        end
    end)
    
    -- Start listening for keybind
    self.KeybindButton.MouseButton1Click:Connect(function()
        self:StartListening()
    end)
    
    -- Handle toggling
    if self.Mode == "Toggle" then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            local userKeybind = self.Value
            if userKeybind then
                if (input.KeyCode == userKeybind) or 
                   (input.UserInputType == userKeybind) then
                    self.IsActive = not self.IsActive
                    self.Callback(self.IsActive)
                end
            end
        end)
    elseif self.Mode == "Hold" then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            local userKeybind = self.Value
            if userKeybind then
                if (input.KeyCode == userKeybind) or 
                   (input.UserInputType == userKeybind) then
                    self.IsActive = true
                    self.Callback(true)
                end
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input, gameProcessed)
            local userKeybind = self.Value
            if userKeybind then
                if (input.KeyCode == userKeybind) or 
                   (input.UserInputType == userKeybind) then
                    self.IsActive = false
                    self.Callback(false)
                end
            end
        end)
    end
end

function KeybindElement:StartListening()
    if self.IsListening then return end
    
    self.IsListening = true
    self.KeybindButton.Text = "..."
    
    -- Visual feedback
    TweenService:Create(
        self.KeybindButton, 
        LISTENING_TWEEN, 
        {BackgroundColor3 = self.Theme.AccentColor:Lerp(Color3.new(0, 0, 0), 0.3)}
    ):Play()
    
    -- Disconnect previous connection if exists
    if self.ListeningConnection then
        self.ListeningConnection:Disconnect()
    end
    
    -- Listen for new keybind
    self.ListeningConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard or
           input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.MouseButton2 or
           input.UserInputType == Enum.UserInputType.MouseButton3 then
            
            -- Allow escape to cancel
            if input.KeyCode == Enum.KeyCode.Escape then
                self:StopListening()
                return
            end
            
            -- Set new keybind
            if input.UserInputType == Enum.UserInputType.Keyboard then
                self:SetValue(input.KeyCode)
            else
                self:SetValue(input.UserInputType)
            end
            
            -- Stop listening
            self:StopListening()
            
            -- Fire changed callback
            self.ChangedCallback(self.Value)
        end
    end)
end

function KeybindElement:StopListening()
    if not self.IsListening then return end
    
    self.IsListening = false
    self.KeybindButton.Text = self.DisplayName
    
    -- Visual feedback
    TweenService:Create(
        self.KeybindButton, 
        LISTENING_TWEEN, 
        {BackgroundColor3 = self.Theme.ElementBackground:Lerp(Color3.new(0, 0, 0), 0.2)}
    ):Play()
    
    -- Disconnect listener
    if self.ListeningConnection then
        self.ListeningConnection:Disconnect()
        self.ListeningConnection = nil
    end
end

function KeybindElement:GetState()
    if self.Mode == "Always" then
        return true
    elseif self.Mode == "Toggle" then
        return self.IsActive
    elseif self.Mode == "Hold" then
        local userKeybind = self.Value
        
        if userKeybind == Enum.KeyCode.Unknown then
            return false
        end
        
        if userKeybind.EnumType == Enum.KeyCode then
            return UserInputService:IsKeyDown(userKeybind)
        elseif userKeybind == Enum.UserInputType.MouseButton1 then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        elseif userKeybind == Enum.UserInputType.MouseButton2 then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        elseif userKeybind == Enum.UserInputType.MouseButton3 then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
        end
    end
    
    return false
end

function KeybindElement:SetValue(value, mode)
    self.Value = value or Enum.KeyCode.Unknown
    
    if mode then
        self.Mode = mode
    end
    
    self.DisplayName = GetInputName(self.Value)
    self.KeybindButton.Text = self.DisplayName
end

function KeybindElement:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function KeybindElement:SetDescription(description)
    self.Description = description
    
    if self.DescriptionLabel then
        self.DescriptionLabel.Text = description
    elseif description and description ~= "" then
        self.DescriptionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -110, 0, 12),
            Position = UDim2.new(0, 10, 0.5, 7),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = description,
            TextColor3 = self.Theme.TextColor,
            TextTransparency = 0.4,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.KeybindFrame
        })
    end
end

function KeybindElement:SetCallback(callback)
    self.Callback = callback or function() end
end

function KeybindElement:OnChanged(callback)
    self.ChangedCallback = callback or function() end
end

function KeybindElement:OnClick(callback)
    self.Callback = callback or function() end
end

function KeybindElement:Destroy()
    self.Container:Destroy()
end

return KeybindElement
