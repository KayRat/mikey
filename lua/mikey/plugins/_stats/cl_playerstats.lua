mikey.network.receive("player.firstjoin", function(tblData)
  local objPl = tblData["player"]

  if(not IsValid(objPl)) then
    error("tried to show a welcome message for a player that doesn't exist")
  end

  chat.AddText(
    mikey.colors.alt,       "! ",
    mikey.colors.primary,   objPl:Nick(),
    color_white,            " has joined ",
    mikey.colors.alt,       "for the first time",
    color_white,            "!"
  )
end)
