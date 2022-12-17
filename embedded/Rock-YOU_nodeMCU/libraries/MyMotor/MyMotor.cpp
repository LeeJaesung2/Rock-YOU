#include "MyMotor.h"

void MyMotorClass::setMotor(){
    mainServo.attach(MainGear_pin);
    lockServo.attach(LockGear_pin);
    lockServo.write(0);
}

/*unlock using motor*/
void MyMotorClass::unlockBicycle(){
    for(int posDegrees = 180; posDegrees >= 0; posDegrees--) {
        lockServo.write(posDegrees);
        delay(20);
    }
    for(int posDegrees = 180; posDegrees >= 0; posDegrees--) {
        mainServo.write(posDegrees);
        delay(20);
    }
}

/*lock usgin motor*/
void MyMotorClass::lockBicycle(){
    for(int posDegrees = 0; posDegrees <= 180; posDegrees++) {
        mainServo.write(posDegrees);
        delay(20);
    }
    for(int posDegrees = 0; posDegrees <= 180; posDegrees++) {
        lockServo.write(posDegrees);
        delay(20);
    }
}