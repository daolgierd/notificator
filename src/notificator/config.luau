export type notification_info = {
  icon: string,
  color: Color3,
}

return {
  info = {
    icon = "rbxassetid://134135248281130",
    color = Color3.fromRGB(75, 168, 255)
  },
  error = {
    icon = "rbxassetid://73894334952114",
    color = Color3.fromRGB(255, 75, 75)
  },
  warn = {
    icon = "rbxassetid://121807596616831",
    color = Color3.fromRGB(255, 157, 71)
  }
} :: {[string] : notification_info}