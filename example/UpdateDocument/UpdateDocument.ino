
/**
 * Created by K. Suwatchai (Mobizt)
 *
 * Email: k_suwatchai@hotmail.com
 *
 * Github: https://github.com/mobizt/Firebase-ESP-Client
 *
 * Copyright (c) 2022 mobizt
 *
 */

// This example shows how to patch or update a document in a document collection. This operation required Email/password, custom or OAUth2.0 authentication.

#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif

#include <Firebase_ESP_Client.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Jaesung’s iPhone"
#define WIFI_PASSWORD "87654321"

/* 2. Define the API Key */
#define API_KEY "AIzaSyCYI5hrkkNjjQUB11bYCvdvfHHNmHUvNYc"

/* 3. Define the project ID */
#define FIREBASE_PROJECT_ID "rock-u-9c940"

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "dlwotjd9909@gmail.com"
#define USER_PASSWORD "FirebaseRockyou"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long dataMillis = 0;
int count = 0;

bool taskcomplete = false;

void setup()
{

    Serial.begin(115200);

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

    /* Assign the api key (required) */
    config.api_key = API_KEY;

    /* Assign the user sign in credentials */
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

    /* Assign the callback function for the long running token generation task */
    config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

#if defined(ESP8266)
    // In ESP8266 required for BearSSL rx/tx buffer for large data handle, increase Rx size as needed.
    fbdo.setBSSLBufferSize(2048 /* Rx buffer size in bytes from 512 - 16384 */, 2048 /* Tx buffer size in bytes from 512 - 16384 */);
#endif

    // Limit the size of response payload to be collected in FirebaseData
    fbdo.setResponseSize(2048);

    Firebase.begin(&config, &auth);

    Firebase.reconnectWiFi(true);
}

void loop()
{

    // Firebase.ready() should be called repeatedly to handle authentication tasks.

    if (Firebase.ready() && (millis() - dataMillis > 60000 || dataMillis == 0))
    {
        dataMillis = millis();

        // For the usage of FirebaseJson, see examples/FirebaseJson/BasicUsage/Create.ino
        FirebaseJson content;

        // aa is the collection id, bb is the document id.
        String documentPath = "bicycle/qf6r5zOcY4jXmmcniqX9";

        content.clear();
        content.set("fields/GPS/geoPointValue/latitude",1.486284);
        content.set("fields/GPS/geoPointValue/longitude",23.678198);
        //content.set("fields/bicycleNickname/stringValue");
        content.set("fields/lock/integerValue","1");
        content.set("fields/state/integerValue", "3");
        //content.set("fields/uid/referenceValue");

        Serial.print("Update a document... ");

        /** if updateMask contains the field name that exists in the remote document and
         * this field name does not exist in the document (content), that field will be deleted from remote document
         */

        if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "" /* databaseId can be (default) or empty */, documentPath.c_str(), content.raw(), "lock,state" /* updateMask */))
            Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
        else
            Serial.println(fbdo.errorReason());
    }
}
