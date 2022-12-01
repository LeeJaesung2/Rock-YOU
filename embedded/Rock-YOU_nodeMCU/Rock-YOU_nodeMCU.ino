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
ValueClass Value;

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
  //bluetooth check
  int lockCmd;
  lockCmd = BLE.getCmdFromBLE(lockCmd);
  if(lockCmd!=-1){
    switch (lockCmd)
    {
    case Value.CLOSE:
      Motor.lockBicycle();
      BLE.sendCmdToBLE(Value.state);
      MyFirebase.updateFirebase(Value.STATE, Value.state);
      
      break;
  
    case Value.OPEN:
      Motor.unlockBicycle();
      BLE.sendCmdToBLE(Value.state);
      MyFirebase.updateFirebase(Value.STATE, Value.state);
      break;
    default:
      Serial.println("invalid command");
      break;
    }
  }

  
  GPSValue gpsValue = GPS.getGPSValue();
  float distance;
  if(Value.preGpsValue.latitude!=0){
    distance = GPS.gps.distance_between(gpsValue.latitude, gpsValue.longitude, Value.preGpsValue.latitude, Value.preGpsValue.longitude);
  }
  if(distance>=1||Value.preGpsValue.latitude==0){
    Value.preGpsValue = gpsValue;
    MyFirebase.updateGPSFirebase(Value.LATITUDE, gpsValue.latitude);
    MyFirebase.updateGPSFirebase(Value.LONGITUDE, gpsValue.longitude);
    if(Value.state == Value.LOCKED){
      Value.state = Value.STEEL;
      MyFirebase.updateFirebase(Value.STATE, Value.state);
    }
  }
  
}
