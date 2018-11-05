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
      { t = "Roll",					x =  55, y =   8, to = SMLSIZE },
      { t = "Nick",					x =  80, y =   8, to = SMLSIZE },
      { t = "Heck",					x = 105, y =   8, to = SMLSIZE },
      
      { t = "IBereich",					x =   3, y =  16, to = SMLSIZE },
      { t = "IVerlauf",					x =   3, y =  24, to = SMLSIZE },
      { t = "IVerlMod.",				x =   3, y =  32, to = SMLSIZE },
      { t = "DVorhzei.",				x =   3, y =  40, to = SMLSIZE },
      { t = "A.K. Stat.",				x =   3, y =  48, to = SMLSIZE },
      { t = "A.K. Dyna.",				x =   3, y =  56, to = SMLSIZE },
   },
   value_set = 2,
   param_check = 48462,
   fields = {
      -- Roll
      { x =  55, y =  16, min =   0, max = 128, param = 137, type = "uint8_t", to = SMLSIZE },
      { x =  55, y =  24, min =   0, max = 128, param = 134, type = "uint8_t", to = SMLSIZE, valuetext = { [128] = "HH" } },
      { x =  55, y =  32, min =   0, max =   1, param = 135, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Einf", "Erwe" } },
      { x =  55, y =  40, min =   1, max =  64, param = 138, type = "uint8_t", to = SMLSIZE },
      -- Nick
      { x =  80, y =  16, min =   0, max = 128, param = 149, type = "uint8_t", to = SMLSIZE },
      { x =  80, y =  24, min =   0, max = 128, param = 146, type = "uint8_t", to = SMLSIZE, valuetext = { [128] = "HH" } },
      { x =  80, y =  32, min =   0, max =   1, param = 147, type = "bool",    to = SMLSIZE, valuetext = { [0] = "Einf", "Erwe" } },
      { x =  80, y =  40, min =   1, max =  64, param = 150, type = "uint8_t", to = SMLSIZE },
      { x =  80, y =  48, min =   0, max = 128, param = 151, type = "uint8_t", to = SMLSIZE },
      { x =  80, y =  56, min =   0, max = 128, param = 185, type = "uint8_t", to = SMLSIZE },
      -- Heck
      { x = 105, y =  16, min =   0, max = 128, param = 163, type = "uint8_t", to = SMLSIZE },
      { x = 105, y =  24, min =   0, max = 128, param = 162, type = "uint8_t", to = SMLSIZE, valuetext = { [128] = "HH" } },
      
      { x = 105, y =  40, min =   1, max =  32, param = 164, type = "uint8_t", to = SMLSIZE },
   },
}