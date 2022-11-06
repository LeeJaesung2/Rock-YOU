#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

//firebase library
#include "addons/TokenHelper.h" //Provide the token generation process info.
#include "addons/RTDBHelper.h" //Provide the RTDB payload printing info and other helper functions.

//GPIO pin
int vib_pin = 2;

// set wifi
#define WIFI_SSID "Jaesung’s iPhone"
#define WIFI_PASSWORD "87654321"

// firebas key & url
#define API_KEY "AIzaSyCYI5hrkkNjjQUB11bYCvdvfHHNmHUvNYc"
#define DATABASE_URL "https://rock-u-9c940-default-rtdb.firebaseio.com/" 

//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

//global variables
unsigned long sendDataPrevMillis = 0; //이전 데이터 전송 시간
bool signupOK = false; //로그인 여부 확인
bool lock = false; //잠금여부
bool conn_bluetooth = false; //블루투스 연결 여부
String status = 0; //상태  nomal = 0, shock = 1, steel = 2, drive = 3
int vib //충격 감지  non = 0, shock = 1

//함수 선언부
void setData(String path, int data)

void setup(){
  Serial.begin(115200);
  pinMode(vib_pin, INPUT);
  
  //conn wifi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // firebase key & url
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  //login
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop(){
  val = digitalRead(vib_pin); //get vibration value
  setData("test/int", 10);
}

void setData(String path, int data){
  //파이어베이스가 준비되고 로그인이 되어있고 너무 많은 데이터를 보내지 않기 위해 시간 측정
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)){
    sendDataPrevMillis = millis();
    // Write an data on the database path
    if (Firebase.RTDB.setInt(&fbdo, path, data)){
      Serial.println("PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
}
