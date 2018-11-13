-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/13
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

-- Do not change the fields values without deep knowledge.
-- Wrong values result in wrong mapping and may cause unpredictable FBL behaviour.

return {
   title = "Information",
   title_en = "Information",
   topic = {
   },
   text = {
      { t = "Seriennummer",				x =   3, y =   8, to = SMLSIZE },
      { t = "Ver. Hardware",				x =   3, y =  16, to = SMLSIZE },
      { t = "Ver. Firmware",				x =   3, y =  24, to = SMLSIZE },
      { t = "Akt. Flugnummer",				x =   3, y =  32, to = SMLSIZE },
      { t = "Letzte Meldung",				x =   3, y =  40, to = SMLSIZE },
      { t = "bei Flugnummer",				x =   3, y =  48, to = SMLSIZE },
      { t = "zum Zeitpunkt",				x =   3, y =  56, to = SMLSIZE },
   },
   text_en = {
      { t = "Serial number",				x =   3, y =   8, to = SMLSIZE },
      { t = "Ver. hardware",				x =   3, y =  16, to = SMLSIZE },
      { t = "Ver. firmware",				x =   3, y =  24, to = SMLSIZE },
      { t = "Curr. flight num.",			x =   3, y =  32, to = SMLSIZE },
      { t = "Last message",				x =   3, y =  40, to = SMLSIZE },
      { t = "at flight",				x =   3, y =  48, to = SMLSIZE },
      { t = "at time",					x =   3, y =  56, to = SMLSIZE },
   },
   value_set = 0,
   param_check = 28904,
   fields = {
      -- Seriennummer
      { x =  80, y =   8, min =   0, max =   0, param =  -1, type = "serial",   ro = 1, to = SMLSIZE },
      -- Version Hardware
      { x =  80, y =  16, min =   0, max =   0, param = 202, type = "nibble",   ro = 1, to = SMLSIZE },
      -- Version Firmware
      { x =  80, y =  24, min =   0, max =   0, param =  -1, type = "v_firm",   ro = 1, to = SMLSIZE },
      -- Aktuelle Flugnmmer
      { x =  80, y =  32, min =   0, max =   0, param = 217, type = "uint16_t", ro = 1, to = SMLSIZE },
      -- Letzte Meldung
      { x =  80, y =  40, min =   0, max =   0, param = 214, type = "text",     ro = 1, to = SMLSIZE },
      -- bei Flugnummer
      { x =  80, y =  48, min =   0, max =   0, param = 215, type = "uint16_t", ro = 1, to = SMLSIZE },
      -- zum Zeitpunkt
      { x =  80, y =  56, min =   0, max =   0, param = 216, type = "uint16_t", ro = 1, to = SMLSIZE },
   },
}