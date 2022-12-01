#include<SoftwareSerial.h>
SoftwareSerial gpsSerial(3,1);

char c; 
String str = ""; 
String targetStr = "GPGGA" ;

void setup() {
  Serial.begin(115200);
  gpsSerial.begin(9600);

}

void loop() {
  if(gpsSerial.available()){
    c = gpsSerial.read();
    Serial.write(gpsSerial.read());

  // 쉼표를 기준으로 파싱하기
  int firstData = str.indexOf(","); //첫 번째 콤마 전까지의 내용을 파싱 
  int secondData = str.indexOf(",", firstData+1); 
  int thirdData = str.indexOf(",", firstData+2); 
  int fourthData = str.indexOf(",", firstData+3); 
  int fivethData = str.indexOf(",", firstData+4); 

  Serial.print(firstData);
  Serial.print(secondData);
  Serial.print(thirdData);
  Serial.print(fourthData);
  Serial.print(fivethData);
  Serial.println("-------------");

  //data 추출 
  String Lat = str.substring(secondData+1, thirdData); 
  String Long = str.substring(fourthData+1, fivethData);
  Serial.print(Lat);
  Serial.print(Long);
  Serial.println("aaaaaaaaaaaaaaa");
  }

}


void encode(char c){
  // 쉼표를 기준으로 파싱하기
  int firstData = str.indexOf(","); //첫 번째 콤마 전까지의 내용을 파싱 
  int secondData = str.indexOf(",", firstData+1); 
  int thirdData = str.indexOf(",", firstData+2); 
  int fourthData = str.indexOf(",", firstData+3); 
  int fivethData = str.indexOf(",", firstData+4); 

  //data 추출 
  String Lat = str.substring(secondData+1, thirdData); 
  String Long = str.substring(fourthData+1, fivethData); 
}

/*13:42:32.662 -> $GPGGA,000043.799,,,,,0,0,,,M,,M,,*48
13:42:32.707 -> $GPGSA,A,1,,,,,,,,,,,,,,,*1E
13:42:32.752 -> $GPRMC,000043.799,V,,,,,0.00,0.00,050180,,,N*41
13:42:32.797 -> $GPVTG,0.00,T,,M,0.00,N,0.00,K,N*32*/
