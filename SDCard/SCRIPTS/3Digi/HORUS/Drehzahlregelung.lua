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
   title = "Drehzahlregelung",
   topic = {
      { t = "Aktivierung",				x =  10, y =  45 },
      { t = "Regelung",					x =  10, y =  95 },
      { t = "Kompensation",				x =  10, y = 170 },
   },
   text = {
      { t = "Drehzahlregelung aktivieren",		x =  20, y =  68 },
      { t = "Drehzahl",					x = 320, y =  68 },
      { t = "Empfindlichkeit",				x =  20, y = 118 },
      { t = "PFaktor",					x =  20, y = 143 },
      { t = "IFaktor",					x = 170, y = 143 },
      { t = "IBereich",					x = 320, y = 143 },
      { t = "Pitch Kurve verwenden",			x =  20, y = 193 },
      { t = "Von Pitch",				x =  20, y = 218 },
      { t = "Von Roll",					x = 170, y = 218 },
      { t = "Von Nick",					x = 320, y = 218 },
      { t = "Beschleunigung",				x =  20, y = 243 },
   },
   value_set = 8,
   param_check = 64552,
   fields = {
      -- Drehzahlregelung aktivieren
      { x = 260, y =  68, min =   0, max =   1, param = 219, type = "uint8_t", to = MIDSIZE, valuetext = { [0] = "Aus", "An" }, bitmask = 0x01 },
      -- Drehzahl
      { x = 405, y =  68, min = 500, max =5000, param = 221, type = "uint16_t",to = MIDSIZE },
      -- Empfindlichkeit
      { x = 260, y = 118, min =   0, max = 128, param = 222, type = "uint8_t", to = MIDSIZE },
      -- PFaktor
      { x = 110, y = 143, min =   0, max = 128, param = 223, type = "uint8_t", to = MIDSIZE },
      -- IFaktor
      { x = 260, y = 143, min =   0, max = 128, param = 224, type = "uint8_t", to = MIDSIZE },
      -- IBereich
      { x = 410, y = 143, min =   0, max = 128, param = 226, type = "uint8_t", to = MIDSIZE },
      -- Pitch-Kurve verwenden
      { x = 260, y = 193, min =   0, max =   1, param = 219, type = "uint8_t", to = MIDSIZE, valuetext = { [0] = "Aus", "An" }, bitmask = 0x02 },
      -- Von Pitch
      { x = 110, y = 218, min =   0, max = 128, param = 228, type = "uint8_t", to = MIDSIZE },
      -- Von Roll
      { x = 260, y = 218, min =   0, max = 128, param = 229, type = "uint8_t", to = MIDSIZE },
      -- Von Nick
      { x = 410, y = 218, min =   0, max = 128, param = 230, type = "uint8_t", to = MIDSIZE },
      -- Beschleunigung
      { x = 260, y = 243, min =   0, max = 128, param = 232, type = "uint8_t", to = MIDSIZE },
   },
}