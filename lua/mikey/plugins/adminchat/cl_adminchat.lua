mikey.network.setHandler("adminchat.message", function(objData)
  local objFrom = objData["__SENDER"]
  local strText = objData["message"]

  --chat.AddText(Color(100, 200, 100), "→  ", team.GetColor(objFrom:Team()), objFrom:Nick()..": ", color_white, strText)
  chat.AddText(team.GetColor(objFrom:Team()), objFrom:Nick(), color_white, " to staff: ", color_white, strText)
end)
