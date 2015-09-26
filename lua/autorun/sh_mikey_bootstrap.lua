local function loadDirectory(strDir)
  local tblFiles,tblFolders = file.Find("mikey/"..strDir.."/*", "LUA")

  for k,v in pairs(tblFiles) do
    local strPrefix = string.sub(v, 1, 3)

    if(strPrefix == "cl_") then
        if(CLIENT) then
            include("mikey/"..strDir.."/"..v)
        end

        AddCSLuaFile("mikey/"..strDir.."/"..v)
    elseif(SERVER and strPrefix == "sv_") then
        include("mikey/"..strDir.."/"..v)
    else
        include("mikey/"..strDir.."/"..v)
        AddCSLuaFile("mikey/"..strDir.."/"..v)
    end
  end

  for k,v in pairs(tblFolders) do
    loadDirectory(strDir.."/"..v)
  end
end

loadDirectory("runtime")
loadDirectory("plugins")
