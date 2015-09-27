mikey = mikey or {}
mikey.ranks = mikey.ranks or {}
mikey.ranks.list = mikey.ranks.list or {}
mikey.ranks.default = mikey.ranks.default or nil

local pl = FindMetaTable("Player")

local function makeStringMethodSafe(str)
  str = string.Replace(str, " ", "")

  return str
end

mikey.ranks.setDefault = function(rank)
  mikey.ranks.default = rank
end

mikey.ranks.getDefault = function()
  return mikey.ranks.default
end

mikey.ranks.exists = function(rank)
  if(rank == nil) then return false end

  return mikey.ranks.list[rank] ~= nil
end

mikey.ranks.getAll = function()
  return mikey.ranks.list
end

mikey.ranks.get = function(rank)
  return mikey.ranks.list[rank]
end

mikey.ranks.create = function(rankName, weight, aliases)
  if(mikey.ranks.exists(rankName)) then
    mikey.log.warn("Rank '%s' already exists; overwriting", (type(rankName) == "string" and rankName or rankName:getName()))
  end

  weight = weight or 1
  aliases = aliases or {}

  local skeleton = {
    -- data
    ["rankName"] = rankName,
    ["weight"] = weight,

    -- functions
    ["getName"] = function(self) return self.rankName end,
    ["getWeight"] = function(self) return self.weight end,
  }

  skeleton.__index = skeleton

  local newRank = {}
  setmetatable(newRank, skeleton)

  local function isThisRank(pl)
    return pl:getRank():getWeight() >= newRank:getWeight()
  end

  local checkName = makeStringMethodSafe(newRank:getName())
  pl["is"..checkName] = isThisRank
  pl["Is"..checkName] = isThisRank

  if(not mikey.ranks.getDefault() or mikey.ranks.getDefault():getWeight() > newRank:getWeight()) then
    mikey.ranks.setDefault(newRank)
  end

  mikey.ranks.list[newRank:getName()] = newRank
  mikey.ranks.list[newRank:getWeight()] = newRank

  for k,v in pairs(aliases) do
    v = makeStringMethodSafe(v)
    mikey.ranks.list[v] = newRank

    pl["is"..v] = isThisRank
    pl["Is"..v] = isThisRank
  end

  return newRank
end

pl.getRankName = function(self)
  return self:getNWVar("mikey.rank", mikey.ranks.getDefault():getName())
end

pl.getRank = function(self)
  return mikey.ranks.get(self:getRankName())
end

pl.setRank = function(self, rank)
  if(not mikey.ranks.exists(rank)) then
    mikey.log.error("Rank '"..rank.."' cannot be assigned to '"..self:Nick().."': not found")
    return
  end

  self:setNWVar("mikey.rank", rank)
end

pl.setUserGroup = function(self, group)
  return false
end

pl.getUserGroup = function(self)
  return self:getRankName()
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
