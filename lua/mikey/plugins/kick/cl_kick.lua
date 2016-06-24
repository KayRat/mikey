local PLUGIN = mikey.plugins.get()

PLUGIN.onMenuClick = function(self, tblTargets)
  print("Menu clicked", tblTargets)
end

PLUGIN.onMenuRightClick = function(self, tblTargets)
  mikey.network.send("kick.doKick", {
    ["targets"] = tblTargets,
    ["reason"]  = "Consider this a warning...don't do it again",
  })
end

mikey.network.receive("kick.log", function(tblData)
  local objAdmin    = tblData["admin"]
  local tblTargets  = tblData["targets"]
  local strReason   = tblData["reason"]

  local tblMessage = {
    team.GetColor(objAdmin:Team()),   objAdmin:Nick(),
    color_white,                      " gave ",
  }

  mikey.util.processNames(tblMessage, tblTargets)

  mikey.util.addPlainText(tblMessage, " the boot: ")
  table.insert(tblMessage, mikey.colors.secondary)
  table.insert(tblMessage, strReason)

  chat.AddText(unpack(tblMessage))
end)
