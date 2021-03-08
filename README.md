# 3Digi FrSky-TX LUA scripts

Here you can find LUA scripts and Arduino code which enables you to configure the 3Digi FBL directly from your FrSky transmitter using SmartPort telemetry.


## Please consider donating

So many downloads and only 4 donations yet.
Probably my last opensource project.

[![paypal](https://www.paypalobjects.com/en_US/DE/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3FXULQ9U8QRJL)


## A video

<a href="http://www.youtube.com/watch?feature=player_embedded&v=JW1EijqbsC4" target="_blank"><img src="http://img.youtube.com/vi/JW1EijqbsC4/0.jpg" alt="FrSky OpenTX integration for 3Digi" width="240" height="180" border="10" /></a>





## How to play around with the scripts in the OpenTX Companion

Prior to installing the scripts on a real transmitter and building the Arduino adapter you can play around with the scripts for different FrSky TX series in the OpenTX Companion.

Just copy the content of the SDCard path of this repository into the appropriate SDCARD path of your OpenTX Companion installation (see: 'Settings' 'SD Structure Path').

Start the OpenTX Companion TX simulator for the TX of your choice.

Navigate to the 'SD CARD' menu of the simulated TX.

Choose the folder [3Digi].

Execute the script 3Digi_de.lua for the german version or execute the script 3Digi_en.lua for the english version.

Start the 'Telemetry Simulator' and check the check box 'Simulate'.

Set the RSSI value to a value above 30 dB.

If you created a new model it is necessary to 'Discover new sensors' in the models 'Telemetry' menu of the simulated TX.


Here is a screenshot of OpenTX Companion simulating the scripts on the Horus X10:

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/SrceenShot001_en.jpg">


Here is a screenshot of OpenTX Companion simulating the scripts on the Taranis X9D:

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/SrceenShot002_en.jpg">


Here is a screenshot of OpenTX Companion simulating the scripts on the Taranis Q X7:

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/SrceenShot003_en.jpg">


## How to install the scripts on your TX

Just copy the whole content of the SDCard path of this repository into the appropriate SDCARD path of your TX.


## How to start the scripts on your TX

Navigate to the 'SD CARD' menu of the TX.

Choose the folder [3Digi].

Execute the script 3Digi_de.lua for the german version or execute the script 3Digi_en.lua for the english version.


And here you can see the real thing (german version):

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_001.jpg">


## Usage and navigation

Long press Enter button: Enter menu screen.

You can choose between 'Parameter Set 1-3' and 'Save values permanently'.

Press Enter button after selection.


Press Page button: Next screen.


While marker is not blinking:


Press - or + button or turn wheel left / right: Select item to edit.

Press Enter button: Edit highlighted value (starts blinking).


While marker is blinking:


Press - or + button or turn wheel left / right: Choose new value for selected item.

Press Enter button: Send new value for selected item temporarily (stops blinking).


Remember:

The new values are stored only temporarily for testing.

To save them permanetly you have to long press the Enter button, choose 'Save values permanently' and press the Enter button again.


## Adding the main script as a telemetry page

Setting up the main script as a telemetry page will enable access at the press of a button.
For now, this only applies to the Taranis X9 and Q7 series, not for the Horus series.

1. Hit the [MENU] button and select the model for which you would like to enable the script.
2. While on the [MODEL SELECTION] screen, long-press the [PAGE] button to navigate to the [DISPLAY] page.
3. Use the [-] button to move the cursor down to [Screen 1] and hit [ENT].
4. Use the [+] or [-] buttons to select the [Script] option and press [ENT].
5. Press [-] to move the cursor to the script selection field and hit [ENT].
6. Select TDde for the german version or TDen for the english version and hit [ENT].
7. Long-press [EXIT] to return to your model screen.

To invoke the script, simply long-press the [PAGE] button from the model screen.


## Important for Taranis X9D users:

Some changes in the recently released OpenTX 2.2.1 cause this version to have less RAM available for lua scripts than previous versions. This often leads to problems when using larger lua scripts on the Taranis X9D. A discussion of these problems can be found [here](https://github.com/betaflight/betaflight-tx-lua-scripts/issues/97).
A potential fix to increase the amount of RAM available has been identified: (https://github.com/opentx/opentx/pull/5579).
For now, the recommendation is for users wanting to update OpenTX from 2.2.0 to 2.2.1 on a Taranis X9D (and keep using these 3Digi FrSky-TX LUA scripts) to hold on and monitor the situation, in the hope that OpenTX will release a version with this bugfix in the near future.


## How to build the needed 3Digi-SmartPort adapter

It's easy! You need the following parts (except for the last part the parts are available e.g. at ebay):

1. An Arduino Pro Mini 5V: https://store.arduino.cc/arduino-pro-mini
2. A cable to connect with your 3Digi
3. A cable to connect with your FrSky RX
4. A 6 pin header
5. A servo connector
6. Some heatshrink
7. Some fun


There are many ways how to build the adapter, I did it this way:

1. Solder the 6 pin header directly to the Arduino:

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_1a.jpg">

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_1b.jpg">

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_1c.jpg">


2. Solder the SmartPort cable for connecting with your FrSky RX directly to the Arduino:

GND <-> GND

5V <-> RAW

SmartPort <-> 3

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_2a.jpg">

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_2b.jpg">

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_2c.jpg">

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_2d.jpg">


3. Solder the adapter cable for later connecting the Arduino with your 3Digi:

TX <-> RX

RX <-> TX

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_3a.jpg">


4. Heatshrink the adapter:

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_4a.jpg">


5. Slit the heatshrink for better installation of the programmer cable or adapter cable:

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_5a.jpg">

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_5b.jpg">


6. Celebrate your success with your loved one (optional).

No picture available ;-)


## How to program the 3Digi-SmartPort adapter

There are a bazillion of descriptions how to program an arduino on the web.

Use the code in the folder 3D-FrSky of this repository.

I use this programming 'equipment':

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_pa.jpg">


## How to connect the 3Digi-SmartPort adapter

Well, when this little thing fits in my small and slim SAB Goblin Mini Comet it will also fit in most other helicopter:

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_ca.jpg">

<img src="https://github.com/JR63/3Digi-FrSky-TX-LUA-scripts/blob/master/Images/IMG_cb.jpg">
