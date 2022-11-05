int vib_pin=2;

void setup() {
  pinMode(vib_pin,INPUT);
  Serial.begin(9600);
}

void loop() {
  int val;
  val=digitalRead(vib_pin); // get vibration value
  Serial.println(val);
  delay(100);
}
