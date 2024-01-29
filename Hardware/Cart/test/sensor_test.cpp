#include <unity.h>
#include <Arduino.h>
#include <QMC5883LCompass.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

void test_compass_sensor_initialization() {
  // Initialize sensor
  QMC5883LCompass compass;
  compass.init();
  // Assert correct initialization state
  TEST_ASSERT_EQUAL(compass.getAzimuth()>=0, true);
}

void test_mpu_sensor_initialization() {
  // Initialize sensor
  Adafruit_MPU6050 mpu;
  
  // Assert correct initialization state
  TEST_ASSERT_EQUAL(mpu.begin(), true);
}
void test_mpu_sensor_reading() {
  // ... (test sensor reading functionality)
Adafruit_MPU6050 mpu;
mpu.begin();
mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
mpu.setGyroRange(MPU6050_RANGE_500_DEG);
mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);

sensors_event_t a, g, temp;
mpu.getEvent(&a, &g, &temp);

float yAccel = a.acceleration.y;
float xAccel = a.acceleration.x;

TEST_ASSERT_FLOAT_WITHIN(2.0f, 0.0f, yAccel);
TEST_ASSERT_FLOAT_WITHIN(2.0f, 10.0f, xAccel);


}

void test_compass_sensor_reading() {
  // ... (test sensor reading functionality)
  QMC5883LCompass compass;
  compass.init();

  float heading = compass.getAzimuth();
  TEST_ASSERT_GREATER_OR_EQUAL(0.0f, heading);  // Ensure heading is greater than or equal to 0
  TEST_ASSERT_LESS_OR_EQUAL(360.0f, heading);
}

void test_hall_sensor_reading() {
  // Initialize sensor
  int hallSensorPin = 34;
  int sensorValue = analogRead(hallSensorPin);

  // test readings
  TEST_ASSERT_FLOAT_WITHIN(1000.0f, 4096.0f, sensorValue);
}

// void setup() {
//   UNITY_BEGIN(); // Initialize Unity framework
// }

// void loop() {
//     //Test Compass Sensor
// RUN_TEST(test_compass_sensor_initialization);
// RUN_TEST(test_compass_sensor_reading);
  
//   //Test MPU Sensor
// RUN_TEST(test_mpu_sensor_initialization);
// RUN_TEST(test_mpu_sensor_reading);
    
//     //Test Hall Sensor
// RUN_TEST(test_hall_sensor_reading);

// UNITY_END(); // Finalize Unity framework
// }
