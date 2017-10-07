mikey = mikey or {}
mikey.log = mikey.log or {}

local logger = ubilog.new("serverid")

local function out(str)
  -- TODO: file and/or database logging
end

function mikey.log.warn(str, ...)
    logger:warn(str, ...)
end

function mikey.log.info(str, ...)
    logger:info(str, ...)
end

function mikey.log.error(str, ...)
    logger:error(str, ...)
end
