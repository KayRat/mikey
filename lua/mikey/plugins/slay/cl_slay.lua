local PLUGIN = mikey.plugins.get()

mikey.network.receive("slay.log", function(tblData)
  local objAdmin    = tblData["admin"]
  local tblTargets  = tblData["targets"]

  local tblMessage = {
    team.GetColor(objAdmin:Team()),   objAdmin:Nick(),
    color_white,                      " has slain ",
  }

  mikey.util.processNames(tblMessage, tblTargets)

  chat.AddText(unpack(tblMessage))
end)

PLUGIN.onMenuClick = function(self, objTargets)
  mikey.network.send("slay.doSlay", {
    ["targets"] = objTargets
  })
end
