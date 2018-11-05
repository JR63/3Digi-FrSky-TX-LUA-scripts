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
   title = "Drehzahlregelung 1",
   topic = {
      { t = "Aktivierung",				x =  10, y =  12 },
      { t = "Regelung",					x =  10, y =  40 },
   },
   text = {
      { t = "Drehzahlregelung aktivieren",		x =   6, y =  21, to = SMLSIZE },
      { t = "Drehzahl",					x =   6, y =  29, to = SMLSIZE },
      { t = "Empfindlichkeit",				x =   6, y =  49, to = SMLSIZE },
      { t = "PFaktor",					x =   6, y =  57, to = SMLSIZE },
      { t = "IFaktor",					x =  76, y =  57, to = SMLSIZE },
      { t = "IBereich",					x = 146, y =  57, to = SMLSIZE },
   },
   value_set = 8,
   param_check = 38056,
   fields = {
      -- Drehzahlregelung aktivieren
      { x = 160, y =  21, min =   0, max =   1, param = 219, type = "uint8_t", to = SMLSIZE, valuetext = { [0] = "Aus", "An" }, bitmask = 0x01 },
      -- Drehzahl
      { x = 160, y =  29, min = 500, max =5000, param = 221, type = "uint16_t",to = SMLSIZE },
      -- Empfindlichkeit
      { x = 160, y =  49, min =   0, max = 128, param = 222, type = "uint8_t", to = SMLSIZE },
      -- PFaktor
      { x =  52, y =  57, min =   0, max = 128, param = 223, type = "uint8_t", to = SMLSIZE },
      -- IFaktor
      { x = 122, y =  57, min =   0, max = 128, param = 224, type = "uint8_t", to = SMLSIZE },
      -- IBereich
      { x = 192, y =  57, min =   0, max = 128, param = 226, type = "uint8_t", to = SMLSIZE },
   },
}