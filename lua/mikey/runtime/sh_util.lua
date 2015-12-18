mikey = mikey or {}
mikey.util = mikey.util or {}

local function addPlainText(tblOutput, strText)
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
        addPlainText(tblOutput, ", ")
      end

      if(iNumTargets == 1 or iNum == iNumTargets) then
        addPlainText(tblOutput, (iNumTargets <= 2 and " " or "").."and ")
      end
    end

    table.insert(tblOutput, team.GetColor(v:Team()))
    table.insert(tblOutput, strText)

    iNum = iNum + 1
  end
end
