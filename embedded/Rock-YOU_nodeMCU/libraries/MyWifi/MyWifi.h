#ifndef __MYWIFI_H__
#define __MYWIFI_H__
#include <WiFi.h>
#include "Value.h"

//_________wifi________________
#define WIFI_SSID "SJ's iPhone"
#define WIFI_PASSWORD "1234567890"

class MyWifiClass{
    public:
        void connWifi();
};


#endif