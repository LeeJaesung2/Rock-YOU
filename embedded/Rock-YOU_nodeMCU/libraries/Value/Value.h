#ifndef __VALUE_H__
#define __VALUE_H__
#include <SoftwareSerial.h>
#include <Arduino.h>
//_________mcu board________________
//DEBUG mode
#define DEBUG true

#define bicycleId "qf6r5zOcY4jXmmcniqX9" //PBMS identication key



class ValueClass{
    public:
        //global variables
        //unsigned long sendDataPrevMillis; //last data send time
        //bool signupOK; //firebase login
        //bool lockState;
        //bool conn_bluetooth;
        //int pastvib; //sensing shock value  safe = 0, shock = 1
        int state;
        float flat, flon;

        typedef enum{
            CLOSE,
            OPEN
        } lockCmd;

        typedef enum {
            LOCKED,//lock
            //SHOCK,
            DRIVE,//drive
            STEEL//steel
        } bicycleState;

        typedef enum{
            LONGITUDE,
            LATITUDE,
            LOCK,
            STATE
        } value;

        void initValue();
};


#endif