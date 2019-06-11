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

#ifndef GPS_UBX_H
#define GPS_UBX_H


#define GPSPOSITIONSENSOR_STATUS_NOGPS	0
#define GPSPOSITIONSENSOR_STATUS_NOFIX	1
#define GPSPOSITIONSENSOR_STATUS_FIX2D	2
#define GPSPOSITIONSENSOR_STATUS_FIX3D	3


#define NO_PARSER          -3 // no parser available
#define PARSER_OVERRUN     -2 // message buffer overrun before completing the message
#define PARSER_ERROR       -1 // message unparsable by this parser
#define PARSER_INCOMPLETE   0 // parser needs more data to complete the message
#define PARSER_COMPLETE     1 // parser has received a complete message and finished processing
#define PARSER_COMPLETE_SET 2 // parser has received a complete message set and finished processing

struct GPS_RX_STATS {
    uint16_t gpsRxReceived;
    uint16_t gpsRxChkSumError;
    uint16_t gpsRxOverflow;
    uint16_t gpsRxParserError;
};


#define UBX_SYNC1      0xB5  // UBX protocol synchronization characters
#define UBX_SYNC2      0x62

// From u-blox6 receiver protocol specification

// Messages classes
typedef enum {
    UBX_CLASS_NAV     = 0x01,
    UBX_CLASS_ACK     = 0x05,
    UBX_CLASS_CFG     = 0x06,
} ubx_class;

// Message IDs
typedef enum {
    UBX_ID_NAV_POSLLH    = 0x02,
    UBX_ID_NAV_STATUS    = 0x03,
    UBX_ID_NAV_DOP       = 0x04,
    UBX_ID_NAV_SOL       = 0x06,
    UBX_ID_NAV_VELNED    = 0x12,
    UBX_ID_NAV_TIMEUTC   = 0x21,
    UBX_ID_NAV_SVINFO    = 0x30,

    UBX_ID_NAV_AOPSTATUS = 0x60,
    UBX_ID_NAV_CLOCK     = 0x22,
    UBX_ID_NAV_DGPS      = 0x31,
    UBX_ID_NAV_POSECEF   = 0x01,
    UBX_ID_NAV_SBAS      = 0x32,
    UBX_ID_NAV_TIMEGPS   = 0x20,
    UBX_ID_NAV_VELECEF   = 0x11
} ubx_class_nav_id;

typedef enum {
    UBX_ID_ACK_ACK = 0x01,
    UBX_ID_ACK_NAK = 0x00,
} ubx_class_ack_id;

typedef enum {
    UBX_ID_CFG_NAV5 = 0x24,
    UBX_ID_CFG_RATE = 0x08,
    UBX_ID_CFG_MSG  = 0x01,
    UBX_ID_CFG_CFG  = 0x09,
    UBX_ID_CFG_SBAS = 0x16,
    UBX_ID_CFG_GNSS = 0x3E,
    UBX_ID_CFG_PRT  = 0x00
} ubx_class_cfg_id;

// private structures

// Geodetic Position Solution
struct UBX_NAV_POSLLH {
    uint32_t iTOW;   // GPS Millisecond Time of Week (ms)
    int32_t  lon;    // Longitude (deg*1e-7)
    int32_t  lat;    // Latitude (deg*1e-7)
    int32_t  height; // Height above Ellipsoid (mm)
    int32_t  hMSL;   // Height above mean sea level (mm)
    uint32_t hAcc;   // Horizontal Accuracy Estimate (mm)
    uint32_t vAcc;   // Vertical Accuracy Estimate (mm)
};

// Receiver Navigation Status

#define STATUS_GPSFIX_NOFIX    0x00
#define STATUS_GPSFIX_DRONLY   0x01
#define STATUS_GPSFIX_2DFIX    0x02
#define STATUS_GPSFIX_3DFIX    0x03
#define STATUS_GPSFIX_GPSDR    0x04
#define STATUS_GPSFIX_TIMEONLY 0x05

#define STATUS_FLAGS_GPSFIX_OK (1 << 0)
#define STATUS_FLAGS_DIFFSOLN  (1 << 1)
#define STATUS_FLAGS_WKNSET    (1 << 2)
#define STATUS_FLAGS_TOWSET    (1 << 3)

struct UBX_NAV_STATUS {
    uint32_t iTOW;    // GPS Millisecond Time of Week (ms)
    uint8_t  gpsFix;  // GPS fix type
    uint8_t  flags;   // Navigation Status Flags
    uint8_t  fixStat; // Fix Status Information
    uint8_t  flags2;  // Additional navigation output information
    uint32_t ttff;    // Time to first fix (ms)
    uint32_t msss;    // Milliseconds since startup/reset (ms)
};

// Dilution of precision
struct UBX_NAV_DOP {
    uint32_t iTOW; // GPS Millisecond Time of Week (ms)
    uint16_t gDOP; // Geometric DOP
    uint16_t pDOP; // Position DOP
    uint16_t tDOP; // Time DOP
    uint16_t vDOP; // Vertical DOP
    uint16_t hDOP; // Horizontal DOP
    uint16_t nDOP; // Northing DOP
    uint16_t eDOP; // Easting DOP
};

// Navigation solution
struct UBX_NAV_SOL {
    uint32_t iTOW;      // GPS Millisecond Time of Week (ms)
    int32_t  fTOW;      // fractional nanoseconds (ns)
    int16_t  week;      // GPS week
    uint8_t  gpsFix;    // GPS fix type
    uint8_t  flags;     // Fix status flags
    int32_t  ecefX;     // ECEF X coordinate (cm)
    int32_t  ecefY;     // ECEF Y coordinate (cm)
    int32_t  ecefZ;     // ECEF Z coordinate (cm)
    uint32_t pAcc;      // 3D Position Accuracy Estimate (cm)
    int32_t  ecefVX;    // ECEF X coordinate (cm/s)
    int32_t  ecefVY;    // ECEF Y coordinate (cm/s)
    int32_t  ecefVZ;    // ECEF Z coordinate (cm/s)
    uint32_t sAcc;      // Speed Accuracy Estimate
    uint16_t pDOP;      // Position DOP
    uint8_t  reserved1; // Reserved
    uint8_t  numSV;     // Number of SVs used in Nav Solution
    uint32_t reserved2; // Reserved
};

// North/East/Down velocity etc.
struct UBX_NAV_VELNED {
    uint32_t iTOW;    // ms GPS Millisecond Time of Week
    int32_t  velN;    // cm/s NED north velocity
    int32_t  velE;    // cm/s NED east velocity
    int32_t  velD;    // cm/s NED down velocity
    uint32_t speed;   // cm/s Speed (3-D)
    uint32_t gSpeed;  // cm/s Ground Speed (2-D)
    int32_t  heading; // 1e-5 *deg Heading of motion 2-D
    uint32_t sAcc;    // cm/s Speed Accuracy Estimate
    uint32_t cAcc;    // 1e-5 *deg Course / Heading Accuracy Estimate
};

// UTC Time Solution
#define TIMEUTC_VALIDTOW (1 << 0)
#define TIMEUTC_VALIDWKN (1 << 1)
#define TIMEUTC_VALIDUTC (1 << 2)
struct UBX_NAV_TIMEUTC {
    uint32_t iTOW;  // GPS Millisecond Time of Week (ms)
    uint32_t tAcc;  // Time Accuracy Estimate (ns)
    int32_t  nano;  // Nanoseconds of second
    uint16_t year;
    uint8_t  month;
    uint8_t  day;
    uint8_t  hour;
    uint8_t  min;
    uint8_t  sec;
    uint8_t  valid; // Validity Flags
};

// Space Vehicle (SV) Information
// Single SV information block
#define SVUSED     (1 << 0) // This SV is used for navigation
#define DIFFCORR   (1 << 1) // Differential correction available
#define ORBITAVAIL (1 << 2) // Orbit information available
#define ORBITEPH   (1 << 3) // Orbit information is Ephemeris
#define UNHEALTHY  (1 << 4) // SV is unhealthy
#define ORBITALM   (1 << 5) // Orbit information is Almanac Plus
#define ORBITAOP   (1 << 6) // Orbit information is AssistNow Autonomous
#define SMOOTHED   (1 << 7) // Carrier smoothed pseudoranges used
struct UBX_NAV_SVINFO_SV {
    uint8_t chn;     // Channel number
    uint8_t svid;    // Satellite ID
    uint8_t flags;   // Misc SV information
    uint8_t quality; // Misc quality indicators
    uint8_t cno;     // Carrier to Noise Ratio (dbHz)
    int8_t  elev;    // Elevation (integer degrees)
    int16_t azim;    // Azimuth	(integer degrees)
    int32_t prRes;   // Pseudo range residual (cm)
};

// SV information message
#define MAX_SVS 16
struct UBX_NAV_SVINFO {
    uint32_t iTOW;        // GPS Millisecond Time of Week (ms)
    uint8_t  numCh;       // Number of channels
    uint8_t  globalFlags; //
    uint16_t reserved2;   // Reserved
    struct UBX_NAV_SVINFO_SV sv[MAX_SVS]; // Repeated 'numCh' times
};

// ACK message class
struct UBX_ACK_ACK {
    uint8_t clsID;	// ClassID
    uint8_t msgID;	// MessageID
};

// NAK message class
struct UBX_ACK_NAK {
    uint8_t clsID;	// ClassID
    uint8_t msgID;	// MessageID
};

typedef union {
    uint8_t payload[0];
    struct UBX_NAV_POSLLH  nav_posllh;
    struct UBX_NAV_STATUS  nav_status;
    struct UBX_NAV_DOP     nav_dop;
    struct UBX_NAV_SOL     nav_sol;
    struct UBX_NAV_VELNED  nav_velned;
#if !defined(PIOS_GPS_MINIMAL)
    struct UBX_NAV_TIMEUTC nav_timeutc;
    struct UBX_NAV_SVINFO  nav_svinfo;
#endif
    struct UBX_ACK_ACK     ack_ack;
    struct UBX_ACK_NAK     ack_nak;
} UBXPayload;

struct UBXHeader {
    uint8_t  class_nav;
    uint8_t  id;
    uint16_t len;
    uint8_t  ck_a;
    uint8_t  ck_b;
};

struct UBXPacket {
    struct UBXHeader header;
    UBXPayload payload;
};


// GPS_AUTO_CONFIG start


#define UBX_CFG_CFG_DEVICE_BBR        0x01
#define UBX_CFG_CFG_DEVICE_FLASH      0x02
#define UBX_CFG_CFG_DEVICE_EEPROM     0x04
#define UBX_CFG_CFG_DEVICE_SPIFLASH   0x10

#define UBX_CFG_CFG_DEVICE_ALL		\
    (UBX_CFG_CFG_DEVICE_BBR		| \
     UBX_CFG_CFG_DEVICE_FLASH		| \
     UBX_CFG_CFG_DEVICE_EEPROM		| \
     UBX_CFG_CFG_DEVICE_SPIFLASH)

#define UBX_CFG_CFG_SETTINGS_NONE     0x000
#define UBX_CFG_CFG_SETTINGS_IOPORT   0x001
#define UBX_CFG_CFG_SETTINGS_MSGCONF  0x002
#define UBX_CFG_CFG_SETTINGS_INFMSG   0x004
#define UBX_CFG_CFG_SETTINGS_NAVCONF  0x008
#define UBX_CFG_CFG_SETTINGS_TPCONF   0x010
#define UBX_CFG_CFG_SETTINGS_SFDRCONF 0x100
#define UBX_CFG_CFG_SETTINGS_RINVCONF 0x200
#define UBX_CFG_CFG_SETTINGS_ANTCONF  0x400

#define UBX_CFG_CFG_SETTINGS_ALL	\
    (UBX_CFG_CFG_SETTINGS_IOPORT	| \
     UBX_CFG_CFG_SETTINGS_MSGCONF	| \
     UBX_CFG_CFG_SETTINGS_INFMSG	| \
     UBX_CFG_CFG_SETTINGS_NAVCONF	| \
     UBX_CFG_CFG_SETTINGS_TPCONF	| \
     UBX_CFG_CFG_SETTINGS_SFDRCONF	| \
     UBX_CFG_CFG_SETTINGS_RINVCONF	| \
     UBX_CFG_CFG_SETTINGS_ANTCONF)

#define UBX_CFG_CFG_STORE_SETTINGS	\
    (UBX_CFG_CFG_SETTINGS_IOPORT	| \
     UBX_CFG_CFG_SETTINGS_MSGCONF	| \
     UBX_CFG_CFG_SETTINGS_NAVCONF)
     
#define UBX_CFG_CFG_CLEAR_SETTINGS	(~UBX_CFG_CFG_STORE_SETTINGS & UBX_CFG_CFG_SETTINGS_ALL)

struct UBX_CFG_CFG {
    uint32_t clearMask;
    uint32_t saveMask;
    uint32_t loadMask;
    uint8_t  deviceMask;
};

struct UBX_CFG_MSG {
    uint8_t msgClass;
    uint8_t msgID;
    uint8_t rate;
};

struct UBX_CFG_NAV5 {
    uint16_t mask;
    uint8_t  dynModel;
    uint8_t  fixMode;
    int32_t  fixedAlt;
    uint32_t fixedAltVar;
    int8_t   minElev;
    uint8_t  drLimit;
    uint16_t pDop;
    uint16_t tDop;
    uint16_t pAcc;
    uint16_t tAcc;
    uint8_t  staticHoldThresh;
    uint8_t  dgpsTimeOut;
    uint8_t  cnoThreshNumSVs;
    uint8_t  cnoThresh;
    uint16_t reserved2;
    uint32_t reserved3;
    uint32_t reserved4;
};

#define UBX_CFG_PRT_PORTID_DDC       0
#define UBX_CFG_PRT_PORTID_UART1     1
#define UBX_CFG_PRT_PORTID_UART2     2
#define UBX_CFG_PRT_PORTID_USB       3
#define UBX_CFG_PRT_PORTID_SPI       4
#define UBX_CFG_PRT_MODE_DATABITS5   0x00
#define UBX_CFG_PRT_MODE_DATABITS6   0x40
#define UBX_CFG_PRT_MODE_DATABITS7   0x80
#define UBX_CFG_PRT_MODE_DATABITS8   0xC0
#define UBX_CFG_PRT_MODE_EVENPARITY  0x000
#define UBX_CFG_PRT_MODE_ODDPARITY   0x200
#define UBX_CFG_PRT_MODE_NOPARITY    0x800
#define UBX_CFG_PRT_MODE_STOPBITS1_0 0x0000
#define UBX_CFG_PRT_MODE_STOPBITS1_5 0x1000
#define UBX_CFG_PRT_MODE_STOPBITS2_0 0x2000
#define UBX_CFG_PRT_MODE_STOPBITS0_5 0x3000
#define UBX_CFG_PRT_MODE_RESERVED    0x10

#define UBX_CFG_PRT_MODE_DEFAULT     (UBX_CFG_PRT_MODE_DATABITS8 | UBX_CFG_PRT_MODE_NOPARITY | UBX_CFG_PRT_MODE_STOPBITS1_0 | UBX_CFG_PRT_MODE_RESERVED)
struct UBX_CFG_PRT {
    uint8_t  portID;		// 1 or 2 for UART ports
    uint8_t  res0;		// reserved
    uint16_t res1;		// reserved
    uint32_t mode;		// bit masks for databits, stopbits, parity, and non-zero reserved
    uint32_t baudRate;		// bits per second, 9600 means 9600
    uint16_t inProtoMask;	// bit 0 on = UBX, bit 1 on = NEMA
    uint16_t outProtoMask;	// bit 0 on = UBX, bit 1 on = NEMA
    uint16_t flags;		// reserved
    uint16_t pad;		// reserved
};

struct UBX_CFG_PRT_POLL {
    uint8_t  portID;		// 1 or 2 for UART ports
};

struct UBX_CFG_RATE {
    uint16_t measRate;
    uint16_t navRate;
    uint16_t timeRef;
};

#define UBX_CFG_SBAS_MODE_ENABLED    0x01
#define UBX_CFG_SBAS_MODE_TEST       0x02
#define UBX_CFG_SBAS_USAGE_RANGE     0x01
#define UBX_CFG_SBAS_USAGE_DIFFCORR  0x02
#define UBX_CFG_SBAS_USAGE_INTEGRITY 0x04

// SBAS used satellite PNR bitmask (120-151)
// -------------------------------------1---------1---------1---------1
// -------------------------------------5---------4---------3---------2
// ------------------------------------10987654321098765432109876543210
// WAAS 122, 133, 134, 135, 138---------|---------|---------|---------|
#define UBX_CFG_SBAS_SCANMODE1_WAAS  0b00000000000001001110000000000100
// EGNOS 120, 124, 126, 131-------------|---------|---------|---------|
#define UBX_CFG_SBAS_SCANMODE1_EGNOS 0b00000000000000000000100001010001
// MSAS 129, 137------------------------|---------|---------|---------|
#define UBX_CFG_SBAS_SCANMODE1_MSAS  0b00000000000000100000001000000000
// GAGAN 127, 128-----------------------|---------|---------|---------|
#define UBX_CFG_SBAS_SCANMODE1_GAGAN 0b00000000000000000000000110000000
// SDCM 125, 140, 141-------------------|---------|---------|---------|
#define UBX_CFG_SBAS_SCANMODE1_SDCM  0b00000000001100000000000000100000

#define UBX_CFG_SBAS_SCANMODE2       0x00
struct UBX_CFG_SBAS {
    uint8_t  mode;
    uint8_t  usage;
    uint8_t  maxSBAS;
    uint8_t  scanmode2;
    uint32_t scanmode1;
};

typedef union {
    uint8_t payload[0];
    struct UBX_CFG_CFG		cfg_cfg;
    struct UBX_CFG_MSG		cfg_msg;
    struct UBX_CFG_NAV5		cfg_nav5;
    struct UBX_CFG_PRT		cfg_prt;
    struct UBX_CFG_PRT_POLL	cfg_prt_poll;
    struct UBX_CFG_RATE		cfg_rate;
    struct UBX_CFG_SBAS		cfg_sbas;
} UBXSendPayload;

struct UBXSendHeader {
    uint8_t  prolog[2];
    uint8_t  class_nav;
    uint8_t  id;
    uint16_t len;
};

struct UBXSendPacket {
    uint8_t buffer[0];
    struct {
        struct UBXSendHeader header;
        UBXSendPayload payload;
        uint8_t  ck_a;
        uint8_t  ck_b;
    } message;
};

// Sent messages for configuration support
typedef struct UBX_CFG_CFG ubx_cfg_cfg_t;
typedef struct UBX_CFG_MSG ubx_cfg_msg_t;
typedef struct UBX_CFG_NAV5 ubx_cfg_nav5_t;
typedef struct UBX_CFG_PRT ubx_cfg_prt_t;
typedef struct UBX_CFG_PRT_POLL ubx_cfg_prt_poll_t;
typedef struct UBX_CFG_RATE ubx_cfg_rate_t;
typedef struct UBX_CFG_SBAS ubx_cfg_sbas_t;
typedef struct UBXSendHeader UBXSendHeader_t;
typedef struct UBXSendPacket UBXSendPacket_t;


// GPS_AUTO_CONFIG end


int parse_ubx(uint8_t);
struct GPS_VALUES* get_gps_values_ptr(void);

#ifdef GPS_AUTO_CONFIG
boolean GPSAutoConfigStateMachine(void);
#endif // GPS_AUTO_CONFIG


#endif /* GPS_UBX_H */

#endif // GPS_OPTION
