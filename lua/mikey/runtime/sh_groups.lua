mikey = mikey or {}
mikey.groups = mikey.groups or {}
mikey.groups.list = mikey.groups.list or {}

mikey.groups.get = function(strGroupName)
  return mikey.groups.list[strGroupName] or nil
end

mikey.groups.getAll = function()
  return mikey.groups.list
end

local pl = FindMetaTable("Player")

function pl:getGroup()
  return mikey.groups.get(self:GetUserGroup())
end

function pl:IsAdmin()
  return self:hasPermission("isAdmin")
end

function pl:IsSuperAdmin()
  return self:hasPermission("isSuperAdmin")
end

function pl:GetUserGroup()
  return self:getNWVar("usergroup", "Guest")
end
