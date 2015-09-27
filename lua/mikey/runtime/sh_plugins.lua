mikey = mikey or {}
mikey.plugins = mikey.plugins or {}
mikey.plugins.list = mikey.plugins.list or {}
mikey.plugins.netMessages = mikey.plugins.netMessages or {}

if(SERVER) then
  util.AddNetworkString("mikey.plugins.netMessage")
end

net.Receive("mikey.plugins.netMessage", function(len, pl)
  local pluginName = net.ReadString()
  local msgName = net.ReadString()

  if(not mikey.plugins.exists(pluginName)) then
    mikey.log.error("Tried to handle net message for invlaid plugin '"..pluginName.."'")
    return
  end

  if(mikey.plugins.netMessages[pluginName][msgName] == nil) then
    mikey.log.error("Tried to handle net message '"..pluginName.."' with no handler for alias '"..msgName.."'")
    return
  end

  local data = net.ReadTable()
  data["sender"] = pl

  mikey.log.info("Handling net message '"..msgName.."'"..(SERVER and " from "..pl:Nick() or ""))
  mikey.plugins.netMessages[pluginName][msgName](data)
end)

function mikey.plugins.new(name)
    local skeleton = {
        -- data
        ["name"] = name,

        -- functions
        ["getName"] = function(self) return self.name end,
        ["canUserRun"] = function(self, pl) return IsValid(pl) end,

        ["sendNetMessage"] = function(self, msgName, target, data)
          net.Start("mikey.plugins.netMessage")
            net.WriteString(self:getName())
            net.WriteString(msgName)
            net.WriteTable(SERVER and data or target)

          if(SERVER) then
            net.Send(target)
          else
            net.SendToServer()
          end
        end,
    }

    skeleton["handleNetMessage"] = function(self, msgName, callback)
      mikey.plugins.netMessages[self:getName()] = mikey.plugins.netMessages[self:getName()] or {}
      mikey.plugins.netMessages[self:getName()][msgName] = callback
    end

    skeleton["removeNetMessage"] = function(self, msgName)
      if(mikey.plugins.netMessages[self:getName()]) then
        mikey.plugins.netMessages[self:getName()][msgName] = nil
      end
    end

    skeleton.__index = skeleton

    local objPlugin = {}
    setmetatable(objPlugin, skeleton)

    return objPlugin
end

function mikey.plugins.exists(name)
  return mikey.plugins.list[name] ~= nil
end

function mikey.plugins.get(name)
    return mikey.plugins.list[name] or mikey.plugins.new(name)
end

function mikey.plugins.add(objPlugin)
    mikey.plugins.list[objPlugin:getName()] = objPlugin
end
