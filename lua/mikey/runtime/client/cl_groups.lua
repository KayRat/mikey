mikey = mikey or {}
mikey.groups = mikey.groups or {}
mikey.groups.list = mikey.groups.list or {}

mikey.network.receive("groups.fullUpdate", function(tblData)
  for k,v in pairs(tblData) do
    local strName         = v['name']
    local objColor        = v['color']
    local strInheritsFrom  = v['inheritsFrom']
    local iWeight         = v['weight']
    local tblPermissions  = v['permissions']

    local objGroup = Group.new(strName, objColor, strInheritsFrom, iWeight)
    objGroup:addPermissions(tblPermissions)

    mikey.groups.list[strName] = objGroup
  end
end)
