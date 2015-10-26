mikey = mikey or {}

local function loadDirectory(strDir)
  local tblFiles,tblFolders = file.Find("mikey/"..strDir.."/*", "LUA")

  for k,v in pairs(tblFiles) do
    local tblSplit = string.Split(strDir, "/")
    local strRootDirName = tblSplit[1]
    local strChildDirName = tblSplit[2]
    local bIsPlugin = strRootDirName == "plugins" and #tblSplit > 1

    if(bIsPlugin) then
      _G["PLUGIN"] = mikey.plugins.get(strChildDirName)
      _G["PLUGIN"]["__NAME"] = strRootDirName
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
      _G["PLUGIN"]["__NAME"] = strRootDirName -- just in case a plugin tries to override its name
      mikey.plugins.commit(_G["PLUGIN"])
      _G["PLUGIN"] = {}
    end
  end

  for k,v in pairs(tblFolders) do
    loadDirectory(strDir.."/"..v)
  end
end

loadDirectory("runtime")
loadDirectory("plugins")

hook.Add("OnReloaded", "mikey.bootstrap.reloadPlugins", function()
  loadDirectory("plugins")
end)
