using "mikey.ranks"

mikey = mikey or {}
mikey.ranks = mikey.ranks or {}
mikey.ranks.list = mikey.ranks.list or {}

local pl = FindMetaTable("Player")

local function makeStringMethodSafe(str)
  str = string.Replace(str, " ", "")

  return str
end

mikey.ranks.exists = function(objRank)
  if(objRank == nil) then return false end

  return mikey.ranks.list[objRank] ~= nil
end

mikey.ranks.getAll = function()
  return table.Copy(mikey.ranks.list)
end

mikey.ranks.get = function(strRank)
  return mikey.ranks.list[strRank]
end

mikey.ranks.create = function(strName, iWeight, tblPermissions, objColor)
  if(mikey.ranks.exists(strName)) then
    mikey.log.warn("Rank '%s' already exists; overwriting", (type(strName) == "string" and strName or strName:getName()))
  end

  iWeight         = iWeight or 1
  tblPermissions  = tblPermissions or {}
  objColor        = objColor or color_black

  local objRank = mikey.ranks.Rank.new(strName, iWeight, tblPermissions, objColor)

  local function isThisRank(objPl)
    return objPl:getRank():getWeight() >= objRank:getWeight()
  end

  local strSafeName = makeStringMethodSafe(objRank:getName())
  pl["is"..strSafeName] = isThisRank
  pl["Is"..strSafeName] = isThisRank

  mikey.ranks.list[objRank:getName()] = objRank
  mikey.ranks.list[objRank:getWeight()] = objRank

  return objRank
end

pl.getRankName = function(self)
  return self:getNWVar("mikey.rank", mikey.ranks.list[1]:getName())
end

pl.getRank = function(self)
  return mikey.ranks.get(self:getRankName())
end

pl.setRank = function(self, strName)
  if(not mikey.ranks.exists(strName)) then
    mikey.log.error("Rank '"..strName.."' cannot be assigned to '"..self:Nick().."': rank not found")
    return
  end

  self:setNWVar("mikey.rank", strName)
end

pl.setUserGroup = function(self, strGroup)
  return false
end

pl.getUserGroup = function(self)
  return self:getRankName()
end

pl.isUserGroup = function(self, strGroup)
  return self:getUserGroup() == strGroup
end

pl.SetUserGroup = pl.setUserGroup
pl.GetUserGroup = pl.getUserGroup
pl.IsUserGroup = pl.isUserGroup

pl.isAdmin = function(self)
  return self:hasPermission("isAdmin")
end

pl.IsAdmin = pl.isAdmin

pl.isSuperAdmin = function(self)
  return self:hasPermission("isSuperAdmin")
end

pl.IsSuperAdmin = pl.isSuperAdmin

hook.Add("Initialize", "mikey.ranks.loadRanks", function()
  hook.Call("mikey.ranks.load", nil)
end)

hook.Add("mikey.ranks.load", "mikey.ranks.addGuest", function()
  mikey.ranks.create("Guest", 1, {
    "useAdminChat",
    "menu",
  }, Color(187, 255, 135, 255))
end)
