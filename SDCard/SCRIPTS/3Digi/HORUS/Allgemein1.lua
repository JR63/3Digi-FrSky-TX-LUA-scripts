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
      { t = "Steuerverhalten",				x =  10, y =  65 },
      { t = "Auto-Trimm",				x =  10, y = 150 },
   },
   topic_en = {
      { t = "Control feeling",				x =  10, y =  65 },
      { t = "Auto trim",				x =  10, y = 150 },
   },
   text = {
      { t = "Roll",					x = 290, y =  35, to = MIDSIZE },
      { t = "Nick",					x = 350, y =  35, to = MIDSIZE },
      { t = "Heck",					x = 410, y =  35, to = MIDSIZE },
      
      { t = "Ruhig <-> Dynamisch",			x =  20, y =  90 },
      { t = "Trimm-Flug aktivieren",			x =  20, y = 175 },
      { t = "Qualitaet",				x =  20, y = 200 },
      { t = "Trimmwert",				x =  20, y = 225 },
   },
   text_en = {
      { t = "Aile.",					x = 290, y =  35, to = MIDSIZE },
      { t = "Elev.",					x = 350, y =  35, to = MIDSIZE },
      { t = "Tail",					x = 410, y =  35, to = MIDSIZE },
      
      { t = "Smooth <-> Lively",			x =  20, y =  90 },
      { t = "Activate auto trim",			x =  20, y = 175 },
      { t = "Quality",					x =  20, y = 200 },
      { t = "Current trim value",			x =  20, y = 225 },
   },
   bar = { rect_w = 220, rect_h = 16 },
   value_set = 10,
   param_check = 36854,
   fields = {
      -- Ruhig <-> Dynamisch
      { x = 290, y =  90, min =   1, max =   5, param = 121, index = 0, type = "uint8_t", to = MIDSIZE },
      { x = 350, y =  90, min =   1, max =   5, param = 121, index = 1, type = "uint8_t", to = MIDSIZE },
      { x = 410, y =  90, min =   1, max =   5, param = 121, index = 2, type = "uint8_t", to = MIDSIZE },
      -- Trimm-Flug aktivieren
      { x = 240, y = 175, min =   0, max =   1, param = 196, type = "bool",    to = MIDSIZE, valuetext = { [0] = "Deaktiviert", "Aktiviert" }, valuetext_en = { [0] = "Deactivated", "Activated" } },
      -- Qualitaet
      { x = 240, y = 205, min =   0, max = 20000, param = 197, type = "bar",   to = MIDSIZE },
      -- Trimmwert
      { x = 290, y = 225, min =-200, max = 200, param = 198, type = "int32_t", to = MIDSIZE },
      { x = 350, y = 225, min =-200, max = 200, param = 199, type = "int32_t", to = MIDSIZE },
      { x = 410, y = 225, min =-500, max = 500, param = 200, type = "int32_t", to = MIDSIZE },
   },
}