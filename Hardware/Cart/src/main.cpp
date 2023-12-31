
#include <Arduino.h>
#include "PinDefinitionsAndMore.h"
#include "SupermarketMapper.h"
#include <IRremote.hpp>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_HMC5883_U.h> 
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "Secret.h"
#include <WiFiClientSecure.h>
#include <WiFi.h>
#include <Wire.h>

// Insert your network credentials
#define WIFI_SSID "Dialog 4G 500"
#define WIFI_PASSWORD "775bECe1"

#define AWS_IOT_PUBLISH_TOPIC   "esp32/pub"
#define AWS_IOT_SUBSCRIBE_TOPIC "esp32/sub"

WiFiClientSecure net = WiFiClientSecure();
PubSubClient client(net);

Adafruit_MPU6050 mpu;
Adafruit_HMC5883_Unified mag = Adafruit_HMC5883_Unified(12345);

const int hallSensorPin = 34;

unsigned long sendDataPrevMillis = 0;
int count = 0;
int distance = 0;
int currentStation = 0;

//Define Ir Receiver pins
#define DECODE_NEC     
#define IR_RECEIVE_PIN  25

//Map 
 

//Get Accelerometer and Gyroscope data  from MPU6050
int getMPUSensorReadings() {
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  Serial.print("Accelerometer - X: ");
  Serial.print(a.acceleration.x);
  Serial.print(", Y: ");
  Serial.print(a.acceleration.y);
  Serial.print(", Z: ");
  Serial.println(a.acceleration.z);

  Serial.print("Gyroscope - X: ");
  Serial.print(g.gyro.x);
  Serial.print(", Y: ");
  Serial.print(g.gyro.y);
  Serial.print(", Z: ");
  Serial.println(g.gyro.z);

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
  sensors_event_t event;
  mag.getEvent(&event);


/* Display the results (magnetic vector values are in micro-Tesla (uT)) */
  Serial.print("X: ");
  Serial.print(event.magnetic.x);
  Serial.print(" ");
  Serial.print("Y: ");
  Serial.print(event.magnetic.y);
  Serial.print("");
  Serial.print("Z: ");
  Serial.print(event.magnetic.z);
  Serial.print(" ");
  Serial.println("uT");

  float heading = atan2(event.magnetic.y, event.magnetic.x);

// Once you have your heading, you must then add your ‘Declination Angle', which is the ‘Error' of the magnetic field in your location.
// Find yours here: http://www.magnetic-declination.com/
// Mine is: -13* 2′ W, which is ~13 Degrees, or (which we need) 0.22 radians
// If you cannot find your Declination, comment out these two lines, your compass will be slightly off.
  float declinationAngle = 0.22;
  heading += declinationAngle;

// Correct for when signs are reversed.
  if(heading < 0)
  heading += 2*PI;


// Check for wrap due to addition of declination.
  if(heading > 2*PI)
  heading -= 2*PI;

  // Convert radians to degrees for readability.
  float headingDegrees = heading * 180/M_PI;

  Serial.print("Heading (degrees): ");
  Serial.println(headingDegrees);

  return headingDegrees;
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
        
          int receivedCommand = IrReceiver.decodedIRData.command;
          if(currentStation != receivedCommand){
              currentStation = receivedCommand;
              distance = 0;
          }
        }
        IrReceiver.resume(); // Enable receiving of the next value
    }
    return receivedCommand;
  
  }

void messageHandler(char* topic, byte* payload, unsigned int length)
{
  Serial.print("incoming: ");
  Serial.println(topic);
 
  StaticJsonDocument<200> doc;
  deserializeJson(doc, payload);
  const char* message = doc["message"];
  Serial.println(message);
}


void connectAWS()
{
    //Connect to Wifi
    WiFi.mode(WIFI_STA);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();
 
  // Configure WiFiClientSecure to use the AWS IoT device credentials
  net.setCACert(AWS_CERT_CA);
  net.setCertificate(AWS_CERT_CRT);
  net.setPrivateKey(AWS_CERT_PRIVATE);
 
  // Connect to the MQTT broker on the AWS endpoint we defined earlier
  client.setServer(AWS_IOT_ENDPOINT, 8883);
 
  // Create a message handler
  client.setCallback(messageHandler);
 
  Serial.println("Connecting to AWS IOT");
 
  while (!client.connect(THINGNAME))
  {
    Serial.print(".");
    delay(100);
  }
 
  if (!client.connected())
  {
    Serial.println("AWS IoT Timeout!");
    return;
  }
 
  // Subscribe to a topic
  client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
 
  Serial.println("AWS IoT Connected!");
}
 
void publishMessage()
{
  Serial.print("Distance:");
  Serial.print(distance);
  Serial.print(" Station:");
  Serial.println(currentStation);
  StaticJsonDocument<200> doc;
  doc["distance"] = distance;
  doc["current Location"] = currentStation;
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
 
  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}
 
//Interupt for hall sensor for get distance
void hallSensorInterrupt() {
    
    distance += 10; // Add 10cm to the distance if the sensor value is high
    
}

SupermarketMapper supermarketMapper;

void setup() {
    Serial.begin(115200);

    attachInterrupt(digitalPinToInterrupt(hallSensorPin), hallSensorInterrupt, RISING);
        
    //AWS Connect
    //connectAWS();

    //Ir Receive Begin    
    IrReceiver.begin(IR_RECEIVE_PIN, ENABLE_LED_FEEDBACK);
    //Serial.print(F("Ready to receive IR signals of protocols: "));
    //printActiveIRProtocols(&Serial);
    //Serial.println(F("at pin " STR(IR_RECEIVE_PIN)));

    //Get Sensor data
    pinMode(hallSensorPin, INPUT); 
    pinMode(4, INPUT); 

  // Wire.begin(); // Start the I2C communication
  
  // //Initialize MPU6050
  // if (!mpu.begin()) {
  //   Serial.println("Failed to find MPU6050 chip");
  //   while (1) {
  //     delay(10);
  //   }
  // }

  // mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  // mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  // mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);
  
  // // Initialize HMC5883L
  // if (!mag.begin()) {
  //   Serial.println("Failed to find Magnetometer chip");
  //   while (1) {
  //     delay(10);
  //   }
  // }
  
  delay(20);
}

void loop() {
        int receivedCommand = IrData();
        //int direction = getMAGSensorReadings();
        //hallEffectSensor();
        // int acceleration = getMPUSensorReadings();
        
        // int heading = 1;
        // if(acceleration > 0){
        //     heading = 1;
        // }else{
        //     heading = -1;
        // }
     int heading = 1;
    int sensorValue = analogRead(4); 
    sensorValue = map(sensorValue, 0, 4095, 0, 360);
    Serial.print("Magnetometer Value: ");
    Serial.println(sensorValue);

      supermarketMapper.updateLocation(currentStation, sensorValue, distance, heading);
      supermarketMapper.displayLocation();
        
        // publishMessage();
        // client.loop();

        delay(1500);
}


