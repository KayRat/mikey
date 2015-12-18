local PLUGIN = mikey.plugins.get()

PLUGIN["Menu"] = {
  ["Category"]      = mikey.menu.category.ADMIN,
  ["DisplayName"]   = "Kick",
  ["Icon"]          = "icon16/disconnect.png",
  ["SingleSelect"]  = false,
}

PLUGIN.canUserRun = function(self, objPl)
  if(not IsValid(objPl)) then
    return mikey.permission.NO_CONSOLE
  end

  if(objPl:isMod()) then
    return true
  end

  return mikey.permission.NONE
end
