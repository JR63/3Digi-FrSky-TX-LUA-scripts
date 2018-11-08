-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/08
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

--
-- TODOs
--
--	Allgemein 1:	Qualitaet
--	Allgemein 2:	Qualitaet
--
--	evtl. Seiten mit Graphen nur einblenden, wenn nötig
--
--	evtl. key events optimieren
--


local userEvent = assert(loadScript(SCRIPT_HOME.."/events.lua"))()

local comStates =
{
    init		= 1,
    versionCheck	= 2,
    versionOk		= 3,
}

local pageStates =
{
    display     = 2,
    editing     = 3,
    saving      = 4,
    displayMenu = 5,
}

local comState = comStates.init
local comTS = 0
local version = ""
local Page = nil
local pageState = pageStates.display
local bitmasked = {}
local paramCheck = 0
local paramset = 1
local currentPage = 1
local currentLine = 1
local saveTS = 0
local saveTimeout = 0
local saveRetries = 0
local saveMaxRetries = 0
local menuActive = false
local lastRunTS = 0
local killEnterBreak = 0
local backgroundFill = backgroundFill or ERASE
local foregroundColor = foregroundColor or SOLID
local globalTextOptions = globalTextOptions or 0
local debugStr = ""


local function clearPageData()
    Page = nil
    paramCheck = 0
    pageState = pageStates.display
    saveTS = 0
    Page = assert(loadScript(radio.templateHome .. PageFiles[currentPage]))()
    Page.graph_values = {}
    if comState == comStates.versionOk then
        protocol.TDGetValueSet(Page.value_set + (paramset - 1) * 0x4000)
    end
end


local function handleSpecial(appId, value)
    -- TODO appId = bit32.band(appId,0x00FF)
    -- version response
    if appId == SPECIAL_VERSION then
	version = "V"
	version = version..bit32.rshift(bit32.band(value,0x000000FF),  0).."."
	version = version..bit32.rshift(bit32.band(value,0x0000FF00),  8).."."
	version = version..bit32.rshift(bit32.band(value,0x00FF0000), 16)
	if version == "V2.0.0" then
	    comState = comStates.versionOk
	end
	clearPageData()
    end
    -- save response
    if appId == SPECIAL_SAVE_RESPONSE then
        if value == 1 then
	    saveRetries = 100
	end
    end
end


local function handleSigned(f, value)
    if f.type == "int8_t" and value > 0x80 then
        value = value - 0x100
    elseif f.type == "int32_t" and value > 0x80000000 then
        value = value - 0x100000000
    end
    return value
end


local function handleBitmask(f, value, action)
    if f.bitmask ~= nil then
        if action == 0 then				-- set from 3Digi
	    bitmasked[f.param] = value
	    value = bit32.band(value, f.bitmask)
	    if value > 0 then
	        value = 1
	    end
	else						-- set from LUA
	    if value == 1 then
	        bitmasked[f.param] = bit32.bor(bitmasked[f.param], f.bitmask)
	    else
	        bitmasked[f.param] = bit32.band(bitmasked[f.param], bit32.bnot(f.bitmask))
	    end
	    value = bitmasked[f.param]
	end
    end
    return value
end


local function setValue()
    local f = Page.fields[currentLine]
    local param
    if f.index ~= nil then
	param = f.param + (paramset - 1) * 0x4000 + bit32.lshift(f.index, 8)
    else
        param = f.param + (paramset - 1) * 0x4000
    end
    local value = handleBitmask(f, f.value, 1)
    repeat
        ok = protocol.TDSetValue(param, value)
    until (ok)
    f.value = "SET"
end


local function pollValues()
    local cnt = 0
    local cnt_max = 9
    local appId, value = protocol.TDPollValue()
    while appId ~= 0 and cnt < cnt_max do
        cnt = cnt + 1
	handleSpecial(appId, value)
	if comState == comStates.versionOk and Page ~= nil then
            for i=1,#(Page.fields) do
	        local f = Page.fields[i]
	        local match = 0
	        if f.index ~= nil then
                    if f.param == bit32.band(appId,0x00FF) and f.index == bit32.rshift(bit32.band(appId,0x0F00), 8) then
	                match = 1
		    end
	        else
	            if f.param == bit32.band(appId,0x00FF) then
	                match = 1
                    end
	        end
	        if match == 1 then
		    if f.value == nil then
			if f.index ~= nil then
			    paramCheck = paramCheck + (32-i) * (bit32.band(appId,0x00FF)+i*f.index)
			elseif f.bitmask ~= nil then
			    paramCheck = paramCheck + (32-i) * (bit32.band(appId,0x00FF)+i*f.bitmask)
			else
			    paramCheck = paramCheck + (32-i) * bit32.band(appId,0x00FF)
			end
		    end
		    local calculated = value
		    calculated = handleSigned(f, calculated)
		    calculated = handleBitmask(f, calculated, 0)
		    if Page.graph ~= nil then
		        Page.graph_values[f.index+1] = calculated
		    end
		    f.value = calculated
	        end
            end
        end
	if cnt < cnt_max then
            appId, value = protocol.TDPollValue()
	end
    end
end


local function setparamset1()
    paramset = 1
    clearPageData()
end


local function setparamset2()
    paramset = 2
    clearPageData()
end


local function setparamset3()
    paramset = 3
    clearPageData()
end


local function saveSettings()
    if comState == comStates.versionOk and paramCheck == Page.param_check then
        protocol.TDSaveParameter()
        saveTS = getTime()
        if pageState == pageStates.saving then
            saveRetries = saveRetries + 1
        else
            pageState = pageStates.saving
            saveRetries = 0
            saveMaxRetries = protocol.saveMaxRetries or 2
            saveTimeout = protocol.saveTimeout or 150
        end
    else
	pageState = pageStates.saving
	saveMaxRetries = protocol.saveMaxRetries or 2
	saveTimeout = protocol.saveTimeout or 150
	saveRetries = saveMaxRetries + 1
        saveTS = getTime()
    end
end


local menuList = {
    {
        i = 1,
        f = setparamset1
    },
    {
        i = 2,
        f = setparamset2
    },
    {
        i = 3,
        f = setparamset3
    },
    {
        i = 4,
        f = nil
    },
    {
        i = 5,
        f = saveSettings
    },
}


local function incMax(val, inc, base)
   return ((val + inc + base - 1) % base) + 1
end


local function incPage(inc)
   currentPage = incMax(currentPage, inc, #(PageFiles))
   currentLine = 1
   clearPageData()
   collectgarbage()
end


local function incLine(inc)
   if Page ~= nil then
      currentLine = incMax(currentLine, inc, #(Page.fields))
      if Page.fields[currentLine].type == "bar" then
          currentLine = incMax(currentLine, inc, #(Page.fields))
      end
   end
end


local function incMenu(inc)
   menuActive = incMax(menuActive, inc, #(menuList))
   if MenuText[menuList[menuActive].i+1] == "" then
      menuActive = incMax(menuActive, inc, #(menuList))
   end
end


local function drawScreenTitle(screen_title)
    if radio.resolution == lcdResolution.low or radio.resolution == lcdResolution.medium then
        lcd.drawFilledRectangle(0, 0, LCD_W,  7)
        lcd.drawText(1, 0, screen_title, SMLSIZE+INVERS)
    else
        lcd.drawFilledRectangle(0, 0, LCD_W, 30, TITLE_BGCOLOR)
        lcd.drawText(5, 5, screen_title, MENU_TITLE_COLOR)
    end
end


local function drawTopic(y, topic)
    if radio.resolution == lcdResolution.low or radio.resolution == lcdResolution.medium then
        lcd.drawFilledRectangle(3, y, LCD_W - 6, 8)
        lcd.drawText(6, y+1, topic, SMLSIZE+INVERS)
    else
        lcd.drawFilledRectangle(10, y, LCD_W - 20, 20, TITLE_BGCOLOR)
        lcd.drawText(15, y,  topic, MENU_TITLE_COLOR)
    end
end


local function drawBar(x, y, w, h, v)
    -- 20000 -> 100%
    local v = v / 200
    lcd.drawRectangle(x, y, w,  h)
    lcd.drawFilledRectangle(x+2, y+2, (w-4)*v/100, h-4)
end


local function drawGraph()
    lcd.drawRectangle(Page.graph.rect_x, Page.graph.rect_y - 1, Page.graph.rect_w, Page.graph.rect_h + 3, foregroundColor)
    local steps = #(Page.fields)
    if Page.graph_values[steps] ~= nil and paramCheck == Page.param_check then
        local x = Page.graph.rect_x
        local y = Page.graph.rect_y + Page.graph.rect_h
        local x_delta = Page.graph.rect_w / (steps-1)
	local y_v
	local y_vp
        local ver, radio, major, minor, rev = getVersion()
	-- HORUS X10 lcd.drawLine error:
	-- https://github.com/opentx/opentx/issues/5764
	-- fixed since OpenTx 2.2.2
	local x10Fix
	if radio == "x10" and major <= 2 and minor <= 2 and rev <= 1 then
	    x10Fix = 1
	else
	    x10Fix = 0
	end
        for i=1,(steps-1) do
	    y_v  = Page.graph_values[i]   * Page.graph.rect_h / Page.graph.y_max
	    y_vp = Page.graph_values[i+1] * Page.graph.rect_h / Page.graph.y_max
	    if x10Fix == 1 then
	        if Page.graph_values[i] == Page.graph_values[i+1] then
                    lcd.drawLine(x, y - y_v, x + x_delta - 1, y - y_vp, SOLID, foregroundColor)
	        else
                    lcd.drawLine(LCD_W-1-x, LCD_H-1-(y - y_v), LCD_W-1-(x + x_delta - 1), LCD_H-1-(y - y_vp), SOLID, foregroundColor)
	        end
	    else
                lcd.drawLine(x, y - y_v, x + x_delta - 1, y - y_vp, SOLID, foregroundColor)
	    end
	    x = x + x_delta
        end
    end
end


local function drawScreen()
    local t
    if language == "en" and Page.title_en then
        drawScreenTitle(TitleText_en.pre..paramset..TitleText_en.div..Page.title_en)
    else
        drawScreenTitle(TitleText.pre..paramset..TitleText.div..Page.title)
    end
    for i=1,#(Page.topic) do
        if language == "en" and Page.topic_en then
            t = Page.topic_en[i]
	else
            t = Page.topic[i]
	end
        drawTopic(t.y, t.t)
    end
    for i=1,#(Page.text) do
        if language == "en" and Page.text_en then
            t = Page.text_en[i]
	else
            t = Page.text[i]
	end
        local textOptions = (t.to or 0) + globalTextOptions
        lcd.drawText(t.x, t.y, t.t, textOptions)
    end
    for i=1,#(Page.fields) do
        local f = Page.fields[i]
        local text_options = (f.to or 0) + globalTextOptions
        local value_options = text_options
        if i == currentLine then
            value_options = text_options + INVERS
            if pageState == pageStates.editing then
                value_options = value_options + BLINK
            end
        end
        local val = "---"
        if f.value and paramCheck == Page.param_check then
            val = f.value
            if (f.valuetext_en and f.valuetext_en[f.value]) or (f.valuetext and f.valuetext[f.value]) then
                if language == "en" and f.valuetext_en and f.valuetext_en[f.value] then
                    val = f.valuetext_en[f.value]
	        else
                    val = f.valuetext[f.value]
	        end
            end
        end
	if f.type == "bar" and val ~= "---" then
	    drawBar(f.x, f.y, Page.bar.rect_w, Page.bar.rect_h, val)
	else
            lcd.drawText(f.x, f.y, val, value_options)
	end
    end
    if Page.graph ~= nil then
        drawGraph()
    end
end


local function clipValue(val,min,max)
    if val < min then
        val = min
    elseif val > max then
        val = max
    end
    return val
end


local function getCurrentField()
    return Page.fields[currentLine]
end


local function incValue(inc)
    local f = Page.fields[currentLine]
    f.value = clipValue(f.value + inc, f.min, f.max)
    if Page.graph ~= nil then
        Page.graph_values[f.index+1] = f.value
        drawGraph()
    end
end


local function drawMenu()
    local x = MenuBox.x
    local y = MenuBox.y
    local w = MenuBox.w
    local h_line = MenuBox.h_line
    local y_offset = MenuBox.y_offset
    local h = #(menuList) * h_line + y_offset*2
    local lang_text
    
    lcd.drawFilledRectangle(x,y,w,h,backgroundFill)
    lcd.drawRectangle(x,y,w-1,h-1,foregroundColor)
    if language == "en" and  MenuText_en then
        lcd.drawText(x+h_line/2,y+y_offset,MenuText_en[1],globalTextOptions)
    else
        lcd.drawText(x+h_line/2,y+y_offset,MenuText[1],   globalTextOptions)
    end

    for i,e in ipairs(menuList) do
        local text_options = globalTextOptions
        if menuActive == i then
            text_options = text_options + INVERS
        end
	if language == "en" and  MenuText_en then
	    lang_text = MenuText_en[e.i+1]
	else
	    lang_text = MenuText[e.i+1]
	end
	if lang_text ~= "" then
            lcd.drawText(x+MenuBox.x_offset,y+(i-1)*h_line+y_offset,lang_text,text_options)
	end
    end
end


function run_ui(event)
    local now = getTime()
    
    if (comState == comStates.init) then
        protocol.TDInit()
        comState = comStates.versionCheck
        comTS = getTime()
	version = "V-.-.-"
    end
    
    if (comState == comStates.versionCheck) then
        if (comTS + 50 < now) then
	    comTS = now
            protocol.TDGetVersion()
        end
    end
    
    -- if lastRunTS older than 500ms
    if lastRunTS + 50 < now then
        clearPageData()
    end
    lastRunTS = now
    
    if (pageState == pageStates.saving) then
        if (saveTS + saveTimeout < now) then
            if saveRetries < saveMaxRetries+1 then
                saveSettings()
            elseif saveRetries == saveMaxRetries+1 then
	        saveRetries = saveRetries + 1
	    elseif saveRetries == 100 then
	        saveRetries = saveRetries + 1
	    else
                pageState = pageStates.display
                clearPageData()
                if comState ~= comStates.versionCheck then
                    comState = comStates.versionCheck
                    comTS = getTime()
	            version = "V-.-.-"
                end
            end
        end
    end
    
    -- navigation
    if (event == userEvent.longPress.menu) then -- Taranis QX7 / X9
        menuActive = paramset
	if comState == comStates.versionOk and pageState == pageStates.display then
	    pageState = pageStates.displayMenu
	end
    elseif userEvent.press.pageDown and (event == userEvent.longPress.enter) then -- Horus
        menuActive = paramset
        killEnterBreak = 1
	if comState == comStates.versionOk and pageState == pageStates.display then
	    pageState = pageStates.displayMenu
	end
    -- menu is currently displayed
    elseif pageState == pageStates.displayMenu then
        if event == userEvent.release.exit then
            pageState = pageStates.display
        elseif event == userEvent.release.plus or event == userEvent.dial.left then
            incMenu(-1)
        elseif event == userEvent.release.minus or event == userEvent.dial.right then
            incMenu(1)
        elseif event == userEvent.release.enter then
            if killEnterBreak == 1 then
                killEnterBreak = 0
            else
                pageState = pageStates.display
		if menuList[menuActive].f ~= nil then
		    menuList[menuActive].f()
		end
            end
        end
    -- normal page viewing
    elseif pageState <= pageStates.display then
        if event == userEvent.press.pageUp then
            incPage(-1)
        elseif event == userEvent.release.menu or event == userEvent.press.pageDown then
            incPage(1)
        elseif event == userEvent.release.plus or event == userEvent.dial.left then
            incLine(-1)
        elseif event == userEvent.release.minus or event == userEvent.dial.right then
            incLine(1)
        elseif event == userEvent.release.enter then
            if comState == comStates.versionOk and Page ~= nil then
	        local f = Page.fields[currentLine]
                if paramCheck == Page.param_check and f.value ~= nil and f.type ~= "bar" then
                    pageState = pageStates.editing
                end
            end
        elseif event == userEvent.release.exit then
            return protocol.exitFunc()
        end
    -- editing value
    elseif pageState == pageStates.editing then
        if (event == userEvent.release.exit) or (event == userEvent.release.enter) then
            setValue()
            pageState = pageStates.display
        elseif event == userEvent.press.plus or event == userEvent.repeatPress.plus or event == userEvent.dial.right then
            incValue(1)
        elseif event == userEvent.press.minus or event == userEvent.repeatPress.minus or event == userEvent.dial.left then
            incValue(-1)
        end
    end
    
    pollValues()
    
    if Page ~= nil then
        lcd.clear()
        if TEXT_BGCOLOR then
            lcd.drawFilledRectangle(0, 0, LCD_W, LCD_H, TEXT_BGCOLOR)
        end
        drawScreen()
    end
    
    if protocol.rssi() > 30 then
        lcd.drawText(InfoBox.x, InfoBox.y, version, InfoBox.to)
	local offset
	if currentPage < 10 then
	    offset = InfoBox.offset1
	else
	    offset = InfoBox.offset2
	end
        lcd.drawText(InfoBox.x+offset,          InfoBox.y, currentPage,       InfoBox.to)
        lcd.drawText(InfoBox.x+InfoBox.offset3, InfoBox.y, "/"..#(PageFiles), InfoBox.to)
    else
        if language == "en" and TelemText_en then
            lcd.drawText(TeleBox.x, TeleBox.y, TelemText_en.Text, TeleBox.to)
	else
            lcd.drawText(TeleBox.x, TeleBox.y, TelemText.Text,    TeleBox.to)
	end
	clearPageData()
        if comState ~= comStates.versionCheck then
            comState = comStates.versionCheck
            comTS = getTime()
	    version = "V-.-.-"
        end
    end
    
    if debugStr ~= "" then
        lcd.drawText(TeleBox.x, TeleBox.y, " >"..debugStr.."< ", TEXT_COLOR + INVERS)
    end
    
    if pageState == pageStates.displayMenu then
        drawMenu()
    elseif pageState == pageStates.saving then
        lcd.drawFilledRectangle(SaveBox.x, SaveBox.y, SaveBox.w, SaveBox.h, backgroundFill)
        lcd.drawRectangle(SaveBox.x, SaveBox.y, SaveBox.w, SaveBox.h, SOLID)
	local text_s
	local text_r
	local text_o
	local text_e
        if language == "en" and SaveBoxText_en then
	    text_s = SaveBoxText_en.TextS
	    text_r = SaveBoxText_en.TextR
	    text_o = SaveBoxText_en.TextO
	    text_e = SaveBoxText_en.TextE
	else
	    text_s = SaveBoxText.TextS
	    text_r = SaveBoxText.TextR
	    text_o = SaveBoxText.TextO
	    text_e = SaveBoxText.TextE
	end
        if saveRetries <= 0 then
            lcd.drawText(SaveBox.x+SaveBox.x_offset+SaveBox.x_o_s, SaveBox.y+SaveBox.y_offset, text_s,              SaveTextSize + (globalTextOptions))
        elseif saveRetries < saveMaxRetries+1 then
            lcd.drawText(SaveBox.x+SaveBox.x_offset+SaveBox.x_o_r, SaveBox.y+SaveBox.y_offset, text_r..saveRetries, SaveTextSize + (globalTextOptions))
	elseif saveRetries == 100 or saveRetries == 101 then
            lcd.drawText(SaveBox.x+SaveBox.x_offset+SaveBox.x_o_o, SaveBox.y+SaveBox.y_offset, text_o,              SaveTextSize + (globalTextOptions))
	else
            lcd.drawText(SaveBox.x+SaveBox.x_offset+SaveBox.x_o_e, SaveBox.y+SaveBox.y_offset, text_e,              SaveTextSize + (globalTextOptions))
        end
    end
    
    return 0
end


return run_ui
