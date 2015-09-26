mikey = mikey or {}
mikey.ranks = mikey.ranks or {}
mikey.ranks.list = mikey.ranks.list or {}

local pl = FindMetaTable("Player")

local defaultRank = nil

local function makeStringMethodSafe(str)
  str = string.Replace(str, " ", "")

  return str
end

mikey.ranks.getDefault = function()
  return defaultRank
end

mikey.ranks.exists = function(rank)
  if(rank == nil) then return false end

  return mikey.ranks.list[rank] ~= nil
end

mikey.ranks.get = function(rank)
  return mikey.ranks.list[rank]
end

mikey.ranks.create = function(rankName, weight)
  if(mikey.ranks.exists(rankName)) then
    mikey.log.warn("Rank '%s' already exists; overwriting", (type(rankName) == "string" and rankName or rankName:getName()))
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
    return mikey.ranks.get(self:getRankName()):getWeight() >= newRank:getWeight()
  end
  pl["Is"..checkName] = function(self) return self["is"..checkName]() end

  if(not defaultRank or defaultRank:getWeight() > newRank:getWeight()) then
    defaultRank = newRank
  end

  return newRank
end

pl.getRankName = function(self)
  return self:getNWVar("mikey.rank", mikey.ranks.getDefault())
end

pl.getRank = function(self)
  return mikey.rnaks.get(self:getRankName())
end

pl.setRank = function(self, rank)
  if(not mikey.ranks.exists(rank)) then
    mikey.log.error("Rank '"..rank.."' cannot be assigned to '"..self:Nick().."': not found")
    return
  end

  self:setNWVar("mikey.rank", rank)
end

pl.setUserGroup = function(self, group)
  self:setNWVar("mikey.rank", group)
end

pl.getUserGroup = function(self)
  return self:getNWVar("mikey.rank", mikey.ranks.getDefault())
end

pl.isUserGroup = function(self, group)
  return self:getUserGroup() == group
end

pl.SetUserGroup = pl.setUserGroup
pl.GetUserGroup = pl.getUserGroup
pl.IsUserGroup = pl.isUserGroup

hook.Add("InitPostEntity", "mikey.ranks.loadRanks", function()
  hook.Call("mikey.ranks.preLoad", nil)
  hook.Call("mikey.ranks.load", nil)
  hook.Call("mikey.ranks.postLoad", nil)
end)

hook.Add("mikey.ranks.postLoad", "checkForRanks", function()
  if(not mikey.ranks.getDefault()) then
    mikey.log.error("No default rank found; no ranks loaded. Nothing will work")
  end
end)
