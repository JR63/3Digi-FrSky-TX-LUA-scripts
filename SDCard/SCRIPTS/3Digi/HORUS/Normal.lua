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
   title = "Normal",
   topic = {
      { t = "Regelung",					x =  10, y =  65 },
   },
   text = {
      { t = "Roll",					x = 180, y =  35, to = MIDSIZE },
      { t = "Nick",					x = 280, y =  35, to = MIDSIZE },
      { t = "Heck",					x = 380, y =  35, to = MIDSIZE },
      
      { t = "Drehrate",					x =  20, y =  90 },
      { t = "Empfindlichkeit",				x =  20, y = 115 },
      { t = "Direktanteil",				x =  20, y = 140 },
      { t = "PFaktor",					x =  20, y = 165 },
      { t = "IFaktor",					x =  20, y = 190 },
      { t = "DFaktor",					x =  20, y = 215 },
   },
   value_set = 1,
   param_check = 56886,
   fields = {
      -- Roll
      { x = 180, y =  90, min =   0, max = 128, param = 132, type = "uint8_t", to = MIDSIZE },
      { x = 180, y = 115, min =   0, max = 128, param = 133, type = "uint8_t", to = MIDSIZE },
      { x = 180, y = 140, min =   0, max = 128, param = 131, type = "uint8_t", to = MIDSIZE },
      { x = 180, y = 165, min =   0, max = 128, param = 128, type = "uint8_t", to = MIDSIZE },
      { x = 180, y = 190, min =   0, max = 128, param = 129, type = "uint8_t", to = MIDSIZE },
      { x = 180, y = 215, min =   0, max =  80, param = 130, type = "uint8_t", to = MIDSIZE },
      -- Nick
      { x = 280, y =  90, min =   0, max = 128, param = 144, type = "uint8_t", to = MIDSIZE },
      { x = 280, y = 115, min =   0, max = 128, param = 145, type = "uint8_t", to = MIDSIZE },
      { x = 280, y = 140, min =   0, max = 128, param = 143, type = "uint8_t", to = MIDSIZE },
      { x = 280, y = 165, min =   0, max = 128, param = 140, type = "uint8_t", to = MIDSIZE },
      { x = 280, y = 190, min =   0, max = 128, param = 141, type = "uint8_t", to = MIDSIZE },
      { x = 280, y = 215, min =   0, max =  80, param = 142, type = "uint8_t", to = MIDSIZE },
      -- Heck
      { x = 380, y =  90, min =   0, max = 128, param = 156, type = "uint8_t", to = MIDSIZE },
      { x = 380, y = 115, min =   0, max = 128, param = 157, type = "uint8_t", to = MIDSIZE },
      { x = 380, y = 140, min =   0, max = 128, param = 155, type = "uint8_t", to = MIDSIZE },
      { x = 380, y = 165, min =   0, max = 128, param = 152, type = "uint8_t", to = MIDSIZE },
      { x = 380, y = 190, min =   0, max = 128, param = 153, type = "uint8_t", to = MIDSIZE },
      { x = 380, y = 215, min =   0, max = 128, param = 154, type = "uint8_t", to = MIDSIZE },
   },
}