#include "MyMotor.h"

void MyMotorClass::setMotor(){
    mainServo.attach(MainGear_pin);
    lockServo.attach(LockGear_pin);
}

/*unlock using motor*/
bool MyMotorClass::unlockBicycle(bool lockState){
    for(int posDegrees = 180; posDegrees >= 0; posDegrees--) {
        lockServo.write(posDegrees);
        delay(20);
    }
    for(int posDegrees = 180; posDegrees >= 0; posDegrees--) {
        mainServo.write(posDegrees);
        delay(20);
    }
    lockState = true;
    return lockState;
}

/*lock usgin motor*/
bool MyMotorClass::lockBicycle(bool lockState){
    for(int posDegrees = 0; posDegrees <= 270; posDegrees++) {
        mainServo.write(posDegrees);
        delay(20);
    }
    for(int posDegrees = 0; posDegrees <= 270; posDegrees++) {
        lockServo.write(posDegrees);
        delay(20);
    }
    lockState = false;
    return lockState;
}