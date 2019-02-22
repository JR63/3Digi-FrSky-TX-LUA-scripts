-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2019/02/21
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

-- Do not change the fields values without deep knowledge.
-- Wrong values result in wrong mapping and may cause unpredictable FBL behaviour.

return {
   title = "Aktivierungen",
   title_en = "Activations",
   topic = {
      { t = "AutoLevel Aktivierung",			x =  10, y =  45 },
      { t = "Drehzahlregelung Aktivierung",		x =  10, y = 160 },
   },
   topic_en = {
      { t = "AutoLevel activation",			x =  10, y =  45 },
      { t = "Governor activation",			x =  10, y = 160 },
   },
   text = {
      { t = "AutoLevel in diesem PS aktivieren",	x =  20, y =  70 },
      { t = "Drehzahlregelung aktivieren",		x =  20, y = 185 },
   },
   text_en = {
      { t = "Activate AutoLevel in this ParSet",	x =  20, y =  70 },
      { t = "Activate Governor",			x =  20, y = 185 },
   },
   value_set = 7,
   param_check = 14318,
   fields = {
      -- AutoLevel in diesem PS aktivieren
      { x = 310, y =  70, min =   0, max =   1, param = 248, type = "bool",    to = MIDSIZE, valuetext = { [0] = "Aus", "An" }, valuetext_en = { [0] = "Off", "On" } },
      -- Drehzahlregelung aktivieren
      { x = 310, y = 185, min =   0, max =   1, param = 219, type = "uint8_t", to = MIDSIZE, valuetext = { [0] = "Aus", "An" }, valuetext_en = { [0] = "Off", "On" }, bitmask = 0x01 },
   },
}