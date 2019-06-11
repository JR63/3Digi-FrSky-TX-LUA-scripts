/**
 *
 * @file       
 * @author     Joerg-D. Rothfuchs
 * @brief      Implements GPS for experimental usage.
 * @see        (C) by Joerg-D. Rothfuchs aka JR
 * @see        Version v0.01 - November 2015
 *
 *             Usage at your own risk! No warranty for anything!
 *
 *****************************************************************************/

#ifdef GPS_OPTION


#define FIX3D_APPROACH


#include "GPS.h"

#define TRUE			1
#define FALSE			0


static struct GPS_VALUES* GPSData = NULL;


// call this every 100ms at least till home position found
static boolean checkGPSHomeValid(void)
{
#ifdef SET_TEST_VALUES
  GPSData->Status		= GPSPOSITIONSENSOR_STATUS_FIX3D;
  GPSData->Satellites		=        10;
  GPSData->hDOP			=       320;
  GPSData->Latitude		= 500012300;
  GPSData->Longitude		=  60012300;
  GPSData->Altitude		=    195000;	//   15 m above home
  GPSData->Heading		=   9000000;	//   90 °
  GPSData->Speed3D		=      1000;	// 1000 cm/s -> 36 km/h
  GPSData->Speed2D		=      2000;	// 2000 cm/s -> 72 km/h
  GPSData->Down			=         0;	//    0 cm/s
  GPSData->HomeValid		=      TRUE;
  GPSData->HomeLatitude		= 500000000;
  GPSData->HomeLongitude	=  60000000;
  GPSData->HomeAltitude		=    180000;	//  180 m home
  return TRUE;
#endif
#ifndef FIX3D_APPROACH
  static uint8_t      gps_alt_cnt = 0;                // counter for stable altitude
  static int32_t      gps_alt_prev = 0;               // previous altitude
#endif // FIX3D_APPROACH

  if (!GPSData->HomeValid) {
#ifdef FIX3D_APPROACH
    if (GPSData->Status == GPSPOSITIONSENSOR_STATUS_FIX3D) {
      GPSData->HomeValid = TRUE;
      GPSData->HomeLatitude = GPSData->Latitude;  	// take this as home lat
      GPSData->HomeLongitude = GPSData->Longitude;  	// take this as home lon
      GPSData->HomeAltitude = GPSData->Altitude;  	// take this as home alt
    }
#else // FIX3D_APPROACH
    // criteria for a stable home position:
    //  - GPS fix
    //  - with at least 5 satellites
    //  - gps_alt stable for 50 * 100ms = 5s
    //  - gps_alt stable means the delta is lower 500mm = 0.5m
    if (GPSData->Status > GPSPOSITIONSENSOR_STATUS_NOFIX && GPSData->Satellites >= 5 && gps_alt_cnt < 50) {
      if (abs(gps_alt_prev - GPSData->Altitude) > 500) {
        gps_alt_cnt = 0;
        gps_alt_prev = GPSData->Altitude;
      } else {
        if (++gps_alt_cnt >= 50) {
          GPSData->HomeValid = TRUE;
          GPSData->HomeLatitude = GPSData->Latitude;  	// take this as home lat
          GPSData->HomeLongitude = GPSData->Longitude;  // take this as home lon
          GPSData->HomeAltitude = GPSData->Altitude;  	// take this as home alt
        }
      }
    }
#endif // FIX3D_APPROACH
  }
  
  return GPSData->HomeValid;
}


struct GPS_VALUES* readGPS(void) {
  static unsigned long last_100ms = 0;
  static uint8_t gps_got_home = FALSE;
  int max_read = 100;

  GPSData = get_gps_values_ptr();
  GPSData->HomeValid = gps_got_home;
	
#ifdef SET_TEST_VALUES
  gps_got_home = checkGPSHomeValid();
  return GPSData;
#endif
  
  // grabbing data
  while (Serial.available() > 0 && max_read--) {
    uint8_t c = Serial.read();
#ifdef GPS_PROTOCOL_UBX
    if (parse_ubx(c) == PARSER_COMPLETE_SET) {
      if (!gps_got_home && last_100ms + 100 <= millis()) {
        last_100ms = millis();
	gps_got_home = checkGPSHomeValid();
      }
    }
#endif
  }
  return GPSData;
}

#endif // GPS_OPTION
