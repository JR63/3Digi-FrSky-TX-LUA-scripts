-- @author     Joerg-D. Rothfuchs
-- @brief      3Digi FrSky-TX LUA scripts
-- @see
-- @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
-- @see        Version V1.00 - 2018/11/13
-- @see        UI concept initially based on betaflight-tx-lua-scripts.
-- @see
-- @see        Usage at your own risk! No warranty for anything!
-- @see

TEXT_COLOR = 2
SaveTextSize = DBLSIZE

PageFiles = {
    "Information.lua",
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

PageSkip = {
      { page = "IVerlaufRoll.lua", param = 135, bitmask = 0x01 },
      { page = "IVerlaufNick.lua", param = 147, bitmask = 0x01 },
      { page = "PitchKurve.lua",   param = 219, bitmask = 0x02 },
}

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
    "Save values permanently",
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

InfoText = {
    { "Everything Okay", "Alles OK" },
    { "System start", "System Start" },
    { "Sensor Okay", "Sensor OK" },
    { "RC reception Okay", "RC Empfang OK" },
    { "Autotrim start", "Autotrimm Start" },
    { "Autotrim stop", "Autotrimm Stop" },
    { "Autotrim saved", "Autotrim Speichern" },
    { "Governor active", "Drehzahlregler aktiv" },
    { "Governor deactivated", "Drehzahlregler deaktiviert" },
    { "AutoLevel active", "AutoLevel aktiv" },
    { "AutoLevel deactivated", "AutoLevel deaktiviert" },
}

WarningText = {
    { "Voltage below 5.0V", "Spannung unter 5,0V" },
    { "RC sat master failsafe", "RC Sat Master Failsafe" },
    { "RC sat slave failsafe", "RC Sat Slave Failsafe" },
    { "RC sat master Okay", "RC Sat Master OK" },
    { "RC sat slave Okay", "RC Sat Slave OK" },
    { "Voltage below 4.0V", "Spannung unter 4,0V" },
    { "Aileron servo limit reached", "Roll Servo Limit erreicht" },
    { "Elevator servo limit reached", "Nick Servo Limit erreicht" },
    { "Tail servo limit reached", "Heck Servo Limit erreicht" },
    { "Throttle channel limit reached", "Gas Kanal Limit erreicht" },
}

ErrorText = {
    { "Error sensor", "Fehler Sensor" },
    { "Voltage below 4.5V", "Spannung unter 4,5V" },
    { "RC failsafe", "RC Failsafe" },
    { "Voltage below 3.5V", "Spannung unter 3,5V" },
    { "Error RPM sensor", "Fehler RPM Sensor" },
    { "Error Governor Spoolup", "Fehler Drehzahlregler Spoolup" },
    { "Sensor limit rotation", "Sensor Limit Drehrate" },
    { "Sensor limit acceleration", "Sensor Limit Beschleunigung" },
}

MenuBox = { x=10, y=12, x_offset=44, y_offset=3, w=194, h_line=8 }
SaveBox = { x=10, y=12, x_offset= 4, y_offset=5, w=194, h=30, x_o_s=0, x_o_r=0, x_o_o=0, x_o_e=70 }
TeleBox = { x=155, y=0, to=SMLSIZE+TEXT_COLOR+BLINK }
InfoBox = { x=160, y=0, offset1=33, offset2=28, offset3=38, to=SMLSIZE+TEXT_COLOR }
