mikey = mikey or {}
mikey.api = mikey.api or {}

util.AddNetworkString("mikey.api.info")

local strToken = nil

local objAPIURL = CreateConVar("mikey_api_url", "", {
  FCVAR_PROTECTED,
  FCVAR_SERVER_CAN_EXECUTE,
}, "The URL of mikey's API")

local objAPIKey = CreateConVar("mikey_api_key", "", {
  FCVAR_PROTECTED,
  FCVAR_SERVER_CAN_EXECUTE,
}, "The key for mikey's API")

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

function mikey.api.get(strURL, objSuccess, objFail)
  http.Post(buildURL(strURL), {
    ["token"] = getToken()
  }, function(strResponse, iLength, tblHeaders, iStatusCode)
    local tblResponse = util.JSONToTable(strResponse)
    objSuccess(table.Copy(tblResponse))
  end, objFail)
end

do -- server authentication
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

do -- send client info
  hook.Add("PlayerInitialSpawn", "mikey.api.sendInfo", function(objPl)
    net.Start("mikey.api.info")
      net.WriteString(getURL())
    net.Send(objPl)
  end)
end
