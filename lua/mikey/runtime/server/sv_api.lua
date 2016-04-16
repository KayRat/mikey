mikey = mikey or {}
mikey.api = mikey.api or {}

util.AddNetworkString("mikey.api.info")

local strToken = nil

local objAPIURL = CreateConVar("mikey_api_url", "", {
  FCVAR_PROTECTED,
  FCVAR_SERVER_CAN_EXECUTE,
}, "The URL of the mikey API")

local objAPIKey = CreateConVar("mikey_api_key", "", {
  FCVAR_PROTECTED,
  FCVAR_SERVER_CAN_EXECUTE,
}, "This server's key for the mikey API")

local function getURL()
  return objAPIURL:GetString()
end

local function getKey()
  return objAPIKey:GetString()
end

local function getToken()
  return strToken
end

local function buildURL(...)
  return getURL()..table.concat({...}, "/")
end

mikey.api.get = function(strURL, objSuccess, objFail)
  http.Post(buildURL(strURL), {
    ["token"] = getToken()
  }, function(strResponse, iLength, tblHeaders, iStatusCode)
    -- TODO: check response for proper formatting, check status codes, etc etc
    local tblResponse = util.JSONToTable(strResponse)
    objSuccess(table.Copy(tblResponse))
  end, objFail)
end

do -- Server Authentication
  local function doPostAuth()
    hook.Call("mikey.auth.completed")
  end

  local function onSuccessfulAuth(strResponse, iLength, tblHeaders, iStatusCode)
    print(strResponse, iLength, tblHeaders, iStatusCode)
    doPostAuth()
  end

  local function onFailedAuth(strError)
    mikey.log.error("api failed to do authentication: "..strError)
    doPostAuth()
  end

  hook.Add("Initialize", "mikey.api.authenticate", function()
    timer.Simple(0, function()
      http.Post(buildURL("authenticate"), {
        ["key"] = getKey(),
      }, onSuccessfulAuth, onFailedAuth)
    end)
  end)
end

mikey.api.put = function(strURL, tblData, objSuccess, objFail)
end

-- I prefer to send this via a net message because it makes it *slightly* more difficult to snoop
-- Granted if you want to snoop this won't really stop you
-- Not to mention all clientside requests are to the public API
-- So like, authentication man
do -- send client info
  hook.Add("PlayerInitialSpawn", "mikey.api.sendInfo", function(objPl)
    net.Start("mikey.api.info")
      net.WriteString(getURL())
    net.Send(objPl)
  end)
end
