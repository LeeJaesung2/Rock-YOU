#ifndef __MYMOTOR_H__
#define __MYMOTOR_H__
#include <ESP32_Servo.h>
#include "Value.h"

#define LockGear_pin 16
#define MainGear_pin 17



class MyMotorClass{
    public:
        void setMotor();
        void unlockBicycle();
        void lockBicycle();
    private:
        Servo mainServo;
        Servo lockServo;

};


#endif