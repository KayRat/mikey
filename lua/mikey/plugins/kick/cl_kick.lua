PLUGIN.buildModal = function(self, menu, target)
end

PLUGIN.onMenuClick = function(self, objTargets)
  print("Menu clicked", objTargets)
end

PLUGIN.onMenuRightClick = function(self, objTargets)
  mikey.network.sendMessage("kick.kickPlayer", {
    ["targets"] = objTargets,
    ["reason"]  = "Consider this a warning...don't do it again",
  })
end
