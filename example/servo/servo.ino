#include <ESP32_Servo.h>

static const int servoPin = 17;

Servo servo1;

void setup() {
    Serial.begin(115200);
    servo1.attach(servoPin);
    servo1.write(0);
    delay(5000);
}

void loop() {
    for(int posDegrees = 0; posDegrees <= 270; posDegrees++) {
        servo1.write(posDegrees);
        Serial.println(posDegrees);
        delay(40);
    }

    for(int posDegrees = 270; posDegrees >= 0; posDegrees--) {
        servo1.write(posDegrees);
        Serial.println(posDegrees);
        delay(20);
    }
}
