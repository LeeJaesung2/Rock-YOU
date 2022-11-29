#include "MyGPS.h"


SoftwareSerial gss(GPS_RX_pin, GPS_TX_pin);

void MyGPSClass::setGPSPin(){
    pinMode(GPS_RX_pin, INPUT);
    gss.begin(9600);
}

/*get GPS value from GPS module*/
GPSValue MyGPSClass::getGPSValue(){
    bool newData = false;
    GPSValue gpsValue;
    for (unsigned long start = millis(); millis() - start < 1000;){
        if(gss.available()){
            if (gps.encode(gss.read())){
                newData = true;
            }
        }
    }
    if (newData)
    {
        float flat, flon;
        unsigned long age;
        gps.f_get_position(&flat, &flon, &age);
        #if(DEBUG)
            Serial.print("LAT=");
            Serial.print(flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6);
            Serial.print(" LON=");
            Serial.print(flon == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flon, 6);
            Serial.println();
        #endif
        gpsValue.latitude = flat;
        gpsValue.longitude = flon;
    }
    return gpsValue;
}