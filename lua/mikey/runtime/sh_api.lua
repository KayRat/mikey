mikey = mikey or {}
mikey.api = mikey.api or {}

local strAPIURL = nil

net.Receive("mikey.api.info", function(iLen)
  local strAPIURL = net.ReadString()
end)

local function getURL()
  return strAPIURL
end

local function buildURL(...)
  return getURL()..table.concat({...}, "/")
end

function mikey.api.get(strURL, objSuccess, objFail)
  http.Fetch(buildURL(strURL), function(strResponse, iLength, tblHeaders, iStatusCode)
    local tblResponse = util.JSONToTable(strResponse)
    objSuccess(table.Copy(tblResponse))
  end, objFail)
end
