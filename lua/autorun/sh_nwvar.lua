if(SERVER) then
    util.AddNetworkString("nwvars.set")
    util.AddNetworkString("nwvars.remove")
	util.AddNetworkString("nwvars.fullUpdate")
end

nwvars = nwvars or {}
nwvars.data = nwvars.data or {}
nwvars.privacy = {
    SHARED,
    PRIVATE,
}
local meta = FindMetaTable("Player")

function meta:getNWVar(strVar, objDefault)
    local strUniqueID = self:UniqueID()

    if(nwvars.data[strUniqueID] and nwvars.data[strUniqueID][strVar] ~= nil) then
        return SERVER and nwvars.data[strUniqueID][strVar]["data"] or nwvars.data[strUniqueID][strVar]
    end

    return objDefault
end

if(SERVER) then
    function meta:setNWVar(strVar, objData, iPrivacy)
        iPrivacy = iPrivacy or nwvars.privacy.PRIVATE

        local strUniqueID = self:UniqueID()

        nwvars.data[strUniqueID] = nwvars.data[strUniqueID] or {}

        nwvars.data[strUniqueID][strVar] = {
            ["name"] = strVar,
            ["data"] = objData,
            ["privacy"] = iPrivacy,
        }

        net.Start("nwvars.set")
            net.WriteString(strUniqueID)
            net.WriteString(strVar)
            net.WriteType(objData)

        if(iPrivacy == nwvars.privacy.SHARED) then
            net.Broadcast()
        else
            net.Send(self)
        end
    end

    function meta:removeNWVar(strVar)
        local strUniqueID = self:UniqueID()

        if(nwvars.data[strUniqueID]) then
            nwvars.data[strUniqueID][strVar] = nil
        end

        net.Start("nwvars.remove")
            net.WriteString(strUniqueID)
            net.WriteString(strVar)
        net.Broadcast()
    end

	local function clearVars(strUniqueID)
		if(nwvars.data[strUniqueID]) then
            nwvars.data[strUniqueID] = nil
        end

        net.Start("nwvars.clear")
            net.WriteString(strUniqueID)
        net.Broadcast()
	end

    function meta:clearNWVars()
        clearVars(self:UniqueID())
    end

	hook.Add("PlayerInitialSpawn", "nwvars.sendUpdate", function(objPl)
		local tblVars = {}

		for strUniqueID,objData in pairs(nwvars.data) do
			tblVars[strUniqueID] = {}

			for strVar,objVarData in pairs(objData) do
				tblVars[strUniqueID][strVar] = objVarData["data"]
			end
		end

		net.Start("nwvars.fullUpdate")
			net.WriteTable(tblVars)
		net.Send(objPl)
	end)

	hook.Add("PlayerDisconnected", "nwvar.cleanup", function(objPl)
		local strUniqueID = objPl:UniqueID()

		timer.Start(0, function()
			clearVars(strUniqueID)
		end)
	end)
end

if(CLIENT) then
    net.Receive("nwvars.set", function(iLen)
        local strUniqueID = net.ReadString()
        local strVar = net.ReadString()
        local objData = net.ReadType(net.ReadUInt(8))

        nwvars.data[strUniqueID] = nwvars.data[strUniqueID] or {}
        nwvars.data[strUniqueID][strVar] = objData
    end)

    net.Receive("nwvars.remove", function(iLen)
        local strUniqueID = net.ReadString()
        local strVar = net.ReadString()

        if(nwvars.data[strUniqueID]) then
            nwvars.data[strUniqueID][strVar] = nil
        end
    end)

	net.Receive("nwvars.fullUpdate", function(iLen)
		local tblVars = net.ReadTable()

		for strUniqueID,tblData in pairs(tblVars) do
			nwvars.data[strUniqueID] = nwvars.data[strUniqueID] or {}

			for strVar,objData in pairs(tblData) do
				nwvars.data[strUniqueID][strVar] = objData
			end
		end
	end)
end












local meta = FindMetaTable("Player")
local tblVars = {}

if(SERVER) then
    util.AddNetworkString("nwvar")
    util.AddNetworkString("nwvar_fullupdate")
    util.AddNetworkString("nwvar_clear")
end

function meta:getNWVar(strVar, objVal)
    local strUniqueID = self:UniqueID()

    if(tblVars[strUniqueID] and tblVars[strUniqueID][strVar]) then
        return tblVars[strUniqueID][strVar]
    end

    return objVal
end

net.Receive("nwvar", function(iLen)
    local strUniqueID = net.ReadString()
    local strVar = net.ReadString()
    local strVal = net.ReadString()
    local tblVal = util.JSONToTable(strVal)
    local objVal = tblVal['Data']

    frank.debugPrint("Received '"..strVar.."' (value: '"..tostring(objVal).."', bytes: "..num.format(iLen / 8)..")")

    if(not tblVars[strUniqueID]) then
        tblVars[strUniqueID] = {}
    end

    tblVars[strUniqueID][strVar] = objVal
end)

net.Receive("nwvar_fullupdate", function(iLen)
    frank.debugPrint("Received 'nwvar_fullupdate' (bytes: "..num.format(iLen / 8)..")")

    local strData = net.ReadString()
    local tblData = util.JSONToTable(strData)

    table.Merge(tbldata, tblVars)
end)

net.Receive("nwvar_clear", function(iLen)
    local strUniqueID = net.ReadString()

    if(tblVars[strUniqueID]) then
        tblVars[strUniqueID] = nil
    end
end)

if(CLIENT) then return end

function meta:setNWVar(strVar, objVal, bPrivate)
    local strUniqueID = self:UniqueID()

    if(not tblVars[strUniqueID]) then
        tblVars[strUniqueID] = {}
    end

    tblVars[strUniqueID][strVar] = objVal

    net.Start("nwvar")
        net.WriteString(strUniqueID)
        net.WriteString(strVar)
        net.WriteString(util.TableToJSON({['Data'] = objVal}))
    if(bPrivate) then
        net.Send(self)
    else
        net.Broadcast()
    end

    return objVal
end

hook.Add("PlayerInitialSpawn", "nwvars_PlayerInitialSpawn", function(objPl)
    if(table.Count(tblVars) == 0) then return end
    local tblData = {}

    for strUniqueID,_ in pairs(tblVars) do
        if(strUniqueID ~= objPl:UniqueID()) then
            tblData[strUniqueID] = {}
            for strVar,objVal in pairs(tblVars[strUniqueID]) do
                tblData[strUniqueID][strVar] = objVal
            end
        end
    end

    local strData = util.TableToJSON(tblData)

    net.Start("nwvar_fullupdate")
        net.WriteString(strData)
    net.Send(objPl)
end)

hook.Add("PlayerDisconnected", "nwvars_PlayerDisconnected", function(objPl)
    local strUniqueID = objPl:UniqueID()

    -- if there isn't a timer this conflicts with other hooks that use NWVars
    -- a delay of 0 is probably okay but 0.05 works too, just in case!
    timer.Simple(0.05, function()
        net.Start("nwvar_clear")
            net.WriteString(strUniqueID)
        net.Broadcast()

        if(tblVars[strUniqueID]) then
            tblVars[strUniqueID] = nil
        end
    end)
end)
