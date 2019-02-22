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
      { t = "AutoLevel Aktivierung",			x =  10, y =  12 },
      { t = "Drehzahlreg. Aktivierung",			x =  10, y =  40 },
   },
   topic_en = {
      { t = "AutoLevel activation",			x =  10, y =  12 },
      { t = "Governor activation",			x =  10, y =  40 },
   },
   text = {
      { t = "AutoLevel in",				x =   6, y =  21, to = SMLSIZE },
      { t = "diesem PS aktivieren",			x =   6, y =  29, to = SMLSIZE },
      { t = "Drehzahlregelung",				x =   6, y =  49, to = SMLSIZE },
      { t = "aktivieren",				x =   6, y =  57, to = SMLSIZE },
   },
   text_en = {
      { t = "Activate AutoLevel",			x =   6, y =  21, to = SMLSIZE },
      { t = "in this ParSet",				x =   6, y =  29, to = SMLSIZE },
      { t = "Activate",					x =   6, y =  49, to = SMLSIZE },
      { t = "governor",					x =   6, y =  57, to = SMLSIZE },
   },
   value_set = 7,
   param_check = 14318,
   fields = {
      -- AutoLevel in diesem PS aktivieren
      { x = 105, y =  25, min =   0, max =   1, param = 248, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Aus", "An" }, valuetext_en = { [0] = "Off", "On" } },
      -- Drehzahlregelung aktivieren
      { x = 105, y =  53, min =   0, max =   1, param = 219, type = "uint8_t", to = SMLSIZE, valuetext = { [0] = "Aus", "An" }, valuetext_en = { [0] = "Off", "On" }, bitmask = 0x01 },
   },
}