#ifndef __MYGPS_H__
#define __MYGPS_H__
#include <TinyGPS.h>
#include "Value.h"

#define GPS_RX_pin 35
#define GPS_TX_pin 1

typedef struct{
    float latitude; //위도
    float longitude; //경도
} GPSValue;

class MyGPSClass{
    public:
        TinyGPS gps;
        void setGPSPin();
        GPSValue getGPSValue();
        
    
};


#endif