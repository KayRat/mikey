mike = mike or {}
mike.log = mike.log or {}

local function out(str)
end

function mike.log.warn(str, ...)
    str = string.format(str, ...)

    MsgC(unpack({
        mike.colors.outside,  "[",
        color_white,          "MIKEY",
        mike.colors.outside,  "] ",
        mike.colors.warning,  "WARN: ",
        color_white,          str.."\n",
    }))

    str = "[MIKEY] WARN: "..str
    out(str)
end

function mike.log.info(str, ...)
    str = "[MIKEY] INFO: "..string.format(str, ...)

    MsgC(unpack({
        mike.colors.outside,  "[",
        color_white,          "MIKEY",
        mike.colors.outside,  "] ",
        mike.colors.info,     "INFO: ",
        color_white,          str.."\n",
    }))

    str = "[MIKEY] WARN: "..str

    out(str)
end

function mike.log.error(str, ...)
    str = string.format(str, ...).."\n"

    MsgC(unpack({
        mike.colors.outside,  "[",
        color_white,          "MIKEY",
        mike.colors.outside,  "] ",
        mike.colors.error,    "ERROR: ",
        color_white,          str,
    }))

    str = "[MIKEY] WARN: "..str

    out(str)
end
