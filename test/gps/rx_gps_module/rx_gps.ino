#include <SoftwareSerial.h>
#include <TinyGPS.h>

#define RX_pin 35
#define TX_pin 3

TinyGPS gps;
SoftwareSerial gss(RX_pin, TX_pin);

unsigned long sendDataPrevMillis;

void setup()
{
  Serial.begin(115200);
  pinMode(RX_pin, INPUT);
  gss.begin(9600);

}

void loop()
{
 

}

void getGPSValue(){
  bool newData = false;
  
  // For one second we parse GPS data and report some key values
  if (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0){
    sendDataPrevMillis = millis();
    if (gss.available()){
      // Serial.write(c); // uncomment this line if you want to see the GPS data flowing
      if (gps.encode(gss.read())) // Did a new valid sentence come in?
        newData = true;
    }
  }

  if (newData)
  {
    float flat, flon;
    unsigned long age;
    gps.f_get_position(&flat, &flon, &age);
    Serial.print("LAT=");
    Serial.print(flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6);
    Serial.print(" LON=");
    Serial.print(flon == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flon, 6);
    Serial.println();
  }
}
