#include<SoftwareSerial.h>
SoftwareSerial gps(3,1);
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  gps.begin(9600);
  while(!gps.available()){
    Serial.print(".");
    delay(10000);
  }

}

void loop() {
  Serial.write(gps.read());
  delay(1000);

}
