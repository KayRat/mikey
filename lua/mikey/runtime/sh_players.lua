mikey = mikey or {}
mikey.players = mikey.players or {}

local pl = FindMetaTable("Player")

function pl:hasPermission(strPermission)
  local objGroup = self:getGroup()
  if(not objGroup) then return false end
  return objGroup:hasPermission(strPermission)
end

pl.HasPermission = pl.hasPermission

mikey.players.getPrettyName = function(ply)
  local name = {
    team.GetColor(ply:Team()), ply:Nick().." (",
    color_white, ply:SteamID(),
    team.GetColor(ply:Team()), " | ",
    color_white, ply:getRank():getName(),
    team.GetColor(ply:Team()), ")"
  }

  return name
end
