//Direction variables
#define   F     1
#define   FR    2
#define   R     3
#define   BR    4
#define   B     5
#define   BL    6
#define   L     7
#define   FL    8
#define   STOP  0
#define   SPEED_CONSTANT  0.2

//pin setting
#define   IN1   9
#define   IN2   8
#define   IN3   7
#define   IN4   6
#define   ENA   10
#define   ENB   5

void setup() {
  // put your setup code here, to run once:
  //D5~D10 pin set output mode
  for(int i=5; i<=10; i++){
    pinMode(i, OUTPUT);
  }
}
void motor(int dir, int speed);
void loop() {
  // put your main code here, to run repeatedly:
  motor(F, 150);
  delay(1000);
  // 500ms right @200 speed
  motor(R, 200);
  delay(500);
  // 1000ms forward @150 speed
  motor(F, 150);
  delay(1000);
  // 1000ms backward @150 speed
  motor(B, 150);
  delay(1000);
  // 500ms left @200 speed
  motor(L, 200);
  delay(500);
  // 1000ms backward @150 speed
  motor(B, 150);
  delay(1000);

}

void motor(int dir, int speed) {
  if (dir == F) {
    // Left motor forward with full speed
    digitalWrite(IN1, HIGH);
    digitalWrite(IN2, LOW);
    analogWrite(ENA, speed);
    // Right motor forward with full speed
    digitalWrite(IN3, HIGH);
    digitalWrite(IN4, LOW);
    analogWrite(ENB, speed);
  } else if (dir == FR) {
    // Left motor forward with full speed
    digitalWrite(IN1, HIGH);
    digitalWrite(IN2, LOW);
    analogWrite(ENA, speed);
    // Right motor forward with speed*SPEED_CONSTANT
    digitalWrite(IN3, HIGH);
    digitalWrite(IN4, LOW);
    analogWrite(ENB, speed * SPEED_CONSTANT);
  } else if (dir == R) {
    // Left motor forward with full speed
    digitalWrite(IN1, HIGH);
    digitalWrite(IN2, LOW);
    analogWrite(ENA, speed);
    // Right motor backward with full speed
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, HIGH);
    analogWrite(ENB, speed);
  } else if (dir == BR) {
    // Left motor backward with full speed
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);
    analogWrite(ENA, speed);
    // Right motor backward with speed*SPEED_CONSTANT
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, HIGH);
    analogWrite(ENB, speed * SPEED_CONSTANT);
  } else if (dir == B) {
    // Left motor backward with full speed
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);
    analogWrite(ENA, speed);
    // Right motor backward with full speed
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, HIGH);
    analogWrite(ENB, speed);
  } else if (dir == BL) {
    // Left motor backward with speed*SPEED_CONSTANT
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);
    analogWrite(ENA, speed * SPEED_CONSTANT);
    // Right motor backward with full speed
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, HIGH);
    analogWrite(ENB, speed);
  } else if (dir == L) {
    // Left motor forward with full speed
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);
    analogWrite(ENA, speed);
    // Right motor backward with full speed
    digitalWrite(IN3, HIGH);
    digitalWrite(IN4, LOW);
    analogWrite(ENB, speed);
  } else if (dir == FL) {
    // Left motor forward with speed*SPEED_CONSTANT
    digitalWrite(IN1, HIGH);
    digitalWrite(IN2, LOW);
    analogWrite(ENA, speed * SPEED_CONSTANT);
    // Right motor forward with full speed
    digitalWrite(IN3, HIGH);
    digitalWrite(IN4, LOW);
    analogWrite(ENB, speed);
  } else if (dir == STOP) {
    // Left motor stop
    analogWrite(ENA, 0);
    // Right motor stop
    analogWrite(ENB, 0);
  }
}
