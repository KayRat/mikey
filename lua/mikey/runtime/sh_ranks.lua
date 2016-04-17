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

mikey.ranks.create = function(strName, iWeight, tblPermissions, tblAliases)
  if(mikey.ranks.exists(strName)) then
    mikey.log.warn("Rank '%s' already exists; overwriting", (type(strName) == "string" and strName or strName:getName()))
  end

  iWeight         = iWeight or 1
  tblPermissions  = tblPermissions or {}
  tblAliases      = tblAliases or {}

  local objRank = mikey.ranks.Rank.new(strName, iWeight, tblPermissions)

  local function isThisRank(objPl)
    return objPl:getRank():getWeight() >= objRank:getWeight()
  end

  local strSafeName = makeStringMethodSafe(objRank:getName())
  pl["is"..strSafeName] = isThisRank
  pl["Is"..strSafeName] = isThisRank

  mikey.ranks.list[objRank:getName()] = objRank
  mikey.ranks.list[objRank:getWeight()] = objRank

  for k,v in pairs(tblAliases) do
    v = makeStringMethodSafe(v)
    mikey.ranks.list[v] = objRank

    pl["is"..v] = isThisRank
    pl["Is"..v] = isThisRank
  end

  return objRank
end

--[[
{
  "1": {
    "id": 1,
    "name": "Guest",
    "weight": 1,
  },
  "2": {
    "id": 2,
    "name": "Moderator",
    "weight": 2,"
    "permissions": {
      "menu",
      "kick",
      "ban",
      "adminchat",
      "slay"
    },
    "aliases": {
      "Mod"
    }
  },
  "3": {
    "id": 3,
    "name": "Regional Manager",
    "weight": 10,
    "permissions": {
      "lua"
    }
  }
}
]]

mikey.ranks.refresh = function()
  mikey.api.get("ranks/getAll", function(tblData)
    if(not tblData) then
      mikey.log.error("data parse failed on rank fetch")
      return
    end

    if(#tblData <= 0) then
      mikey.log.error("found 0 configured ranks")
      return
    end

    for k,tblRank in pairs(tblData) do
      mikey.ranks.create(tblData["name"], tblData["weight"], tblData["permissions"], tblData["aliases"])
    end
  end, function(strError)
    mikey.log.error("Error refreshing ranks: "..strError)
  end)
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

hook.Add("mikey.auth.completed", "mikey.ranks.loadRanks", function()
  hook.Call("mikey.ranks.load", nil)
end)

hook.Add("mikey.ranks.load", "mikey.ranks.addGuest", function()
  mikey.ranks.create("Guest", 1, {
    "useAdminChat",
    "menu"
  })
end)

hook.Add("mikey.ranks.load", "mikey.ranks.fetch", function()
  mikey.ranks.refresh()
end)
