/**
 *
 * @author     Joerg-D. Rothfuchs
 * @brief      Implements 3Digi to FrSky SmartPort converter.
 * @see        (C) by Joerg-D. Rothfuchs aka JR / JR63
 * @see        Version v1.00 - 2018/11/05
 *
 *             Usage at your own risk! No warranty for anything!
 *
 *****************************************************************************/


#define BOARD_LED_MASK		0x20
#define BOARD_LED_LO		DDRB |= BOARD_LED_MASK; \
				PORTB &= ~BOARD_LED_MASK;
#define BOARD_LED_HI		DDRB |= BOARD_LED_MASK; \
				PORTB |= BOARD_LED_MASK;
				
#define DEBUG_PIN_MASK		0x40
#define DEBUG_PIN_LO		DDRD |= DEBUG_PIN_MASK; \
				PORTD &= ~DEBUG_PIN_MASK;
#define DEBUG_PIN_HI		DDRD |= DEBUG_PIN_MASK; \
				PORTD |= DEBUG_PIN_MASK;


#define SERIAL_BAUD_RATE	115200


//#define CRC_USE_TABLE


#define REQUEST_FRAME_ID_GET_VERSION		0x10
#define REQUEST_FRAME_ID_GET_VALUE_SET		0x11
#define REQUEST_FRAME_ID_SET_VALUE		0x12
#define REQUEST_FRAME_ID_SAVE_PARAMETER		0x13


#define TD_COMMAND_GET				0x20
#define TD_COMMAND_SET				0x21
#define TD_COMMAND_SAVE				0x28
#define TD_COMMAND_GET_VERSION			0x2D


#define SPECIAL_VERSION				1
#define SPECIAL_SERIAL_PART_1			2
#define SPECIAL_SERIAL_PART_2			3
#define SPECIAL_SERIAL_PART_3			4
#define SPECIAL_SAVE_RESPONSE			5


#define SERIAL_HI_BYTE(value)			(uint8_t)((value >> 8) & 0x00ff)
#define SERIAL_LO_BYTE(value)			(uint8_t)((value     ) & 0x00ff)


#define SERIAL_END_OF_FRAME			0x7A
#define SERIAL_ESCAPE				0x7B
#define SERIAL_XOR				0x80


#include "FrSkySportSensor.h"
#include "FrSkySportBidirectional.h"
#include "FrSkySportSensor3DigiRx.h"
#include "FrSkySportSensor3DigiTx.h"
#include "FrSkySportSingleWireSerial.h"
#if !defined(__MK20DX128__) && !defined(__MK20DX256__) && !defined(__MKL26Z64__) && !defined(__MK66FX1M0__) && !defined(__MK64FX512__)
#include "SoftwareSerial.h"
#endif


enum TDQueueStates { 
	READY_FOR_SEND,
	WAIT_FOR_RESPONSE
};


struct TDQueueData_t {
	uint8_t command;
	uint16_t parameter;
	uint16_t value;
};


FrSkySportBidirectional bidirectional;                 	// Create bidirectional object
FrSkySportSensor3DigiRx digiRx;				// Create 3Digi Rx sensor with default ID
FrSkySportSensor3DigiTx digiTx;				// Create 3Digi Tx sensor with default ID


/*
CRC:	CRC8_MAXIM
		Input reflected		yes
		Result reflected	yes
		Polynom:		0x31
		Ininitial Value:	0x00
		Final Xor Value:	0x00
*/

#if defined(CRC_USE_TABLE)
static uint8_t crc_table[256] =
{
    0x00, 0x5e, 0xbc, 0xe2, 0x61, 0x3f, 0xdd, 0x83,
    0xc2, 0x9c, 0x7e, 0x20, 0xa3, 0xfd, 0x1f, 0x41,
    0x9d, 0xc3, 0x21, 0x7f, 0xfc, 0xa2, 0x40, 0x1e,
    0x5f, 0x01, 0xe3, 0xbd, 0x3e, 0x60, 0x82, 0xdc,
    0x23, 0x7d, 0x9f, 0xc1, 0x42, 0x1c, 0xfe, 0xa0,
    0xe1, 0xbf, 0x5d, 0x03, 0x80, 0xde, 0x3c, 0x62,
    0xbe, 0xe0, 0x02, 0x5c, 0xdf, 0x81, 0x63, 0x3d,
    0x7c, 0x22, 0xc0, 0x9e, 0x1d, 0x43, 0xa1, 0xff,
    0x46, 0x18, 0xfa, 0xa4, 0x27, 0x79, 0x9b, 0xc5,
    0x84, 0xda, 0x38, 0x66, 0xe5, 0xbb, 0x59, 0x07,
    0xdb, 0x85, 0x67, 0x39, 0xba, 0xe4, 0x06, 0x58,
    0x19, 0x47, 0xa5, 0xfb, 0x78, 0x26, 0xc4, 0x9a,
    0x65, 0x3b, 0xd9, 0x87, 0x04, 0x5a, 0xb8, 0xe6,
    0xa7, 0xf9, 0x1b, 0x45, 0xc6, 0x98, 0x7a, 0x24,
    0xf8, 0xa6, 0x44, 0x1a, 0x99, 0xc7, 0x25, 0x7b,
    0x3a, 0x64, 0x86, 0xd8, 0x5b, 0x05, 0xe7, 0xb9,
    0x8c, 0xd2, 0x30, 0x6e, 0xed, 0xb3, 0x51, 0x0f,
    0x4e, 0x10, 0xf2, 0xac, 0x2f, 0x71, 0x93, 0xcd,
    0x11, 0x4f, 0xad, 0xf3, 0x70, 0x2e, 0xcc, 0x92,
    0xd3, 0x8d, 0x6f, 0x31, 0xb2, 0xec, 0x0e, 0x50,
    0xaf, 0xf1, 0x13, 0x4d, 0xce, 0x90, 0x72, 0x2c,
    0x6d, 0x33, 0xd1, 0x8f, 0x0c, 0x52, 0xb0, 0xee,
    0x32, 0x6c, 0x8e, 0xd0, 0x53, 0x0d, 0xef, 0xb1,
    0xf0, 0xae, 0x4c, 0x12, 0x91, 0xcf, 0x2d, 0x73,
    0xca, 0x94, 0x76, 0x28, 0xab, 0xf5, 0x17, 0x49,
    0x08, 0x56, 0xb4, 0xea, 0x69, 0x37, 0xd5, 0x8b,
    0x57, 0x09, 0xeb, 0xb5, 0x36, 0x68, 0x8a, 0xd4,
    0x95, 0xcb, 0x29, 0x77, 0xf4, 0xaa, 0x48, 0x16,
    0xe9, 0xb7, 0x55, 0x0b, 0x88, 0xd6, 0x34, 0x6a,
    0x2b, 0x75, 0x97, 0xc9, 0x4a, 0x14, 0xf6, 0xa8,
    0x74, 0x2a, 0xc8, 0x96, 0x15, 0x4b, 0xa9, 0xf7,
    0xb6, 0xe8, 0x0a, 0x54, 0xd7, 0x89, 0x6b, 0x35,
};
#endif // CRC_USE_TABLE


#define BUF_SIZE		50
uint8_t buf[BUF_SIZE];
uint8_t* bufptr = buf;


#define TD_SEND_QUEUE_DEPTH	64
uint8_t  TDQueueState = READY_FOR_SEND;
uint8_t  TDSendQueueLastCommand = 0;
uint16_t TDSendQueueLastParameter = 0;
uint8_t  TDSendQueueIn  = 0;
uint8_t  TDSendQueueOut = 0;
uint8_t  TDSendQueueCnt = 0;
struct TDQueueData_t TDSendQueue[TD_SEND_QUEUE_DEPTH];


#if !defined(CRC_USE_TABLE)
/**
 * @brief  Calculate CRC bits
 */
uint8_t crc_bits(uint8_t data)
{
    uint8_t crc = 0;
    if (data & 0x01) crc ^= 0x5e;
    if (data & 0x02) crc ^= 0xbc;
    if (data & 0x04) crc ^= 0x61;
    if (data & 0x08) crc ^= 0xc2;
    if (data & 0x10) crc ^= 0x9d;
    if (data & 0x20) crc ^= 0x23;
    if (data & 0x40) crc ^= 0x46;
    if (data & 0x80) crc ^= 0x8c;
    return crc;
}
#endif // CRC_USE_TABLE


/**
 * @brief  Calculate CRC
 */
uint8_t calcCRC(uint8_t *crc, uint8_t b)
{
#if defined(CRC_USE_TABLE)
	*crc = crc_table[b ^ *crc];
#else // CRC_USE_TABLE
	*crc = crc_bits(b ^ *crc);
#endif // CRC_USE_TABLE
	return b;
}


/**
 * @brief  Check CRC
 */
bool checkCRC(uint8_t* bptr, uint8_t len)
{
	bool ret;
	
	uint8_t crc = 0;
	for (int i = 0; i < len; i++) {
#if defined(CRC_USE_TABLE)
		crc = crc_table[*bptr++ ^ crc];
#else // CRC_USE_TABLE
		crc = crc_bits(*bptr++ ^ crc);
#endif // CRC_USE_TABLE
	}
	
	ret  = *bptr++ == crc;
	ret &= *bptr++ == SERIAL_END_OF_FRAME;
	return ret;
}


/**
 * @brief  Serial escaping
 */
void serialEscape(uint8_t b)
{
	if (b == SERIAL_END_OF_FRAME) {
		Serial.write(SERIAL_ESCAPE);
		Serial.write(b ^ SERIAL_XOR);
	} else if (b == SERIAL_ESCAPE) {
		Serial.write(SERIAL_ESCAPE);
		Serial.write(b ^ SERIAL_XOR);
	} else {
		Serial.write(b);
	}
}


/**
 * @brief  Send 3Digi get frame
 */
void sendTDGet(uint16_t param)
{
	uint8_t crc = 0x00;
	
	Serial.write(calcCRC(&crc, TD_COMMAND_GET));
	
	serialEscape(calcCRC(&crc, SERIAL_LO_BYTE(param)));
	serialEscape(calcCRC(&crc, SERIAL_HI_BYTE(param)));
	serialEscape(crc);
	
	Serial.write(SERIAL_END_OF_FRAME);
}


/**
 * @brief  Send 3Digi set frame
 */
void sendTDSet(uint16_t param, uint32_t value)
{
	uint8_t crc = 0x00;
	
	Serial.write(calcCRC(&crc, TD_COMMAND_SET));
	
	serialEscape(calcCRC(&crc, SERIAL_LO_BYTE(param)));
	serialEscape(calcCRC(&crc, SERIAL_HI_BYTE(param)));
	switch (SERIAL_LO_BYTE(param)) {
		case 198:
		case 199:
		case 200:
		case 221:
			if (value <= 0xff) {
				serialEscape(calcCRC(&crc, 0x01));
				serialEscape(calcCRC(&crc, SERIAL_LO_BYTE(value)));
			} else if (value > 0x8000) {
				serialEscape(calcCRC(&crc, 0x02));
				serialEscape(calcCRC(&crc, SERIAL_LO_BYTE(value)));
				serialEscape(calcCRC(&crc, SERIAL_HI_BYTE(value)));
			} else {
				serialEscape(calcCRC(&crc, 0x03));
				serialEscape(calcCRC(&crc, SERIAL_LO_BYTE(value)));
				serialEscape(calcCRC(&crc, SERIAL_HI_BYTE(value)));
			}
		break;
		default:
			serialEscape(calcCRC(&crc, (value > 0x80) ? 0x00 : 0x01));
			serialEscape(calcCRC(&crc, SERIAL_LO_BYTE(value)));
		break;
	}
	serialEscape(crc);
	
	Serial.write(SERIAL_END_OF_FRAME);
}


/**
 * @brief  Send 3Digi save frame
 */
void sendTDSave(void)
{
	uint8_t crc = 0x00;
	
	Serial.write(calcCRC(&crc, TD_COMMAND_SAVE));
	
	serialEscape(crc);
	
	Serial.write(SERIAL_END_OF_FRAME);
}


/**
 * @brief  Send 3Digi get version frame
 */
void sendTDGetVersion(void)
{
	uint8_t crc = 0x00;
	
	Serial.write(calcCRC(&crc, TD_COMMAND_GET_VERSION));
	
	serialEscape(crc);
	
	Serial.write(SERIAL_END_OF_FRAME);
}


/**
 * @brief  Clear 3Digi Queue
 */
void clearTDQueue(void)
{
	TDQueueState = WAIT_FOR_RESPONSE;
	TDSendQueueLastCommand = 0;
	TDSendQueueLastParameter = 0;
	TDSendQueueIn  = 0;
	TDSendQueueOut = 0;
	TDSendQueueCnt = 0;
	TDQueueState = READY_FOR_SEND;
}


/**
 * @brief  Queue 3Digi command
 */
void queueTDCommand(uint8_t command, uint16_t parameter, uint32_t value)
{
	if (TDSendQueueCnt < TD_SEND_QUEUE_DEPTH) {
		TDSendQueueCnt++;
		TDSendQueue[TDSendQueueIn].command = command;
		TDSendQueue[TDSendQueueIn].parameter = parameter;
		TDSendQueue[TDSendQueueIn].value = value;
		TDSendQueueIn++;
		if (TDSendQueueIn >= TD_SEND_QUEUE_DEPTH)
			TDSendQueueIn = 0;
	}
}


/**
 * @brief  Dequeue 3Digi command
 */
void dequeueTDCommand(void)
{
	if (TDQueueState == READY_FOR_SEND && TDSendQueueCnt > 0) {
		TDSendQueueCnt--;
		TDQueueState = WAIT_FOR_RESPONSE;
		TDSendQueueLastCommand = TDSendQueue[TDSendQueueOut].command;
		TDSendQueueLastParameter = TDSendQueue[TDSendQueueOut].parameter;
		switch (TDSendQueue[TDSendQueueOut].command) {
			case TD_COMMAND_GET:
				sendTDGet(TDSendQueue[TDSendQueueOut].parameter);
			break;
			case TD_COMMAND_SET:
				sendTDSet(TDSendQueue[TDSendQueueOut].parameter, TDSendQueue[TDSendQueueOut].value);
			break;
			case TD_COMMAND_SAVE:
				sendTDSave();
			break;
			case TD_COMMAND_GET_VERSION:
				sendTDGetVersion();
			break;
			default:
			break;
		}
		TDSendQueueOut++;
		if (TDSendQueueOut >= TD_SEND_QUEUE_DEPTH)
			TDSendQueueOut = 0;
	}
}


/**
 * @brief  Handle 3Digi frame type SERIAL_END_OF_FRAME
 */
void handleTDFrameType_SERIAL_END_OF_FRAME(uint8_t* bptr)
{
	// seems to be the NOT OK frame
	
	// if the last command was a save then respond with not ok
	if (TDSendQueueLastCommand == TD_COMMAND_SAVE) {
		digiTx.queueData(SPECIAL_SAVE_RESPONSE, 0);
	}
	
	TDQueueState = READY_FOR_SEND;
}


/**
 * @brief  Handle 3Digi frame type 0xAA
 */
void handleTDFrameType_AA(uint8_t* bptr)
{
	// seems to be the OK frame
	
	// if the last command was a save then respond with ok
	if (TDSendQueueLastCommand == TD_COMMAND_SAVE) {
		digiTx.queueData(SPECIAL_SAVE_RESPONSE, 1);
	}
	
	TDQueueState = READY_FOR_SEND;
}


/**
 * @brief  Handle 3Digi frame type 0x00
 */
void handleTDFrameType_00(uint8_t* bptr)
{
	// seems to be the response to the get command frame for negative 7 bit values
	if (TDSendQueueLastCommand == TD_COMMAND_GET) {
		digiTx.queueData(TDSendQueueLastParameter, bptr[1]);
	}
	TDQueueState = READY_FOR_SEND;
}


/**
 * @brief  Handle 3Digi frame type 0x01
 */
void handleTDFrameType_01(uint8_t* bptr)
{
	// seems to be the response to the get command frame for positive 8 bit values
	if (TDSendQueueLastCommand == TD_COMMAND_GET) {
		digiTx.queueData(TDSendQueueLastParameter, bptr[1]);
	}
	TDQueueState = READY_FOR_SEND;
}


/**
 * @brief  Handle 3Digi frame type 0x02
 */
void handleTDFrameType_02(uint8_t* bptr)
{
	// seems to be the response to the get command frame for negative 15 bit values
	if (TDSendQueueLastCommand == TD_COMMAND_GET) {
		digiTx.queueData(TDSendQueueLastParameter, bptr[1] + (bptr[2] << 8));
	}
	TDQueueState = READY_FOR_SEND;
}


/**
 * @brief  Handle 3Digi frame type 0x03
 */
void handleTDFrameType_03(uint8_t* bptr)
{
	// seems to be the response to the get command frame for positive 16 bit values
	if (TDSendQueueLastCommand == TD_COMMAND_GET) {
		digiTx.queueData(TDSendQueueLastParameter, bptr[1] + (bptr[2] << 8));
	}
	TDQueueState = READY_FOR_SEND;
}


/**
 * @brief  Handle 3Digi frame type 0x05
 */
void handleTDFrameType_05(uint8_t* bptr)
{
	// ?
/*
13.149443249999999,Async Serial,' ' 	(0x20)		get
13.149530000000000,Async Serial,'218' 	(0xDA)		218
13.149616750000000,Async Serial,'0' 	(0x00)		0
13.149703750000000,Async Serial,+ 	(0x2B)		CRC
13.149790500000000,Async Serial,z 	(0x7A)		frame end

13.150277750000001,Async Serial,'5' 	(0x05)				Flug Info ?
13.150364500000000,Async Serial,'0' 	(0x00)		0
13.150451000000000,Async Serial,'0' 	(0x00)		0
13.150537750000000,Async Serial,'8' 	(0x08)		8
13.150624499999999,Async Serial,'0' 	(0x00)		0
13.150711250000001,Async Serial,'164' 	(0xA4)		CRC
13.150798000000000,Async Serial,z 	(0x7A)		frame end
*/
}


/**
 * @brief  Handle 3Digi frame type 0x31
 */
void handleTDFrameType_31(uint8_t* bptr)
{
	// seems to be the response to the get version frame
	if (TDSendQueueLastCommand == TD_COMMAND_GET_VERSION) {
		digiTx.queueData(SPECIAL_VERSION,       bptr[ 1] + ((uint32_t)bptr[ 2] << 8) + ((uint32_t)bptr[ 3] << 16));
		digiTx.queueData(SPECIAL_SERIAL_PART_1, bptr[ 5] + ((uint32_t)bptr[ 6] << 8) + ((uint32_t)bptr[ 7] << 16) + ((uint32_t)bptr[ 8] << 24));
		digiTx.queueData(SPECIAL_SERIAL_PART_2, bptr[ 9] + ((uint32_t)bptr[10] << 8) + ((uint32_t)bptr[11] << 16) + ((uint32_t)bptr[12] << 24));
		digiTx.queueData(SPECIAL_SERIAL_PART_3, bptr[13] + ((uint32_t)bptr[14] << 8) + ((uint32_t)bptr[15] << 16) + ((uint32_t)bptr[16] << 24));
	}
}


/**
 * @brief  SmartPort packet received: get version
 */
void receivedGetVersion(void)
{
	//clearTDQueue();
	//digiTx.clearQueue();
	
	// get firmware version
	queueTDCommand(TD_COMMAND_GET_VERSION, 0, 0);
}


/**
 * @brief  SmartPort packet received: get value set (aka get a set of values)
 */
void receivedGetValueSet(void)
{
	uint16_t paramset = digiRx.getAppId() & 0xff00;
	switch (digiRx.getAppId() & 0x00ff) {
		case 1:		// prepare for getting ValueSet 1
			queueTDCommand(TD_COMMAND_GET, 132 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 133 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 131 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 128 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 129 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 130 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 144 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 145 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 143 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 140 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 141 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 142 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 156 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 157 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 155 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 152 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 153 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 154 + paramset, 0);
		break;
		case 2:		// prepare for getting ValueSet 2
			queueTDCommand(TD_COMMAND_GET, 137 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 134 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 135 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 138 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 149 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 146 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 147 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 150 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 151 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 185 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 163 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 162 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 164 + paramset, 0);
		break;
		case 3:		// prepare for getting ValueSet 3
			queueTDCommand(TD_COMMAND_GET, 136 + paramset + 0x0000, 0);
			queueTDCommand(TD_COMMAND_GET, 136 + paramset + 0x0100, 0);
			queueTDCommand(TD_COMMAND_GET, 136 + paramset + 0x0200, 0);
			queueTDCommand(TD_COMMAND_GET, 136 + paramset + 0x0300, 0);
			queueTDCommand(TD_COMMAND_GET, 136 + paramset + 0x0400, 0);
			queueTDCommand(TD_COMMAND_GET, 136 + paramset + 0x0500, 0);
			queueTDCommand(TD_COMMAND_GET, 136 + paramset + 0x0600, 0);
			queueTDCommand(TD_COMMAND_GET, 136 + paramset + 0x0700, 0);
			queueTDCommand(TD_COMMAND_GET, 136 + paramset + 0x0800, 0);
		break;
		case 4:		// prepare for getting ValueSet 4
			queueTDCommand(TD_COMMAND_GET, 148 + paramset + 0x0000, 0);
			queueTDCommand(TD_COMMAND_GET, 148 + paramset + 0x0100, 0);
			queueTDCommand(TD_COMMAND_GET, 148 + paramset + 0x0200, 0);
			queueTDCommand(TD_COMMAND_GET, 148 + paramset + 0x0300, 0);
			queueTDCommand(TD_COMMAND_GET, 148 + paramset + 0x0400, 0);
			queueTDCommand(TD_COMMAND_GET, 148 + paramset + 0x0500, 0);
			queueTDCommand(TD_COMMAND_GET, 148 + paramset + 0x0600, 0);
			queueTDCommand(TD_COMMAND_GET, 148 + paramset + 0x0700, 0);
			queueTDCommand(TD_COMMAND_GET, 148 + paramset + 0x0800, 0);
		break;
		case 5:		// prepare for getting ValueSet 5
			queueTDCommand(TD_COMMAND_GET, 168 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 126 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 127 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 169 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 170 + paramset, 0);
		break;
		case 6:		// prepare for getting ValueSet 6
			queueTDCommand(TD_COMMAND_GET, 158 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 159 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 160 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 161 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 167 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 165 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 166 + paramset, 0);
		break;
		case 7:		// prepare for getting ValueSet 7
			queueTDCommand(TD_COMMAND_GET, 248 + paramset, 0);
		break;
		case 8:		// prepare for getting ValueSet 8
			queueTDCommand(TD_COMMAND_GET, 219 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 221 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 222 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 223 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 224 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 226 + paramset, 0);
			//queueTDCommand(TD_COMMAND_GET, 219 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 228 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 229 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 230 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 232 + paramset, 0);
		break;
		case 9:		// prepare for getting ValueSet 9
			queueTDCommand(TD_COMMAND_GET, 227 + paramset + 0x0000, 0);
			queueTDCommand(TD_COMMAND_GET, 227 + paramset + 0x0100, 0);
			queueTDCommand(TD_COMMAND_GET, 227 + paramset + 0x0200, 0);
			queueTDCommand(TD_COMMAND_GET, 227 + paramset + 0x0300, 0);
			queueTDCommand(TD_COMMAND_GET, 227 + paramset + 0x0400, 0);
			queueTDCommand(TD_COMMAND_GET, 227 + paramset + 0x0500, 0);
			queueTDCommand(TD_COMMAND_GET, 227 + paramset + 0x0600, 0);
			queueTDCommand(TD_COMMAND_GET, 227 + paramset + 0x0700, 0);
			queueTDCommand(TD_COMMAND_GET, 227 + paramset + 0x0800, 0);
		break;
		case 10:	// prepare for getting ValueSet 10
			queueTDCommand(TD_COMMAND_GET, 121 + paramset + 0x0000, 0);
			queueTDCommand(TD_COMMAND_GET, 121 + paramset + 0x0100, 0);
			queueTDCommand(TD_COMMAND_GET, 121 + paramset + 0x0200, 0);
			queueTDCommand(TD_COMMAND_GET, 196 + paramset, 0);
			//queueTDCommand(TD_COMMAND_GET, ??? + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 198 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 199 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET, 200 + paramset, 0);
		break;
		case 11:	// prepare for getting ValueSet 11
			queueTDCommand(TD_COMMAND_GET,  43 + paramset, 0);
			//queueTDCommand(TD_COMMAND_GET, ??? + paramset, 0);
			queueTDCommand(TD_COMMAND_GET,  44 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET,  45 + paramset, 0);
			queueTDCommand(TD_COMMAND_GET,  47 + paramset, 0);
		break;
		case 12:	// prepare for getting ValueSet 12
			queueTDCommand(TD_COMMAND_GET, 125 + paramset + 0x0000, 0);
			queueTDCommand(TD_COMMAND_GET, 125 + paramset + 0x0100, 0);
			queueTDCommand(TD_COMMAND_GET, 125 + paramset + 0x0200, 0);
			queueTDCommand(TD_COMMAND_GET, 123 + paramset + 0x0000, 0);
			queueTDCommand(TD_COMMAND_GET, 123 + paramset + 0x0100, 0);
			queueTDCommand(TD_COMMAND_GET, 123 + paramset + 0x0200, 0);
			queueTDCommand(TD_COMMAND_GET, 122 + paramset + 0x0000, 0);
			queueTDCommand(TD_COMMAND_GET, 122 + paramset + 0x0100, 0);
			queueTDCommand(TD_COMMAND_GET, 122 + paramset + 0x0200, 0);
		break;
		default:
		break;
	}
}


/**
 * @brief  SmartPort packet received: set value
 */
void receivedSetValue(void)
{
	// prepare for setting the data
	queueTDCommand(TD_COMMAND_SET, digiRx.getAppId(), digiRx.getData());
	
	// prepare for getting the data
	queueTDCommand(TD_COMMAND_GET, digiRx.getAppId(), 0);
}


/**
 * @brief  SmartPort packet received: save parameter
 */
void receivedSaveParameter(void)
{
	//clearTDQueue();
	//digiTx.clearQueue();
	
	// save values permanently
	queueTDCommand(TD_COMMAND_SAVE, 0, 0);
}


/**
 * @brief  Process SmartPort
 */
void processSmartPort(void)
{
	static bool led_on = true;
	uint16_t result;
	uint8_t frameId;

	result = bidirectional.processSmartPort();
	if (result != SENSOR_NO_DATA_ID) {
		frameId = result & 0xff;
		
		switch (frameId) {
			case REQUEST_FRAME_ID_GET_VERSION:
				receivedGetVersion();
			break;
			case REQUEST_FRAME_ID_GET_VALUE_SET:
				receivedGetValueSet();
			break;
			case REQUEST_FRAME_ID_SET_VALUE:
				receivedSetValue();
			break;
			case REQUEST_FRAME_ID_SAVE_PARAMETER:
				receivedSaveParameter();
			break;
			default:
			break;
		}
		
		if (led_on) {
			BOARD_LED_LO
			led_on = false;
		} else {
			BOARD_LED_HI
			led_on = true;
		}
	}
}


/**
 * @brief  Read 3Digi response
 */
void readTDResponse(void)
{
	static unsigned long last_3Digi_response = 0;
	static bool end_of_frame_seen = false;
	static bool escape_seen = false;
	uint8_t byte_cnt = 0;
	uint8_t c;
	
	while (byte_cnt++ < BUF_SIZE && Serial.available() > 0 && !end_of_frame_seen) {
                c = (uint8_t)Serial.read();
		
		if (c == SERIAL_END_OF_FRAME) end_of_frame_seen = true;
		
		// Serial deescaping
		if (c == SERIAL_ESCAPE) {
			escape_seen = true;
		} else {
			if (escape_seen) {
				escape_seen = false;
				c ^= SERIAL_XOR;
			}
			
			if (bufptr < buf + BUF_SIZE) *bufptr++ = c;
		}
	}
	
	if (end_of_frame_seen) {
		end_of_frame_seen = false;
		switch (buf[0]) {
			case SERIAL_END_OF_FRAME:
				handleTDFrameType_SERIAL_END_OF_FRAME(buf);
			break;
			case 0xAA:
				if (buf[1] == SERIAL_END_OF_FRAME) handleTDFrameType_AA(buf);
			break;
			case 0x00:
				if (checkCRC(buf,  2)) handleTDFrameType_00(buf);
			break;
			case 0x01:
				if (checkCRC(buf,  2)) handleTDFrameType_01(buf);
			break;
			case 0x02:
				if (checkCRC(buf,  3)) handleTDFrameType_02(buf);
			break;
			case 0x03:
				if (checkCRC(buf,  3)) handleTDFrameType_03(buf);
			break;
			case 0x05:
				if (checkCRC(buf,  5)) handleTDFrameType_05(buf);
			break;
			case 0x31:
				if (checkCRC(buf, 17)) handleTDFrameType_31(buf);
			break;
			default:
				TDQueueState = READY_FOR_SEND;
			break;
		}
		bufptr = buf;
		last_3Digi_response = millis();
	}
	
	if (millis() - last_3Digi_response > 500) {
		TDQueueState = READY_FOR_SEND;
		last_3Digi_response = millis();
	}
}


/**
 * @brief  setup
 */
void setup(void)
{
  BOARD_LED_HI
  DEBUG_PIN_LO
  
  Serial.begin(SERIAL_BAUD_RATE);

// Configure the telemetry serial port and sensors
#if defined(__MK20DX128__) || defined(__MK20DX256__) || defined(__MKL26Z64__) || defined(__MK66FX1M0__) || defined(__MK64FX512__)
  bidirectional.begin(FrSkySportSingleWireSerial::SERIAL_3, &digiRx, &digiTx);			// set rx sensors first !
#else
  bidirectional.begin(FrSkySportSingleWireSerial::SOFT_SERIAL_PIN_3, &digiRx, &digiTx);		// set rx sensors first !
#endif
  bidirectional.setRxCount(1);									// set the number of rx sensors
}


/**
 * @brief  main loop
 */
void loop(void)
{
	processSmartPort();
	readTDResponse();
	dequeueTDCommand();
}
