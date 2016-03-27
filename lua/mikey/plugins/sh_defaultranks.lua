hook.Add("mikey.ranks.load", "zzzzzz_defaultRanks", function()
  mikey.ranks.create("Guest", 1)

  mikey.ranks.create("Moderator", 8, {"Mod"})
  mikey.ranks.create("Admin", 9)
  mikey.ranks.create("Super Admin", 10)
end)
