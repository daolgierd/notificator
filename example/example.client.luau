local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Notificator = require(ReplicatedStorage.notificator)

local player = game:GetService("Players").LocalPlayer
local player_gui = player:FindFirstChildOfClass("PlayerGui") :: PlayerGui

local notificator = Notificator.new(player_gui)

UserInputService.InputBegan:Connect(function(input)
  if input.KeyCode == Enum.KeyCode.F then
    notificator:notify("info", "SERWER ZOSTANIE ZAMKNIETY ZA 15 MINUT. SERWER ZOSTANIE ZAMKNIETY ZA 15 MINUT. SERWER ZOSTANIE ZAMKNIETY ZA 15 MINUT.", 5)
  end
  if input.KeyCode == Enum.KeyCode.G then
    notificator:notify("error", "Wystapił błąd, spróbuj ponownie później.", 2)
  end
  if input.KeyCode == Enum.KeyCode.H then
    notificator:notify("warn", "Jeżeli będziesz dalej to robić, to zostaniesz wyrzucony.", 5)
  end
  if input.KeyCode == Enum.KeyCode.J then
    notificator:notify("error", "No to chujnia", 1)
  end
end)