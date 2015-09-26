mikey = mikey or {}
mikey.commands = mikey.commands or {}
mikey.commands.list = mikey.commands.list or {}
mikey.commands.error = {
  ["NO_CONSOLE"]    = 1,
  ["NO_PERMISSION"] = 2,
  ["NOT_FOUND"]     = 3,
}

local function rootHandler(pl, cmd, args)
  if(table.Count(args) <= 0) then return end

  local silent = (string.lower(cmd) == "mikey")

  local arg = args[1]

  if(mikey.commands.exists(arg)) then
    local targetCmd = mikey.commands.get(arg)
    PrintTable(targetCmd)

    local targetCmdArgs = table.Copy(args)
    table.remove(args, 1)

    if(not targetCmd) then mikey.log.error("No command??? Huh?") return end

    local canRun = targetCmd:canUserRun(pl, arg, targetCmdArgs)

    if(canRun == true) then
      targetCmd:run(pl, targetCmd, args)
    else
      if(canRun == mikey.commands.error.NO_CONSOLE) then
        mikey.log.error("This command is forbidden from the console")
      elseif(canRun == mikey.commands.error.NO_PERMISSION) then
        mikey.log.error("No permission")
      elseif(canRun == mikey.commands.error.NOT_FOUND) then
        mikey.log.error("Command not found")
      else
        mikey.log.error("Unknown error occurred (canRun: "..tostring(canRun)..")")
      end
    end
  else
    mikey.log.error("Command '"..arg.."' not found")
  end
end

if(SERVER) then
  concommand.Add("mikey", rootHandler, nil, "mikey's Cereal Shack")
  concommand.Add("mikey", rootHandler, nil, "mikey's ~Silent~ Cereal Shack")
end

function mikey.commands.add(cmd)
  mikey.commands.list[cmd:getCommand()] = cmd
end

function mikey.commands.exists(cmd)
  if(cmd == nil) then return false end

  if(type(cmd) ~= "string") then
    cmd = cmd:getCommand()
  end

  return mikey.commands.list[cmd] ~= nil
end

function mikey.commands.get(cmd)
  if(mikey.commands.exists(cmd)) then
    return mikey.commands.list[cmd]
  end

  return mikey.commands.new(cmd)
end

function mikey.commands.new(cmd, help)
  if(mikey.commands.exists(cmd)) then
    mikey.log.warn("Command '%s' already exists; overwriting", (type(cmd) == "string" and cmd or cmd:getCommand()))
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
      return mikey.commands.error.NO_PERMISSION
    end,
  }
  skeleton.__index = skeleton

  local cmd = {}
  setmetatable(cmd, skeleton)

  return cmd
end
