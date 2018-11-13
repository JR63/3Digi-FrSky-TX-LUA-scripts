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
      { t = "Geraete-Info",				x =  10, y =  40 },
      { t = "Flug-Info",				x =  10, y = 140 },
   },
   topic_en = {
      { t = "Device info",				x =  10, y =  40 },
      { t = "Flight info",				x =  10, y = 140 },
   },
   text = {
      { t = "Seriennummer",				x =  20, y =  65 },
      { t = "Version Hardware",				x =  20, y =  90 },
      { t = "Version Firmware",				x =  20, y = 115 },
      { t = "Aktuelle Flugnummer",			x =  20, y = 165 },
      { t = "Letzte Meldung",				x =  20, y = 190 },
      { t = "bei Flugnummer",				x =  20, y = 215 },
      { t = "zum Zeitpunkt",				x =  20, y = 240 },
   },
   text_en = {
      { t = "Serial number",				x =  20, y =  65 },
      { t = "Version hardware",				x =  20, y =  90 },
      { t = "Version firmware",				x =  20, y = 115 },
      { t = "Current flight number",			x =  20, y = 165 },
      { t = "Last message",				x =  20, y = 190 },
      { t = "at flight",				x =  20, y = 215 },
      { t = "at time",					x =  20, y = 240 },
   },
   value_set = 0,
   param_check = 28904,
   fields = {
      -- Seriennummer
      { x = 210, y =  65, min =   0, max =   0, param =  -1, type = "serial",   ro = 1, to = SMLSIZE },
      -- Version Hardware
      { x = 210, y =  90, min =   0, max =   0, param = 202, type = "nibble",   ro = 1 },
      -- Version Firmware
      { x = 210, y = 115, min =   0, max =   0, param =  -1, type = "v_firm",   ro = 1 },
      -- Aktuelle Flugnummer
      { x = 210, y = 165, min =   0, max =   0, param = 217, type = "uint16_t", ro = 1 },
      -- Letzte Meldung
      { x = 210, y = 190, min =   0, max =   0, param = 214, type = "text",     ro = 1 },
      -- bei Flugnummer
      { x = 210, y = 215, min =   0, max =   0, param = 215, type = "uint16_t", ro = 1 },
      -- zum Zeitpunkt
      { x = 210, y = 240, min =   0, max =   0, param = 216, type = "uint16_t", ro = 1 },
   },
}