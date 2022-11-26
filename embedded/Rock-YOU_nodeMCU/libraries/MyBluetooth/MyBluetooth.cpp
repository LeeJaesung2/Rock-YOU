#include "MyBluetooth.h"

SoftwareSerial BTSerial(BLE_RX_pin, BLE_TX_pin);

void MyBluetoothClass::setBLEPin(){
    pinMode(BLE_RX_pin, INPUT);
    pinMode(BLE_TX_pin, OUTPUT);
    BTSerial.begin(9600);
}

/*get command fornm bluetooth module*/
bool MyBluetoothClass::getCmdFromBLE(bool lockState){
    if(BTSerial.available()){
        lockState = BTSerial.read();
        Serial.write(lockState);
    }
    return lockState;
}

/*send commant to bluetooth module*/
void MyBluetoothClass::sendCmdToBLE(bool lockState){
    BTSerial.write(lockState);
}
