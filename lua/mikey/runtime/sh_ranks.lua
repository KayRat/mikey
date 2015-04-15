mike = mike or {}
mike.ranks = mike.ranks or {}
mike.ranks.default = {}
mike.ranks.list = mike.ranks.list or {}

local meta = FindMetaTable("Player")

function meta:setRank(iLevel)
    local objRank = mike.ranks.get(iLevel)

    if(objRank ~= nil) then
        self.rank = objRank
    end
end

local function makeSafe(str)
    return string.Replace(str, " ", "")
end

function mike.ranks.setDefault(objRank)
    mike.ranks.default = objRank
end

function mike.ranks.getDefault()
    return mike.ranks.default
end

function mike.ranks.new(strName, iLevel)
    local tblSkeleton = {
        -- data
        ["name"] = strName,
        ["level"] = iLevel,
        ["shortName"] = strName,
        ["aliases"] = {},

        -- functions
        ["setShortName"] = function(self, strShort) self.shortName = strShort end,
        ["getShortName"] = function(self) return self.shortName end,

        ["getName"] = function(self) return self.name end,
        ["getLevel"] = function(self) return self.level end,

        ["addAlias"] = function(self, strAlias) self.aliases[strAlias] = true end,
        ["getAliases"] = function(self) return table.Copy(self.aliases) end,
    }

    tblSkeleton.__index = tblSkeleton

    local objRank = {}
    setmetatable(objRank, tblSkeleton)

    return objRank
end

function mike.ranks.add(objRank)
    if(mike.ranks.exists(objRank)) then
        mike.log.warn("Rank '%s' already exists; overwriting", objRank:getName())
    end

    local strSafeName = makeSafe(objRank:getName())

    meta["is"..strSafeName] = function(self)
        return self:getNWVar("rankLevel", 100) <= objRank:getLevel()
    end

    meta["Is"..strSafeName] = meta["is"..strSafeName]

    if(table.Count(objRank:getAliases()) > 0) then
        for k,v in pairs(objRank:getAliases()) do
            local vSafe = makeSafe(k)
            meta["is"..vSafe] = meta["is"..strSafeName]
            meta["Is"..vSafe] = meta["is"..strSafeName]
        end
    end

    mike.ranks.list[objRank:getName()] = objRank
    mike.ranks.list[objRank:getLevel()] = objRank
end

function mike.ranks.get(objRank)
    if(type(objRank) == "number" or type(objRank) == "string") then
        return mike.ranks.list[objRank]
    end
end

function mike.ranks.exists(strRank)
    if(type(strRank) ~= "string") then
        strRank = strRank:getName()
    end

    return mike.ranks.list[strRank] ~= nil
end

local objManager = mike.ranks.new("Regional Manager", 1)
objManager:setShortName("Manager")
objManager:addAlias("SuperAdmin")
mike.ranks.add(objManager)

local objARM = mike.ranks.new("Assistant (to the) Regional Manager", 2)
objARM:setShortName("ARM")
objARM:addAlias("Admin")
objARM:addAlias("ARM")
mike.ranks.add(objARM)

local objSales = mike.ranks.new("Salesman", 3)
objSales:setShortName("Sales")
objSales:addAlias("Mod")
objSales:addAlias("Moderator")
objSales:addAlias("Sales")
mike.ranks.add(objSales)

local objAcc = mike.ranks.new("Accountant", 4)
mike.ranks.add(objAcc)

local objCS = mike.ranks.new("Customer Service", 5)
mike.ranks.add(objCS)

local objTemp = mike.ranks.new("Temp", 10)
mike.ranks.add(objTemp)

local objGuest = mike.ranks.new("Client", 100)
objGuest:addAlias("Guest")
mike.ranks.add(objGuest)
mike.ranks.setDefault(objGuest)
