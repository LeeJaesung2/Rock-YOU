#include "MyFirebase.h"
/*setting Firebase firestore*/
void setFirebase(){
    // firebase key & auth
    config.api_key = API_KEY;
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

     /* Assign the callback function for the long running token generation task */
    config.token_status_callback = tokenStatusCallback; 

    fbdo.setResponseSize(2048);

    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
}

/*update value to firebase firestore*/
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

/*update GPS value to firebase firestore*/
void updateGPSFirebase(int value, float data){
    String path = "bicycle/qf6r5zOcY4jXmmcniqX9";
    String jsonPath;
    String updateMask;
    switch(value){
        case LONGITUDE:
            jsonPath = "fields/GPS/geoPointValue/longitude";
            updateMask = "GPS";
            break;
        case LATITUDE:
            jsonPath = "fields/GPS/geoPointValue/latitude";
            updateMask = "GPS";
            break;
    }
    //content.clear();
    content.set(jsonPath, data);
    if (Firebase.ready()){
            if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", path.c_str(), content.raw(), updateMask))
                Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
            else
                Serial.println(fbdo.errorReason());
    }

}