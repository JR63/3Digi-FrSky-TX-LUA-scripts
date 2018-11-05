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
   },
   text = {
      { t = "Roll",					x =  95, y =   8, to = SMLSIZE },
      { t = "Nick",					x = 140, y =   8, to = SMLSIZE },
      { t = "Heck",					x = 185, y =   8, to = SMLSIZE },
      
      { t = "IBereich",					x =   3, y =  16, to = SMLSIZE },
      { t = "IVerlauf",					x =   3, y =  24, to = SMLSIZE },
      { t = "IVerlaufModus",				x =   3, y =  32, to = SMLSIZE },
      { t = "DVorhaltezeit",				x =   3, y =  40, to = SMLSIZE },
      { t = "A.K. Statisch",				x =   3, y =  48, to = SMLSIZE },
      { t = "A.K. Dynamisch",				x =   3, y =  56, to = SMLSIZE },
   },
   value_set = 2,
   param_check = 48462,
   fields = {
      -- Roll
      { x =  95, y =  16, min =   0, max = 128, param = 137, type = "uint8_t", to = SMLSIZE },
      { x =  95, y =  24, min =   0, max = 128, param = 134, type = "uint8_t", to = SMLSIZE, valuetext = { [128] = "HH" } },
      { x =  95, y =  32, min =   0, max =   1, param = 135, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Einfach", "Erweit." } },
      { x =  95, y =  40, min =   1, max =  64, param = 138, type = "uint8_t", to = SMLSIZE },
      -- Nick
      { x = 140, y =  16, min =   0, max = 128, param = 149, type = "uint8_t", to = SMLSIZE },
      { x = 140, y =  24, min =   0, max = 128, param = 146, type = "uint8_t", to = SMLSIZE, valuetext = { [128] = "HH" } },
      { x = 140, y =  32, min =   0, max =   1, param = 147, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Einfach", "Erweit." } },
      { x = 140, y =  40, min =   1, max =  64, param = 150, type = "uint8_t", to = SMLSIZE },
      { x = 140, y =  48, min =   0, max = 128, param = 151, type = "uint8_t", to = SMLSIZE },
      { x = 140, y =  56, min =   0, max = 128, param = 185, type = "uint8_t", to = SMLSIZE },
      -- Heck
      { x = 185, y =  16, min =   0, max = 128, param = 163, type = "uint8_t", to = SMLSIZE },
      { x = 185, y =  24, min =   0, max = 128, param = 162, type = "uint8_t", to = SMLSIZE, valuetext = { [128] = "HH" } },
      
      { x = 185, y =  40, min =   1, max =  32, param = 164, type = "uint8_t", to = SMLSIZE },
   },
}