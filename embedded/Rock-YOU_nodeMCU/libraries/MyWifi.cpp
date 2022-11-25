#include "MyWifi.h"

/*Wi-fi connecting function*/
void connWifi(){
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    #if(DEBUG)
        Serial.print("Connecting to Wi-Fi");
    #endif
    while (WiFi.status() != 3){
        #if(DEBUG)
        Serial.print(".");
        #endif
        delay(300);
    }
    #if(DEBUG)
        Serial.println();
        Serial.print("Connected with IP: ");
        Serial.println(WiFi.localIP());
        Serial.println();
    #endif
}