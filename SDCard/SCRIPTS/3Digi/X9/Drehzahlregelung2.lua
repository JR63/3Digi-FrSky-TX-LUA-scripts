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
   title = "Drehzahlregelung 2",
   topic = {
      { t = "Kompensation",				x =  10, y =   12 },
   },
   text = {
      { t = "Pitch Kurve verwenden",			x =   6, y =  21, to = SMLSIZE },
      { t = "Von Pitch",				x =   6, y =  29, to = SMLSIZE },
      { t = "Von Roll",					x =  76, y =  29, to = SMLSIZE },
      { t = "Von Nick",					x = 146, y =  29, to = SMLSIZE },
      { t = "Beschleunigung",				x =   6, y =  37, to = SMLSIZE },
   },
   value_set = 8,
   param_check = 33036,
   fields = {
      -- Pitch-Kurve verwenden
      { x = 160, y =  21, min =   0, max =   1, param = 219, type = "uint8_t", to = SMLSIZE, valuetext = { [0] = "Aus", "An" }, bitmask = 0x02 },
      -- Von Pitch
      { x =  52, y =  29, min =   0, max = 128, param = 228, type = "uint8_t", to = SMLSIZE },
      -- Von Roll
      { x = 122, y =  29, min =   0, max = 128, param = 229, type = "uint8_t", to = SMLSIZE },
      -- Von Nick
      { x = 192, y =  29, min =   0, max = 128, param = 230, type = "uint8_t", to = SMLSIZE },
      -- Beschleunigung
      { x = 160, y =  37, min =   0, max = 128, param = 232, type = "uint8_t", to = SMLSIZE },
   },
}