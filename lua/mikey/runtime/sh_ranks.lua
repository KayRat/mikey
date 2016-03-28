mikey = mikey or {}
mikey.ranks = mikey.ranks or {}
mikey.ranks.list = mikey.ranks.list or {}
mikey.ranks.default = mikey.ranks.default or nil

local pl = FindMetaTable("Player")

local function makeStringMethodSafe(str)
  str = string.Replace(str, " ", "")

  return str
end

mikey.ranks.setDefault = function(objRank)
  mikey.ranks.default = objRank
end

mikey.ranks.getDefault = function()
  return mikey.ranks.default
end

mikey.ranks.exists = function(objRank)
  if(rank == nil) then return false end

  return mikey.ranks.list[objRank] ~= nil
end

mikey.ranks.getAll = function()
  return table.Copy(mikey.ranks.list)
end

mikey.ranks.get = function(strRank)
  return mikey.ranks.list[strRank]
end

mikey.ranks.create = function(strRank, iWeight, tblPermissions, tblAliases)
  if(mikey.ranks.exists(strRank)) then
    mikey.log.warn("Rank '%s' already exists; overwriting", (type(strRank) == "string" and strRank or strRank:getName()))
  end

  iWeight         = iWeight or 1
  tblPermissions  = tblPermissions or {}
  tblAliases      = tblAliases or {}

  local skeleton = {
    -- data
    ["__strRank"]         = strRank,
    ["__iWeight"]         = iWeight,
    ["__tblPermissions"]  = {},

    -- functions
    ["getName"]         = function(self) return self.__strRank end,
    ["getWeight"]       = function(self) return self.__iWeight end,
    ["getPermissions"]  = function(self) return table.Copy(self.__tblPermissions) end,
  }

  skeleton.__index = skeleton

  local objRank = {}
  setmetatable(objRank, skeleton)

  local function isThisRank(objPl)
    return objPl:getRank():getWeight() >= objRank:getWeight()
  end

  local strSafeName = makeStringMethodSafe(objRank:getName())
  pl["is"..strSafeName] = isThisRank
  pl["Is"..strSafeName] = isThisRank

  if(not mikey.ranks.getDefault() or mikey.ranks.getDefault():getWeight() > objRank:getWeight()) then
    mikey.ranks.setDefault(objRank)
  end

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
    mikey.log.error("Error getting ranks: "..strError)
  end)
end

pl.getRankName = function(self)
  if(not mikey.ranks.getDefault()) then return "ERROR" end
  return self:getNWVar("mikey.rank", mikey.ranks.getDefault():getName())
end

pl.getRank = function(self)
  return mikey.ranks.get(self:getRankName())
end

pl.setRank = function(self, strRank)
  if(not mikey.strRanks.exists(strRank)) then
    mikey.log.error("Rank '"..strRank.."' cannot be assigned to '"..self:Nick().."': rank not found")
    return
  end

  self:setNWVar("mikey.rank", strRank)
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

hook.Add("mikey.ranks.load", "mikey.ranks.fetch", function()
  mikey.ranks.refresh()
end)
