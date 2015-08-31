local objKick = mike.plugins.get("Kick")

function objKick:canUserRun(objPl)
    if(not IsValid(objPl)) then return true end

    if(objPl:IsTemp()) then return true end

    return mike.commands.error.NOT_FOUND
end

function objKick:onRun(objPl, strFirst, tblArgs)
    if(not strFirst) then return end

    local objTarget = mike.util.findPlayer(strFirst)

    if(not IsValid(objTarget)) then
        mike.log.error("Player '"..strFirst.."' not found")
        return
    end

    table.remove(tblArgs, 1)

    local strReason = "Consider this a warning!"

    if(tblArgs and table.Count(tblArgs) > 0) then
        strReason = table.concat(tblArgs, " ")
    end

    strReason = "Kicked by "..(IsValid(objPl) and objPl:Nick() or "(console)")..": "..strReason

    print("kicking", objTarget, strReason)

    --objTarget:Kick("Nope")
end

mike.plugins.add(objKick)
