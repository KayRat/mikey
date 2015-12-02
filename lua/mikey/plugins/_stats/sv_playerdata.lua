local PLAYER = FindMetaTable("Player")

local function CreateStats(objPl)
  objPl.m_bCreateStats = true

  dyndb.query("INSERT INTO player_stats (name, steamid, credits) VALUES('{1}', '{2}', {3})", {objPl:Nick(), objPl:SteamID(), 0}, function(tblResults)
    if(not IsValid(objPl)) then return end

    objPl:LoadStats()
  end)
end

function PLAYER:LoadStats()
  if(self:IsBot()) then return end

  dyndb.query("SELECT * FROM player_stats WHERE steamid = '{1}' LIMIT 1", {self:SteamID()}, function(tblResults)
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
    end
  end)
end

hook.Add("PlayerInitialSpawn", "mikey.stats.createOrLoad", function(objPl)
  objPl:LoadStats()
end)
