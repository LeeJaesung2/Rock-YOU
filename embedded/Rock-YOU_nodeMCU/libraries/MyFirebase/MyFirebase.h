#ifndef __MYFIREBASE_H__
#define __MYFIREBASE_H__
#include <Firebase_ESP_Client.h>
#include "Value.h"

// firebas key & url
#define API_KEY "AIzaSyCYI5hrkkNjjQUB11bYCvdvfHHNmHUvNYc"
#define FIREBASE_PROJECT_ID "rock-u-9c940"
#define USER_EMAIL "dlwotjd9909@gmail.com"
#define USER_PASSWORD "FirebaseRockyou"



class MyFirebaseClass{
    public:
        void setFirebase();
        void updateFirebase(int updateValue, int data);
        void updateGPSFirebase(int updateValue, float data);
    private:
        //Define Firebase Data object
        FirebaseData fbdo; //here
        FirebaseAuth auth; //here
        FirebaseConfig config; //here
        FirebaseJson content; //here
        
        typedef enum{
            LONGITUDE,
            LATITUDE,
            LOCK,
            STATE
        } updateValue;
};


#endif