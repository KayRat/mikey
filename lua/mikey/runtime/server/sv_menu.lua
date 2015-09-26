util.AddNetworkString("mikey.commands.menu.open")

local objMenu = mikey.commands.new("menu", "Show the menu")

function objMenu:canUserRun(objPl)
    if(not IsValid(objPl)) then return mikey.commands.error.NO_CONSOLE end

    return true
end

function objMenu:onRun(objPl, strFirst, tblArgs)
    print("[SERVER] onRun called by", objPl, tblArgs and tblArgs[1] or nil)

    net.Start("mikey.commands.menu.open")
        if(strFirst and string.len(strFirst) > 0) then
            net.WriteBool(true)
            net.WriteString(strFirst)
        else
            net.WriteBool(false)
        end
    net.Send(objPl)
end

mikey.commands.add(objMenu)
