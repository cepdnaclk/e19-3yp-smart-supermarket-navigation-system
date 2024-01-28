
#include <Arduino.h>
#include <ElegantOTA.h>
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

#define firmwareVersion 1.1

#define AWS_IOT_PUBLISH_TOPIC "esp32/pub"
#define AWS_IOT_SUBSCRIBE_TOPIC "esp32/test"

WiFiClientSecure net = WiFiClientSecure();
PubSubClient client(net);

Adafruit_MPU6050 mpu;
QMC5883LCompass compass;

const int hallSensorPin = 32;

const int biosPin = 35;

unsigned long sendDataPrevMillis = 0;
int count = 0;
int distance = 0;
int currentStation = 0;
int currentLocation = 0;
uint8_t batt_counter = 200;
uint8_t prev_battLev = 200;

// Define Ir Receiver pins
#define DECODE_NEC
#define IR_RECEIVE_PIN 25
#define wifiInd 16
#define awsInd 17
#define BATT_PIN 33

// battry info
#define BATTV_MAX 4.1          // maximum voltage of battery
#define BATTV_MIN 3.2          // what we regard as an empty battery
#define BATTV_LOW 3.4          // voltage considered to be low battery
#define BATT_ALERT_THRESHOLD 5 // how many times we read low battery before sending alert

// Map

// Wifi list
const char *ssid[] = {"Dialog 4G 555", "Dialog 4G 932", "dlg989", "Eng-Student", "PeraComStudents"}; // List of SSIDs to try
const char *password[] = {"5d56C7D3", "B40a8EC1", "coc200044", "3nG5tuDt", "abcd1234"};              // Corresponding passwords
const int num_ssids = 5;
int ssid_index = 0;

// Try multiple wifi(s) and connect
void connectToWiFi()
{
  Serial.println("Connecting to WiFi");
  clearDisplay();
  displayText("Connecting to WiFi", 2, 1);
  delay(500);

  int attempts = 0;
  for (int j = 0; j < 10; j++)
  {

    while (WiFi.status() != WL_CONNECTED)
    {
      Serial.print("Attempting connection to ");
      Serial.println(ssid[ssid_index]);
      clearDisplay();
      displayText("Trying...", 2, 0);
      displayText(ssid[ssid_index], 2, 2);

      for (int i = 0; i < 2; i++)
      {
        WiFi.begin(ssid[ssid_index], password[ssid_index]);
        delay(3000);
        if (WiFi.status() == WL_CONNECTED)
          break;
      }

      ssid_index++;

      // infinite loop if no SSID is found
      if (ssid_index >= num_ssids)
      {
        ssid_index = 0;
      }
    }
    ssid_index = 0;
  }

  if (WiFi.status() == WL_CONNECTED)
  {
    Serial.println("Connected to WiFi");
    Serial.print("SSID: ");
    Serial.println(WiFi.SSID());
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());
    clearDisplay();
    displayText("WiFi      connected!", 2, 1);
    digitalWrite(wifiInd, HIGH);
  }
  else
  {
    Serial.println("Could not connect to any available SSID");
    clearDisplay();
    displayText("WiFi connection failed!", 1, 1);
    while (1)
    {
      displayText("Please Restart Device", 1, 1);
    }
  }
  delay(1000);
}

// Print Battery Info
int printBatteryLevel()
{
  float battv = analogRead(BATT_PIN) * 2 * 3.3 / 4095 * 1.05;
  Serial.println(battv);
  int battPercent = (battv - BATTV_MIN) / (BATTV_MAX - BATTV_MIN) * 100;
  Serial.print("Battery:");
  Serial.println(battPercent);
  batteryLevel(battPercent);
  return battPercent;
}

// Get Accelerometer and Gyroscope data  from MPU6050
float getMPUSensorReadings()
{
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

// Get Hall Effect Sensor data
int hallEffectSensor()
{
  int sensorValue = analogRead(hallSensorPin);
  Serial.print("Analog Sensor Value: ");
  Serial.println(sensorValue);
  return sensorValue;
}

// Get Magnetometer data from HMC5883L
int getMAGSensorReadings()
{
  int x, y, z, a, b;
  char myArray[3];

  compass.read();
  //compass.calibrate();
  x = compass.getX();
  y = compass.getY();
  z = compass.getZ();

  // Calculate heading angle

  //float heading = compass.getAzimuth();

  // Convert heading from radians to degrees
  float headingDegrees = atan2( y, x ) * 180.0 / PI;
  
  // Ensure heading is in the range [0, 360)
  if (headingDegrees < 0) {
    headingDegrees += 360.0;
  }
  
  //Calibrate for Real Values
   headingDegrees = 0.0000147207 * pow(headingDegrees, 3) - 0.0102583 * pow(headingDegrees, 2) + 2.7987 * headingDegrees + 36.2822;
   if(headingDegrees > 360){
    headingDegrees = headingDegrees - 360.0;
   }
        


  return headingDegrees;

 
}

// Read IR sensor data
int IrData()
{
  int receivedCommand = 0;
  if (IrReceiver.decode())
  {

    IrReceiver.printIRResultShort(&Serial);
    IrReceiver.printIRSendUsage(&Serial);
    if (IrReceiver.decodedIRData.protocol == UNKNOWN)
    {
      Serial.println(F("Received noise or an unknown (or not yet enabled) protocol"));
    }
    else
    {
      Serial.println();

      receivedCommand = IrReceiver.decodedIRData.command;

      if (currentStation != receivedCommand)
      {
        currentStation = receivedCommand;
        distance = 0;
      }
    }
    IrReceiver.resume(); // Enable receiving of the next value
  }
  return receivedCommand;
}



void messageHandler(char *topic, byte *payload, unsigned int length)
{
  Serial.print("incoming: ");
  Serial.println(topic);

  StaticJsonDocument<200> doc;
  deserializeJson(doc, payload);
  const char *message = doc["message"];
  Serial.println(message);
}

void connectAWS()
{
  // Connect to Wifi
  connectToWiFi();

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
  // display screen connection status
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
  doc["current_Direction"] = getMAGSensorReadings();
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client

  client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);
}

// Interupt for hall sensor for get distance
void hallSensorInterrupt()
{

  distance += 31; // Add 10cm to the distance if the sensor value is high
}

// The following codes are for OTA implementation (server, biosMode)
// web server for elegantOTA
WebServer server(80);

void biosMode()
{
  // display Recovery Init Screen
  clearDisplay();
  displayText("Recovery", 2, 1);
  displayText("Mode", 2, 2);
  delay(2000);

  // Connect to Wifi
  connectToWiFi();

  // Once connected, get the local IP address
  IPAddress localIP = WiFi.localIP();

  // Convert the IP address to char array
  char ssidName[20];
  char ipAddressCharArray[16]; // IPv4 addresses are at most 15 characters long
  WiFi.SSID().toCharArray(ssidName, sizeof(ssidName));
  localIP.toString().toCharArray(ipAddressCharArray, sizeof(ipAddressCharArray));

  server.on("/", []()
            { server.send(200, "text/plain", "Shopwise booted in recovery mode."); });

  ElegantOTA.begin(&server); // Start ElegantOTA
  server.begin();
  Serial.println("Recovery server started");

  // Set ip address info to display
  clearDisplay();
  displayText("   ~Recovery Mode~", 1, 0);
  displayText(ssidName, 1, 2);
  displayText(ipAddressCharArray, 1, 4);
  char versionBuffer[20];
  sprintf(versionBuffer, "firmware v%.2f", firmwareVersion);
  displayText(versionBuffer, 1, 6);

  while (1)
  {
    server.handleClient();
    ElegantOTA.loop();
  }
}

// Create Supermarket Mapper Object
SupermarketMapper supermarketMapper;

// Create Display Object
// Display OledDisplay;

void setup()
{
  Serial.begin(115200);

  // initialize the OLED object
  initOLED();

  pinMode(biosPin, INPUT);
  int Push_button_state = digitalRead(biosPin);

  if (Push_button_state == HIGH)
  {
    // delay(500);
    Serial.println("Booting in recovery mode");
    delay(500);
    biosMode();
  }

  attachInterrupt(digitalPinToInterrupt(hallSensorPin), hallSensorInterrupt, RISING);

  // Initiate Indicate LEDs
  pinMode(wifiInd, OUTPUT); // WiFi indicator
  pinMode(awsInd, OUTPUT);  // AWS connection indicator

  // AWS Connect
  connectAWS();

  // Ir Receive Begin
  IrReceiver.begin(IR_RECEIVE_PIN, ENABLE_LED_FEEDBACK);
  // Serial.print(F("Ready to receive IR signals of protocols: "));
  // printActiveIRProtocols(&Serial);
  // Serial.println(F("at pin " STR(IR_RECEIVE_PIN)));

  // Get Sensor data
  pinMode(hallSensorPin, INPUT);
  pinMode(4, INPUT);
  pinMode(BATT_PIN, INPUT);

  // Calibrate HMC5883L
  // compass.calibrate();

  Wire.begin(); // Start the I2C communication

  // Initialize MPU6050
  if (!mpu.begin())
  {
    Serial.println("Failed to find MPU6050 chip");
    while (1)
    {
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

void loop()
{
  int receivedCommand = IrData();
  int direction = getMAGSensorReadings();
  // hallEffectSensor();
  float acceleration = getMPUSensorReadings();

  int heading = 1;
  if (acceleration > 0)
  {
    heading = 1;
  }
  else
  {
    heading = 1;
  }

  supermarketMapper.updateLocation(receivedCommand, direction, distance, heading);

  currentLocation = supermarketMapper.displayLocation();
  publishMessage(currentLocation);
  client.loop();

  // // Print Battery Level
  // if (batt_counter >= 200 && prev_battLev >= printBatteryLevel())
  // {
  //   prev_battLev = printBatteryLevel();
  //   batt_counter = 0;
  // }
  // else
  // {
  //   batt_counter++;
  // }

  // Test Results
  clearDisplay();
  showTestData(direction, acceleration, distance, currentLocation, currentStation, supermarketMapper.getLocationX(), supermarketMapper.getLocationY(),compass.getX(),compass.getY(),compass.getZ());

  delay(1500);
}
