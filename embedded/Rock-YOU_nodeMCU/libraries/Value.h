#include <SoftwareSerial.h>
#include <Arduino.h>
//_________mcu board________________
//DEBUG mode
#define DEBUG true

#define bicycleId "qf6r5zOcY4jXmmcniqX9" //PBMS identication key

//global variables
unsigned long sendDataPrevMillis; //last data send time
bool signupOK; //firebase login
bool lock;
bool conn_bluetooth;
//int pastvib; //sensing shock value  safe = 0, shock = 1
int state;

typedef enum {
    SAFE,
    //SHOCK,
    STEEL,
    DRIVE
} bicycleState;

typedef enum{
    LONGITUDE,
    LATITUDE,
    LOCK,
    STATE
} value;


void initValue();