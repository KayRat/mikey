local PLUGIN = mikey.plugins.get()

PLUGIN.onMenuClick = function(self, objTargets)
  print("Menu clicked", objTargets)
end

PLUGIN.onMenuRightClick = function(self, objTargets)
  mikey.network.send("kick.kickPlayer", {
    ["targets"] = objTargets,
    ["reason"]  = "Consider this a warning...don't do it again",
  })
end
