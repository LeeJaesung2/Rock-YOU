#include <SoftwareSerial.h> //module for serial networking


//defin here
SoftwareSerial wifi_serial(3,4); //serial for arduino and wifi module

void setup() {
  wifi_serial.begin(9600);
  Serial.bein(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  //wifi module available serial bring data from wifi module
  if(wifi_serial.available()){
    int resulet  = wifi_serial.read();
    Serial.println(result);
  }
  if(Serial.available()){
    int message = 1;
    Serial.write(message);
  }
  

}
