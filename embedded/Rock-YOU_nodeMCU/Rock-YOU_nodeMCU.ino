#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

//_________bluetooth________________
//bluethooth library
#include "BluetoothSerial.h"
BluetoothSerial serialBT;

//check bluetooth enabled
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

//_________firebase________________
//firebase library
#include "addons/TokenHelper.h" //Provide the token generation process info.
#include "addons/RTDBHelper.h" //Provide the RTDB payload printing info and other helper functions.

// firebas key & url
#define API_KEY "AIzaSyCYI5hrkkNjjQUB11bYCvdvfHHNmHUvNYc"
#define DATABASE_URL "https://rock-u-9c940-default-rtdb.firebaseio.com/" 

//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

//_________mcu board________________
//DEBUG mode
#define DEBUG true

#define id "qf6r5zOcY4jXmmcniqX9" //PBMS identication key

//GPIO pin
#define vib_pin 2 //2번 : 충격센서

//global variables
unsigned long sendDataPrevMillis = 0; //이전 데이터 전송 시간
bool signupOK = false; //로그인 여부 확인
bool lock = false; //잠금여부
bool conn_bluetooth = false; //블루투스 연결 여부
int status = 0; //상태  nomal = 0, shock = 1, steel = 2, drive = 3
int vib; //충격 감지  non = 0, shock = 1


//_________wifi________________
// set wifi
#define WIFI_SSID "Jaesung’s iPhone"
#define WIFI_PASSWORD "87654321"

//________function declaration________________
void setData(String path, int data);

void setup(){
  #if(DEBUG)
    Serial.begin(115200);
  #endif
  //vibration sensor setup
  pinMode(vib_pin, INPUT);
  
  //conn wifi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  #if(DEBUG)
    Serial.print("Connecting to Wi-Fi");
  #endif
  while (WiFi.status() != WL_CONNECTED){
    #if(DEBUG)
      Serial.print(".");
    #endif
    delay(300);
  }
  #if(DEBUG)
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();
  #endif

  //serialBT.begin("Rock_YOU"); //named "Rock_YOU" bluetooth begin
  #if(DEBUG)
    Serial.println("The device started, now you can pair it with bluetooth!");
  #endif

  // firebase key & url
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  //login
  if (Firebase.signUp(&config, &auth, "", "")){
    #if(DEBUG)
      Serial.println("ok");
    #endif
    signupOK = true;
  }
  else{
    #if(DEBUG)
      Serial.printf("%s\n", config.signer.signupError.message.c_str());
    #endif
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop(){
  vib = digitalRead(vib_pin); //get vibration value
  Serial.println(vib);
  setData("test/int", 10);
}


/*path = "bicycle/qf6r5zOcY4jXmmcniqX9/gps/altitude"
path = "bicycle/qf6r5zOcY4jXmmcniqX9/gps/latitude"
path = "bicycle/qf6r5zOcY4jXmmcniqX9/lock"
path = "bicycle/qf6r5zOcY4jXmmcniqX9/status"
*/
void setData(String path, int data){
  //파이어베이스가 준비되고 로그인이 되어있고 너무 많은 데이터를 보내지 않기 위해 시간 측정
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)){
    sendDataPrevMillis = millis();
    // Write an data on the database path
    if (Firebase.RTDB.setInt(&fbdo, path, data)){
      #if(DEBUG)
        Serial.println("PASSED");
        Serial.println("PATH: " + fbdo.dataPath());
        Serial.println("TYPE: " + fbdo.dataType());
      #endif
    }
    else {
      #if(DEBUG)
        Serial.println("FAILED");
        Serial.println("REASON: " + fbdo.errorReason());
      #endif
    }
  }
}
