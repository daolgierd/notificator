--!strict

local class = {} :: class
class.__index = class

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local config = require("./config")
local template = script:FindFirstChild("Template") :: template

local IN_SPACING = 10
local OUT_SPACING = 15
local TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

type class = {
  new: (player_gui: PlayerGui) -> Notificator,

  notify: (self: Notificator, type: string, message: string, lifetime: number) -> (),
  __index: class
}

export type Notificator = typeof(setmetatable({} :: {
  screen_gui: ScreenGui,
  current_size: number,
  notifications: {notification},
}, class :: class))

type notification = {
  lifetime: number,
  ui: template,
}

type template = Frame & {
  Bar: Frame,
  Icon: ImageLabel,
  Message: TextLabel,
}

local function get_text_size(label: TextLabel)
  local font = label.Font
  local font_size = label.TextSize
  return TextService:GetTextSize(label.Text, font_size, font, Vector2.new(label.AbsoluteSize.X, label.AbsoluteSize.Y + math.huge))
end

function class.new(player_gui: PlayerGui) : Notificator
  local screen_gui = Instance.new("ScreenGui")
  screen_gui.Name = "Notificator"
  screen_gui.IgnoreGuiInset = true
  screen_gui.Parent = player_gui
  return setmetatable({
    screen_gui = screen_gui,
    current_size = OUT_SPACING,
    notifications = {},
  }, class)
end

function class:notify(type: string, message: string, lifetime: number)
  local info = config[type]
  if not info then return end
  local icon = info.icon
  local color = info.color
  local notification = template:Clone()
  notification.Icon.Image = icon
  notification.Bar.BackgroundColor3 = color
  notification.Message.Text = message

  local text_size = get_text_size(notification.Message)
  local size = ((IN_SPACING*2) + text_size.Y < 50) and 50 or (IN_SPACING*2) + text_size.Y

  notification.Size = UDim2.new(0, 250, 0, size)
  notification.Position = UDim2.new(1, notification.AbsoluteSize.X + OUT_SPACING, 0, self.current_size)

  local goal = {Position = UDim2.new(1, -OUT_SPACING, 0, self.current_size)}
  local tween = TweenService:Create(notification, TWEEN_INFO, goal)
  tween:Play()

  self.current_size += notification.AbsoluteSize.Y + OUT_SPACING
  notification.Parent = self.screen_gui

  table.insert(self.notifications, {ui = notification, lifetime = lifetime})

  task.delay(lifetime, function()
    self:remove(notification)
  end)
end

function class:remove(notification)
  local goal = {Position = UDim2.new(1, notification.AbsoluteSize.X + OUT_SPACING, 0, notification.AbsolutePosition.Y + notification.AbsoluteSize.Y)}
  local tween = TweenService:Create(notification, TWEEN_INFO, goal)
  tween:Play()
  tween.Completed:Once(function()
    notification:Destroy()
  end)
  for i, notif in self.notifications do
    if notif.ui == notification then
      table.remove(self.notifications, i)
      break
    end
  end
  self:update()
end

function class:update()
  local current_y = OUT_SPACING
  for _, notif in self.notifications do
    local goal = {Position = UDim2.new(1, -OUT_SPACING, 0, current_y)}
    local tween = TweenService:Create(notif.ui, TWEEN_INFO, goal)
    tween:Play()
    current_y += notif.ui.AbsoluteSize.Y + OUT_SPACING
    self.current_size = current_y
  end
end

return class