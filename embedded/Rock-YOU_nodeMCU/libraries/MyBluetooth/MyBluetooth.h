#ifndef __MYBLUETOOTH_H__
#define __MYBLUETOOTH_H__
#include "Value.h"


#define BLE_RX_pin 32
#define BLE_TX_pin 33


class MyBluetoothClass{
    public:
        void setBLEPin();
        int getCmdFromBLE();
        void sendCmdToBLE(int lockState);
};


#endif