-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/13
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

TD_RX_SENSOR_ID				= 0x0D
TD_TX_SENSOR_ID				= 0x1B


REQUEST_FRAME_ID_GET_VERSION		= 0x10
REQUEST_FRAME_ID_GET_VALUE_SET		= 0x11
REQUEST_FRAME_ID_SET_VALUE		= 0x12
REQUEST_FRAME_ID_SAVE_PARAMETER		= 0x13

REPLY_FRAME_ID				= 0x32


SPECIAL_VERSION				= 1
SPECIAL_SERIAL_PART_1			= 2
SPECIAL_SERIAL_PART_2			= 3
SPECIAL_SERIAL_PART_3			= 4
SPECIAL_SAVE_RESPONSE			= 5


--> simulator
local simulator = -1
local sim_paramset_1 = {}
local sim_paramset_2 = {}
local sim_paramset_3 = {}
local sendQueue = {}
local packet_cnt = 0
local wait = 0
local setValueSet = 0

TDInitSimValues = function()
        sim_paramset_1[202] =  49
        sim_paramset_1[214] =   0
        sim_paramset_1[215] =  80
        sim_paramset_1[216] =  95
        sim_paramset_1[217] =  85
    
        sim_paramset_1[132] = 100
        sim_paramset_1[133] =  60
        sim_paramset_1[131] =  85
        sim_paramset_1[128] =  30
        sim_paramset_1[129] =  45
        sim_paramset_1[130] =  10
        sim_paramset_1[144] = 100
        sim_paramset_1[145] =  60
        sim_paramset_1[143] =  85
        sim_paramset_1[140] =  30
        sim_paramset_1[141] =  45
        sim_paramset_1[142] =  10
        sim_paramset_1[156] = 100
        sim_paramset_1[157] =  60
        sim_paramset_1[155] =  85
        sim_paramset_1[152] =  30
        sim_paramset_1[153] =  45
        sim_paramset_1[154] =  10
	
        sim_paramset_1[137] =  80
        sim_paramset_1[134] = 128
        sim_paramset_1[135] =   1
        sim_paramset_1[138] =  10
        sim_paramset_1[149] =  80
        sim_paramset_1[146] = 128
        sim_paramset_1[147] =   1
        sim_paramset_1[150] =  40
        sim_paramset_1[151] =  20
        sim_paramset_1[185] =   0
        sim_paramset_1[163] =  64
        sim_paramset_1[162] = 128
        sim_paramset_1[164] =  30
	
        sim_paramset_1[136 + 0x0000] = 110
        sim_paramset_1[136 + 0x0100] = 110
        sim_paramset_1[136 + 0x0200] = 110
        sim_paramset_1[136 + 0x0300] = 110
        sim_paramset_1[136 + 0x0400] = 110
        sim_paramset_1[136 + 0x0500] = 128
        sim_paramset_1[136 + 0x0600] = 128
        sim_paramset_1[136 + 0x0700] = 128
        sim_paramset_1[136 + 0x0800] = 128
	
        sim_paramset_1[148 + 0x0000] = 110
        sim_paramset_1[148 + 0x0100] = 110
        sim_paramset_1[148 + 0x0200] = 110
        sim_paramset_1[148 + 0x0300] = 110
        sim_paramset_1[148 + 0x0400] = 110
        sim_paramset_1[148 + 0x0500] = 128
        sim_paramset_1[148 + 0x0600] = 128
        sim_paramset_1[148 + 0x0700] = 128
        sim_paramset_1[148 + 0x0800] = 128
	
        sim_paramset_1[168] =   1
        sim_paramset_1[126] =   1
        sim_paramset_1[127] =  71
        sim_paramset_1[169] =   0
        sim_paramset_1[170] =  15
	
        sim_paramset_1[158] =   0
        sim_paramset_1[159] =   0
        sim_paramset_1[160] =   0
        sim_paramset_1[161] =   0
        sim_paramset_1[167] =  50
        sim_paramset_1[165] =   0
        sim_paramset_1[166] =   0
	
        sim_paramset_1[248] =   0
	
        sim_paramset_1[219] =   3
        sim_paramset_1[221] =1500
        sim_paramset_1[222] =  50
        sim_paramset_1[223] =  50
        sim_paramset_1[224] =  50
        sim_paramset_1[226] =  60
        sim_paramset_1[228] =  30
        sim_paramset_1[229] =  30
        sim_paramset_1[230] =  30
        sim_paramset_1[232] =  10
	
        sim_paramset_1[227 + 0x0000] =  60
        sim_paramset_1[227 + 0x0100] =  47
        sim_paramset_1[227 + 0x0200] =  38
        sim_paramset_1[227 + 0x0300] =  32
        sim_paramset_1[227 + 0x0400] =  30
        sim_paramset_1[227 + 0x0500] =  32
        sim_paramset_1[227 + 0x0600] =  38
        sim_paramset_1[227 + 0x0700] =  47
        sim_paramset_1[227 + 0x0800] =  60
	
        sim_paramset_1[121 + 0x0000] =   3
        sim_paramset_1[121 + 0x0100] =   3
        sim_paramset_1[121 + 0x0200] =   3
        sim_paramset_1[196] =   0
        sim_paramset_1[197] = 20000
        sim_paramset_1[198] =   0
        sim_paramset_1[199] =   0
        sim_paramset_1[200] =   0
	
        sim_paramset_1[ 43] =   0
        sim_paramset_1[ 46] = 5000
        sim_paramset_1[ 44] =   0
        sim_paramset_1[ 45] =   0
        sim_paramset_1[ 47] =   0
	
        sim_paramset_1[125 + 0x0000] =   0
        sim_paramset_1[125 + 0x0100] =   0
        sim_paramset_1[125 + 0x0200] =   0
        sim_paramset_1[123 + 0x0000] =  10
        sim_paramset_1[123 + 0x0100] =  10
        sim_paramset_1[123 + 0x0200] =   6
        sim_paramset_1[122 + 0x0000] =  10
        sim_paramset_1[122 + 0x0100] =  10
        sim_paramset_1[122 + 0x0200] =  10
    
    
        sim_paramset_2[202] =  49
        sim_paramset_2[214] =   0
        sim_paramset_2[215] =  80
        sim_paramset_2[216] =  95
        sim_paramset_2[217] =  85
	
        sim_paramset_2[132] = 100
        sim_paramset_2[133] =  45
        sim_paramset_2[131] =  85
        sim_paramset_2[128] =  30
        sim_paramset_2[129] =  45
        sim_paramset_2[130] =  10
        sim_paramset_2[144] = 100
        sim_paramset_2[145] =  45
        sim_paramset_2[143] =  85
        sim_paramset_2[140] =  30
        sim_paramset_2[141] =  45
        sim_paramset_2[142] =  10
        sim_paramset_2[156] = 100
        sim_paramset_2[157] =  45
        sim_paramset_2[155] =  85
        sim_paramset_2[152] =  30
        sim_paramset_2[153] =  45
        sim_paramset_2[154] =  10
	
        sim_paramset_2[137] =  80
        sim_paramset_2[134] = 128
        sim_paramset_2[135] =   1
        sim_paramset_2[138] =  10
        sim_paramset_2[149] =  80
        sim_paramset_2[146] = 128
        sim_paramset_2[147] =   1
        sim_paramset_2[150] =  40
        sim_paramset_2[151] =  20
        sim_paramset_2[185] =   0
        sim_paramset_2[163] =  64
        sim_paramset_2[162] = 128
        sim_paramset_2[164] =  30
	
        sim_paramset_2[136 + 0x0000] = 110
        sim_paramset_2[136 + 0x0100] = 110
        sim_paramset_2[136 + 0x0200] = 110
        sim_paramset_2[136 + 0x0300] = 110
        sim_paramset_2[136 + 0x0400] = 110
        sim_paramset_2[136 + 0x0500] = 128
        sim_paramset_2[136 + 0x0600] = 128
        sim_paramset_2[136 + 0x0700] = 128
        sim_paramset_2[136 + 0x0800] = 128
	
        sim_paramset_2[148 + 0x0000] = 110
        sim_paramset_2[148 + 0x0100] = 110
        sim_paramset_2[148 + 0x0200] = 110
        sim_paramset_2[148 + 0x0300] = 110
        sim_paramset_2[148 + 0x0400] = 110
        sim_paramset_2[148 + 0x0500] = 128
        sim_paramset_2[148 + 0x0600] = 128
        sim_paramset_2[148 + 0x0700] = 128
        sim_paramset_2[148 + 0x0800] = 128
	
        sim_paramset_2[168] =   1
        sim_paramset_2[126] =   1
        sim_paramset_2[127] =  71
        sim_paramset_2[169] =   0
        sim_paramset_2[170] =  15
	
        sim_paramset_2[158] =   0
        sim_paramset_2[159] =   0
        sim_paramset_2[160] =   0
        sim_paramset_2[161] =   0
        sim_paramset_2[167] =  50
        sim_paramset_2[165] =   0
        sim_paramset_2[166] =   0
	
        sim_paramset_2[248] =   0
	
        sim_paramset_2[219] =   3
        sim_paramset_2[221] =1500
        sim_paramset_2[222] =  50
        sim_paramset_2[223] =  50
        sim_paramset_2[224] =  50
        sim_paramset_2[226] =  60
        sim_paramset_2[228] =  30
        sim_paramset_2[229] =  30
        sim_paramset_2[230] =  30
        sim_paramset_2[232] =  10
	
        sim_paramset_2[227 + 0x0000] =  60
        sim_paramset_2[227 + 0x0100] =  47
        sim_paramset_2[227 + 0x0200] =  38
        sim_paramset_2[227 + 0x0300] =  32
        sim_paramset_2[227 + 0x0400] =  30
        sim_paramset_2[227 + 0x0500] =  32
        sim_paramset_2[227 + 0x0600] =  38
        sim_paramset_2[227 + 0x0700] =  47
        sim_paramset_2[227 + 0x0800] =  60
	
        sim_paramset_2[121 + 0x0000] =   3
        sim_paramset_2[121 + 0x0100] =   3
        sim_paramset_2[121 + 0x0200] =   3
        sim_paramset_2[196] =   0
        sim_paramset_2[197] = 15000
        sim_paramset_2[198] =   0
        sim_paramset_2[199] =   0
        sim_paramset_2[200] =   0
	
        sim_paramset_2[ 43] =   0
        sim_paramset_2[ 46] = 2500
        sim_paramset_2[ 44] =   0
        sim_paramset_2[ 45] =   0
        sim_paramset_2[ 47] =   0
	
        sim_paramset_2[125 + 0x0000] =   0
        sim_paramset_2[125 + 0x0100] =   0
        sim_paramset_2[125 + 0x0200] =   0
        sim_paramset_2[123 + 0x0000] =  10
        sim_paramset_2[123 + 0x0100] =  10
        sim_paramset_2[123 + 0x0200] =   6
        sim_paramset_2[122 + 0x0000] =  10
        sim_paramset_2[122 + 0x0100] =  10
        sim_paramset_2[122 + 0x0200] =  10
    
    
        sim_paramset_3[202] =  49
        sim_paramset_3[214] =   0
        sim_paramset_3[215] =  80
        sim_paramset_3[216] =  95
        sim_paramset_3[217] =  85
	
        sim_paramset_3[132] = 100
        sim_paramset_3[133] =  45
        sim_paramset_3[131] =  85
        sim_paramset_3[128] =  30
        sim_paramset_3[129] =  45
        sim_paramset_3[130] =  10
        sim_paramset_3[144] = 100
        sim_paramset_3[145] =  45
        sim_paramset_3[143] =  85
        sim_paramset_3[140] =  30
        sim_paramset_3[141] =  45
        sim_paramset_3[142] =  10
        sim_paramset_3[156] = 100
        sim_paramset_3[157] =  45
        sim_paramset_3[155] =  85
        sim_paramset_3[152] =  30
        sim_paramset_3[153] =  45
        sim_paramset_3[154] =  10
	
        sim_paramset_3[137] =  80
        sim_paramset_3[134] = 128
        sim_paramset_3[135] =   1
        sim_paramset_3[138] =  10
        sim_paramset_3[149] =  80
        sim_paramset_3[146] = 128
        sim_paramset_3[147] =   1
        sim_paramset_3[150] =  40
        sim_paramset_3[151] =  20
        sim_paramset_3[185] =   0
        sim_paramset_3[163] =  64
        sim_paramset_3[162] = 128
        sim_paramset_3[164] =  30
	
        sim_paramset_3[136 + 0x0000] = 110
        sim_paramset_3[136 + 0x0100] = 110
        sim_paramset_3[136 + 0x0200] = 110
        sim_paramset_3[136 + 0x0300] = 110
        sim_paramset_3[136 + 0x0400] = 110
        sim_paramset_3[136 + 0x0500] = 128
        sim_paramset_3[136 + 0x0600] = 128
        sim_paramset_3[136 + 0x0700] = 128
        sim_paramset_3[136 + 0x0800] = 128
	
        sim_paramset_3[148 + 0x0000] = 110
        sim_paramset_3[148 + 0x0100] = 110
        sim_paramset_3[148 + 0x0200] = 110
        sim_paramset_3[148 + 0x0300] = 110
        sim_paramset_3[148 + 0x0400] = 110
        sim_paramset_3[148 + 0x0500] = 128
        sim_paramset_3[148 + 0x0600] = 128
        sim_paramset_3[148 + 0x0700] = 128
        sim_paramset_3[148 + 0x0800] = 128
	
        sim_paramset_3[168] =   1
        sim_paramset_3[126] =   1
        sim_paramset_3[127] =  71
        sim_paramset_3[169] =   0
        sim_paramset_3[170] =  15
	
        sim_paramset_3[158] =   0
        sim_paramset_3[159] =   0
        sim_paramset_3[160] =   0
        sim_paramset_3[161] =   0
        sim_paramset_3[167] =  50
        sim_paramset_3[165] =   0
        sim_paramset_3[166] =   0
	
        sim_paramset_3[248] =   0
	
        sim_paramset_3[219] =   3
        sim_paramset_3[221] =1500
        sim_paramset_3[222] =  50
        sim_paramset_3[223] =  50
        sim_paramset_3[224] =  50
        sim_paramset_3[226] =  60
        sim_paramset_3[228] =  30
        sim_paramset_3[229] =  30
        sim_paramset_3[230] =  30
        sim_paramset_3[232] =  10
	
        sim_paramset_3[227 + 0x0000] =  60
        sim_paramset_3[227 + 0x0100] =  47
        sim_paramset_3[227 + 0x0200] =  38
        sim_paramset_3[227 + 0x0300] =  32
        sim_paramset_3[227 + 0x0400] =  30
        sim_paramset_3[227 + 0x0500] =  32
        sim_paramset_3[227 + 0x0600] =  38
        sim_paramset_3[227 + 0x0700] =  47
        sim_paramset_3[227 + 0x0800] =  60
	
        sim_paramset_3[121 + 0x0000] =   3
        sim_paramset_3[121 + 0x0100] =   3
        sim_paramset_3[121 + 0x0200] =   3
        sim_paramset_3[196] =   0
        sim_paramset_3[197] = 10000
        sim_paramset_3[198] =   0
        sim_paramset_3[199] =   0
        sim_paramset_3[200] =   0
	
        sim_paramset_3[ 43] =   0
        sim_paramset_3[ 46] = 1250
        sim_paramset_3[ 44] =   0
        sim_paramset_3[ 45] =   0
        sim_paramset_3[ 47] =   0
	
        sim_paramset_3[125 + 0x0000] =   0
        sim_paramset_3[125 + 0x0100] =   0
        sim_paramset_3[125 + 0x0200] =   0
        sim_paramset_3[123 + 0x0000] =  10
        sim_paramset_3[123 + 0x0100] =  10
        sim_paramset_3[123 + 0x0200] =   6
        sim_paramset_3[122 + 0x0000] =  10
        sim_paramset_3[122 + 0x0100] =  10
        sim_paramset_3[122 + 0x0200] =  10
end

TDQueue = function()
        if bit32.band(setValueSet,0x00FF) == 0 then
	    sendQueue[ 1] = 202
	    sendQueue[ 2] = 214
	    sendQueue[ 3] = 215
	    sendQueue[ 4] = 216
	    sendQueue[ 5] = 217
	    sendQueue[ 6] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 1 then
	    sendQueue[ 1] = 132
	    sendQueue[ 2] = 133
	    sendQueue[ 3] = 131
	    sendQueue[ 4] = 128
	    sendQueue[ 5] = 129
	    sendQueue[ 6] = 130
	    sendQueue[ 7] = 144
	    sendQueue[ 8] = 145
	    sendQueue[ 9] = 143
	    sendQueue[10] = 140
	    sendQueue[11] = 141
	    sendQueue[12] = 142
	    sendQueue[13] = 156
	    sendQueue[14] = 157
	    sendQueue[15] = 155
	    sendQueue[16] = 152
	    sendQueue[17] = 153
	    sendQueue[18] = 154
	    sendQueue[19] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 2 then
	    sendQueue[ 1] = 137
	    sendQueue[ 2] = 134
	    sendQueue[ 3] = 135
	    sendQueue[ 4] = 138
	    sendQueue[ 5] = 149
	    sendQueue[ 6] = 146
	    sendQueue[ 7] = 147
	    sendQueue[ 8] = 150
	    sendQueue[ 9] = 151
	    sendQueue[10] = 185
	    sendQueue[11] = 163
	    sendQueue[12] = 162
	    sendQueue[13] = 164
	    sendQueue[14] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 3 then
	    sendQueue[ 1] = 136 + 0x0000
	    sendQueue[ 2] = 136 + 0x0100
	    sendQueue[ 3] = 136 + 0x0200
	    sendQueue[ 4] = 136 + 0x0300
	    sendQueue[ 5] = 136 + 0x0400
	    sendQueue[ 6] = 136 + 0x0500
	    sendQueue[ 7] = 136 + 0x0600
	    sendQueue[ 8] = 136 + 0x0700
	    sendQueue[ 9] = 136 + 0x0800
	    sendQueue[10] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 4 then
	    sendQueue[ 1] = 148 + 0x0000
	    sendQueue[ 2] = 148 + 0x0100
	    sendQueue[ 3] = 148 + 0x0200
	    sendQueue[ 4] = 148 + 0x0300
	    sendQueue[ 5] = 148 + 0x0400
	    sendQueue[ 6] = 148 + 0x0500
	    sendQueue[ 7] = 148 + 0x0600
	    sendQueue[ 8] = 148 + 0x0700
	    sendQueue[ 9] = 148 + 0x0800
	    sendQueue[10] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 5 then
	    sendQueue[ 1] = 168
	    sendQueue[ 2] = 126
	    sendQueue[ 3] = 127
	    sendQueue[ 4] = 169
	    sendQueue[ 5] = 170
	    sendQueue[ 6] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 6 then
	    sendQueue[ 1] = 158
	    sendQueue[ 2] = 159
	    sendQueue[ 3] = 160
	    sendQueue[ 4] = 161
	    sendQueue[ 5] = 167
	    sendQueue[ 6] = 165
	    sendQueue[ 7] = 166
	    sendQueue[ 8] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 7 then
	    sendQueue[ 1] = 248
	    sendQueue[ 2] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 8 then
	    sendQueue[ 1] = 219
	    sendQueue[ 2] = 221
	    sendQueue[ 3] = 222
	    sendQueue[ 4] = 223
	    sendQueue[ 5] = 224
	    sendQueue[ 6] = 226
	    sendQueue[ 7] = 228
	    sendQueue[ 8] = 229
	    sendQueue[ 9] = 230
	    sendQueue[10] = 232
	    sendQueue[11] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 9 then
	    sendQueue[ 1] = 227 + 0x0000
	    sendQueue[ 2] = 227 + 0x0100
	    sendQueue[ 3] = 227 + 0x0200
	    sendQueue[ 4] = 227 + 0x0300
	    sendQueue[ 5] = 227 + 0x0400
	    sendQueue[ 6] = 227 + 0x0500
	    sendQueue[ 7] = 227 + 0x0600
	    sendQueue[ 8] = 227 + 0x0700
	    sendQueue[ 9] = 227 + 0x0800
	    sendQueue[10] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 10 then
	    sendQueue[ 1] = 121 + 0x0000
	    sendQueue[ 2] = 121 + 0x0100
	    sendQueue[ 3] = 121 + 0x0200
	    sendQueue[ 4] = 196
	    sendQueue[ 5] = 197
	    sendQueue[ 6] = 198
	    sendQueue[ 7] = 199
	    sendQueue[ 8] = 200
	    sendQueue[ 9] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 11 then
	    sendQueue[ 1] =  43
	    sendQueue[ 2] =  46
	    sendQueue[ 3] =  44
	    sendQueue[ 4] =  45
	    sendQueue[ 5] =  47
	    sendQueue[ 6] =  -1
        elseif bit32.band(setValueSet,0x00FF) == 12 then
	    sendQueue[ 1] = 125 + 0x0000
	    sendQueue[ 2] = 125 + 0x0100
	    sendQueue[ 3] = 125 + 0x0200
	    sendQueue[ 4] = 123 + 0x0000
	    sendQueue[ 5] = 123 + 0x0100
	    sendQueue[ 6] = 123 + 0x0200
	    sendQueue[ 7] = 122 + 0x0000
	    sendQueue[ 8] = 122 + 0x0100
	    sendQueue[ 9] = 122 + 0x0200
	    sendQueue[10] =  -1
	end
	packet_cnt = 1
end
--< simulator


protocol.TDInit = function(ValueSet)
--> simulator
    if simulator == -1 then
        local ver, radio, major, minor, rev = getVersion()
        if string.find(radio, "-simu") ~= nil then
            simulator = 1
            TDInitSimValues()
        else
            simulator = 0
        end
    end
--< simulator
end


protocol.TDGetValueSet = function(ValueSet)
--> simulator
    if simulator == 1 then
        wait = 10
	setValueSet = ValueSet
        TDQueue()
	return true
    end
--< simulator
    return sportTelemetryPush(TD_RX_SENSOR_ID, REQUEST_FRAME_ID_GET_VALUE_SET, ValueSet, 0)
end


protocol.TDSetValue = function(ValueId, Value)
--> simulator
    if simulator == 1 then
        wait = 10
        local setValueId = bit32.band(ValueId,0x0FFF)
        if bit32.band(setValueSet,0xF000) == 0x0000 then
	    sim_paramset_1[setValueId] = Value
        elseif bit32.band(setValueSet,0xF000) == 0x4000 then
	    sim_paramset_2[setValueId] = Value
        elseif bit32.band(setValueSet,0xF000) == 0x8000 then
	    sim_paramset_3[setValueId] = Value
	end
	sendQueue[ 1] = setValueId
	sendQueue[ 2] =  -1
	packet_cnt = 1
	return true
    end
--< simulator
    return sportTelemetryPush(TD_RX_SENSOR_ID, REQUEST_FRAME_ID_SET_VALUE, ValueId, Value)
end


protocol.TDSaveParameter = function()
--> simulator
    if simulator == 1 then
        wait = 10
        -- queue ok response
        sim_paramset_1[SPECIAL_SAVE_RESPONSE] = 1
        sim_paramset_2[SPECIAL_SAVE_RESPONSE] = 1
        sim_paramset_3[SPECIAL_SAVE_RESPONSE] = 1
	sendQueue[ 1] = SPECIAL_SAVE_RESPONSE
	sendQueue[ 2] =  -1
	packet_cnt = 1
	return true
    end
--< simulator
    return sportTelemetryPush(TD_RX_SENSOR_ID, REQUEST_FRAME_ID_SAVE_PARAMETER, 0, 0)
end


protocol.TDGetVersion = function()
--> simulator
    if simulator == 1 then
        wait = 10
        -- queue 2.0.0 response
        sim_paramset_1[SPECIAL_VERSION] = 2
        sim_paramset_2[SPECIAL_VERSION] = 2
        sim_paramset_3[SPECIAL_VERSION] = 2
	sendQueue[ 1] = SPECIAL_VERSION
	sendQueue[ 2] =  -1
	packet_cnt = 1
	return true
    end
--< simulator
    return sportTelemetryPush(TD_RX_SENSOR_ID, REQUEST_FRAME_ID_GET_VERSION, 0, 0)
end


protocol.TDPollValue = function()
--> simulator
    if simulator == 1 then
        if wait > 0 then
	    wait = wait - 1
	    return 0, 0
	end
	
	if sendQueue[packet_cnt] ~= -1 then
	    local appId = sendQueue[packet_cnt]
	    packet_cnt = packet_cnt + 1
	    
            if bit32.band(setValueSet,0xF000) == 0x0000 then
	        value = sim_paramset_1[appId]
            elseif bit32.band(setValueSet,0xF000) == 0x4000 then
	        value = sim_paramset_2[appId]
            elseif bit32.band(setValueSet,0xF000) == 0x8000 then
	        value = sim_paramset_3[appId]
	    end
            return appId, value
	end
	return 0, 0
    end
--< simulator
    local sensorId, frameId, appId, value = sportTelemetryPop()
    if sensorId == TD_TX_SENSOR_ID and frameId == REPLY_FRAME_ID then
	return appId, value
    end
    return 0, 0
end
