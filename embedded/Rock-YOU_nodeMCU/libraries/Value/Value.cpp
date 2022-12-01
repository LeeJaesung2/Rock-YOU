#include "value.h"

/*initialize global value*/
void ValueClass::initValue(){
    //sendDataPrevMillis = 0;
    //signupOK = false;
    //lockState = false;
    //conn_bluetooth = false;
    //pastvib = 0;
    state = LOCK;
    preGpsValue.latitude = 0;
    preGpsValue.longitude = 0;
}