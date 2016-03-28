local objMenu = mikey.commands.new("menu", "Show the menu")

function objMenu:canUserRun(objPl)
    if(not IsValid(objPl)) then return mikey.commands.error.NO_CONSOLE end

    return objPl:hasPermission("menu") or mikey.commands.error.NO_PERMISSION
end

function objMenu:onRun(objPl, strCmd, tblArgs)
    mikey.network.send("mikey.menu.open", objPl)
end

mikey.commands.add(objMenu)
