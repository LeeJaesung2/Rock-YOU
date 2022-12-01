#include "MyBluetooth.h"

SoftwareSerial BTSerial(BLE_RX_pin, BLE_TX_pin);

void MyBluetoothClass::setBLEPin(){
    pinMode(BLE_RX_pin, INPUT);
    pinMode(BLE_TX_pin, OUTPUT);
    BTSerial.begin(9600);
}

/*get command fornm bluetooth module*/
int MyBluetoothClass::getCmdFromBLE(){
    if(BTSerial.available()){
        int lockCmd = BTSerial.parseInt();
        Serial.write(lockCmd);
        return lockCmd;
    }
    return -1;
}

/*send commant to bluetooth module*/
void MyBluetoothClass::sendCmdToBLE(int lockState){
    BTSerial.write(lockState);
}
