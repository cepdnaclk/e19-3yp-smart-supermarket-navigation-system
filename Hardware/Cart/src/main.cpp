
#include <Arduino.h>
#include "PinDefinitionsAndMore.h"
#include "SupermarketMapper.h"
#include <display.h>
#include <IRremote.hpp>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h> 
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "Secret.h"
#include <WiFiClientSecure.h>
#include <WiFi.h>
#include <Wire.h>
#include <QMC5883LCompass.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// Insert your network credentials
#define WIFI_SSID "Dialog 4G 932"
#define WIFI_PASSWORD "B40a8EC1"

// #define WIFI_SSID "PeraComStudents"
// #define WIFI_PASSWORD "abcd1234"

#define AWS_IOT_PUBLISH_TOPIC   "esp32/pub"
#define AWS_IOT_SUBSCRIBE_TOPIC "esp32/test"


WiFiClientSecure net = WiFiClientSecure();
PubSubClient client(net);

Adafruit_MPU6050 mpu;
QMC5883LCompass compass;

const int hallSensorPin = 32;

unsigned long sendDataPrevMillis = 0;
int count = 0;
int distance = 0;
int currentStation = 0;
int currentLocation = 0;
uint8_t batt_counter = 200;
uint8_t prev_battLev = 200;

//Define Ir Receiver pins
#define DECODE_NEC     
#define IR_RECEIVE_PIN  25
#define wifiInd  16
#define awsInd 17
#define BATT_PIN 33

//battry info
#define BATTV_MAX           4.1     // maximum voltage of battery
#define BATTV_MIN           3.2     // what we regard as an empty battery
#define BATTV_LOW           3.4     // voltage considered to be low battery
#define BATT_ALERT_THRESHOLD 5      // how many times we read low battery before sending alert

//Map 
 
 //Print Battery Info
 int printBatteryLevel() {
  float battv = analogRead(BATT_PIN) * 2 * 3.3 / 4095 *1.05;
  Serial.println(battv);
  int battPercent = (battv - BATTV_MIN) / (BATTV_MAX - BATTV_MIN) * 100;
  Serial.print("Battery:");
  Serial.println(battPercent);
  batteryLevel(battPercent);
  return battPercent;
}

//Get Accelerometer and Gyroscope data  from MPU6050
int getMPUSensorReadings() {
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  Serial.print("Acceleration - Y: ");
  Serial.println(a.acceleration.y);

  // Serial.print("Gyroscope - X: ");
  // Serial.print(g.gyro.x);
  // Serial.print(", Y: ");
  // Serial.print(g.gyro.y);
  // Serial.print(", Z: ");
  // Serial.println(g.gyro.z);

  return a.acceleration.z;
}

//Get Hall Effect Sensor data
int hallEffectSensor(){
  int sensorValue = analogRead(hallSensorPin); 
  Serial.print("Analog Sensor Value: ");
  Serial.println(sensorValue);
  return sensorValue;
  }

//Get Magnetometer data from HMC5883L
int getMAGSensorReadings() {
  int x, y, z, a, b;
	char myArray[3];
	
	compass.read();
  
	x = compass.getX();
	y = compass.getY();
	z = compass.getZ();
	
	// Calculate heading angle


  float heading = compass.getAzimuth();
 
  return heading;
}

//Read IR sensor data
int IrData(){
  int receivedCommand=0;
  if (IrReceiver.decode()) {
       
        IrReceiver.printIRResultShort(&Serial);
        IrReceiver.printIRSendUsage(&Serial);
        if (IrReceiver.decodedIRData.protocol == UNKNOWN) {
            Serial.println(F("Received noise or an unknown (or not yet enabled) protocol"));
        }else{
          Serial.println();
        
          receivedCommand = IrReceiver.decodedIRData.command;
  
          if(currentStation != receivedCommand){
              currentStation = receivedCommand;
              distance = 0;
          }
        }
        IrReceiver.resume(); // Enable receiving of the next value
    }
    return receivedCommand;
  
  }

//Send Testing data to AWS
void publishTestData()
{
  Serial.print("Publishing Test Data:");

  StaticJsonDocument<200> doc;
  doc["message"] = "This is Test Data , Connection was Successful";
  doc["distance_Readings"] = distance;
  doc["current_Station"] = currentStation;
  doc["current_Location"] = currentLocation;
  doc["current_Direction"] = getMAGSensorReadings();
  doc["current_Acceleration"] = getMPUSensorReadings();
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
 
  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);

  Serial.print("Successfully Publlished Test Data");

}


void messageHandler(char* topic, byte* payload, unsigned int length)
{
  Serial.print("incoming: ");
  Serial.println(topic);
 
  StaticJsonDocument<200> doc;
  deserializeJson(doc, payload);
  const char* message = doc["message"];
  if(message == "test"){
    publishTestData();
  }
  Serial.println(message);
}

void connectAWS()
{
    //Connect to Wifi
    WiFi.mode(WIFI_STA);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    displayText("Connectingto WiFi", 2, 1);
    while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
    }
    digitalWrite(wifiInd, HIGH);
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    clearDisplay();
    displayText("Connected to WiFi", 2, 1);
 
  // Configure WiFiClientSecure to use the AWS IoT device credentials
  net.setCACert(AWS_CERT_CA);
  net.setCertificate(AWS_CERT_CRT);
  net.setPrivateKey(AWS_CERT_PRIVATE);
 
  // Connect to the MQTT broker on the AWS endpoint we defined earlier
  client.setServer(AWS_IOT_ENDPOINT, 8883);
 
  // Create a message handler
  client.setCallback(messageHandler);
 
  Serial.println("Connecting to AWS IOT");
  clearDisplay();
  displayText("Connectingto Server", 2, 1);
 
  while (!client.connect(THINGNAME))
  {
    Serial.print(".");
    delay(100);
  }
 
  if (!client.connected())
  { 
    clearDisplay();
    displayText("Connection Failed", 2, 1);
    Serial.println("AWS IoT Timeout!");
    return;
  }
  digitalWrite(awsInd, HIGH);
  // Subscribe to a topic
  client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
 
  Serial.println("AWS IoT Connected!");
  //display screen connection status
  clearDisplay();
  displayText("Connected To Server", 2, 1);
  clearDisplay();
  displayText("Enjoy", 2, 1);
  displayText("Shopping", 2, 2);
  displayHeader();

}
 
void publishMessage(int position)
{
  Serial.print("Distance:");
  Serial.print(distance);
  Serial.print(" Station:");
  Serial.println(currentStation);
  StaticJsonDocument<200> doc;
  doc["distance"] = distance;
  doc["current_Station"] = currentStation;
  doc["current_Location"] = position;
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
 
  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}
 
//Interupt for hall sensor for get distance
void hallSensorInterrupt() {
    
    distance += 15; // Add 10cm to the distance if the sensor value is high
    
}

//Create Supermarket Mapper Object
SupermarketMapper supermarketMapper;

//Create Display Object
//Display OledDisplay;

void setup() {
    Serial.begin(115200);

    attachInterrupt(digitalPinToInterrupt(hallSensorPin), hallSensorInterrupt, RISING);

    //Initiate Indicate LEDs
    pinMode(wifiInd, OUTPUT); //WiFi indicator
    pinMode(awsInd, OUTPUT); // AWS connection indicator

    // initialize the OLED object
    initOLED();

    //AWS Connect
    connectAWS();

    
    //Ir Receive Begin    
    IrReceiver.begin(IR_RECEIVE_PIN, ENABLE_LED_FEEDBACK);
    //Serial.print(F("Ready to receive IR signals of protocols: "));
    //printActiveIRProtocols(&Serial);
    //Serial.println(F("at pin " STR(IR_RECEIVE_PIN)));

    //Get Sensor data
    pinMode(hallSensorPin, INPUT); 
    pinMode(4, INPUT); 
    pinMode(BATT_PIN, INPUT);

    //Calibrate HMC5883L
    //compass.calibrate();

    

  Wire.begin(); // Start the I2C communication
  
  //Initialize MPU6050
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);
  
  // Initialize HMC5883L
  compass.init();
  
  delay(20);
}

void loop() {
        int receivedCommand = IrData();
        int direction = getMAGSensorReadings();
        //hallEffectSensor();
        int acceleration = getMPUSensorReadings();
        
        int heading = 1;
        if(acceleration > 0){
            heading = 1;
        }else{
            heading = 1;
        }

  
    supermarketMapper.updateLocation(receivedCommand, direction, distance, heading);
    
    
    currentLocation = supermarketMapper.displayLocation();
    publishMessage(currentLocation);
    client.loop();

    //Print Battery Level
    if(batt_counter >= 200 && prev_battLev >= printBatteryLevel()){
      prev_battLev = printBatteryLevel();
      batt_counter = 0;
      }else{
        batt_counter++;
      }

    delay(1500);
}


