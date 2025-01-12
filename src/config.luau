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
  }
} :: {[string] : notification_info}