#include "value.h"

/*initialize global value*/
void initValue(){
    sendDataPrevMillis = 0;
    signupOK = false;
    lock = false;
    conn_bluetooth = false;
    //pastvib = 0;
    state = SAFE;
}