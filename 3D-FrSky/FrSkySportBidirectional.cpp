/*
  FrSky SmartPort bidirectional class for Teensy 3.x/LC and 328P based boards (e.g. Pro Mini, Nano, Uno)
  based on Pawelsky code
  (C) by Joerg-D. Rothfuchs 20190611
  Not for commercial use
*/

#include "FrSkySportBidirectional.h"

FrSkySportBidirectional::FrSkySportBidirectional()
{
}

void FrSkySportBidirectional::begin(FrSkySportSingleWireSerial::SerialId id,
                                FrSkySportSensor* sensor1,  FrSkySportSensor* sensor2,  FrSkySportSensor* sensor3,
                                FrSkySportSensor* sensor4,  FrSkySportSensor* sensor5,  FrSkySportSensor* sensor6,
                                FrSkySportSensor* sensor7,  FrSkySportSensor* sensor8,  FrSkySportSensor* sensor9,
                                FrSkySportSensor* sensor10, FrSkySportSensor* sensor11, FrSkySportSensor* sensor12,
                                FrSkySportSensor* sensor13, FrSkySportSensor* sensor14, FrSkySportSensor* sensor15,
                                FrSkySportSensor* sensor16, FrSkySportSensor* sensor17, FrSkySportSensor* sensor18,
                                FrSkySportSensor* sensor19, FrSkySportSensor* sensor20, FrSkySportSensor* sensor21,
                                FrSkySportSensor* sensor22, FrSkySportSensor* sensor23, FrSkySportSensor* sensor24,
                                FrSkySportSensor* sensor25, FrSkySportSensor* sensor26, FrSkySportSensor* sensor27,
                                FrSkySportSensor* sensor28)
{
  // Store sensor references in array
  sensors[0] = sensor1;
  sensors[1] = sensor2;
  sensors[2] = sensor3;
  sensors[3] = sensor4;
  sensors[4] = sensor5;
  sensors[5] = sensor6;
  sensors[6] = sensor7;
  sensors[7] = sensor8;
  sensors[8] = sensor9;
  sensors[9] = sensor10;
  sensors[10] = sensor11;
  sensors[11] = sensor12;
  sensors[12] = sensor13;
  sensors[13] = sensor14;
  sensors[14] = sensor15;
  sensors[15] = sensor16;
  sensors[16] = sensor17;
  sensors[17] = sensor18;
  sensors[18] = sensor19;
  sensors[19] = sensor20;
  sensors[20] = sensor21;
  sensors[21] = sensor22;
  sensors[22] = sensor23;
  sensors[23] = sensor24;
  sensors[24] = sensor25;
  sensors[25] = sensor26;
  sensors[26] = sensor27;
  sensors[27] = sensor28;

  // Count sensors (stops at first NULL)
  for (sensorCount = 0; sensorCount < FRSKY_BIDIRECTIONAL_MAX_SENSORS; sensorCount++) {
    if (sensors[sensorCount] == NULL)
      break;
  }

  rxCount = 0;
  state = START_FRAME;
  stuffing = false;
  sensorId = FrSkySportSensor::ID_IGNORE;
  frameId = SENSOR_NO_DATA_ID;
  
  FrSkySportBidirectional::serial.begin(id);
}


void FrSkySportBidirectional::setRxCount(uint8_t count)
{
  rxCount = count;
}


uint16_t FrSkySportBidirectional::processSmartPort()
{
  uint16_t result = SENSOR_NO_DATA_ID;
  uint32_t now = millis();
  
  if (serial.port != NULL) {
    if (serial.port->available()) {
      uint8_t byte = serial.port->read();
      //Serial.print  (byte, HEX);
      //Serial.print  (" ");
      // Receive
      if (byte == FRSKY_TELEMETRY_START_FRAME) { sensorId = FrSkySportSensor::ID_IGNORE; frameId = SENSOR_NO_DATA_ID; state = SENSOR_ID; stuffing = false; }	// Regardless of the state restart state machine when start frame found
      else if (state == SENSOR_ID) { sensorId = byte; state = FRAME_ID; }					// Store the sensor ID, start searching for frame ID
      else if (state == FRAME_ID) { frameId = byte; crc = byte; state = APP_ID_BYTE_1; }			// Frame ID found, initialize the CRC and start collecting APP ID
      else if (byte == FRSKY_STUFFING && state >= APP_ID_BYTE_1 && state <= CRC) { stuffing = true; }		// Skip stuffing byte in data and mark to xor next byte with 0x20
      else {
        if (stuffing) { byte ^= 0x20; stuffing = false; }							// Xor THIS byte with 0x20 to remove stuffing
        if (state >= APP_ID_BYTE_1 && state <= DATA_BYTE_4) { crc += byte; crc += crc >> 8; crc &= 0x00ff; }	// Update CRC value
	if      (state == APP_ID_BYTE_1) { ((uint8_t*)&appId)[0] = byte; state = APP_ID_BYTE_2; }		// APP ID first byte collected, look for second byte
        else if (state == APP_ID_BYTE_2) { ((uint8_t*)&appId)[1] = byte; state = DATA_BYTE_1; }			// APP ID second byte collected, store APP ID and start looking for DATA
        else if (state == DATA_BYTE_1)   { ((uint8_t*)&data )[0] = byte; state = DATA_BYTE_2; }			// DATA first byte collected, look for second byte
        else if (state == DATA_BYTE_2)   { ((uint8_t*)&data )[1] = byte; state = DATA_BYTE_3; }			// DATA second byte collected, look for third byte
        else if (state == DATA_BYTE_3)   { ((uint8_t*)&data )[2] = byte; state = DATA_BYTE_4; }			// DATA third byte collected, look for fourth byte
        else if (state == DATA_BYTE_4)   { ((uint8_t*)&data )[3] = byte; state = CRC; }				// DATA fourth byte collected, store DATA and look for CRC
        else if (state == CRC && byte == (0xFF - crc))								// Read CRC and compare with calculated one
        {													// If OK, send data to registered sensors for decoding and restart the state machine
          for (uint8_t i = 0; i < rxCount; i++) { result = sensors[i]->decodeData(sensorId, appId, data); if (result != SENSOR_NO_DATA_ID) break; }
	  state = START_FRAME;
        }
        else {
          state = START_FRAME;
        }
      }
      if (state == FRAME_ID) {
        // Send (possibly)
	for (uint8_t i = rxCount; i < sensorCount; i++) {
	  sensors[i]->send(serial, sensorId, now);
        }
      }
    }
  }
  
  if (result != SENSOR_NO_DATA_ID)
    return (result << 8) + frameId;
  else
    return SENSOR_NO_DATA_ID;
}
