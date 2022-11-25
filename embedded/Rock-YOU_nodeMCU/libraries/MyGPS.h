#include <TinyGPS.h>
#include "Value.h"

#define GPS_RX_pin 35
#define GPS_TX_pin 1

//_________GPS________________
TinyGPS gps;
SoftwareSerial gss(GPS_RX_pin, GPS_TX_pin);

void getGPSValue();