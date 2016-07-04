mikey = mikey or {}
mikey.groups = mikey.groups or {}
mikey.groups.list = mikey.groups.list or {}

local pl = FindMetaTable("Player")

function pl:SetUserGroup(iUserGroup)
  self:setNWVar("usergroup", iUserGroup)
end

hook.Add("mikey.db.connected", "mikey.groups.fetchAll", function()
  mikey.db.query("SELECT * FROM mikey.groups ORDER BY groups.weight DESC", function(self, tblData)
    for k,v in pairs(tblData) do
      local iGroupID = v['id']
      local strName = v['name']
      local objColor = Color(v['color_r'], v['color_g'], v['color_b'], 255)
      local iWeight = v['weight']

      local objGroup = Group.new(iGroupID, strName, objColor, iWeight)

      mikey.groups.list[iGroupID] = objGroup
      mikey.log.info("created rank '"..strName.."'")
    end

    hook.Call("mikey.groups.fetchPermissions", nil)
  end, function(self, strError)
    mikey.log.error(strError)
  end);
end)

hook.Add("mikey.groups.fetchPermissions", "mikey.groups.fetchAll", function()
  mikey.db.query("SELECT group_permissions.groupid AS groupid, permissions.name AS name FROM group_permissions, permissions WHERE group_permissions.permission = permissions.name", function(self, tblData)
    for k,v in pairs(tblData) do
      local iGroupID = v['groupid']
      local strName  = v['name']

      local objGroup = mikey.groups.get(iGroupID)
      if(objGroup) then
        objGroup:addPermission(strName)
      else
        mikey.log.error("tried adding permission '"..strName.."' to groupid '"..iGroupID.."' (group not found)")
      end
    end
  end, function(self, strError)
    mikey.log.error(strError)
  end)

  mikey.db.query("SELECT * FROM group_inheritence", function(self, tblData) -- TODO: actual inheritence, not this weird stuff
    for k,v in pairs(tblData) do
      local iParent = v['parent']
      local iTarget = v['target']

      local objParentGroup = mikey.groups.get(iParent)
      local objTargetGroup = mikey.groups.get(iTarget)

      if(objParentGroup and objTargetGroup) then
        objParentGroup:addPermissions(objTargetGroup:getPermissions())
      else
        mikey.log.error("unable to locate a group when building inheritence")
      end
    end
  end, function(self, strError)
    mikey.log.error(strError)
  end)
end)

hook.Add("PlayerInitialSpawn", "mikey.groups.sendGroupData", function(objPl)
  objPl:SetUserGroup(1)

  local tblData = {}

  for k,v in pairs(mikey.groups.getAll()) do
    table.insert(tblData, {
      ["groupid"]       = v:getID(),
      ["name"]          = v:getName(),
      ["color"]         = v:getColor(),
      ["weight"]        = v:getWeight(),
      ["permissions"]   = v:getPermissions(),
    })
  end

  mikey.network.send("groups.fullUpdate", objPl, tblData)
end)
