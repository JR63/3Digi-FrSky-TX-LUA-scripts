-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/05
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

local supportedProtocols =
{
    smartPort =
    {
        transport       = SCRIPT_HOME.."/TD/sp.lua",
        rssi            = function() return getValue("RSSI") end,
        exitFunc        = function() return 0 end,
        stateSensor     = "Tmp1",
        push            = sportTelemetryPush,
        maxTxBufferSize = 6,
        maxRxBufferSize = 6,
        saveMaxRetries  = 2,
        saveTimeout     = 200
    }
}

function getProtocol()
    if supportedProtocols.smartPort.push() then
        return supportedProtocols.smartPort
    end
end

local protocol = getProtocol()

if not protocol then
    error("Telemetry protocol not supported!")
end

return protocol
