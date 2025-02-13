--!strict

local class = {} :: class
class.__index = class

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local config = require(script.config)
local template = script:FindFirstChild("Template") :: template

local WIDTH = 250
local MIN_HEIGHT = 50
local IN_SPACING = 10
local OUT_SPACING = 15
local TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

type class = {
  new: (player_gui: PlayerGui, order: number?) -> Notificator,

  notify: (self: Notificator, type: string, message: string, lifetime: number) -> (),
  remove: (self: Notificator, notification: template) -> (),
  update: (self: Notificator) -> (),
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

function class.new(player_gui: PlayerGui, order: number?) : Notificator
  local screen_gui = Instance.new("ScreenGui")
  screen_gui.Name = "Notificator"
  screen_gui.IgnoreGuiInset = true
  screen_gui.Parent = player_gui
  screen_gui.DisplayOrder = order or 1
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
  local size = ((IN_SPACING*2) + text_size.Y < MIN_HEIGHT) and MIN_HEIGHT or (IN_SPACING*2) + text_size.Y

  notification.Size = UDim2.new(0, WIDTH, 0, size)
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

function class:remove(notification: template)
  local goal = {Position = UDim2.new(1, notification.AbsoluteSize.X + OUT_SPACING, 0, notification.AbsolutePosition.Y)}
  local tween = TweenService:Create(notification, TWEEN_INFO, goal)
  tween:Play()
  notification.ZIndex = 0
  tween.Completed:Once(function()
    notification:Destroy()
  end)
  for i, notif in self.notifications do
    if #self.notifications == 1 then
      table.remove(self.notifications, i)
      self.current_size = OUT_SPACING
      return
    end
    -- cant do shit about this *type error* (luau union types sucks)
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