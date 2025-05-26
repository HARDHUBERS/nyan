-- NYAN UI Library
-- A beautiful animated UI library for Roblox

local NyanLibrary = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Constants
local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local ACCENT_COLOR = Color3.fromRGB(255, 105, 180) -- Pink default
local THEME = {
    Background = Color3.fromRGB(30, 30, 30),
    Card = Color3.fromRGB(40, 40, 40),
    TopBar = Color3.fromRGB(50, 50, 50),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = ACCENT_COLOR,
    ElementBackground = Color3.fromRGB(55, 55, 55),
    InactiveTab = Color3.fromRGB(45, 45, 45),
    ElementBorder = Color3.fromRGB(65, 65, 65)
}

-- Library Variables
NyanLibrary.Windows = {}
NyanLibrary.Theme = THEME
NyanLibrary.Connections = {}

-- Utility Functions
local function AddConnection(connection)
    table.insert(NyanLibrary.Connections, connection)
    return connection
end

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

local function ApplyNyanStyle(instance)
    if instance:IsA("Frame") or instance:IsA("TextButton") then
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 6)
        uiCorner.Parent = instance
        
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = THEME.ElementBorder
        uiStroke.Thickness = 1
        uiStroke.Transparency = 0.5
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Parent = instance
    end
end

local function CreateRippleEffect(parent)
    local ripple = CreateInstance("Frame", {
        Size = UDim2.fromScale(0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        Parent = parent
    })
    
    ApplyNyanStyle(ripple)
    
    return function(position)
        local newRipple = ripple:Clone()
        newRipple.Position = UDim2.fromOffset(position.X, position.Y)
        newRipple.Parent = parent
        
        local targetSize = UDim2.fromScale(3, 3)
        local fadeOut = TweenService:Create(newRipple, TWEEN_INFO, {
            Size = targetSize,
            BackgroundTransparency = 1
        })
        
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            newRipple:Destroy()
        end)
    end
end

-- Main window creation function
function NyanLibrary:CreateWindow(config)
    config = config or {}
    
    local window = {
        Title = config.Title or "NYAN UI",
        Size = config.Size or UDim2.fromOffset(600, 400),
        Position = config.Position or UDim2.fromScale(0.5, 0.5),
        Theme = config.Theme or self.Theme,
        Tabs = {},
        TabButtons = {},
        CurrentTab = nil,
        Minimized = false,
        Elements = {}
    }
    
    -- Will implement window GUI creation in the next part
    
    table.insert(self.Windows, window)
    return window
end

-- Clean up function
function NyanLibrary:Destroy()
    for _, connection in ipairs(self.Connections) do
        connection:Disconnect()
    end
    
    for _, window in ipairs(self.Windows) do
        if window.GUI then
            window.GUI:Destroy()
        end
    end
    
    self.Windows = {}
    self.Connections = {}
end

return NyanLibrary
