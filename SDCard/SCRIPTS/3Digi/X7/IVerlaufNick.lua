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
   title = "IVerlauf Nick",
   topic = {
   },
   text = {
      --{ t = "-100",					x =   0, y =   0, to = SMLSIZE },
      --{ t = " -75",					x =   0, y =   0, to = SMLSIZE },
      --{ t = " -50",					x =   0, y =   0, to = SMLSIZE },
      --{ t = " -25",					x =   0, y =   0, to = SMLSIZE },
      --{ t = "   0",					x =   0, y =   0, to = SMLSIZE },
      --{ t = " +25",					x =   0, y =   0, to = SMLSIZE },
      --{ t = " +50",					x =   0, y =   0, to = SMLSIZE },
      --{ t = " +75",					x =   0, y =   0, to = SMLSIZE },
      --{ t = "+100",					x =   0, y =   0, to = SMLSIZE },
   },
   graph = { rect_x =  0, rect_y =  10, rect_w = 128, rect_h =  32, y_max = 128 },
   value_set = 4,
   param_check = 41904,
   fields = {
      -- Nick
      { x =   1, y =  48, min =   0, max = 128, param = 148, index = 0, type = "uint8_t", valuetext = { [128] = "HH" }, to = SMLSIZE},
      { x =  15, y =  56, min =   0, max = 128, param = 148, index = 1, type = "uint8_t", valuetext = { [128] = "HH" }, to = SMLSIZE},
      { x =  29, y =  48, min =   0, max = 128, param = 148, index = 2, type = "uint8_t", valuetext = { [128] = "HH" }, to = SMLSIZE},
      { x =  43, y =  56, min =   0, max = 128, param = 148, index = 3, type = "uint8_t", valuetext = { [128] = "HH" }, to = SMLSIZE},
      { x =  57, y =  48, min =   0, max = 128, param = 148, index = 4, type = "uint8_t", valuetext = { [128] = "HH" }, to = SMLSIZE},
      { x =  71, y =  56, min =   0, max = 128, param = 148, index = 5, type = "uint8_t", valuetext = { [128] = "HH" }, to = SMLSIZE},
      { x =  85, y =  48, min =   0, max = 128, param = 148, index = 6, type = "uint8_t", valuetext = { [128] = "HH" }, to = SMLSIZE},
      { x =  99, y =  56, min =   0, max = 128, param = 148, index = 7, type = "uint8_t", valuetext = { [128] = "HH" }, to = SMLSIZE},
      { x = 113, y =  48, min =   0, max = 128, param = 148, index = 8, type = "uint8_t", valuetext = { [128] = "HH" }, to = SMLSIZE},
   },
}