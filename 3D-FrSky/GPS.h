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

#ifndef GPS_H
#define GPS_H


struct GPS_VALUES {
    uint8_t	Status;
    uint8_t	Satellites;
    uint16_t	hDOP;
    int32_t	Latitude;
    int32_t	Longitude;
    int32_t	Altitude;
    int32_t	Heading;
    uint32_t	Speed3D;
    uint32_t	Speed2D;
    int32_t	Down;
    boolean	HomeValid;
    int32_t	HomeLatitude;
    int32_t	HomeLongitude;
    int32_t	HomeAltitude;
};


#ifdef GPS_PROTOCOL_UBX

#include "GPS_UBX.h"

#endif // GPS_PROTOCOL_UBX


struct GPS_VALUES* readGPS(void);


#endif /* GPS_H */

#endif // GPS_OPTION
