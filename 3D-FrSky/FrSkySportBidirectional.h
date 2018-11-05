/*
  FrSky SmartPort bidirectional class for Teensy 3.x/LC and 328P based boards (e.g. Pro Mini, Nano, Uno)
  based on Pawelsky code
  (C) by Joerg-D. Rothfuchs 20181105
  Not for commercial use
*/

#ifndef _FRSKY_SPORT_BIDIRECTIONAL_H_
#define _FRSKY_SPORT_BIDIRECTIONAL_H_

#include "Arduino.h"
#include "FrSkySportSensor.h"
#include "FrSkySportSingleWireSerial.h"

#define FRSKY_BIDIRECTIONAL_MAX_SENSORS 28

class FrSkySportBidirectional
{
  public:
    FrSkySportBidirectional();
    void begin(FrSkySportSingleWireSerial::SerialId id,
                FrSkySportSensor* sensor1,         FrSkySportSensor* sensor2 =  NULL, FrSkySportSensor* sensor3 =  NULL, 
                FrSkySportSensor* sensor4  = NULL, FrSkySportSensor* sensor5 =  NULL, FrSkySportSensor* sensor6 =  NULL,
                FrSkySportSensor* sensor7  = NULL, FrSkySportSensor* sensor8 =  NULL, FrSkySportSensor* sensor9 =  NULL, 
                FrSkySportSensor* sensor10 = NULL, FrSkySportSensor* sensor11 = NULL, FrSkySportSensor* sensor12 = NULL,
                FrSkySportSensor* sensor13 = NULL, FrSkySportSensor* sensor14 = NULL, FrSkySportSensor* sensor15 = NULL,
                FrSkySportSensor* sensor16 = NULL, FrSkySportSensor* sensor17 = NULL, FrSkySportSensor* sensor18 = NULL,
                FrSkySportSensor* sensor19 = NULL, FrSkySportSensor* sensor20 = NULL, FrSkySportSensor* sensor21 = NULL,
                FrSkySportSensor* sensor22 = NULL, FrSkySportSensor* sensor23 = NULL, FrSkySportSensor* sensor24 = NULL,
                FrSkySportSensor* sensor25 = NULL, FrSkySportSensor* sensor26 = NULL, FrSkySportSensor* sensor27 = NULL,
                FrSkySportSensor* sensor28 = NULL);
    void setRxCount(uint8_t count);
    uint16_t processSmartPort();

  private:
    enum State { 
	    START_FRAME,
	    SENSOR_ID,
	    FRAME_ID,
	    APP_ID_BYTE_1,
	    APP_ID_BYTE_2,
	    DATA_BYTE_1,
	    DATA_BYTE_2,
	    DATA_BYTE_3,
	    DATA_BYTE_4,
	    CRC
    };
    FrSkySportSensor* sensors[FRSKY_BIDIRECTIONAL_MAX_SENSORS];
    FrSkySportSingleWireSerial serial;
    uint8_t  sensorCount;
    uint8_t  rxCount;
    State    state;
    boolean  stuffing;
    uint8_t  sensorId;
    uint8_t  frameId;
    uint16_t appId;
    uint32_t data;
    uint16_t crc;
};

#endif // _FRSKY_SPORT_BIDIRECTIONAL_H_
