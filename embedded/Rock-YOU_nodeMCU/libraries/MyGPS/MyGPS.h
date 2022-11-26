#ifndef __MYGPS_H__
#define __MYGPS_H__
#include <TinyGPS.h>
#include "Value.h"

#define GPS_RX_pin 35
#define GPS_TX_pin 1



class MyGPSClass{
    public:
        //_________GPS________________
        TinyGPS gps;
        void setGPSPin();
        void getGPSValue();
};


#endif