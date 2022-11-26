#include <MyWifi.h>
#include <MyBluetooth.h>
#include <MyFirebase.h>
#include <MyGPS.h>
#include <Value.h>
#include <MyMotor.h>

MyBluetoothClass BLE;
MyFirebaseClass MyFirebase;
MyGPSClass GPS;
MyMotorClass Motor;
MyWifiClass Wifi;
ValueClass Value; //need to fix

void setup(){
  Value.initValue();
  Motor.setMotor();
  GPS.setGPSPin();
  BLE.setBLEPin();
  #if(DEBUG)
    Serial.begin(115200);
  #endif
  Wifi.connWifi();
  MyFirebase.setFirebase();
  
}

void loop(){
  Value.lockState = Motor.unlockBicycle(Value.lockState);
  MyFirebase.updateFirebase(Value.LOCK, Value.lockState);
  Value.lockState = Motor.lockBicycle(Value.lockState);
  MyFirebase.updateFirebase(Value.LOCK, Value.lockState);
  
}
