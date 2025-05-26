-- NYAN UI Library - Elements
-- Main module that imports all UI elements

local Elements = {}

-- Load each element from its respective file
local ButtonElement = require(script.Parent.Elements.ButtonElement)
local ToggleElement = require(script.Parent.Elements.ToggleElement)
local SliderElement = require(script.Parent.Elements.SliderElement)
local TextboxElement = require(script.Parent.Elements.TextboxElement)
local DropdownElement = require(script.Parent.Elements.DropdownElement)
local KeybindElement = require(script.Parent.Elements.KeybindElement)
local LabelElement = require(script.Parent.Elements.LabelElement)

-- Export all elements
Elements.Button = ButtonElement
Elements.Toggle = ToggleElement
Elements.Slider = SliderElement
Elements.Textbox = TextboxElement
Elements.Dropdown = DropdownElement
Elements.Keybind = KeybindElement
Elements.Label = LabelElement

return Elements
