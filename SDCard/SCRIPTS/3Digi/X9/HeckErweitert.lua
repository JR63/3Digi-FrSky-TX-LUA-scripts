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
   title = "Heck erweitert",
   title_en = "Tail extended",
   topic = {
      { t = "Extra Empfindlichkeit",			x =  10, y =  12 },
      { t = "Drehmomentausgleich",			x =  10, y =  40 },
   },
   topic_en = {
      { t = "Extra gains",				x =  10, y =  12 },
      { t = "Torque compensation",			x =  10, y =  40 },
   },
   text = {
      { t = "Links",					x =   6, y =  21, to = SMLSIZE },
      { t = "Rechts",					x =  76, y =  21, to = SMLSIZE },
      { t = "Start",					x =   6, y =  29, to = SMLSIZE },
      { t = "Stopp",					x =  76, y =  29, to = SMLSIZE },
      { t = "Von Pitch",				x =   6, y =  49, to = SMLSIZE },
      { t = "Von Roll",					x =  76, y =  49, to = SMLSIZE },
      { t = "Von Nick",					x = 146, y =  49, to = SMLSIZE },
   },
   text_en = {
      { t = "Left",					x =   6, y =  21, to = SMLSIZE },
      { t = "Right",					x =  76, y =  21, to = SMLSIZE },
      { t = "Start",					x =   6, y =  29, to = SMLSIZE },
      { t = "Stop",					x =  76, y =  29, to = SMLSIZE },
      { t = "F. c. pit.",				x =   6, y =  49, to = SMLSIZE },
      { t = "F. aile.",					x =  76, y =  49, to = SMLSIZE },
      { t = "F. elev.",					x = 146, y =  49, to = SMLSIZE },
   },
   value_set = 6,
   param_check = 31765,
   fields = {
      -- Extra Empfindlichkeit Links
      { x =  52, y =  21, min = -16, max =  16, param = 158, type = "int8_t",  to = SMLSIZE },
      -- Extra Empfindlichkeit Rechts
      { x = 122, y =  21, min = -16, max =  16, param = 159, type = "int8_t",  to = SMLSIZE },
      -- Extra Empfindlichkeit Start
      { x =  52, y =  29, min = -16, max =  16, param = 160, type = "int8_t",  to = SMLSIZE },
      -- Extra Empfindlichkeit Stopp
      { x = 122, y =  29, min = -16, max =  16, param = 161, type = "int8_t",  to = SMLSIZE },
      -- Drehmomentausgleich Von Pitch
      { x =  52, y =  49, min =   0, max = 125, param = 167, type = "uint8_t", to = SMLSIZE },
      -- Drehmomentausgleich Von Roll
      { x = 122, y =  49, min =   0, max = 125, param = 165, type = "uint8_t", to = SMLSIZE },
      -- Drehmomentausgleich Von Nick
      { x = 192, y =  49, min =   0, max = 125, param = 166, type = "uint8_t", to = SMLSIZE },
   },
}