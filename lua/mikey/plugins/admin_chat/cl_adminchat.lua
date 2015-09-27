local adminChat = mikey.plugins.get("Admin Chat")

adminChat:handleNetMessage("chatmessage", function(data)
  local from = data["from"]
  local text = data["message"]

  --chat.AddText(Color(100, 200, 100), "→  ", team.GetColor(from:Team()), from:Nick()..": ", color_white, text)
  chat.AddText(team.GetColor(from:Team()), from:Nick(), Color(100, 200, 100), " to staff: ", color_white, text)
end)

mikey.plugins.add(adminChat)
