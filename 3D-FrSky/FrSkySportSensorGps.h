/*
  FrSky GPS sensor class for Teensy 3.x/LC and 328P based boards (e.g. Pro Mini, Nano, Uno)
  (c) Pawelsky 20160919
  (C) by Joerg-D. Rothfuchs 20190509
  Not for commercial use
*/

#ifndef _FRSKY_SPORT_SENSOR_GPS_H_
#define _FRSKY_SPORT_SENSOR_GPS_H_

#include "FrSkySportSensor.h"

#define GPS_DEFAULT_ID ID4
#define GPS_DATA_COUNT 5
#define GPS_LAT_LON_DATA_ID   0x0800
#define GPS_ALT_DATA_ID       0x0820
#define GPS_SPEED_DATA_ID     0x0830
#define GPS_COG_DATA_ID       0x0840

#if 0
#define GPS_LAT_LON_DATA_PERIOD   1000
#define GPS_ALT_DATA_PERIOD       500
#define GPS_SPEED_DATA_PERIOD     500
#define GPS_COG_DATA_PERIOD       500
#else
#define GPS_LAT_LON_DATA_PERIOD   500
#define GPS_ALT_DATA_PERIOD       200
#define GPS_SPEED_DATA_PERIOD     200
#define GPS_COG_DATA_PERIOD       200
#endif


class FrSkySportSensorGps : public FrSkySportSensor
{
  public:
    FrSkySportSensorGps(SensorId id = GPS_DEFAULT_ID);
    void setData(int32_t lat, int32_t lon, int32_t alt, uint32_t speed, int32_t cog);
    virtual void send(FrSkySportSingleWireSerial& serial, uint8_t id, uint32_t now);

  private:
    static uint32_t setLatLon(int32_t latLon, bool isLat);
    uint32_t latData = 0;
    uint32_t lonData = 0;
    int32_t altData = 0;
    uint32_t speedData = 0;
    uint32_t cogData = 0;
  
    uint32_t latTime;
    uint32_t lonTime;
    uint32_t altTime;
    uint32_t speedTime;
    uint32_t cogTime;
};

#endif // _FRSKY_SPORT_SENSOR_GPS_H_
