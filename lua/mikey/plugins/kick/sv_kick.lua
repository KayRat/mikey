local kickPlugin = mike.plugins.get("Kick")
local kickCmd = mike.commands.get("kick")
local kickIDCmd = mike.commands.get("kickid")

kickCmd.canUserRun = function(self, pl, cmd, args)
  if(not IsValid(pl)) then
    return mike.commands.error.NO_CONSOLE
  end

  if(true) then return true end

  if(pl:hasPermission("kick")) then
    return true
  end

  return mike.commands.error.NO_PERMISSION
end

kickIDCmd.canUserRun = kickCmd.canUserRun

local function doKick(admin, target, args)
  table.remove(args, 1)

  local reason = #args > 0 and table.concat(args, " ") or "Consider this a warning...don't do it again"

  mike.log.info("Kicking '"..target:Nick().."' ("..reason..")")
  target:Kick("Kicked by "..admin:Nick()..": "..reason)
end

kickCmd.onRun = function(self, pl, cmd, args)
  local targetStr = args[1]

  local target = utils.findPlayer(targetStr)

  if(not IsValid(target)) then
    mike.log.error("Player '"..targetStr.."' not found")
    return
  end

  doKick(pl, target, args) -- TODO: proper logging
end

kickIDCmd.onRun = function(self, pl, cmd, args)
  if(#args <= 0) then
    mike.log.error("Unsupported number of arguments")
    return
  end

  local targetUniqueID = args[1]
  local target = player.GetByUniqueID(targetUniqueID)

  if(not IsValid(t)) then
    mike.log.error("Player '"..targetUniqueID.."' not found")
    return
  end

  doKick(pl, target, args) -- TODO: proper logging
end

mike.plugins.add(kickPlugin)
mike.commands.add(kickCmd)
mike.commands.add(kickIDCmd)
