gameevent.Listen("player_connect")
hook.Add("player_connect", "mikey.plugins.joinleave", function(tblData)
  local strNick     = tblData["name"]
  local strSteamID  = tblData["networkid"]
  local strIP       = tblData["address"]
  local iUserID     = tblData["userid"]
  local bIsBot      = tblData["bot"]
  local iEntIndex   = tblData["index"]

  mikey.network.send("joinleave.join", player.GetAll(), {
    ["nick"]    = strNick,
    ["steamid"] = strSteamID,
    ["bot"]     = tobool(bIsBot),
    ["userid"]  = iUserID,
  })
end)
