mikey = mikey or {}
mikey.db = mikey.db or {}

require("mysqloo")

function mikey.db.connect()
  if(not file.Exists("mikey_config.json", "DATA")) then
    mikey.log.error("no config file found")
    return
  end

  local tblData = util.JSONToTable(file.Read("mikey_config.json", "DATA"))
  local objDB = mysqloo.connect(tblData['hostname'], tblData['username'], tblData['password'], tblData['database'], tblData['port'])

  objDB.onConnected = function(self)
    mikey.log.info("mysql successfully connected")
    mikey.db.m_objDatabase = objDB
    hook.Call("mikey.db.connected", nil)
  end

  objDB.onConnectionFailed = function(self, strError)
    mikey.log.error("mysql failed to connect: "..strError)
  end

  objDB:connect()
end

function mikey.db.query(strQuery, objOnSuccess, objOnFail)
  local objQuery = mikey.db.m_objDatabase:query(strQuery)
  objQuery.onSuccess  = objOnSuccess
  objQuery.onError    = objOnFail
  objQuery:start()
end

function mikey.db.escape(str)
  return mikey.db.m_objDatabase and mikey.db.m_objDatabase:escape(str) or sql.SQLStr(str, true)
end

if(not mikey.db.m_objDatabase) then
  mikey.db.connect()
end

timer.Create("mikey.db.nosleep", 30, 0, function()
  mikey.db.query("SELECT 1;");
end)
