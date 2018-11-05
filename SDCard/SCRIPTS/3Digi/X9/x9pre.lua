-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/05
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

PageFiles = 
{
    "Normal.lua",
    "Experte.lua",
    "IVerlaufRoll.lua",
    "IVerlaufNick.lua",
    "Taumelscheibe.lua",
    "HeckErweitert.lua",
    "AutoLevel.lua",
    "Drehzahlregelung1.lua",
    "Drehzahlregelung2.lua",
    "PitchKurve.lua",
    "Allgemein1.lua",
    "Allgemein2.lua",
    "Sensoren.lua",
}

TEXT_COLOR = 2
SaveTextSize = DBLSIZE

TitleText = {
    pre = "3Digi/PS",
    div = "/",
}

TitleText_en = {
    pre = "3Digi/PS",
    div = "/",
}

MenuText = {
    "Menue:",
    "Parametersatz 1",
    "Parametersatz 2",
    "Parametersatz 3",
    "",
    "Werte permanent speichern",
}

MenuText_en = {
    "Menu:",
    "Parameter Set 1",
    "Parameter Set 2",
    "Parameter Set 3",
    "",
    "Save vales permanently",
}

SaveBoxText = {
    TextS = "Speichern",
    TextR = "Wiederholen ",
    TextO = "Speichern Ok",
    TextE = "Fehler",
}

SaveBoxText_en = {
    TextS = "Save",
    TextR = "Retry ",
    TextO = "Save Ok",
    TextE = "Error",
}

TelemText = {
    Text = "Keine Telem.",
}

TelemText_en = {
    Text = "No Telemetry",
}

MenuBox = { x=10, y=12, x_offset=44, y_offset=3, w=194, h_line=8 }
SaveBox = { x=10, y=12, x_offset= 4, y_offset=5, w=194, h=30, x_o_s=0, x_o_r=0, x_o_o=0, x_o_e=70 }
TeleBox = { x=155, y=0, to=SMLSIZE+TEXT_COLOR+BLINK }
InfoBox = { x=160, y=0, offset1=33, offset2=28, offset3=38, to=SMLSIZE+TEXT_COLOR }
