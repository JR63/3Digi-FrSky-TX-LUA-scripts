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
   title = "Taumelscheibe",
   title_en = "Swash",
   topic = {
      { t = "Cyclic Ring",				x =  10, y =  16 },
      { t = "Pitch Pump",				x =  10, y =  40 },
   },
   topic_en = {
      { t = "Cyclic ring",				x =  10, y =  16 },
      { t = "Pitch pump",				x =  10, y =  40 },
   },
   text = {
      { t = "Pirouetten Optimierung aktivieren",	x =   3, y =   8, to = SMLSIZE },
      { t = "Cyclic Ring aktivieren",			x =   9, y =  24, to = SMLSIZE },
      { t = "Zyklische Begrenzung",			x =   9, y =  32, to = SMLSIZE },
      { t = "Faktor",					x =   9, y =  48, to = SMLSIZE },
      { t = "Vorhaltezeit",				x =   9, y =  56, to = SMLSIZE },
   },
   text_en = {
      { t = "Activate pirouette optimization",		x =   3, y =   8, to = SMLSIZE },
      { t = "Activate cyclic ring",			x =   9, y =  24, to = SMLSIZE },
      { t = "Cyclic limit",				x =   9, y =  32, to = SMLSIZE },
      { t = "Strength",					x =   9, y =  48, to = SMLSIZE },
      { t = "Decay",					x =   9, y =  56, to = SMLSIZE },
   },
   value_set = 5,
   param_check = 21993,
   fields = {
      -- Pirouetten Optimierung aktivieren
      { x = 160, y =   8, min =   0, max =   1, param = 168, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Deaktiviert", "Aktiviert" }, valuetext_en = { [0] = "Deactivated", "Activated" } },
      -- Cyclic Ring aktivieren
      { x = 160, y =  24, min =   0, max =   1, param = 126, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Aus", "An" }, valuetext_en = { [0] = "Off", "On" } },
      -- Zyklische Begrenzung
      { x = 160, y =  32, min =  50, max = 100, param = 127, type = "uint8_t", to = SMLSIZE },
      -- Faktor
      { x = 160, y =  48, min =   0, max =  64, param = 169, type = "uint8_t", to = SMLSIZE },
      -- Vorhaltezeit
      { x = 160, y =  56, min =   1, max =  32, param = 170, type = "uint8_t", to = SMLSIZE },
   },
}