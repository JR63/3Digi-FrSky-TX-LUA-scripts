-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/05
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

language = "de"

SCRIPT_HOME = "/SCRIPTS/3Digi"

protocol = assert(loadScript(SCRIPT_HOME.."/protocols.lua"))()
radio = assert(loadScript(SCRIPT_HOME.."/radios.lua"))()

assert(loadScript(radio.preLoad))()
assert(loadScript(protocol.transport))()

local run_ui = assert(loadScript(SCRIPT_HOME.."/ui.lua"))()

return { run=run_ui }
