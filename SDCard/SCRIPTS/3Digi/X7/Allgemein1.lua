-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/08
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

-- Do not change the fields values without deep knowledge.
-- Wrong values result in wrong mapping and may cause unpredictable FBL behaviour.

return {
   title = "Allgemein 1",
   title_en = "Commonly 1",
   topic = {
      { t = "Steuerverhalten",				x =  10, y =  16 },
      { t = "Auto-Trimm",				x =  10, y =  32 },
   },
   topic_en = {
      { t = "Control feeling",				x =  10, y =  16 },
      { t = "Auto trim",				x =  10, y =  32 },
   },
   text = {
      { t = "Roll",					x =  59, y =   9, to = SMLSIZE },
      { t = "Nick",					x =  82, y =   9, to = SMLSIZE },
      { t = "Heck",					x = 105, y =   9, to = SMLSIZE },
      
      { t = "Ruh. <> Dyn.",				x =   6, y =  24, to = SMLSIZE },
      { t = "Tr-Flg akt.",				x =   6, y =  40, to = SMLSIZE },
      { t = "Qualitaet",				x =   6, y =  48, to = SMLSIZE },
      { t = "Trimmwert",				x =   6, y =  56, to = SMLSIZE },
   },
   text_en = {
      { t = "Aile.",					x =  59, y =   9, to = SMLSIZE },
      { t = "Elev.",					x =  82, y =   9, to = SMLSIZE },
      { t = "Tail",					x = 105, y =   9, to = SMLSIZE },
      
      { t = "Smo. <> Liv.",				x =   6, y =  24, to = SMLSIZE },
      { t = "Act. a. trim",				x =   6, y =  40, to = SMLSIZE },
      { t = "Quality",					x =   6, y =  48, to = SMLSIZE },
      { t = "Trim value",				x =   6, y =  56, to = SMLSIZE },
   },
   bar = { rect_w =  65, rect_h =  6 },
   value_set = 10,
   param_check = 36854,
   fields = {
      -- Ruhig <-> Dynamisch
      { x =  59, y =  24, min =   1, max =   5, param = 121, index = 0, type = "uint8_t", to = SMLSIZE },
      { x =  82, y =  24, min =   1, max =   5, param = 121, index = 1, type = "uint8_t", to = SMLSIZE },
      { x = 105, y =  24, min =   1, max =   5, param = 121, index = 2, type = "uint8_t", to = SMLSIZE },
      -- Trimm-Flug aktivieren
      { x =  59, y =  40, min =   0, max =   1, param = 196, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Deaktiviert", "Aktiviert" }, valuetext_en = { [0] = "Deactivated", "Activated" } },
      -- Qualitaet
      { x =  59, y =  48, min =   0, max = 20000, param = 197, type = "bar",   to = SMLSIZE },
      -- Trimmwert
      { x =  59, y =  56, min =-200, max = 200, param = 198, type = "int32_t", to = SMLSIZE },
      { x =  82, y =  56, min =-200, max = 200, param = 199, type = "int32_t", to = SMLSIZE },
      { x = 105, y =  56, min =-500, max = 500, param = 200, type = "int32_t", to = SMLSIZE },
   },
}