#include <SoftwareSerial.h>

//use 3,4 pin to serial
SoftwareSerial s(3,4);

 

void setup() {
  s.begin(9600);
  Serial.begin(9600);
  //remote 12pin led but no led in my board
  pinMode(12, OUTPUT);

}

 

void loop() {

  if(s.available()>0) {
    int result = 0;
    result = s.read();
    Serial.println(result);

    if(result == 1) { 
      digitalWrite(12, HIGH);
    } else if(result == 2) { 
      digitalWrite(12, LOW);
    }

  }

  delay(100);

}
