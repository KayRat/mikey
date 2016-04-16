include("autorun/simploo.lua")
mikey = mikey or {}

local function loadDirectory(strDir)
  local tblFiles,tblFolders = file.Find("mikey/"..strDir.."/*", "LUA")

  for k,v in pairs(tblFiles) do
    local tblSplit = string.Split(strDir, "/")
    local strRootDirName = tblSplit[1]
    local strChildDirName = tblSplit[2]
    local bIsPlugin = strRootDirName == "plugins" and strChildDirName ~= nil
    local PLUGIN = nil

    if(bIsPlugin) then
      PLUGIN = mikey.plugins.get(strChildDirName)
      PLUGIN["__NAME"] = strChildDirName
      mikey.plugins.set(PLUGIN)
    end

    local strPrefix = string.sub(v, 1, 3)

    if(strPrefix == "cl_") then
      if(CLIENT) then
        include("mikey/"..strDir.."/"..v)
      end

      AddCSLuaFile("mikey/"..strDir.."/"..v)
    elseif(SERVER and strPrefix == "sv_") then
      include("mikey/"..strDir.."/"..v)
    elseif(string.sub(v, 1, 1) ~= "_") then
      include("mikey/"..strDir.."/"..v)
      AddCSLuaFile("mikey/"..strDir.."/"..v)
    end

    if(bIsPlugin) then
      mikey.plugins.commit(PLUGIN)
    end
  end

  for k,v in pairs(tblFolders) do
    loadDirectory(strDir.."/"..v)
  end
end

loadDirectory("objects")
loadDirectory("runtime")
loadDirectory("plugins")

hook.Add("OnReloaded", "mikey.bootstrap.reloadPlugins", function()
  loadDirectory("plugins")
end)
