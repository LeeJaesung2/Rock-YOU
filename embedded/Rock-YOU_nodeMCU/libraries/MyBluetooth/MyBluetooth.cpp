#include "MyBluetooth.h"

SoftwareSerial BTSerial(BLE_RX_pin, BLE_TX_pin);

void MyBluetoothClass::setBLEPin(){
    pinMode(BLE_RX_pin, INPUT);
    pinMode(BLE_TX_pin, OUTPUT);
    BTSerial.begin(9600);
}

/*get command fornm bluetooth module*/
int MyBluetoothClass::getCmdFromBLE(int lockCmd){
    if(BTSerial.available()){
        lockCmd = BTSerial.read();
        Serial.write(lockCmd);
    }
    return lockCmd;
}

/*send commant to bluetooth module*/
void MyBluetoothClass::sendCmdToBLE(bool lockState){
    BTSerial.write(lockState);
}
