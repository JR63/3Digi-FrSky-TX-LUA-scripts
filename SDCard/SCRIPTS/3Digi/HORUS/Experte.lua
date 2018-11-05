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
   title = "Experte",
   topic = {
      { t = "Regelung",					x =  10, y =  65 },
      { t = "Aufbaeum Kompensation",			x =  10, y = 195 },
   },
   text = {
      { t = "Roll",					x = 180, y =  35, to = MIDSIZE },
      { t = "Nick",					x = 280, y =  35, to = MIDSIZE },
      { t = "Heck",					x = 380, y =  35, to = MIDSIZE },
      
      { t = "IBereich",					x =  20, y =  90 },
      { t = "IVerlauf",					x =  20, y = 115 },
      { t = "IVerlaufModus",				x =  20, y = 140 },
      { t = "DVorhaltezeit",				x =  20, y = 165 },
      { t = "Statisch",					x =  20, y = 220 },
      { t = "Dynamisch",				x =  20, y = 245 },
   },
   value_set = 2,
   param_check = 48462,
   fields = {
      -- Roll
      { x = 180, y =  90, min =   0, max = 128, param = 137, type = "uint8_t", to = MIDSIZE },
      { x = 180, y = 115, min =   0, max = 128, param = 134, type = "uint8_t", to = MIDSIZE, valuetext = { [128] = "HH" } },
      { x = 180, y = 140, min =   0, max =   1, param = 135, type = "bool",                  valuetext = { [0] = "Einfach", "Erweitert" } },
      { x = 180, y = 165, min =   1, max =  64, param = 138, type = "uint8_t", to = MIDSIZE },
      -- Nick
      { x = 280, y =  90, min =   0, max = 128, param = 149, type = "uint8_t", to = MIDSIZE },
      { x = 280, y = 115, min =   0, max = 128, param = 146, type = "uint8_t", to = MIDSIZE, valuetext = { [128] = "HH" } },
      { x = 280, y = 140, min =   0, max =   1, param = 147, type = "bool",                  valuetext = { [0] = "Einfach", "Erweitert" } },
      { x = 280, y = 165, min =   1, max =  64, param = 150, type = "uint8_t", to = MIDSIZE },
      { x = 280, y = 220, min =   0, max = 128, param = 151, type = "uint8_t", to = MIDSIZE },
      { x = 280, y = 245, min =   0, max = 128, param = 185, type = "uint8_t", to = MIDSIZE },
      -- Heck
      { x = 380, y =  90, min =   0, max = 128, param = 163, type = "uint8_t", to = MIDSIZE },
      { x = 380, y = 115, min =   0, max = 128, param = 162, type = "uint8_t", to = MIDSIZE, valuetext = { [128] = "HH" } },
      
      { x = 380, y = 165, min =   1, max =  32, param = 164, type = "uint8_t", to = MIDSIZE },
   },
}