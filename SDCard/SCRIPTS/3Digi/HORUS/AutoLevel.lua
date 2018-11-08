-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/07
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

-- Do not change the fields values without deep knowledge.
-- Wrong values result in wrong mapping and may cause unpredictable FBL behaviour.

return {
   title = "AutoLevel",
   title_en = "AutoLevel",
   topic = {
      { t = "AutoLevel Aktivierung",			x =  10, y =  45 },
   },
   topic_en = {
      { t = "AutoLevel activation",			x =  10, y =  45 },
   },
   text = {
      { t = "AutoLevel in diesem PS aktivieren",	x =  20, y =  70 },
   },
   text_en = {
      { t = "Activate AutoLevel in this ParSet",	x =  20, y =  70 },
   },
   value_set = 7,
   param_check = 7688,
   fields = {
      -- AutoLevel in diesem PS aktivieren
      { x = 310, y =  70, min =   0, max =   1, param = 248, type = "bool",    to = MIDSIZE, valuetext = { [0] = "Aus", "An" }, valuetext_en = { [0] = "Off", "On" } },
   },
}