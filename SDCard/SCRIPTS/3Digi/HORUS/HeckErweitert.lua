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
   title = "Heck erweitert",
   title_en = "Tail extended",
   topic = {
      { t = "Extra Empfindlichkeit",			x =  10, y =  45 },
      { t = "Drehmomentausgleich",			x =  10, y = 160 },
   },
   topic_en = {
      { t = "Extra gains",				x =  10, y =  45 },
      { t = "Torque compensation",			x =  10, y = 160 },
   },
   text = {
      { t = "Links",					x =  20, y =  70 },
      { t = "Rechts",					x = 170, y =  70 },
      { t = "Start",					x =  20, y =  95 },
      { t = "Stopp",					x = 170, y =  95 },
      { t = "Von Pitch",				x =  20, y = 185 },
      { t = "Von Roll",					x = 170, y = 185 },
      { t = "Von Nick",					x = 320, y = 185 },
   },
   text_en = {
      { t = "Left",					x =  20, y =  70 },
      { t = "Right",					x = 170, y =  70 },
      { t = "Start",					x =  20, y =  95 },
      { t = "Stop",					x = 170, y =  95 },
      { t = "F. coll. pit.",				x =  20, y = 185 },
      { t = "F. aileron",				x = 170, y = 185 },
      { t = "F. elevator",				x = 320, y = 185 },
   },
   value_set = 6,
   param_check = 31765,
   fields = {
      -- Extra Empfindlichkeit Links
      { x =  90, y =  70, min = -16, max =  16, param = 158, type = "int8_t",  to = MIDSIZE },
      -- Extra Empfindlichkeit Rechts
      { x = 240, y =  70, min = -16, max =  16, param = 159, type = "int8_t",  to = MIDSIZE },
      -- Extra Empfindlichkeit Start
      { x =  90, y =  95, min = -16, max =  16, param = 160, type = "int8_t",  to = MIDSIZE },
      -- Extra Empfindlichkeit Stopp
      { x = 240, y =  95, min = -16, max =  16, param = 161, type = "int8_t",  to = MIDSIZE },
      -- Drehmomentausgleich Von Pitch
      { x = 120, y = 185, min =   0, max = 125, param = 167, type = "uint8_t", to = MIDSIZE },
      -- Drehmomentausgleich Von Roll
      { x = 270, y = 185, min =   0, max = 125, param = 165, type = "uint8_t", to = MIDSIZE },
      -- Drehmomentausgleich Von Nick
      { x = 420, y = 185, min =   0, max = 125, param = 166, type = "uint8_t", to = MIDSIZE },
   },
}