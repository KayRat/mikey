mike = mike or {}
mike.commands = mike.commands or {}
mike.commands.list = mike.commands.list or {}
mike.commands.error = {
  ["NO_CONSOLE"]    = 1,
  ["NO_PERMISSION"] = 2,
  ["NOT_FOUND"]     = 3,
}

local function rootHandler(pl, cmd, args)
  if(table.Count(args) <= 0) then return end

  local silent = (string.lower(cmd) == "mikey")

  local arg = args[1]

  if(mike.commands.exists(arg)) then
    local targetCmd = mike.commands.get(arg)
    PrintTable(targetCmd)

    local targetCmdArgs = table.Copy(args)
    table.remove(args, 1)

    if(not targetCmd) then mike.log.error("No command??? Huh?") return end

    local canRun = targetCmd:canUserRun(pl, arg, targetCmdArgs)

    if(canRun == true) then
      targetCmd:run(pl, targetCmd, args)
    else
      if(canRun == mike.commands.error.NO_CONSOLE) then
        mike.log.error("This command is forbidden from the console")
      elseif(canRun == mike.commands.error.NO_PERMISSION) then
        mike.log.error("No permission")
      elseif(canRun == mike.commands.error.NOT_FOUND) then
        mike.log.error("Command not found")
      else
        mike.log.error("Unknown error occurred (canRun: "..tostring(canRun)..")")
      end
    end
  else
    mike.log.error("Command '"..arg.."' not found")
  end
end

if(SERVER) then
  concommand.Add("mike", rootHandler, nil, "Mike's Cereal Shack")
  concommand.Add("mikey", rootHandler, nil, "Mikey's ~Silent~ Cereal Shack")
end

function mike.commands.add(cmd)
  mike.commands.list[cmd:getCommand()] = cmd
end

function mike.commands.exists(cmd)
  if(cmd == nil) then return false end

  if(type(cmd) ~= "string") then
    cmd = cmd:getCommand()
  end

  return mike.commands.list[cmd] ~= nil
end

function mike.commands.get(cmd)
  if(mike.commands.exists(cmd)) then
    return mike.commands.list[cmd]
  end

  return mike.commands.new(cmd)
end

function mike.commands.new(cmd, help)
  if(mike.commands.exists(cmd)) then
    mike.log.warn("Command '%s' already exists; overwriting", (type(cmd) == "string" and cmd or cmd:getCommand()))
  end

  local skeleton = {
    -- data
    ["cmd"] = cmd,
    ["help"] = help or "No help available",

    -- functions
    ["getCommand"] = function(self) return self.cmd end,
    ["getHelp"] = function(self) return self.help end,
    ["run"] = function(self, pl, cmd, args)
      -- TODO: logging? probably not
      self:onRun(pl, cmd, args)
    end,
    ["onRun"] = function(self, pl, cmd, args) end,
    ["canUserRun"] = function(self, pl, cmd, args)
      return mike.commands.error.NO_PERMISSION
    end,
  }
  skeleton.__index = skeleton

  local cmd = {}
  setmetatable(cmd, skeleton)

  return cmd
end
