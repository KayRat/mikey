mikey = mikey or {}
mikey.groups = mikey.groups or {}
mikey.groups.list = mikey.groups.list or {}

local pl = FindMetaTable("Player")

function pl:SetUserGroup(strGroupName)
  self:setNWVar("usergroup", strGroupName)
end

hook.Add("mikey.db.connected", "mikey.groups.fetchAll", function()
  mikey.db.query("SELECT * FROM mikey.groups ORDER BY groups.weight DESC", function(self, tblData)
    for k,v in pairs(tblData) do
      local strName = v['name']
      local objColor = Color(v['color_r'], v['color_g'], v['color_b'], 255)
      local strInheritsFrom  = v['inheritsFrom']
      local iWeight = v['weight']

      local objGroup = Group.new(strName, objColor, strInheritsFrom, iWeight)

      mikey.groups.list[strName] = objGroup
      mikey.log.info("created rank '"..strName.."'")
    end

    hook.Call("mikey.groups.fetchPermissions", nil)
  end, function(self, strError)
    mikey.log.error(strError)
  end);
end)

hook.Add("mikey.groups.fetchPermissions", "mikey.groups.fetchAll", function()
  mikey.db.query("SELECT groups.name AS groupname, permissions.name AS name FROM groups, group_permissions, permissions WHERE group_permissions.permission = permissions.name AND groups.name = group_permissions.groupname", function(self, tblData)
    for k,v in pairs(tblData) do
      local strGroupName = v['groupname']
      local strName  = v['name']

      local objGroup = mikey.groups.get(strGroupName)
      if(objGroup) then
        objGroup:addPermission(strName)
      else
        mikey.log.error("tried adding permission '"..strName.."' to group '"..strGroupName.."' (group not found)")
      end
    end
  end, function(self, strError)
    mikey.log.error(strError)
  end)
end)

hook.Add("PlayerInitialSpawn", "mikey.groups.sendGroupData", function(objPl)
  objPl:SetUserGroup("Guest")

  local tblData = {}

  for k,v in pairs(mikey.groups.getAll()) do
    table.insert(tblData, {
      ["name"]          = v:getName(),
      ["color"]         = v:getColor(),
      ["inheritsFrom"]  = v:getInherited(),
      ["weight"]        = v:getWeight(),
      ["permissions"]   = v:getPermissions(),
    })
  end

  mikey.network.send("groups.fullUpdate", objPl, tblData)
end)
