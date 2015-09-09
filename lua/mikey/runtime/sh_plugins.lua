mike = mike or {}
mike.plugins = mike.plugins or {}
mike.plugins.list = mike.plugins.list or {}
mike.plugins.netMessages = mike.plugins.netMessages or {}

util.AddNetworkString("mike.plugins.netMessage")

net.Receive("mike.plugins.netMessage", function(len, pl)
  local msgName = net.ReadString()

  if(not IsValid(mike.plugins.netMessages[msgName])) then
    mike.log.error("Tried to handle net message '"..msgName.."' without handler")
    return
  end

  local data = net.ReadTable()
  data["sender"] = pl

  mike.log.info("Handling net message '"..msgName.."'"..(SERVER and " from "..pl:Nick()))
  mike.plugins.netMessages[msgName](data)
end)

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

        ["sendNetMessage"] = function(self, target, data)
          net.Start("mike.plugins.netMessage")
            net.WriteString(self:getName())
            net.WriteTable(SERVER and data or target)

          if(SERVER) then
            net.Send(target)
          else
            net.SendToServer()
          end
        end,
    }

    tblSkeleton["handleNetMessage"] = function(self, msgName, callback)
      mike.plugins.netMessages[self:getName()] = mike.plugins.netMessages[self:getName()] or {}
      mike.plugins.netMessages[self:getName()][msgName] = callback
    end

    tblSkeleton["removeNetMessage"] = function(self, msgName)
      if(mike.plugins.netMessages[self:getName()]) then
        mike.plugins.netMessages[self:getName()][msgName] = nil
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
