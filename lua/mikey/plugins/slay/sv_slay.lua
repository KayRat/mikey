local PLUGIN = mikey.plugins.get()

PLUGIN.logAction = function(self, objAdmin, tblTargets)
  -- serverside logging stuff???
  mikey.network.send("slay.log", player.GetAll(), {
    ["admin"]   = objAdmin,
    ["targets"] = tblTargets,
  })
end

mikey.network.receive("slay.doSlay", function(objPl, tblData)
  if(not tblData["targets"]) then
    mike.log.error("Received instruction to slay without any targets")
    return
  end

  local tblTargets = tblData["targets"]

  for k,v in pairs(tblTargets) do
    local objTarget = player.GetByUniqueID(k)

    if(IsValid(objTarget)) then
      if(objTarget:Alive()) then
        objTarget:Kill()
      else
        table.remove(tblTargets, k)
      end
    else
      mikey.log.error("Received instruction to slay a non-existent player ("..k..")")
      table.remove(tblTargets, k)
    end
  end

  PLUGIN:logAction(objPl, tblTargets)
end)
