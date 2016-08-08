local PLUGIN = mikey.plugins.get()

PLUGIN.logAction = function(self, objAdmin, tblTargets)
  -- serverside logging stuff???
  mikey.network.send("slay.log", player.GetAll(), {
    ["admin"]   = objAdmin,
    ["targets"] = tblTargets,
  })
end

mikey.network.receive("slay.doSlay", function(objPl, tblData)
  if(PLUGIN:canUserRun(objPl) ~= true) then return end

  if(not tblData["targets"]) then
    mike.log.error("Received instruction to slay without any targets")
    return
  end

  local tblTargets = tblData["targets"]

  mikey.util.auditTargets(tblTargets)

  for k,v in pairs(tblTargets) do
    if(v:Alive()) then
      v:Kill()
    end
  end

  PLUGIN:logAction(objPl, tblTargets)
end)
