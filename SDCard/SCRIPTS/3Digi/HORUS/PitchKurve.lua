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
      { t = "Drehzahlregelung Pitch Kurve",		x =  10, y =  45 },
   },
   topic_en = {
      { t = "Governor collective pitch curve",		x =  10, y =  45 },
   },
   text = {
      { t = "-100",					x =  20, y = 215 },
      { t = " -75",					x =  70, y = 215 },
      { t = " -50",					x = 120, y = 215 },
      { t = " -25",					x = 170, y = 215 },
      { t = "   0",					x = 220, y = 215 },
      { t = " +25",					x = 270, y = 215 },
      { t = " +50",					x = 320, y = 215 },
      { t = " +75",					x = 370, y = 215 },
      { t = "+100",					x = 420, y = 215 },
   },
   graph = { rect_x = 20, rect_y =  94, rect_w = 440, rect_h = 100, y_max = 100 },
   value_set = 9,
   param_check = 61101,
   fields = {
      -- Kurve
      { x =  25, y = 240, min =   0, max = 100, param = 227, index = 0, type = "uint8_t" },
      { x =  75, y = 240, min =   0, max = 100, param = 227, index = 1, type = "uint8_t" },
      { x = 125, y = 240, min =   0, max = 100, param = 227, index = 2, type = "uint8_t" },
      { x = 175, y = 240, min =   0, max = 100, param = 227, index = 3, type = "uint8_t" },
      { x = 225, y = 240, min =   0, max = 100, param = 227, index = 4, type = "uint8_t" },
      { x = 275, y = 240, min =   0, max = 100, param = 227, index = 5, type = "uint8_t" },
      { x = 325, y = 240, min =   0, max = 100, param = 227, index = 6, type = "uint8_t" },
      { x = 375, y = 240, min =   0, max = 100, param = 227, index = 7, type = "uint8_t" },
      { x = 425, y = 240, min =   0, max = 100, param = 227, index = 8, type = "uint8_t" },
   },
}