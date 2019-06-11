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

#include "GPS_UBX.h"

//#define FIRST_POLL

#define TRUE			1
#define FALSE			0


static char gps_rx_buffer[sizeof(struct UBXPacket)];
static struct GPS_VALUES GPSValues;
static struct GPS_RX_STATS gpsRxStats;


#ifdef GPS_AUTO_CONFIG


#define GPS_WAIT_IDLE_TIME		200
#define GPS_WAIT_REACTION_TIME		200


typedef enum {
  GPS_AUTO_CONFIG_READY,						// ready state
  GPS_AUTO_CONFIG_IDLE,							// idle state
  GPS_AUTO_CONFIG_NEXT_BAUD_RATE,					// next baud rate state
  GPS_AUTO_CONFIG_NEXT_BAUD_RATE_POLL,					// next baud rate poll state
  GPS_AUTO_CONFIG_WAIT,							// wait state
  GPS_AUTO_CONFIG_WAIT_ACK,						// wait ack state
  GPS_AUTO_CONFIG_SET_NAV5,
  GPS_AUTO_CONFIG_SET_SBAS,
  GPS_AUTO_CONFIG_SET_MSG,
  GPS_AUTO_CONFIG_SET_RATE,
  GPS_AUTO_CONFIG_SET_CFG,
} GPS_Auto_Config_State_t;

typedef struct {
    GPS_Auto_Config_State_t state;
    unsigned long last_action;
    uint32_t baudRate;
    uint32_t baudRateGoal;
    boolean ack_received;
    int8_t  lastConfigSent;				// index of last configuration string sent
    struct UBX_ACK_ACK requiredAck;			// class and message ID we are waiting for an ACK from GPS
    struct {
        union {
            struct {
                UBXSendPacket_t working_packet;		// outbound "buffer"
            };
        };
    };
} status_t;

static volatile status_t *volatile status = 0;

uint8_t msg_config_ubx[] = {
  UBX_ID_NAV_DOP,
  UBX_ID_NAV_SOL,
  UBX_ID_NAV_POSLLH,
  UBX_ID_NAV_VELNED,
};


#endif // GPS_AUTO_CONFIG


// Keep track of various GPS messages needed to make up a single UAVO update
// time-of-week timestamp is used to correlate matching messages

#define POSLLH_RECEIVED (1 << 0)
#define STATUS_RECEIVED (1 << 1)
#define DOP_RECEIVED    (1 << 2)
#define VELNED_RECEIVED (1 << 3)
#define SOL_RECEIVED    (1 << 4)
#define ALL_RECEIVED    (DOP_RECEIVED | SOL_RECEIVED | POSLLH_RECEIVED | VELNED_RECEIVED)
#define NONE_RECEIVED   0

static struct msgtracker {
    uint32_t currentTOW;   // TOW of the message set currently in progress
    uint8_t  msg_received; // keep track of received message types
} msgtracker;

// Check if a message belongs to the current data set and register it as 'received'
bool check_msgtracker(uint32_t tow, uint8_t msg_flag)
{
    if (tow > msgtracker.currentTOW ? true 				// start of a new message set
        : (msgtracker.currentTOW - tow > 6 * 24 * 3600 * 1000)) {	// 6 days, TOW wrap around occured
        msgtracker.currentTOW   = tow;
        msgtracker.msg_received = NONE_RECEIVED;
    } else if (tow < msgtracker.currentTOW) {				// message outdated (don't process)
        return false;
    }

    msgtracker.msg_received |= msg_flag;				// register reception of this msg type
    return true;
}


void parse_ubx_nav_dop(struct UBX_NAV_DOP *dop)
{
    if (check_msgtracker(dop->iTOW, DOP_RECEIVED)) {
        GPSValues.hDOP = dop->hDOP;
    }
}


void parse_ubx_nav_sol(struct UBX_NAV_SOL *sol)
{
    if (check_msgtracker(sol->iTOW, SOL_RECEIVED)) {
        GPSValues.Satellites = sol->numSV;
        if (sol->flags & STATUS_FLAGS_GPSFIX_OK) {
            switch (sol->gpsFix) {
            case STATUS_GPSFIX_2DFIX:
                GPSValues.Status = GPSPOSITIONSENSOR_STATUS_FIX2D;
                break;
            case STATUS_GPSFIX_3DFIX:
                GPSValues.Status = GPSPOSITIONSENSOR_STATUS_FIX3D;
                break;
            default: GPSValues.Status = GPSPOSITIONSENSOR_STATUS_NOFIX;
            }
        } else { // fix is not valid so we make sure to treat it as NOFIX
            GPSValues.Status = GPSPOSITIONSENSOR_STATUS_NOFIX;
        }
    }
}


void parse_ubx_nav_posllh(struct UBX_NAV_POSLLH *posllh)
{
    if (check_msgtracker(posllh->iTOW, POSLLH_RECEIVED)) {
        if (GPSValues.Status != GPSPOSITIONSENSOR_STATUS_NOFIX) {
            GPSValues.Altitude  = posllh->hMSL;					//(float)posllh->hMSL * 0.001f;
            GPSValues.Latitude  = posllh->lat;					//(float)posllh->lat / 10000000.0;
            GPSValues.Longitude = posllh->lon;					//(float)posllh->lon / 10000000.0;
        }
    }
}


void parse_ubx_nav_velned(struct UBX_NAV_VELNED *velned)
{
    if (check_msgtracker(velned->iTOW, VELNED_RECEIVED)) {
        if (GPSValues.Status != GPSPOSITIONSENSOR_STATUS_NOFIX) {
            GPSValues.Down        = velned->velD;				//(float)velned->velD / 100.0f;
            GPSValues.Speed3D     = velned->speed;				//(float)velned->speed * 0.01f;
            GPSValues.Speed2D     = velned->gSpeed;				//(float)velned->gSpeed * 0.01f;
            GPSValues.Heading     = velned->heading;				//(float)velned->heading * 1.0e-5f;
        }
    }
}


#ifdef GPS_AUTO_CONFIG

void parse_ubx_ack_ack(struct UBX_ACK_ACK *ackack)
{
  if (status->requiredAck.clsID == ackack->clsID && status->requiredAck.msgID == ackack->msgID)
    status->ack_received = TRUE;
}

#endif // GPS_AUTO_CONFIG


bool checksum_ubx_message(struct UBXPacket *ubx)
{
    int i;
    uint8_t ck_a, ck_b;

    ck_a  = ubx->header.class_nav;
    ck_b  = ck_a;

    ck_a += ubx->header.id;
    ck_b += ck_a;

    ck_a += ubx->header.len & 0xff;
    ck_b += ck_a;

    ck_a += ubx->header.len >> 8;
    ck_b += ck_a;

    for (i = 0; i < ubx->header.len; i++) {
        ck_a += ubx->payload.payload[i];
        ck_b += ck_a;
    }

    if (ubx->header.ck_a == ck_a &&
        ubx->header.ck_b == ck_b) {
        return true;
    } else {
        return false;
    }
}


// UBX message parser
void parse_ubx_message(struct UBXPacket *ubx)
{
    switch (ubx->header.class_nav) {
      case UBX_CLASS_NAV:
        switch (ubx->header.id) {
          case UBX_ID_NAV_DOP:
            parse_ubx_nav_dop(&ubx->payload.nav_dop);
          break;
          case UBX_ID_NAV_SOL:
            parse_ubx_nav_sol(&ubx->payload.nav_sol);
          break;
          case UBX_ID_NAV_POSLLH:
            parse_ubx_nav_posllh(&ubx->payload.nav_posllh);
          break;
          case UBX_ID_NAV_VELNED:
            parse_ubx_nav_velned(&ubx->payload.nav_velned);
          break;
        }
      break;
#ifdef GPS_AUTO_CONFIG
      case UBX_CLASS_ACK:
        switch (ubx->header.id) {
          case UBX_ID_ACK_ACK:
            parse_ubx_ack_ack(&ubx->payload.ack_ack);
          break;
        }
      break;
#endif // GPS_AUTO_CONFIG
    }
}


// parse incoming character stream for messages in UBX binary format
int parse_ubx_stream(uint8_t c, char *gps_rx_buffer, struct GPS_RX_STATS *gpsRxStats)
{
    enum proto_states {
        START,
        UBX_SY2,
        UBX_CLASS,
        UBX_ID,
        UBX_LEN1,
        UBX_LEN2,
        UBX_PAYLOAD,
        UBX_CHK1,
        UBX_CHK2,
        FINISHED
    };

    static enum proto_states proto_state = START;
    static uint8_t rx_count = 0;
    struct UBXPacket *ubx   = (struct UBXPacket *)gps_rx_buffer;

    switch (proto_state) {
    case START:							// detect protocol
        if (c == UBX_SYNC1) {					// first UBX sync char found
            proto_state = UBX_SY2;
        }
        break;
    case UBX_SY2:
        if (c == UBX_SYNC2) {					// second UBX sync char found
            proto_state = UBX_CLASS;
        } else {
            proto_state = START;				// reset state
        }
        break;
    case UBX_CLASS:
        ubx->header.class_nav = c;
        proto_state      = UBX_ID;
        break;
    case UBX_ID:
        ubx->header.id   = c;
        proto_state      = UBX_LEN1;
        break;
    case UBX_LEN1:
        ubx->header.len  = c;
        proto_state      = UBX_LEN2;
        break;
    case UBX_LEN2:
        ubx->header.len += (c << 8);
        if (ubx->header.len > sizeof(UBXPayload)) {
            gpsRxStats->gpsRxOverflow++;
            proto_state = START;
        } else {
            rx_count    = 0;
            proto_state = UBX_PAYLOAD;
        }
        break;
    case UBX_PAYLOAD:
        if (rx_count < ubx->header.len) {
            ubx->payload.payload[rx_count] = c;
            if (++rx_count == ubx->header.len) {
                proto_state = UBX_CHK1;
            }
        } else {
            gpsRxStats->gpsRxOverflow++;
            proto_state = START;
        }
        break;
    case UBX_CHK1:
        ubx->header.ck_a = c;
        proto_state = UBX_CHK2;
        break;
    case UBX_CHK2:
        ubx->header.ck_b = c;
        if (checksum_ubx_message(ubx)) {			// message complete and valid
            parse_ubx_message(ubx);
            proto_state = FINISHED;
        } else {
            gpsRxStats->gpsRxChkSumError++;
            proto_state = START;
        }
        break;
    default: break;
    }

    if (proto_state == START) {
        return PARSER_ERROR;					// parser couldn't use this byte
    } else if (proto_state == FINISHED) {
        gpsRxStats->gpsRxReceived++;
        proto_state = START;
	if (msgtracker.msg_received == ALL_RECEIVED) {
		msgtracker.msg_received = NONE_RECEIVED;
		return PARSER_COMPLETE_SET;			// message set complete & processed
	} else {
		return PARSER_COMPLETE;				// message complete & processed
	}
    }

    return PARSER_INCOMPLETE;					// message not (yet) complete
}


#ifdef GPS_AUTO_CONFIG

static void append_checksum_ubx_message(UBXSendPacket_t *packet)
{
    uint8_t i;
    uint8_t ck_a = 0;
    uint8_t ck_b = 0;
    uint16_t len = packet->message.header.len + sizeof(UBXSendHeader_t);

    for (i = 2; i < len; i++) {
        ck_a += packet->buffer[i];
        ck_b += ck_a;
    }

    packet->buffer[len]     = ck_a;
    packet->buffer[len + 1] = ck_b;
}


/**
 * prepare a packet to be send, fill the header and append the checksum.
 * return the total packet lenght comprising header and checksum
 */
static uint16_t prepare_packet(UBXSendPacket_t *packet, uint8_t clsID, uint8_t msgID, uint16_t len)
{
    packet->message.header.prolog[0] = UBX_SYNC1;
    packet->message.header.prolog[1] = UBX_SYNC2;
    packet->message.header.class_nav = clsID;
    packet->message.header.id  = msgID;
    packet->message.header.len = len;
	
    append_checksum_ubx_message(packet);

    status->requiredAck.clsID  = clsID;
    status->requiredAck.msgID  = msgID;

    return len + sizeof(UBXSendHeader_t) + 2;		// payload + header + checksum
}


// CFG-PRT -  06 00 14 00    01 00 00 00 D0 08 00 00 00 96 00 00 01 00 01 00 00 00 00 00
static void config_gps_prt(uint16_t *bytes_to_send)
{
    memset((uint8_t *)status->working_packet.buffer, 0, sizeof(UBXSendHeader_t) + sizeof(ubx_cfg_prt_t));

    status->working_packet.message.payload.cfg_prt.portID       = 1;				// 1 = UART1
    status->working_packet.message.payload.cfg_prt.mode         = UBX_CFG_PRT_MODE_DEFAULT;	// 8 databits, 1 stopbit, no parity, non-zero reserved
    status->working_packet.message.payload.cfg_prt.baudRate     = status->baudRateGoal;		// baud rate goal
    status->working_packet.message.payload.cfg_prt.inProtoMask  = 1;				// 1 = UBX only (bit 0)
    status->working_packet.message.payload.cfg_prt.outProtoMask = 1;				// 1 = UBX only (bit 0)

    *bytes_to_send = prepare_packet((UBXSendPacket_t *)&status->working_packet, UBX_CLASS_CFG, UBX_ID_CFG_PRT, sizeof(ubx_cfg_prt_t));
}


#ifdef FIRST_POLL
static void config_gps_prt_poll(uint16_t *bytes_to_send)
{
    memset((uint8_t *)status->working_packet.buffer, 0, sizeof(UBXSendHeader_t) + sizeof(ubx_cfg_prt_poll_t));

    status->working_packet.message.payload.cfg_prt.portID       = 1;				// 1 = UART1

    *bytes_to_send = prepare_packet((UBXSendPacket_t *)&status->working_packet, UBX_CLASS_CFG, UBX_ID_CFG_PRT, sizeof(ubx_cfg_prt_poll_t));
}
#endif // FIRST_POLL


// CFG-NAV5 - 06 24 24 00    FF FF 06 03 00 00 00 00 10 27 00 00 05 00 FA 00 FA 00 64 00 2C 01 00 3C 00 00 00 00 00 00 00 00 00 00 00 00
static void config_nav5(uint16_t *bytes_to_send)
{
    memset((uint8_t *)status->working_packet.buffer, 0, sizeof(UBXSendHeader_t) + sizeof(ubx_cfg_nav5_t));

    status->working_packet.message.payload.cfg_nav5.mask	= 0xFFFF;
    status->working_packet.message.payload.cfg_nav5.dynModel	= 6;		// airborne with < 1g acceleration
    status->working_packet.message.payload.cfg_nav5.fixMode	= 3;		// 1 = 2D only, 2 = 3D only, 3 = auto 2D/3D
    status->working_packet.message.payload.cfg_nav5.fixedAltVar	= 10000;
    status->working_packet.message.payload.cfg_nav5.minElev	= 5;
    status->working_packet.message.payload.cfg_nav5.pDop	= 250;
    status->working_packet.message.payload.cfg_nav5.tDop	= 250;
    status->working_packet.message.payload.cfg_nav5.pAcc	= 100;
    status->working_packet.message.payload.cfg_nav5.tAcc	= 300;
    status->working_packet.message.payload.cfg_nav5.dgpsTimeOut	= 60;

    *bytes_to_send = prepare_packet((UBXSendPacket_t *)&status->working_packet, UBX_CLASS_CFG, UBX_ID_CFG_NAV5, sizeof(ubx_cfg_nav5_t));
}


// CFG-SBAS - 06 16 08 00    01 03 03 00 51 08 00 00
static void config_sbas(uint16_t *bytes_to_send)
{
    memset((uint8_t *)status->working_packet.buffer, 0, sizeof(UBXSendHeader_t) + sizeof(ubx_cfg_sbas_t));

    status->working_packet.message.payload.cfg_sbas.mode	= UBX_CFG_SBAS_MODE_ENABLED;
    status->working_packet.message.payload.cfg_sbas.usage	= UBX_CFG_SBAS_USAGE_RANGE | UBX_CFG_SBAS_USAGE_DIFFCORR;
    status->working_packet.message.payload.cfg_sbas.maxSBAS	= 3;
    status->working_packet.message.payload.cfg_sbas.scanmode2	= UBX_CFG_SBAS_SCANMODE2;
    status->working_packet.message.payload.cfg_sbas.scanmode1	= UBX_CFG_SBAS_SCANMODE1_EGNOS;

    *bytes_to_send = prepare_packet((UBXSendPacket_t *)&status->working_packet, UBX_CLASS_CFG, UBX_ID_CFG_SBAS, sizeof(ubx_cfg_sbas_t));
}


// CFG-MSG -  06 01 03 00    01 04 01		// DOP
// CFG-MSG -  06 01 03 00    01 06 01		// SOL
// CFG-MSG -  06 01 03 00    01 02 01		// POSLLH
// CFG-MSG -  06 01 03 00    01 12 01		// VELNED
static void config_msg(uint16_t *bytes_to_send)
{
    memset((uint8_t *)status->working_packet.buffer, 0, sizeof(UBXSendHeader_t) + sizeof(ubx_cfg_msg_t));

    status->working_packet.message.payload.cfg_msg.msgClass	= UBX_CLASS_NAV;
    status->working_packet.message.payload.cfg_msg.msgID	= msg_config_ubx[status->lastConfigSent];
    status->working_packet.message.payload.cfg_msg.rate		= 1;

    *bytes_to_send = prepare_packet((UBXSendPacket_t *)&status->working_packet, UBX_CLASS_CFG, UBX_ID_CFG_MSG, sizeof(ubx_cfg_msg_t));
}


// CFG-RATE - 06 08 06 00    C8 00 01 00 01 00
static void config_rate(uint16_t *bytes_to_send)
{
    memset((uint8_t *)status->working_packet.buffer, 0, sizeof(UBXSendHeader_t) + sizeof(ubx_cfg_rate_t));

    status->working_packet.message.payload.cfg_rate.measRate 	= 200;	// ms -> 5 Hz
    status->working_packet.message.payload.cfg_rate.navRate  	= 1;	// must be set to 1
    status->working_packet.message.payload.cfg_rate.timeRef  	= 1;	// 0 = UTC Time, 1 = GPS Time

    *bytes_to_send = prepare_packet((UBXSendPacket_t *)&status->working_packet, UBX_CLASS_CFG, UBX_ID_CFG_RATE, sizeof(ubx_cfg_rate_t));
}


// CFG-CFG - 06 09 0D 00    14 07 00 00 0B 00 00 00 00 00 00 00 01
static void config_cfg(uint16_t *bytes_to_send)
{
    memset((uint8_t *)status->working_packet.buffer, 0, sizeof(UBXSendHeader_t) + sizeof(ubx_cfg_cfg_t));

    status->working_packet.message.payload.cfg_cfg.clearMask	= UBX_CFG_CFG_CLEAR_SETTINGS;
    status->working_packet.message.payload.cfg_cfg.saveMask	= UBX_CFG_CFG_STORE_SETTINGS;
    status->working_packet.message.payload.cfg_cfg.deviceMask	= UBX_CFG_CFG_DEVICE_BBR;	// only battery buffered, because we do it at every power up (not to stress the EEPROM, FLASH)

    *bytes_to_send = prepare_packet((UBXSendPacket_t *)&status->working_packet, UBX_CLASS_CFG, UBX_ID_CFG_CFG, sizeof(ubx_cfg_cfg_t));
}


/**
 * @brief  GPS auto config state machine
 */
boolean GPSAutoConfigStateMachine(void)
{
  static status_t a_c_status;
  static int8_t baud_array_index = -1;
  static long baud_array[] = {
    9600,
    38400,
    57600,
    14400,
    19200,
    28800,
    115200
  };
  uint16_t bytes_to_send = 0;

  if (!status) {
    status = &a_c_status;
    memset((status_t *)status, 0, sizeof(status_t));
    status->state = GPS_AUTO_CONFIG_IDLE;
    status->last_action = millis();
    status->baudRateGoal = GPS_BAUD_RATE;
    status->lastConfigSent = 0;
  }

  switch (status->state) {
    case GPS_AUTO_CONFIG_READY:
    break;
    
    case GPS_AUTO_CONFIG_IDLE:
      if ((status->last_action + GPS_WAIT_IDLE_TIME) < millis()) {
        status->state = GPS_AUTO_CONFIG_NEXT_BAUD_RATE;
        status->last_action = millis();
      }
    break;
      
    case GPS_AUTO_CONFIG_NEXT_BAUD_RATE:
      baud_array_index++;
      if (baud_array_index >= sizeof(baud_array) / sizeof(baud_array[0]))
	baud_array_index = 0;
      status->baudRate = baud_array[baud_array_index];
      Serial.end();
      config_gps_prt(&bytes_to_send);
      Serial.begin(status->baudRate);
#ifdef FIRST_POLL
      status->state = GPS_AUTO_CONFIG_NEXT_BAUD_RATE_POLL;
#else // FIRST_POLL
      status->state = GPS_AUTO_CONFIG_WAIT;
#endif // FIRST_POLL
      status->last_action = millis();
    break;
#ifdef FIRST_POLL
    case GPS_AUTO_CONFIG_NEXT_BAUD_RATE_POLL:
      config_gps_prt_poll(&bytes_to_send);
      status->state = GPS_AUTO_CONFIG_WAIT;
      status->last_action = millis();
    break;
#endif // FIRST_POLL
    case GPS_AUTO_CONFIG_WAIT:
      if ((status->last_action + GPS_WAIT_REACTION_TIME) < millis()) {
        Serial.end();
        config_gps_prt(&bytes_to_send);
        Serial.begin(status->baudRateGoal);
        status->state = GPS_AUTO_CONFIG_WAIT_ACK;
        status->ack_received = FALSE;
        status->last_action = millis();
      }
    break;
    case GPS_AUTO_CONFIG_WAIT_ACK:
      if ((status->last_action + GPS_WAIT_REACTION_TIME) < millis()) {
        status->state = GPS_AUTO_CONFIG_NEXT_BAUD_RATE;
        status->last_action = millis();
      }
      if (status->ack_received) {
        status->state = GPS_AUTO_CONFIG_SET_NAV5;
        status->ack_received = FALSE;
      }
    break;
      
    case GPS_AUTO_CONFIG_SET_NAV5:
      if ((status->last_action + GPS_WAIT_REACTION_TIME) < millis()) {
        config_nav5(&bytes_to_send);
        status->last_action = millis();
      }
      if (status->ack_received) {
        status->state = GPS_AUTO_CONFIG_SET_SBAS;
        status->ack_received = FALSE;
      }
    break;
    case GPS_AUTO_CONFIG_SET_SBAS:
      if ((status->last_action + GPS_WAIT_REACTION_TIME) < millis()) {
        config_sbas(&bytes_to_send);
        status->last_action = millis();
      }
      if (status->ack_received) {
        status->state = GPS_AUTO_CONFIG_SET_MSG;
        status->ack_received = FALSE;
      }
    break;
    case GPS_AUTO_CONFIG_SET_MSG:
      if ((status->last_action + GPS_WAIT_REACTION_TIME) < millis()) {
        config_msg(&bytes_to_send);
        status->last_action = millis();
      }
      if (status->ack_received) {
	status->lastConfigSent++;
	if (status->lastConfigSent >= sizeof(msg_config_ubx) / sizeof(msg_config_ubx[0]))
          status->state = GPS_AUTO_CONFIG_SET_RATE;
        status->ack_received = FALSE;
      }
    break;
    case GPS_AUTO_CONFIG_SET_RATE:
      if ((status->last_action + GPS_WAIT_REACTION_TIME) < millis()) {
        config_rate(&bytes_to_send);
        status->last_action = millis();
      }
      if (status->ack_received) {
        status->state = GPS_AUTO_CONFIG_SET_CFG;
        status->ack_received = FALSE;
      }
    break;
    case GPS_AUTO_CONFIG_SET_CFG:
      if ((status->last_action + GPS_WAIT_REACTION_TIME) < millis()) {
	config_cfg(&bytes_to_send);
        status->last_action = millis();
      }
      if (status->ack_received) {
        status->state = GPS_AUTO_CONFIG_READY;
        status->ack_received = FALSE;
      }
    break;
  }
  
  if (bytes_to_send)
    Serial.write((uint8_t*)status->working_packet.buffer, bytes_to_send);
  
  return (status->state == GPS_AUTO_CONFIG_READY);
}

#endif // GPS_AUTO_CONFIG


// wrapper und getter

int parse_ubx(uint8_t c)
{
    return parse_ubx_stream(c, gps_rx_buffer, &gpsRxStats);
}

struct GPS_VALUES* get_gps_values_ptr(void)
{
    return &GPSValues;
}

#endif // GPS_OPTION
