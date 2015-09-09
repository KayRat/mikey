mike = mike or {}
mike.commands = mike.commands or {}
mike.commands.list = mike.commands.list or {}
mike.commands.error = {
    NO_CONSOLE,
    NOT_FOUND,
    NO_PERMISSION,
}

local function rootHandler(objPl, strCmd, tblArgs)
    if(table.Count(tblArgs) <= 0) then return end
    
    local silent = strCmd == "mikey"

    local strArg = tblArgs[1]

    if(mike.commands.exists(strArg)) then
        local objCmd = mike.commands.get(strArg)

        if(not objCmd) then mike.log.error("No command??? Huh?") end

        local objCanRun = objCmd:canUserRun(objPl)

        if(objCanRun == true) then
            local tblCmdArgs = table.Copy(tblArgs)
            table.remove(tblCmdArgs, 1)
            local objFirst = tblCmdArgs[1]

            objCmd:run(objPl, objFirst, tblCmdArgs)
        else
            if(objCanRun == mike.commands.error.NO_CONSOLE) then
                mike.log.error("This command is forbidden from the console")
            elseif(objCanRun == mike.commands.error.NOT_FOUND) then
                mike.log.error("Command not found")
            else
                mike.log.error("Unknown error occurred ("..tostring(objCanRun)..")")
            end
        end
    else
        mike.log.error("Command '"..strArg.."' not found")
    end
end

if(SERVER) then
    concommand.Add("mike", rootHandler, nil, "Mike's Cereal Shack")
    concommand.Add("mikey", rootHandler, nil, "Mikey's Silent Cereal Shack")
end

function mike.commands.add(objCmd)
    mike.commands.list[objCmd:getCommand()] = objCmd
end

function mike.commands.exists(strCmd)
    if(strCmd == nil) then return false end
    
    if(type(strCmd) ~= "string") then
        strCmd = strCmd:getCommand()
    end

    return mike.commands.list[strCmd] ~= nil
end

function mike.commands.get(strCmd)
    if(mike.commands.exists(strCmd)) then
        return mike.commands.list[strCmd]
    end
    
    return mike.commands.new(strCmd)
end

function mike.commands.new(strCmd, strHelp)
    if(mike.commands.exists(objCmd)) then
        mike.log.warn("Command '%s' already exists; overwriting", objCmd:getCommand())
    end
    
    local tblSkeleton = {
        -- data
        ["strCmd"] = strCmd,
        ["strHelp"] = strHelp or "",

        -- functions
        ["getCommand"] = function(self) return self.strCmd end,
        ["getHelp"] = function(self) return self.strHelp end,
        ["run"] = function(self, objPl, strFirst, tblArgs)
            -- TODO: logging?
            self:onRun(objPl, strFirst, tblArgs)
        end,
        ["onRun"] = function(self, objPl, strFirst, tblArgs) end,
        ["canUserRun"] = function(self, objPl)
            return IsValid(objPl)
        end,
    }
    tblSkeleton.__index = tblSkeleton

    local objCmd = {}
    setmetatable(objCmd, tblSkeleton)

    return objCmd
end
