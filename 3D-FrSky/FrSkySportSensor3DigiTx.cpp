/*
  FrSky 3Digi Tx class for Teensy 3.x/LC and 328P based boards (e.g. Pro Mini, Nano, Uno)
  (C) by Joerg-D. Rothfuchs 20190611
  Not for commercial use
*/

#include "FrSkySportSensor3DigiTx.h" 

FrSkySportSensor3DigiTx::FrSkySportSensor3DigiTx(SensorId id) : FrSkySportSensor(id) { }

void FrSkySportSensor3DigiTx::send(FrSkySportSingleWireSerial& serial, uint8_t sId, uint32_t now)
{
  if (sensorId == sId) {
    if (queueCnt > 0) {
      queueCnt--;
      serial.sendData(sId, appId[queueOut], data[queueOut]);
      queueOut++;
      if (queueOut >= QUEUE_DEPTH)
        queueOut = 0;
    } else {
      serial.sendEmpty(0);
    }
  }
}

void FrSkySportSensor3DigiTx::queueData(uint16_t aId, uint32_t d)
{
  if (queueCnt < QUEUE_DEPTH) {
    queueCnt++;
    appId[queueIn] = aId;
    data[queueIn] = d;
    queueIn++;
    if (queueIn >= QUEUE_DEPTH)
      queueIn = 0;
  }
}

void FrSkySportSensor3DigiTx::clearQueue(void)
{
  queueCnt = 0;
  queueIn  = 0;
  queueOut = 0;
}
