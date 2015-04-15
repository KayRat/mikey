mike = mike or {}
mike.plugins = mike.plugins or {}
mike.plugins.list = mike.plugins.list or {}

function mike.plugins.new(strName)
    local tblSkeleton = {
        -- data
        ["name"] = strName,

        -- functions
        ["getName"] = function(self) return self.name end,
    }

    if(CLIENT) then
        tblSkeleton["onRun"] = function(self, objPl)
            RunConsoleCommand("mike", strName:lower(), objPl:UniqueID())
        end
    end

    tblSkeleton.__index = tblSkeleton

    local objPlugin = {}
    setmetatable(objPlugin, tblSkeleton)

    return objPlugin
end

function mike.plugins.get(strName)
    return mike.plugins.list[strName] or mike.plugins.new(strName)
end

function mike.plugins.add(objPlugin)
    mike.plugins.list[objPlugin:getName()] = objPlugin
end
