mikey = mikey or {}
mikey.network = mikey.network or {}
mikey.network.handlers = mikey.network.handlers or {}

if(SERVER) then util.AddNetworkString("mikey.network.transmit") end

mikey.network.sendMessage = function(strName, objTo, tblData)
  net.Start("mikey.network.transmit")
    net.WriteString(strName)
    net.WriteTable(SERVER and tblData or objTo)

  if(CLIENT) then
    net.SendToServer()
  else
    net.Send(objTo)
  end
end

mikey.network.setHandler = function(strName, objHandler)
  mikey.network.handlers[strName] = objHandler
end

net.Receive("mikey.network.transmit", function(iLen, objPl)
  local strName = net.ReadString()
  local objData = net.ReadTable()

  if(not mikey.network.handlers[strName]) then
    mikey.log.error("Network handler '"..strName.."' not found")
    return
  end

  mikey.network.handlers[strName](objPl or objData, objData)
end)
