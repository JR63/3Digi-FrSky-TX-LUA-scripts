-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2019/02/15
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
      { t = "AutoLevel Aktivierung",			x =  10, y =  12 },
      { t = "Drehzahlreg. Aktivierung",			x =  10, y =  40 },
   },
   topic_en = {
      { t = "AutoLevel activation",			x =  10, y =  12 },
      { t = "Governor activation",			x =  10, y =  40 },
   },
   text = {
      { t = "AutoLevel in diesem PS aktivieren",	x =   6, y =  21, to = SMLSIZE },
      { t = "Drehzahlregelung aktivieren",		x =   6, y =  49, to = SMLSIZE },
   },
   text_en = {
      { t = "Activate AutoLevel in this ParSet",	x =   6, y =  21, to = SMLSIZE },
      { t = "Activate Governor",			x =   6, y =  49, to = SMLSIZE },
   },
   value_set = 7,
   param_check = 14318,
   fields = {
      -- AutoLevel in diesem PS aktivieren
      { x = 170, y =  21, min =   0, max =   1, param = 248, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Aus", "An" }, valuetext_en = { [0] = "Off", "On" } },
      -- Drehzahlregelung aktivieren
      { x = 170, y =  49, min =   0, max =   1, param = 219, type = "uint8_t", to = SMLSIZE, valuetext = { [0] = "Aus", "An" }, valuetext_en = { [0] = "Off", "On" }, bitmask = 0x01 },
   },
}