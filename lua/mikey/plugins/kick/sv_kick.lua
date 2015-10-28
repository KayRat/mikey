local PLUGIN = PLUGIN
local kickCmd = mikey.commands.get("kick")
local kickIDCmd = mikey.commands.get("kickid")

local function doKick(admin, target, args)
  table.remove(args, 1)

  local reason = #args > 0 and table.concat(args, " ") or "Consider this a warning...don't do it again"

  mikey.log.info("Kicking '"..target:Nick().."' ("..reason..")")
  target:Kick("Kicked by "..admin:Nick()..": "..reason)
end

mikey.network.setHandler("kick.kickPlayer", function(objPl, tblData)
  if(not tblData["targets"]) then
    mike.log.error("Received instruction to kick without any targets")
    return
  end

  local tblTargets = tblData["targets"]

  for k,v in pairs(tblTargets) do
    local objTarget = player.GetByUniqueID(k)

    if(IsValid(objTarget)) then
      objTarget:Kick("Kicked by "..objPl:Nick()..": "..tblData["reason"])
    else
      mikey.log.error("Received instruction to kick a non-existent player ("..k..")")
    end
  end
end)

kickCmd.onRun = function(self, pl, cmd, args)
  local targetStr = args[1]

  local target = utils.findPlayer(targetStr)

  if(not IsValid(target)) then
    mikey.log.error("Player '"..targetStr.."' not found")
    return
  end

  doKick(pl, target, args) -- TODO: proper logging
end

kickIDCmd.onRun = function(self, pl, cmd, args)
  if(#args <= 0) then
    mikey.log.error("Unsupported number of arguments")
    return
  end

  local targetUniqueID = args[1]
  local target = player.GetByUniqueID(targetUniqueID)

  if(not IsValid(t)) then
    mikey.log.error("Player '"..targetUniqueID.."' not found")
    return
  end

  doKick(pl, target, args) -- TODO: proper logging
end

mikey.commands.add(kickCmd)
mikey.commands.add(kickIDCmd)
