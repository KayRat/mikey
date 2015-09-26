mikey = mikey or {}
mikey.log = mikey.log or {}

local function out(str)
  -- TODO: file and/or database logging
end

function mikey.log.warn(str, ...)
    str = string.format(str, ...)

    MsgC(unpack({
        mikey.colors.outside,  "[",
        color_white,          "mikey",
        mikey.colors.outside,  "] ",
        mikey.colors.warning,  "WARN: ",
        color_white,          str.."\n",
    }))

    str = "[mikey] WARN: "..str
    out(str)
end

function mikey.log.info(str, ...)
    str = string.format(str, ...)

    MsgC(unpack({
        mikey.colors.outside,  "[",
        color_white,          "mikey",
        mikey.colors.outside,  "] ",
        mikey.colors.info,     "INFO: ",
        color_white,          str.."\n",
    }))

    str = "[mikey] INFO: "..str

    out(str)
end

function mikey.log.error(str, ...)
    str = string.format(str, ...).."\n"

    MsgC(unpack({
        mikey.colors.outside,  "[",
        color_white,          "mikey",
        mikey.colors.outside,  "] ",
        mikey.colors.error,    "ERROR: ",
        color_white,          str,
    }))

    str = "[mikey] ERROR: "..str

    out(str)
end
