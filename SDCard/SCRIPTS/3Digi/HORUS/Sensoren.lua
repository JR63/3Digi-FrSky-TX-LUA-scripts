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
   title = "Sensoren",
   title_en = "Sensors",
   topic = {
      { t = "Sensoren",					x =  10, y =  65 },
      { t = "RC Eingang",				x =  10, y = 160 },
   },
   topic_en = {
      { t = "Sensors",					x =  10, y =  65 },
      { t = "RC input",					x =  10, y = 160 },
   },
   text = {
      { t = "Roll",					x = 180, y =  35, to = MIDSIZE },
      { t = "Nick",					x = 280, y =  35, to = MIDSIZE },
      { t = "Heck",					x = 380, y =  35, to = MIDSIZE },
      
      { t = "Totband",					x =  20, y =  90 },
      { t = "Filter",					x =  20, y = 115 },
      { t = "Totband",					x =  20, y = 185 },
   },
   text_en = {
      { t = "Aile.",					x = 180, y =  35, to = MIDSIZE },
      { t = "Elev.",					x = 280, y =  35, to = MIDSIZE },
      { t = "Tail",					x = 380, y =  35, to = MIDSIZE },
      
      { t = "Deadband",					x =  20, y =  90 },
      { t = "Filter",					x =  20, y = 115 },
      { t = "Deadband",					x =  20, y = 185 },
   },
   value_set = 12,
   param_check = 31284,
   fields = {
      -- Sensoren Totband
      { x = 230, y =  90, min =   0, max =  30, param = 125, index = 0, type = "uint8_t", to = MIDSIZE + RIGHT },
      { x = 330, y =  90, min =   0, max =  30, param = 125, index = 1, type = "uint8_t", to = MIDSIZE + RIGHT },
      { x = 430, y =  90, min =   0, max =  30, param = 125, index = 2, type = "uint8_t", to = MIDSIZE + RIGHT },
      -- Sensoren Filter
      { x = 230, y = 115, min =   0, max =  50, param = 123, index = 0, type = "uint8_t", to = MIDSIZE + RIGHT },
      { x = 330, y = 115, min =   0, max =  50, param = 123, index = 1, type = "uint8_t", to = MIDSIZE + RIGHT },
      { x = 430, y = 115, min =   0, max =  50, param = 123, index = 2, type = "uint8_t", to = MIDSIZE + RIGHT },
      -- RC Eingang Totband
      { x = 230, y = 185, min =   0, max =  50, param = 122, index = 0, type = "uint8_t", to = MIDSIZE + RIGHT },
      { x = 330, y = 185, min =   0, max =  50, param = 122, index = 1, type = "uint8_t", to = MIDSIZE + RIGHT },
      { x = 430, y = 185, min =   0, max =  50, param = 122, index = 2, type = "uint8_t", to = MIDSIZE + RIGHT },
   },
}