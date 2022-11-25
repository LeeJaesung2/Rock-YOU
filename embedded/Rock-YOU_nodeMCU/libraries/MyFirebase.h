#include "Value.h"
//firebase library
#include <Firebase_ESP_Client.h>
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

void setFirebase();
void updateFirebase(int value, int data);
void updateGPSFirebase(int value, float data);