mike = mike or {}
mike.ranks = mike.ranks or {}
mike.ranks.list = mike.ranks.list or {}

local pl = FindMetaTable("Player")

local defaultRank = nil

local function isValidRank(data)
  if(not data["name"] or type(data["name"]) ~= "string") then
    return false
  end

  if(not data["weight"] or type(data["weight"] ~= "number")) then
    return false
  end

  return true
end

local function makeStringMethodSafe(str)
  str = string.Replace(str, " ", "")

  return str
end

mike.ranks.getDefault = function()
  return defaultRank
end

mike.ranks.exists = function(rank)
  if(rank == nil) then return false end

  return mike.ranks.list[rank] ~= nil
end

mike.ranks.get = function(rank)
  return mike.ranks.list[rank]
end

mike.ranks.create = function(rankName, weight)
  if(mike.ranks.exists(rankName)) then
    mike.log.warn("Rank '%s' already exists; overwriting", (type(rankName) == "string" and rankName or rankName:getName()))
  end

  local skeleton = {
    -- data
    ["rankName"] = rankName,
    ["weight"] = weight or 1,

    -- functions
    ["getName"] = function(self) return self.rankName end,
    ["getWeight"] = function(self) return self.weight end,
  }
  skeleton.__index = skeleton

  local newRank = {}
  setmetatable(newRank, skeleton)

  local checkName = makeStringMethodSafe(newRank:getName())
  pl["is"..checkName] = function(self)
    return mike.ranks.get(self:getRankName()):getWeight() >= newRank:getWeight()
  end
  pl["Is"..checkName] = function(self) return self["is"..checkName]() end

  if(not defaultRank or defaultRank:getWeight() > newRank:getWeight()) then
    defaultRank = newRank
  end

  return newRank
end

pl.getRankName = function(self)
  return self:getNWVar("mike.rank", mike.ranks.getDefault())
end

pl.getRank = function(self)
  return mike.rnaks.get(self:getRankName())
end

pl.setRank = function(self, rank)
  if(not mike.ranks.exists(rank)) then
    mike.log.error("Rank '"..rank.."' cannot be assigned to '"..self:Nick().."': not found")
    return
  end

  self:setNWVar("mike.rank", rank)
end

pl.setUserGroup = function(self, group)
  self:setNWVar("mike.rank", group)
end

pl.getUserGroup = function(self)
  return self:getNWVar("mike.rank", mike.ranks.getDefault())
end

pl.isUserGroup = function(self, group)
  return self:getUserGroup() == group
end

pl.SetUserGroup = pl.setUserGroup
pl.GetUserGroup = pl.getUserGroup
pl.IsUserGroup = pl.isUserGroup
