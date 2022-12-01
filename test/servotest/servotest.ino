#include <ESP32_Servo.h>

#define servoPin 17

Servo servo;

void setup() {
    Serial.begin(115200);
    servo.attach(servoPin);
    servo.write(0);
    delay(5000);
}

void loop() {
    for(int posDegrees = 0; posDegrees <= 270; posDegrees++) {
        servo.write(posDegrees);
        Serial.println(posDegrees);
        delay(40);
    }

    for(int posDegrees = 270; posDegrees >= 0; posDegrees--) {
        servo.write(posDegrees);
        Serial.println(posDegrees);
        delay(20);
    }
}
