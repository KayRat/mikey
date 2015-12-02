local PLUGIN = mikey.plugins.get()

PLUGIN.onMenuClick = function(self, objTargets)
  mikey.network.send("slay", {
    ["targets"] = objTargets
  })
end
