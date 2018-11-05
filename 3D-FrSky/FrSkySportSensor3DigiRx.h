/*
  FrSky 3Digi Rx class for Teensy 3.x/LC and 328P based boards (e.g. Pro Mini, Nano, Uno)
  (C) by Joerg-D. Rothfuchs 20181105
  Not for commercial use
*/

#ifndef _FRSKY_SPORT_SENSOR_DIGIRX_H_
#define _FRSKY_SPORT_SENSOR_DIGIRX_H_

#include "FrSkySportSensor.h"

#define DIGIRX_DEFAULT_ID	ID14

class FrSkySportSensor3DigiRx : public FrSkySportSensor
{
  public:
    FrSkySportSensor3DigiRx(SensorId id = DIGIRX_DEFAULT_ID);
    virtual uint16_t decodeData(uint8_t sId, uint16_t aId, uint32_t d);
    uint16_t getAppId(void);
    uint32_t getData(void);

  private:
    uint16_t appId;
    uint32_t data;
};

#endif // _FRSKY_SPORT_SENSOR_DIGIRX_H_
