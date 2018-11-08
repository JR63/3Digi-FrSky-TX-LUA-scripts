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
   title = "Pitch Kurve",
   title_en = "Coll. pitch curve",
   topic = {
   },
   text = {
      { t = "-100",					x =   0, y =  46, to = SMLSIZE },
      { t = " -75",					x =  24, y =  46, to = SMLSIZE },
      { t = " -50",					x =  48, y =  46, to = SMLSIZE },
      { t = " -25",					x =  72, y =  46, to = SMLSIZE },
      { t = "   0",					x =  96, y =  46, to = SMLSIZE },
      { t = " +25",					x = 120, y =  46, to = SMLSIZE },
      { t = " +50",					x = 144, y =  46, to = SMLSIZE },
      { t = " +75",					x = 168, y =  46, to = SMLSIZE },
      { t = "+100",					x = 192, y =  46, to = SMLSIZE },
   },
   graph = { rect_x =  0, rect_y =  10, rect_w = 212, rect_h =  32, y_max = 100 },
   value_set = 9,
   param_check = 61101,
   fields = {
      -- Kurve
      { x =   3, y =  56, min =   0, max = 100, param = 227, index = 0, type = "uint8_t", to = SMLSIZE},
      { x =  27, y =  56, min =   0, max = 100, param = 227, index = 1, type = "uint8_t", to = SMLSIZE},
      { x =  51, y =  56, min =   0, max = 100, param = 227, index = 2, type = "uint8_t", to = SMLSIZE},
      { x =  75, y =  56, min =   0, max = 100, param = 227, index = 3, type = "uint8_t", to = SMLSIZE},
      { x =  99, y =  56, min =   0, max = 100, param = 227, index = 4, type = "uint8_t", to = SMLSIZE},
      { x = 123, y =  56, min =   0, max = 100, param = 227, index = 5, type = "uint8_t", to = SMLSIZE},
      { x = 147, y =  56, min =   0, max = 100, param = 227, index = 6, type = "uint8_t", to = SMLSIZE},
      { x = 171, y =  56, min =   0, max = 100, param = 227, index = 7, type = "uint8_t", to = SMLSIZE},
      { x = 195, y =  56, min =   0, max = 100, param = 227, index = 8, type = "uint8_t", to = SMLSIZE},
   },
}