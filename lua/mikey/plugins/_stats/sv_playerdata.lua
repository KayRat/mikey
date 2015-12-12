local PLAYER = FindMetaTable("Player")

local function CreateStats(objPl)
  objPl.m_bCreateStats = true

  dyndb.query("INSERT INTO player_data (steam64, name, firstjoin, lastjoin, credits) VALUES('{1}', '{2}', {3}, {4}, {5})", {
    objPl:SteamID64(),
    objPl:Nick(),
    os.time(),
    os.time(),
    0,
  }, function(tblResults)
    if(not IsValid(objPl)) then return end

    objPl:LoadPlayerData(true)
  end)
end

function PLAYER:LoadPlayerData(bFirstJoin)
  if(self:IsBot()) then return end

  dyndb.query("SELECT * FROM player_data WHERE steam64 = '{1}' LIMIT 1", {self:SteamID64()}, function(tblResults)
    if(not IsValid(self)) then return end

    if(not tblResults or table.Count(tblResults[1]["data"]) <= 0) then
      if(not self.m_bCreateStats) then
        CreateStats(self)
      else
        error("failed to create player data for "..self:Nick())
      end
    else
      PrintTable(tblResults)
      local tblData = tblResults[1]["data"]
      local iCredits = tonumber(tblData["credits"] or 0)

      self:SetNWVar("credits", iCredits)

      local tblPlayers = table.Copy(player.GetAll())
      table.RemoveByValue(tblPlayers, self)

      mikey.network.send("player.firstjoin", tblPlayers, {
        ["player"]    = self,
      })
    end
  end)
end

hook.Add("PlayerInitialSpawn", "mikey.stats.createOrLoad", function(objPl)
  objPl:LoadPlayerData()
end)
