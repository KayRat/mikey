local PLUGIN = mikey.plugins.get()

mikey.network.receive("slay.log", function(tblData)
  local objAdmin    = tblData["admin"]
  local tblTargets  = tblData["targets"]

  local tblMessage = {
    team.GetColor(objAdmin:Team()),   objAdmin:Nick(),
    color_white,                      " has slain ",
  }

  local iNum = 0

  for k,v in pairs(tblTargets) do
    local objPl = player.GetByUniqueID(k)

    if(IsValid(objPl)) then
      tblTargets[k] = objPl
    end
  end

  mikey.util.processNames(tblMessage, tblTargets)

  chat.AddText(unpack(tblMessage))
end)

PLUGIN.onMenuClick = function(self, objTargets)
  mikey.network.send("slay", {
    ["targets"] = objTargets
  })
end
