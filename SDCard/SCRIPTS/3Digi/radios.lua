-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/05
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

lcdResolution =
{
    low    = 0,
    medium = 1,
    high   = 2
}

local supportedPlatforms = {
    x7 =
    {
        templateHome    = SCRIPT_HOME.."/X7/",
        preLoad         = SCRIPT_HOME.."/X7/x7pre.lua",
        resolution      = lcdResolution.low
    },
    x9 =
    {
        templateHome    = SCRIPT_HOME.."/X9/",
        preLoad         = SCRIPT_HOME.."/X9/x9pre.lua",
        resolution      = lcdResolution.medium
    },
    horus =
    {
        templateHome=SCRIPT_HOME.."/HORUS/",
        preLoad=SCRIPT_HOME.."/HORUS/horuspre.lua",
        resolution      = lcdResolution.high
    },
}

local supportedRadios =
{
    ["x7-simu"] = supportedPlatforms.x7,
    ["x7s-simu"] = supportedPlatforms.x7,
    ["xlite-simu"] = supportedPlatforms.x7,
    ["x9d-simu"] = supportedPlatforms.x9,
    ["x9d+-simu"] = supportedPlatforms.x9,
    ["x9e-simu"] = supportedPlatforms.x9,
    ["x10-simu"] = supportedPlatforms.horus,
    ["x12s-simu"] = supportedPlatforms.horus,
    ["x7"] = supportedPlatforms.x7,
    ["x7s"] = supportedPlatforms.x7,
    ["xlite"] = supportedPlatforms.x7,
    ["x9d"] = supportedPlatforms.x9,
    ["x9d+"] = supportedPlatforms.x9,
    ["x9e"] = supportedPlatforms.x9,
    ["x10"] = supportedPlatforms.horus,
    ["x12s"] = supportedPlatforms.horus,
}

local ver, rad, maj, min, rev = getVersion()
local radio = supportedRadios[rad]

if not radio then
    error("Radio not supported: "..rad)
end

return radio
