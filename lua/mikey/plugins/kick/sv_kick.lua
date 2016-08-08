local PLUGIN = mikey.plugins.get()

PLUGIN.logAction = function(self, objAdmin, tblTargets, strReason)
  local tblLogTargets = {}

  for k,v in pairs(tblTargets) do
    table.insert(tblLogTargets, {
      ["nick"]  = v:Nick(),
      ["team"]  = v:Team(),
    })
  end

  mikey.network.send("kick.log", player.GetAll(), {
    ["admin"]   = objAdmin,
    ["targets"] = tblLogTargets,
    ["reason"]  = strReason,
  })
end

mikey.network.receive("kick.doKick", function(objPl, tblData)
  if(PLUGIN:canUserRun(objPl) ~= true) then return end

  if(not tblData["targets"]) then
    mike.log.error("Received instruction to kick without any targets")
    return
  end

  local tblTargets  = mikey.util.auditTargets(tblData["targets"])
  local strReason   = tblData["reason"] or "Consider this a warning, don't do it again"

  PLUGIN:logAction(objPl, tblTargets, strReason)

  for k,v in pairs(tblTargets) do
    v:Kick("Kicked by "..objPl:Nick()..": "..tblData["reason"])
  end
end)
