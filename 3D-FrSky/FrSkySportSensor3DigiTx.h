/*
  FrSky 3Digi Tx class for Teensy 3.x/LC and 328P based boards (e.g. Pro Mini, Nano, Uno)
  (C) by Joerg-D. Rothfuchs 20190611
  Not for commercial use
*/

#ifndef _FRSKY_SPORT_SENSOR_DIGITX_H_
#define _FRSKY_SPORT_SENSOR_DIGITX_H_

#include "FrSkySportSensor.h"

#define DIGITX_DEFAULT_ID	ID28

#define QUEUE_DEPTH		28

class FrSkySportSensor3DigiTx : public FrSkySportSensor
{
  public:
    FrSkySportSensor3DigiTx(SensorId id = DIGITX_DEFAULT_ID);
    virtual void send(FrSkySportSingleWireSerial& serial, uint8_t sId, uint32_t now);
    void queueData(uint16_t aId, uint32_t d);
    void clearQueue(void);

  private:
    uint8_t  queueIn  = 0;
    uint8_t  queueOut = 0;
    uint8_t  queueCnt = 0;
    uint16_t appId[QUEUE_DEPTH];
    uint32_t data[QUEUE_DEPTH];
};

#endif // _FRSKY_SPORT_SENSOR_DIGITX_H_
