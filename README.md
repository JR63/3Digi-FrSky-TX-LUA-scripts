# 3Digi FrSky-TX LUA scripts

Here you can find LUA scripts and Arduino code which enables you to configure the 3Digi FBL directly from your FrSky transmitter using SmartPort telemetry.


## How to play around with the scripts in the OpenTX Companion

Prior to installing the scripts and buildung the Arduino adapter you can play around with the scripts for different FrSky TX series in the OpenTX Companion.

Yust copy the content of the SDCard path of this repository into the appropriate SDCARD path of your OpenTX Companion installation (see: 'Settings' 'SD Structure Path').

Start the OpenTX Companion TX simulator for the TX of your choice.

Navigate to the 'SD CARD' menu of the simulated TX.
Choose the folder [3Digi].
Execute the script 3Digi_de.lua (there will be a 3Digi_en.lua for the english language later).

Start the 'Telemetry Simulator' and check the check box 'Simulator'.
Set the RSSI value to a value above 30 dB.


## How to install the scripts on your TX

Yust copy the whole content of the SDCard path of this repository into the appropriate SDCARD path of your TX.


## How to start the scripts on your TX

Navigate to the 'SD CARD' menu of the TX.
Choose the folder [3Digi].
Execute the script 3Digi_de.lua (there will be a 3Digi_en.lua for the english language later).


## Adding the main script as a telemetry page

Setting up the main script as a telemetry page will enable access at the press of a button.
For now, this only applies to the Taranis X9 and Q7 series, not for the Horus series.

1. Hit the [MENU] button and select the model for which you would like to enable the script.
2. While on the [MODEL SELECTION] screen, long-press the [PAGE] button to navigate to the [DISPLAY] page.
3. Use the [-] button to move the cursor down to [Screen 1] and hit [ENT].
4. Use the [+] or [-] buttons to select the [Script] option and press [ENT].
5. Press [-] to move the cursor to the script selection field and hit [ENT].
6. Select TDde and hit [ENT]. (There will be a TDen for the english language later).
7. Long-press [EXIT] to return to your model screen.

To invoke the script, simply long-press the [PAGE] button from the model screen.


## Important for Taranis X9D users:

Some changes in the recently released OpenTX 2.2.1 cause this version to have less RAM available for lua scripts than previous versions. This often leads to problems when using larger lua scripts on the Taranis X9D. A discussion of these problems can be found [here](https://github.com/betaflight/betaflight-tx-lua-scripts/issues/97).
A potential fix to increase the amount of RAM available has been identified: (https://github.com/opentx/opentx/pull/5579).
For now, the recommendation is for users wanting to update OpenTX from 2.2.0 to 2.2.1 on a Taranis X9D (and keep using these 3Digi FrSky-TX LUA scripts) to hold on and monitor the situation, in the hope that OpenTX will release a version with this bugfix in the near future.


## How to build the needed 3Digi-SmartPort adapter

It's easy! You need the following parts (except for the last part the parts are available e.g. at ebay):

An Arduino Pro Mini 5V: https://store.arduino.cc/arduino-pro-mini
A cable to connect with your 3Digi
A cable to connect with your FrSky RX
A 6 pin header
A servo connector
Some heatshrink
Some fun


There are many ways how to build the adapter, I did it this way:

1.
Solder the 6 pin header directly to the Arduino:

TODO jpg

2.
Solder the SmartPort cable for connecting with your FrSky RX directly to the Arduino:
GND <-> GND
5V <-> RAW
SmartPort <-> 3

TODO jpg

3.
Solder the adapter cable for later connecting the Arduino with your FrSky RX:
TX <-> RX
RX <-> TX

TODO jpg

4.
Heatshrink the adapter:

TODO jpg

5.
Slit the heatshrink for better installation of the programmer or adapter cable:

TODO jpg

6.
Celebrate your success with your loved one (optional).

No picture available ;-)


## How to program the 3Digi-SmartPort adapter

There are a bazillion of descriptions how to program an arduino on the web.

Use the code in the folder 3D-FrSky

I use this programming 'equipment':

TODO jpg


## How to connect the 3Digi-SmartPort adapter

TODO jpg

TODO jpg
