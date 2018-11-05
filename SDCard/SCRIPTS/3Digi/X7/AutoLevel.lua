-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/05
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

-- Do not change the fields values without deep knowledge.
-- Wrong values result in wrong mapping and may cause unpredictable FBL behaviour.

return {
   title = "AutoLevel",
   topic = {
      { t = "AutoLevel",				x =  10, y =  12 },
   },
   text = {
      { t = "AutoLevel in",				x =   6, y =  21, to = SMLSIZE },
      { t = "diesem PS aktivieren",			x =   6, y =  29, to = SMLSIZE },
   },
   value_set = 7,
   param_check = 7688,
   fields = {
      -- AutoLevel in diesem PS aktivieren
      { x = 105, y =  29, min =   0, max =   1, param = 248, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Aus", "An" } },
   },
}