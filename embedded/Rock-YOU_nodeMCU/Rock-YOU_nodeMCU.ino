#include "MyWifi.h"
#include "MyBletooth.h"
#include "MyFirebase.h"
#include "MyGPS.h"
#include "Value.h"
#include "MyMotor.h"

void setup(){
  initValue();
  /*//vibration sensor setup
  pinMode(vib_pin, INPUT);*/
  mainServo.attach(MainGear_pin);
  lockServo.attach(LockGear_pin);
  pinMode(GPS_RX_pin, INPUT);
  pinMode(BLE_RX_pin, INPUT);
  pinMode(BLE_TX_pin, OUTPUT);
  #if(DEBUG)
    Serial.begin(115200);
  #endif
  gss.begin(9600);
  BTSerial.begin(9600);
  
  connWifi();
  setFirebase();
  
}

void loop(){
  
}



