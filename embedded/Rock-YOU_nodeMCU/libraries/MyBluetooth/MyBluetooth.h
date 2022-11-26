#ifndef __MYBLUETOOTH_H__
#define __MYBLUETOOTH_H__
#include "Value.h"


#define BLE_RX_pin 32
#define BLE_TX_pin 33


class MyBluetoothClass{
    public:
        void setBLEPin();
        bool getCmdFromBLE(bool lockState);
        void sendCmdToBLE(bool lockState);
};


#endif