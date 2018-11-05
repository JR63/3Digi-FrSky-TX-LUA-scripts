/*
  FrSky 3Digi Rx class for Teensy 3.x/LC and 328P based boards (e.g. Pro Mini, Nano, Uno)
  (C) by Joerg-D. Rothfuchs 20181105
  Not for commercial use
*/

#include "FrSkySportSensor3DigiRx.h" 

FrSkySportSensor3DigiRx::FrSkySportSensor3DigiRx(SensorId id) : FrSkySportSensor(id) { }

uint16_t FrSkySportSensor3DigiRx::decodeData(uint8_t sId, uint16_t aId, uint32_t d)
{
  if ((sensorId == sId) || (sensorId == FrSkySportSensor::ID_IGNORE)) {
    appId = aId;
    data = d;
    return sId;
  } else {
    return SENSOR_NO_DATA_ID;
  }
}

uint16_t FrSkySportSensor3DigiRx::getAppId(void)
{
  return appId;
}

uint32_t FrSkySportSensor3DigiRx::getData(void)
{
  return data;
}
