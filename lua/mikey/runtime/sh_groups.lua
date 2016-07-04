mikey = mikey or {}
mikey.groups = mikey.groups or {}
mikey.groups.list = mikey.groups.list or {}

mikey.groups.get = function(obj)
  if(type(obj) == "string") then
    for k,v in pairs(mikey.groups.getAll()) do
      if(v:getName() == obj) then
        return v
      end
    end
  end

  return mikey.groups.list[obj] or nil
end

mikey.groups.getAll = function()
  return mikey.groups.list
end

local pl = FindMetaTable("Player")

function pl:getGroup()
  return mikey.groups.get(self:getNWVar("usergroup", 1))
end

function pl:IsAdmin()
  return self:hasPermission("isAdmin")
end

function pl:IsSuperAdmin()
  return self:hasPermission("isSuperAdmin")
end

function pl:GetUserGroup()
  return self:getNWVar("usergroup", 1)
end

function pl:IsUserGroup(strGroupName)
  if(type(strGroupName) == "string") then
    return self:GetUserGroup() == mikey.groups.get(strGroupName):getID()
  end

  return self:GetUserGroup() == strGroupName
end
