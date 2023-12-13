
#include <Arduino.h>
#include "PinDefinitionsAndMore.h"
#include <IRremote.hpp>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_HMC5883_U.h> 
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "Dialog 4G 555"
#define WIFI_PASSWORD "5d56C7D3"

//Firebase Login
#define USER_EMAIL "nipulviduranga@gmail.com"
#define USER_PASSWORD "12345678";

// Insert Firebase project API Key
#define API_KEY "AIzaSyAIpMMSWsgndPTYbhA1_Sr6PEwRBt74yZM"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://shopwise-5987f-default-rtdb.asia-southeast1.firebasedatabase.app/" 

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;
Adafruit_MPU6050 mpu;
Adafruit_HMC5883_Unified mag;

const int hallSensorPin = 34;

unsigned long sendDataPrevMillis = 0;
int count = 0;
int distance = 0;
int currentStation = 0;

//Define Ir Receiver pins
#define DECODE_NEC     
#define IR_RECEIVE_PIN  25

 
void hallSensorInterrupt() {
    
    distance += 10; // Add 10cm to the distance if the sensor value is high
    
}

void setup() {
    Serial.begin(115200);

    attachInterrupt(digitalPinToInterrupt(hallSensorPin), hallSensorInterrupt, CHANGE);
    //Connect to Wifi
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

    /* Assign the api key (required) */
    config.api_key = API_KEY;

    /* Assign the user sign in credentials */
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;
    
   
    /* Assign the RTDB URL (required) */
    config.database_url = DATABASE_URL;

    /* Assign the callback function for the long running token generation task */
     config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
    // Comment or pass false value when WiFi reconnection will control by your code or third party library e.g. WiFiManager
    Firebase.reconnectNetwork(true);
    
    // Since v4.4.x, BearSSL engine was used, the SSL buffer need to be set.
    // Large data transmission may require larger RX buffer, otherwise connection issue or data read time out can be occurred.
    fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);

    // Limit the size of response payload to be collected in FirebaseData
    fbdo.setResponseSize(2048);

    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);

    Firebase.setDoubleDigits(5);

    config.timeout.serverResponse = 10 * 1000;
    
    //Ir Receive Begin    
    IrReceiver.begin(IR_RECEIVE_PIN, ENABLE_LED_FEEDBACK);
    Serial.print(F("Ready to receive IR signals of protocols: "));
    printActiveIRProtocols(&Serial);
    Serial.println(F("at pin " STR(IR_RECEIVE_PIN)));

    //Get Sensor data
    pinMode(hallSensorPin, INPUT); 
  Serial.begin(115200);

  Wire.begin(); // Start the I2C communication
  
  // Initialize MPU6050
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
  if (!mag.begin()) {
    Serial.println("Failed to find Magnetometer chip");
    while (1) {
      delay(10);
    }
  }
  
  delay(20);
}

void loop() {
        int receivedCommand = IrData();
        int direction = getMAGSensorReadings();
        int acceleration = getMPUSensorReadings();
        
        int heading = 1;
        if(acceleration > 0){
            heading = 1;
        }else{
            heading = -1;
        }
        

        sendDataToFirebase(currentStation, distance, direction, heading);
        
}


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
int hallEffectSensor(){
  int sensorValue = analogRead(hallSensorPin); 
  Serial.print("Analog Sensor Value: ");
  Serial.println(sensorValue);
  
  }

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
void sendDataToFirebase(int data, float distance, int direction, int heading) {
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 2000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    
    // Write unsigned long data to the database path test/data
    if (Firebase.RTDB.setInt(&fbdo, "test/data", data)) {
      Serial.println("INT PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Unsigned Long FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    // Write float data to the database path test/distance
    if (Firebase.RTDB.setFloat(&fbdo, "test/distance", distance)) {
      Serial.println("Float PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Float FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    // Write int data to the database path test/direction
    if (Firebase.RTDB.setInt(&fbdo, "test/direction", direction)) {
      Serial.println("Int PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Int FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    // Write int data to the database path test/direction
    if (Firebase.RTDB.setInt(&fbdo, "test/heading", heading)) {
      Serial.println("Int PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    } else {
      Serial.println("Int FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
  }
}