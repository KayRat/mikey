local PLUGIN = mikey.plugins.get()

PLUGIN["Menu"] = {
  ["Category"]      = mikey.menu.category.FUN,
  ["DisplayName"]   = "Slay",
  ["Icon"]          = "icon16/lightning.png",
  ["SingleSelect"]  = false,
}

PLUGIN.CanUserRun = function(self, objPl, strCmd, tblArgs)
  if(not IsValid(objPl)) then
    return mikey.permission.NO_CONSOLE
  end

  if(objPl:IsMod()) then return true end

  return mikey.permission.NONE
end
