#include <SoftwareSerial.h>
SoftwareSerial BTSerial(32,33);

void setup(){
  pinMode(32,INPUT);
  pinMode(33,OUTPUT);
  Serial.begin(115200);
  Serial.println("Hello!");
  BTSerial.begin(9600);
}

void loop(){
  while(BTSerial.available()){
    byte data = BTSerial.read();
    Serial.write(data);
  }
  while(Serial.available()){
    byte data = Serial.read();
    BTSerial.write(data);
  }
}
