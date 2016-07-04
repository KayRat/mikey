mikey = mikey or {}
mikey.groups = mikey.groups or {}
mikey.groups.list = mikey.groups.list or {}

mikey.network.receive("groups.fullUpdate", function(tblData)
  for k,v in pairs(tblData) do
    local iGroupID        = v['groupid']
    local strName         = v['name']
    local objColor        = v['color']
    local iWeight         = v['weight']
    local tblPermissions  = v['permissions']

    local objGroup = Group.new(iGroupID, strName, objColor, iWeight)
    objGroup:addPermissions(tblPermissions)

    mikey.groups.list[iGroupID] = objGroup
  end
end)
