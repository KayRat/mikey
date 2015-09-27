local adminChat = mikey.plugins.get("Admin Chat")

hook.Add("PlayerSay", "mikey.pluigns.adminchat", function(ply, text, team)
  if(string.sub(text, 1, 1) == "@") then
    text = string.sub(text, 2)

    if(string.len(text) > 0) then
      local to = {ply}

      for k,v in pairs(player.GetAll()) do
        if(v ~= ply and v:isMod()) then
          table.insert(to, v)
        end
      end

      adminChat:sendNetMessage("chatmessage", to, {
        ["from"] = ply,
        ["message"] = text,
      })
    else
      ply:sendMessage(mikey.colors.error, "[!] ", color_white, "You must enter a message to send to staff members!")
    end

    return ""
  end
end)

mikey.plugins.add(adminChat)
