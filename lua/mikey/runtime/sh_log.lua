mikey = mikey or {}
mikey.log = mikey.log or {}

local logger = ubilog.new("serverid")

function mikey.log.warn(str, ...)
    logger:warn(str, ...)
end

function mikey.log.info(str, ...)
    logger:info(str, ...)
end

function mikey.log.error(str, ...)
    logger:error(str, ...)
end
