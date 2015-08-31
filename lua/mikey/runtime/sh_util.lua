mike = mike or {}
mike.util = mike.util or {}

function mike.util.findPlayer(str)
    local objTarget

    objTarget = player.GetByUniqueID(str)

    if(not IsValid(objTarget)) then
        for k,v in pairs(player.GetAll()) do
            local iFound = string.find(string.lower(v:Nick()), string.lower(str))

            if(iFound ~= nil) then
                objTarget = v
                break
            end
        end
    end

    return objTarget
end
