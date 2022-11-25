#include "MyMotor.h"

/*unlock using motor*/
void open(){
    for(int posDegrees = 180; posDegrees >= 0; posDegrees--) {
        lockServo.write(posDegrees);
        delay(20);
    }
    for(int posDegrees = 180; posDegrees >= 0; posDegrees--) {
        mainServo.write(posDegrees);
        delay(20);
    }
    lock = true;
    sendCmdToBLE(lock);
    updateFirebase(LOCK,0);
}

/*lock usgin motor*/
void close(){
    for(int posDegrees = 0; posDegrees <= 270; posDegrees++) {
        mainServo.write(posDegrees);
        delay(20);
    }
    for(int posDegrees = 0; posDegrees <= 270; posDegrees++) {
        lockServo.write(posDegrees);
        delay(20);
    }
    lock = false;
    sendCmdToBLE(lock);
    updateFirebase(LOCK,1);
}