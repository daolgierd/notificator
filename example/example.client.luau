local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Notificator = require(ReplicatedStorage.notificator)

local player = game:GetService("Players").LocalPlayer
local player_gui = player:FindFirstChildOfClass("PlayerGui") :: PlayerGui

local notificator = Notificator.new(player_gui)
notificator:notify("info", "SERWER ZOSTANIE ZAMKNIETY ZA 15 MINUT. SERWER ZOSTANIE ZAMKNIETY ZA 15 MINUT. SERWER ZOSTANIE ZAMKNIETY ZA 15 MINUT.", 5)
task.wait(2)
notificator:notify("error", "Wystapił błąd, spróbuj ponownie później.", 3)
task.wait(2)
notificator:notify("info", "Wystapił błąd, spróbuj ponownie później. HAHA HAHA HAHA", 4)