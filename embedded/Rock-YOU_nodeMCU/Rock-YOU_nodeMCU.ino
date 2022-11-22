#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <SoftwareSerial.h>

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
#define FIREBASE_PROJECT_ID "rock-u-9c940"
#define USER_EMAIL "dlwotjd9909@gmail.com"
#define USER_PASSWORD "FirebaseRockyou"

//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
FirebaseJson content;

//_________mcu board________________
//DEBUG mode
#define DEBUG true

#define bicycleId "qf6r5zOcY4jXmmcniqX9" //PBMS identication key

//GPIO pin
#define vib_pin 2 //2 : shock sensor
#define RX_pin 3
#define TX_pin 1

SoftwareSerial gps(RX_pin, TX_pin);

//global variables
unsigned long sendDataPrevMillis; //last data send time
bool signupOK; //firebase login
bool lock;
bool conn_bluetooth;
int pastvib; //sensing shock value  safe = 0, shock = 1
int state;

typedef enum {
  SAFE,
  SHOCK,
  STEEL,
  DRIVE
} bicycleState;

typedef enum{
  LONGITUDE,
  LATITUDE,
  LOCK,
  STATE
} value;


//_________wifi________________
// set wifi
#define WIFI_SSID "Jaesung’s iPhone"
#define WIFI_PASSWORD "87654321"


void setup(){
  initValue();
  #if(DEBUG)
    Serial.begin(115200);
  #endif
  //vibration sensor setup
  pinMode(vib_pin, INPUT);
  
  connWifi();
  connBluetooth();
  setFirebase();

  

}

void loop(){
  getShockValue();
}


/*function to setup*/

void initValue(){
  sendDataPrevMillis = 0;
  signupOK = false;
  lock = false;
  conn_bluetooth = false;
  pastvib = 0;
  state = SAFE;
}

void connWifi(){
  //conn wifi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  #if(DEBUG)
    Serial.print("Connecting to Wi-Fi");
  #endif
  while (WiFi.status() != 3){
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
}

void connBluetooth(){
  serialBT.begin("Rock_YOU"); //named "Rock_YOU" bluetooth begin
  #if(DEBUG)
    Serial.println("The device started, now you can pair it with bluetooth!");
  #endif
}

void setFirebase(){
  // firebase key & auth
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  fbdo.setResponseSize(2048);
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

/*function to use*/
void updateFirebase(int value, int data){
  String path = "bicycle/qf6r5zOcY4jXmmcniqX9";
  String jsonPath;
  String updateMask;
  switch(value){
    case LOCK:
      jsonPath = "fields/lock/integerValue";
      updateMask = "lock";
      break;
    case STATE:
      jsonPath = "fields/state/integerValue";
      updateMask = "state";
      break;
  }
  content.clear();
  content.set(jsonPath, String(data)); //integer also use ""
  if (Firebase.ready()){
        if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", path.c_str(), content.raw(), updateMask))
            Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
        else
            Serial.println(fbdo.errorReason());
    }
  
}

void updateGPSFirebase(int value, double data){
  String path = "bicycle/qf6r5zOcY4jXmmcniqX9";
  String jsonPath;
  String updateMask;
  switch(value){
    case LONGITUDE:
      jsonPath = "fields/GPS/geoPointValue/longitude";
      updateMask = "longitude";
      break;
    case LATITUDE:
      jsonPath = "fields/GPS/geoPointValue/latitude";
      updateMask = "latitude";
      break;
  }
  content.clear();
  content.set(jsonPath, data);
  if (Firebase.ready()){
        if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", path.c_str(), content.raw(), updateMask))
            Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
        else
            Serial.println(fbdo.errorReason());
    }
  
}



void getShockValue(){
  //get shock value every 1.0s
  if(millis() - sendDataPrevMillis > 10000 || sendDataPrevMillis == 0){
    sendDataPrevMillis = millis();
    int vib = digitalRead(vib_pin); //get vibration value
    //if shock value change to 1 from 0
    if(pastvib == 0 & vib == 1){
      state = SHOCK;
      updateFirebase(STATE, SHOCK);
    }
    pastvib = vib;
  }
}

void getGPSValue(){
  Serial.write(gps.read());

  float latitude = 1.24;
  float longitude = 36.22;
  updateGPSFirebase(LONGITUDE, longitude);
  updateGPSFirebase(LATITUDE, latitude);
}
