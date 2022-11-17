#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <TinyGPSPlus.h>

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

#define bicycleId "qf6r5zOcY4jXmmcniqX9" //PBMS identication key

//GPIO pin
#define vib_pin 2 //2 : shock sensor

//global variables
unsigned long sendDataPrevMillis; //last data send time
bool signupOK; //firebase login
bool lock;
bool conn_bluetooth;
int pastvib; //sensing shock value  safe = 0, shock = 1
int status;

typedef enum {
  SAFE,
  SHOCK,
  STEEL,
  DRIVE
} bicycleStatus;

//////////C언어에서는 안될것 같은디
typedef enum{
  ALTITUDE = "bicycle/"+bicycleId+"/gps/altitude",
  LATITUDE = "bicycle/"+bicycleId+"/gps/latitude",
  LOCK = "bicycle/"+bicycleId+"/lock",
  STATUS = "bicycle/"+bicycleId+"/status"
} FirebasePath;

//_________wifi________________
// set wifi
#define WIFI_SSID "Jaesung’s iPhone"
#define WIFI_PASSWORD "87654321"

//________function declaration________________
void initValue();
void connWifi();
void connBluetooth()
void setFirebase();
void updateFirebase(String path, int data);
int getShockValue();

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
  patvib = getShockValue();
  updateFirebase("test/int", 10);
}


/*function here*/

void initValue(){
  sendDataPrevMillis = 0;
  signupOK = false;
  lock = false;
  conn_bluetooth = false;
  pastvib = 0;
  status = SAFE;
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

void updateFirebase(String path, int data){
  
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

int getShockValue(){
  //get shock value every 1.0s
  if(millis() - sendDataPrevMillis > 10000 || sendDataPrevMillis == 0){
    sendDataPrevMillis = millis();
    int vib = digitalRead(vib_pin); //get vibration value
    //if shock value change to 1 from 0
    if(pastvib == 0 & vib == 1){
      status = SHOCK;
    }
    pastvib = vib;
  }
  return pastvib;
}

void getGPSValue(){

}