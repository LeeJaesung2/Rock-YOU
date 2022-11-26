#include "MyGPS.h"

ValueClass value;
SoftwareSerial gss(GPS_RX_pin, GPS_TX_pin);

void MyGPSClass::setGPSPin(){
    pinMode(GPS_RX_pin, INPUT);
    gss.begin(9600);
}

/*get GPS value from GPS module*/
void MyGPSClass::getGPSValue(){
    bool newData = false;
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
        value.flat = flat;
        value.flon = flon;
        #if(DEBUG)
            Serial.print("LAT=");
            Serial.print(value.flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6);
            Serial.print(" LON=");
            Serial.print(value.flon == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flon, 6);
            Serial.println();
        #endif
    }

}