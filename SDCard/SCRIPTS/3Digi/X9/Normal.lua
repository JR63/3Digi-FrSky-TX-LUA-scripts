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
   title = "Normal",
   title_en = "Normal",
   topic = {
   },
   text = {
      { t = "Roll",					x =  95, y =   8, to = SMLSIZE },
      { t = "Nick",					x = 140, y =   8, to = SMLSIZE },
      { t = "Heck",					x = 185, y =   8, to = SMLSIZE },
      
      { t = "Drehrate",					x =   3, y =  16, to = SMLSIZE },
      { t = "Empfindlichkeit",				x =   3, y =  24, to = SMLSIZE },
      { t = "Direktanteil",				x =   3, y =  32, to = SMLSIZE },
      { t = "PFaktor",					x =   3, y =  40, to = SMLSIZE },
      { t = "IFaktor",					x =   3, y =  48, to = SMLSIZE },
      { t = "DFaktor",					x =   3, y =  56, to = SMLSIZE },
   },
   text_en = {
      { t = "Aile.",					x =  95, y =   8, to = SMLSIZE },
      { t = "Elev.",					x = 140, y =   8, to = SMLSIZE },
      { t = "Tail",					x = 185, y =   8, to = SMLSIZE },
      
      { t = "Agility",					x =   3, y =  16, to = SMLSIZE },
      { t = "Overall gain",				x =   3, y =  24, to = SMLSIZE },
      { t = "Initial response",				x =   3, y =  32, to = SMLSIZE },
      { t = "P",					x =   3, y =  40, to = SMLSIZE },
      { t = "I",					x =   3, y =  48, to = SMLSIZE },
      { t = "D",					x =   3, y =  56, to = SMLSIZE },
   },
   value_set = 1,
   param_check = 56886,
   fields = {
      -- Roll
      { x =  95, y =  16, min =   0, max = 128, param = 132, type = "uint8_t", to = SMLSIZE },
      { x =  95, y =  24, min =   0, max = 128, param = 133, type = "uint8_t", to = SMLSIZE },
      { x =  95, y =  32, min =   0, max = 128, param = 131, type = "uint8_t", to = SMLSIZE },
      { x =  95, y =  40, min =   0, max = 128, param = 128, type = "uint8_t", to = SMLSIZE },
      { x =  95, y =  48, min =   0, max = 128, param = 129, type = "uint8_t", to = SMLSIZE },
      { x =  95, y =  56, min =   0, max =  80, param = 130, type = "uint8_t", to = SMLSIZE },
      -- Nick
      { x = 140, y =  16, min =   0, max = 128, param = 144, type = "uint8_t", to = SMLSIZE },
      { x = 140, y =  24, min =   0, max = 128, param = 145, type = "uint8_t", to = SMLSIZE },
      { x = 140, y =  32, min =   0, max = 128, param = 143, type = "uint8_t", to = SMLSIZE },
      { x = 140, y =  40, min =   0, max = 128, param = 140, type = "uint8_t", to = SMLSIZE },
      { x = 140, y =  48, min =   0, max = 128, param = 141, type = "uint8_t", to = SMLSIZE },
      { x = 140, y =  56, min =   0, max =  80, param = 142, type = "uint8_t", to = SMLSIZE },
      -- Heck
      { x = 185, y =  16, min =   0, max = 128, param = 156, type = "uint8_t", to = SMLSIZE },
      { x = 185, y =  24, min =   0, max = 128, param = 157, type = "uint8_t", to = SMLSIZE },
      { x = 185, y =  32, min =   0, max = 128, param = 155, type = "uint8_t", to = SMLSIZE },
      { x = 185, y =  40, min =   0, max = 128, param = 152, type = "uint8_t", to = SMLSIZE },
      { x = 185, y =  48, min =   0, max = 128, param = 153, type = "uint8_t", to = SMLSIZE },
      { x = 185, y =  56, min =   0, max = 128, param = 154, type = "uint8_t", to = SMLSIZE },
   },
}
