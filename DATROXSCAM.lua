local Config = {
    Key = Enum.KeyCode.V  -- Taste zum Aktivieren des Visual Bugs
}

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TradingCmds = require(ReplicatedStorage.Library.Client.TradingCmds)

-- GUI erstellen
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.Name = "VisualBugGui"

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 200, 0, 50)
Button.Position = UDim2.new(0.5, -100, 0.8, -25)
Button.Text = "Visual Bug Aktivieren"
Button.Parent = ScreenGui
Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

-- Speicher für Fake-Items
local VisualBugItems = {}

-- Original GetState Funktion
local originalGetState = TradingCmds.GetState

-- Hooken der GetState Funktion
TradingCmds.GetState = hookfunction(originalGetState, function(...)
    local state = originalGetState(...)
    for userId, data in pairs(state._items) do
        if VisualBugItems[userId] then
            data["2"] = VisualBugItems[userId]  -- Manipulieren der Items, die der andere Spieler sieht
        end
    end
    return state
end)

-- Funktion, um Visual Bug zu aktivieren
local function ActivateVisualBug()
    local state = originalGetState()._items
    for userId, data in pairs(state) do
        if data["2"] then
            VisualBugItems[userId] = data["2"]
        end
    end
