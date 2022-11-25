#include "MyBletooth.h"

/*get command fornm bluetooth module*/
void getCmdFromBLE(){
    if(BTSerial.available()){
        lock = BTSerial.read();
        Serial.write(lock);
    }
}

/*send commant to bluetooth module*/
void sendCmdToBLE(bool lock){
    BTSerial.write(lock);
}
