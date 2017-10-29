#define PIN_HEATER 14 // D14(A0)
#define PIN_SENSOR 15 // D15(A1)
#define PIN_OUTPUT 3 // A3

#include <Adafruit_Sensor.h>
#include <DHT.h>
#define DHTPIN 2     // what digital pin we're connected to
#define DHTTYPE DHT11   // DHT 11
DHT dht(DHTPIN, DHTTYPE);

#include <Wire.h>
#include <skADT7410.h>
skADT7410 Temp(0x48);


void setup() {
 pinMode(PIN_HEATER,OUTPUT);
 pinMode(PIN_SENSOR,OUTPUT);
 digitalWrite(PIN_HEATER,HIGH); // Heater Off
 digitalWrite(PIN_SENSOR,LOW); // Sensor Pullup Off

 Wire.begin();
 Temp.Begin();
 Temp.ActionMode(ADT_MODE_CONTINUE);
 
 Serial.begin(9600);
 //Serial.println("DHT11");
 dht.begin();
}

void loop() {
 int val_average = 0;
 int val = 0;
 int val_threshold=350;
 int smell_loop = 4;
 int databytes[] = {0,0,0,0,0};
 float temp;
 
 Temp.Read(&temp);
 temp = int(temp/0.0625);
 //Serial.println(temp);
 
 databytes[0] = temp;
 
 //delay(2000);
 
 float h = dht.readHumidity();
  // Read temperature as Celsius (the default)
 float t = dht.readTemperature();
  // Read temperature as Fahrenheit (isFahrenheit = true)
  //float f = dht.readTemperature(true);

 databytes[1] = h;
  
  // Check if any reads failed and exit early (to try again).
  /*
  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  
  // Compute heat index in Fahrenheit (the default)
  float hif = dht.computeHeatIndex(f, h);
  // Compute heat index in Celsius (isFahreheit = false)
  float hic = dht.computeHeatIndex(t, h, false);
  */
  
  //Serial.print("Humidity: ");
  //Serial.println(h);
  //Serial.print(" %\t");
  //Serial.print("Temperature: ");
  //Serial.println(t);
  //Serial.print(" *C ");
  //Serial.print(f);
  //Serial.print(" *F\t");
  //Serial.print("Heat index: ");
  //Serial.print(hic);
  //Serial.print(" *C ");
  //Serial.print(hif);
  //Serial.println(" *F");
  
  

 for (int i = 0; i<smell_loop; i++){
   delay(237);
   digitalWrite(PIN_SENSOR,HIGH); // Sensor Pullup On
   delay(3);
   val += analogRead(PIN_OUTPUT); // Get Sensor Voltage
   delay(2);
   digitalWrite(PIN_SENSOR,LOW); // Sensor Pullup Off
  
   digitalWrite(PIN_HEATER,LOW); // Heater On
   delay(8);
   digitalWrite(PIN_HEATER,HIGH); // Heater Off   
 }
 
 val_average = val/smell_loop;
 //Serial.println(val_average);
 if(val_average<val_threshold){
    databytes[2] = 1;
    //Serial.println("smelled")
   }
 else{
    databytes[2] = 0;
    //Serial.println("ok")
 }
   
 for (int i = 0; i<4; i++){
   Serial.print(databytes[i]); //smell, temperature, humidity
   Serial.print(',');
 }
 Serial.println(databytes[4]);
}
