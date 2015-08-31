mike = mike or {}
mike.plugins = mike.plugins or {}
mike.plugins.list = mike.plugins.list or {}

function mike.plugins.new(strName)
    local tblSkeleton = {
        -- data
        ["name"] = strName,
        ["command"] = strName:lower(),

        -- functions
        ["getName"] = function(self) return self.name end,
        ["getCommand"] = function(self) return self.command end,
        ["canUserRun"] = function(self, objPl)
            return IsValid(objPl)
        end,
        ["onRun"] = function(self, objPl, strFirst, tblArgs) end,
    }

    if(CLIENT) then
        tblSkeleton["onRun"] = function(self, objPl)
            RunConsoleCommand("mike", strName:lower(), objPl:UniqueID())
        end
    else
        local objCmd = mike.commands.new(strName:lower())
        objCmd.onRun = function(self, objPl, strFirst, tblArgs)
            local objPlugin = mike.plugins.get(strName)

            if(objPlugin) then
                objPlugin:onRun(objPl, strFirst, tblArgs)
            end
        end

        mike.commands.add(objCmd)
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

    if(not SERVER) then return end

    local objCmd = mike.commands.get(objPlugin:getCommand())

    if(objCmd) then
        mike.commands.list[objCmd:getCommand()].canUserRun = objPlugin.canUserRun
    else
        mike.log.error("No command for plugin found")
    end
end
