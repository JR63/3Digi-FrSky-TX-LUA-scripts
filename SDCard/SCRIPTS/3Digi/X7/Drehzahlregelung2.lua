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
   title = "Drehzahlreg. 2",
   title_en = "Governor 2",
   topic = {
      { t = "Kompensation",				x =  10, y =   8 },
   },
   topic_en = {
      { t = "Compensation",				x =  10, y =   8 },
   },
   text = {
      { t = "Pitch Kurve ver.",				x =   6, y =  16, to = SMLSIZE },
      { t = "V. Pitch",					x =   6, y =  24, to = SMLSIZE },
      { t = "V. Roll",					x =  49, y =  24, to = SMLSIZE },
      { t = "V. Nick",					x =  92, y =  24, to = SMLSIZE },
      { t = "Beschleunigung",				x =   6, y =  40, to = SMLSIZE },
   },
   text_en = {
      { t = "Use c. pit. curve",			x =   6, y =  16, to = SMLSIZE },
      { t = "F. c. pit.",				x =   6, y =  24, to = SMLSIZE },
      { t = "F. aile.",					x =  49, y =  24, to = SMLSIZE },
      { t = "F. elev.",					x =  92, y =  24, to = SMLSIZE },
      { t = "Acceleration",				x =   6, y =  40, to = SMLSIZE },
   },
   value_set = 8,
   param_check = 33036,
   fields = {
      -- Pitch-Kurve verwenden
      { x =  92, y =  16, min =   0, max =   1, param = 219, type = "uint8_t", to = SMLSIZE, valuetext = { [0] = "Aus", "An" }, valuetext_en = { [0] = "Off", "On" }, bitmask = 0x02 },
      -- Von Pitch
      { x =   6, y =  32, min =   0, max = 128, param = 228, type = "uint8_t", to = SMLSIZE },
      -- Von Roll
      { x =  49, y =  32, min =   0, max = 128, param = 229, type = "uint8_t", to = SMLSIZE },
      -- Von Nick
      { x =  92, y =  32, min =   0, max = 128, param = 230, type = "uint8_t", to = SMLSIZE },
      -- Beschleunigung
      { x =  92, y =  40, min =   0, max = 128, param = 232, type = "uint8_t", to = SMLSIZE },
   },
}