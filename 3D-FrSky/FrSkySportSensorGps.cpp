/*
  FrSky GPS sensor class for Teensy 3.x/LC and 328P based boards (e.g. Pro Mini, Nano, Uno)
  (c) Pawelsky 20160919
  (C) by Joerg-D. Rothfuchs 20190509
  Not for commercial use
*/

#include "FrSkySportSensorGps.h" 

FrSkySportSensorGps::FrSkySportSensorGps(SensorId id) : FrSkySportSensor(id) { }

void FrSkySportSensorGps::setData(int32_t lat, int32_t lon, int32_t alt, uint32_t speed, int32_t cog)
{
  latData = setLatLon(lat, true);
  lonData = setLatLon(lon, false);
  altData = alt;
  speedData = speed;
  cogData = cog;
}

uint32_t FrSkySportSensorGps::setLatLon(int32_t latLon, bool isLat)
{
  uint32_t data = (((((uint32_t)(latLon < 0 ? -latLon : latLon)) / 10 ) * 6 ) / 10 ) & 0x3FFFFFFF;
  if (isLat == false) data |= 0x80000000;
  if (latLon < 0) data |= 0x40000000;

  return data;
}

void FrSkySportSensorGps::send(FrSkySportSingleWireSerial& serial, uint8_t id, uint32_t now)
{
  if(sensorId == id)
  {
    switch(sensorDataIdx)
    {
      case 0:
        if(now > latTime)
        {
          latTime = now + GPS_LAT_LON_DATA_PERIOD;
          serial.sendData(id, GPS_LAT_LON_DATA_ID, latData);
        }
        else
        {
          serial.sendEmpty(GPS_LAT_LON_DATA_ID);
        }
        break;
      case 1:
        if(now > lonTime)
        {
          lonTime = now + GPS_LAT_LON_DATA_PERIOD;
          serial.sendData(id, GPS_LAT_LON_DATA_ID, lonData);
        }
        else
        {
          serial.sendEmpty(GPS_LAT_LON_DATA_ID);
        }
        break;
      case 2:
        if(now > altTime)
        {
          altTime = now + GPS_ALT_DATA_PERIOD;
          serial.sendData(id, GPS_ALT_DATA_ID, altData);
        }
        else
        {
          serial.sendEmpty(GPS_ALT_DATA_ID);
        }
        break;
      case 3:
        if(now > speedTime)
        {
          speedTime = now + GPS_SPEED_DATA_PERIOD;
          serial.sendData(id, GPS_SPEED_DATA_ID, speedData);
        }
        else
        {
          serial.sendEmpty(GPS_SPEED_DATA_ID);
        }
        break;
      case 4:
        if(now > cogTime)
        {
          cogTime = now + GPS_COG_DATA_PERIOD;
          serial.sendData(id, GPS_COG_DATA_ID, cogData);
        }
        else
        {
          serial.sendEmpty(GPS_COG_DATA_ID);
        }
        break;
    }
    sensorDataIdx++;
    if(sensorDataIdx >= GPS_DATA_COUNT) sensorDataIdx = 0;
  }
}
