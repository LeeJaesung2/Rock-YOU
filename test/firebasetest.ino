#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>


#define WIFI_SSID "Jaesung’s iPhone"
#define WIFI_PASSWORD "87654321"

#define API_KEY "AIzaSyCYI5hrkkNjjQUB11bYCvdvfHHNmHUvNYc"

#define FIREBASE_PROJECT_ID "rock-u-9c940"

#define USER_EMAIL "dlwotjd9909@gmail.com"
#define USER_PASSWORD "FirebaseRockyou"

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

    config.api_key = API_KEY;
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

    config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h


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
        FirebaseJson content;
        String documentPath = "bicycle/qf6r5zOcY4jXmmcniqX9";

        content.clear();
        content.set("fields/GPS/geoPointValue/latitude",1.486284);
        content.set("fields/GPS/geoPointValue/longitude",23.678198);
        content.set("fields/lock/integerValue","1");
        content.set("fields/state/integerValue", "3");
        Serial.print("Update a document... ");

        if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "" , documentPath.c_str(), content.raw(), "lock,state" /* updateMask */))
            Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
        else
            Serial.println(fbdo.errorReason());
    }
}