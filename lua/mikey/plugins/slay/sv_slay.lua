local PLUGIN = mikey.plugins.get()

mikey.network.receive("slay", function(objPl, tblData)
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
      end
    else
      mikey.log.error("Received instruction to slay a non-existent player ("..k..")")
    end
  end
end)
