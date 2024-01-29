#include <Wire.h>
#include <IRremote.hpp>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <QMC5883LCompass.h> 
#include <IRremote.hpp>

#define IR_RECEIVE_PIN 25

int currentStation = 0;
int distance = 0;   

Adafruit_MPU6050 mpu;
QMC5883LCompass compass;

void initSensors() {
IrReceiver.begin(IR_RECEIVE_PIN, ENABLE_LED_FEEDBACK);

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

int getDistance()
{
  return distance;
}