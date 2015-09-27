mikey = mikey or {}
mikey.players = mikey.players or {}

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
