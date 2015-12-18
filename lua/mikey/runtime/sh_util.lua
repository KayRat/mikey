mikey = mikey or {}
mikey.util = mikey.util or {}

mikey.util.addPlainText = function(tblOutput, strText)
  table.insert(tblOutput, color_white)
  table.insert(tblOutput, strText)
end

mikey.util.processNames = function(tblOutput, tblInput)
  local iNumTargets = table.Count(tblInput)
  local iNum = 1

  for k,v in pairs(tblInput) do
    local strText = v:Nick()

    if(iNum > 1) then
      if(iNumTargets > 2 and iNum <= iNumTargets) then
        mikey.util.addPlainText(tblOutput, ", ")
      end

      if(iNumTargets == 1 or iNum == iNumTargets) then
        mikey.util.addPlainText(tblOutput, (iNumTargets <= 2 and " " or "").."and ")
      end
    end

    table.insert(tblOutput, team.GetColor(v:Team()))
    table.insert(tblOutput, strText)

    iNum = iNum + 1
  end
end

mikey.util.auditTargets = function(tblTargets)
  for k,v in pairs(tblTargets) do
    if(not IsValid(v) or not v:IsPlayer()) then
      tblTargets[k] = nil
    end
  end

  return tblTargets
end
