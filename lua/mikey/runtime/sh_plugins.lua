mikey = mikey or {}
mikey.plugins = mikey.plugins or {}
mikey.plugins.list = mikey.plugins.list or {}

local function createNewPlugin(name)
    local skeleton = {
        -- data
        ["name"] = name,

        -- functions
        ["getName"] = function(self) return self.name end,
        ["canUserRun"] = function(self, pl) return IsValid(pl) end,
    }

    skeleton.__index = skeleton

    local objPlugin = {}
    setmetatable(objPlugin, skeleton)

    return objPlugin
end

function mikey.plugins.exists(name)
  return mikey.plugins.list[name] ~= nil
end

function mikey.plugins.get(name)
  return mikey.plugins.list[name] or createNewPlugin(name)
end

function mikey.plugins.commit(objPlugin)
  if(not objPlugin["__NAME"]) then
    mikey.log.error("Tried to commit a malformed plugin; aborting")
    return
  end

  mikey.plugins.list[objPlugin["__NAME"]] = objPlugin
end
