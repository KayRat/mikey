mikey = mikey or {}
mikey.plugins = mikey.plugins or {}
mikey.plugins.list = mikey.plugins.list or {}

local objPlugin = nil

local function createNewPlugin(strName)
  local tblSkeleton = {
    -- data
    ["__name"] = strName,

    -- functions
    ["getName"] = function(self) return self.__name end,
    ["canUserRun"] = function(self, objPl) return IsValid(objPl) end,
  }

  tblSkeleton.__index = tblSkeleton

  local objPlugin = {}
  setmetatable(objPlugin, tblSkeleton)

  return objPlugin
end

function mikey.plugins.exists(strName)
  return mikey.plugins.list[strName] ~= nil
end

function mikey.plugins.set(objPlugin)
  objCurPlugin = objPlugin
end

function mikey.plugins.get(strName)
  if(not strName) then
    return objCurPlugin
  end

  return mikey.plugins.list[strName] or createNewPlugin(strName)
end

function mikey.plugins.getAll(objFilter)
  local tbl = {}

  for k,v in pairs(mikey.plugins.list) do
    if(not objFilter or (v["Menu"] and v["Menu"]["Category"] and v["Menu"]["Category"] == objFilter)) then
      table.insert(tbl, v)
    end
  end

  return tbl
end

function mikey.plugins.commit(objPlugin)
  if(not objPlugin["__NAME"]) then
    mikey.log.error("Tried to commit a malformed plugin; aborting")
    return
  end

  mikey.plugins.list[objPlugin["__NAME"]] = objPlugin
end
