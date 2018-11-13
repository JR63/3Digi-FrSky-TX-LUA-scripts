-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/13
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

-- Do not change the fields values without deep knowledge.
-- Wrong values result in wrong mapping and may cause unpredictable FBL behaviour.

return {
   title = "Allgemein 2",
   title_en = "Commonly 2",
   topic = {
      { t = "Direktanteil Optimierer",			x =  10, y =  65 },
      { t = "Speed-Flug Optimierer",			x =  10, y = 190 },
   },
   topic_en = {
      { t = "Initial response optimizer",		x =  10, y =  65 },
      { t = "Speed flight optimizer",			x =  10, y = 190 },
   },
   text = {
      { t = "Roll",					x = 290, y =  35, to = MIDSIZE },
      { t = "Nick",					x = 350, y =  35, to = MIDSIZE },
      
      { t = "Optimierer aktivieren",			x =  20, y =  90 },
      { t = "Qualitaet",				x =  20, y = 115 },
      { t = "Wert",					x =  20, y = 140 },
      { t = "Optimierer aktivieren",			x =  20, y = 215 },
   },
   text_en = {
      { t = "Aile.",					x = 290, y =  35, to = MIDSIZE },
      { t = "Elev.",					x = 350, y =  35, to = MIDSIZE },
      
      { t = "Activate optimizer",			x =  20, y =  90 },
      { t = "Quality",					x =  20, y = 115 },
      { t = "Current value",				x =  20, y = 140 },
      { t = "Activate optimizer",			x =  20, y = 215 },
   },
   bar = { rect_w = 220, rect_h = 16 },
   value_set = 11,
   param_check = 6518,
   fields = {
      -- Optimierer aktivieren
      { x = 240, y =  90, min =   0, max =   1, param =  43, type = "bool",    to = MIDSIZE, valuetext = { [0] = "Deaktiviert", "Aktiviert" }, valuetext_en = { [0] = "Deactivated", "Activated" } },
      -- Qualitaet
      { x = 240, y = 120, min =   0, max = 20000, param =  46, type = "bar",   to = MIDSIZE, ro = 1 },
      -- Wert
      { x = 290, y = 140, min = -30, max =  30, param =  44, type = "int32_t", to = MIDSIZE },
      { x = 350, y = 140, min = -30, max =  30, param =  45, type = "int32_t", to = MIDSIZE },
      -- Optimierer aktivieren
      { x = 240, y = 215, min =   0, max =   1, param =  47, type = "bool",    to = MIDSIZE, valuetext = { [0] = "Deaktiviert", "Aktiviert" }, valuetext_en = { [0] = "Deactivated", "Activated" } },
   },
}