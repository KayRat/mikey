util.AddNetworkString("mike.commands.menu.open")

local objMenu = mike.commands.new("menu", "Show the menu")

function objMenu:canUserRun(objPl)
    if(not IsValid(objPl)) then return mike.commands.error.NO_CONSOLE end

    return true
end

function objMenu:onRun(objPl, strFirst, tblArgs)
    print("[SERVER] onRun called by", objPl, tblArgs and tblArgs[1] or nil)

    net.Start("mike.commands.menu.open")
        if(strFirst and string.len(strFirst) > 0) then
            net.WriteBool(true)
            net.WriteString(strFirst)
        else
            net.WriteBool(false)
        end
    net.Send(objPl)
end

mike.commands.add(objMenu)
