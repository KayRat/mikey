local kickPlugin = mikey.plugins.get("Kick")
local kickCmd = mikey.commands.get("kick")
local kickIDCmd = mikey.commands.get("kickid")

kickCmd.canUserRun = function(self, pl, cmd, args)
  if(not IsValid(pl)) then
    return mikey.commands.error.NO_CONSOLE
  end

  if(pl:hasPermission("kick")) then
    return true
  end

  return mikey.commands.error.NO_PERMISSION
end

kickIDCmd.canUserRun = kickCmd.canUserRun

local function doKick(admin, target, args)
  table.remove(args, 1)

  local reason = #args > 0 and table.concat(args, " ") or "Consider this a warning...don't do it again"

  mikey.log.info("Kicking '"..target:Nick().."' ("..reason..")")
  target:Kick("Kicked by "..admin:Nick()..": "..reason)
end

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

mikey.plugins.add(kickPlugin)
mikey.commands.add(kickCmd)
mikey.commands.add(kickIDCmd)
