#include "Value.h"

#define BLE_RX_pin 32
#define BLE_TX_pin 33

//_________bluetooth________________
SoftwareSerial BTSerial(BLE_RX_pin, BLE_TX_pin);