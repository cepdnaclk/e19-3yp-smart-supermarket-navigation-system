#include <unity.h>
#include "connection_test.cpp"
#include "sensor_test.cpp"

void setup() {
  UNITY_BEGIN();
}

void loop() {

     //Test Compass Sensor
RUN_TEST(test_compass_sensor_initialization);
RUN_TEST(test_compass_sensor_reading);
  
  //Test MPU Sensor
RUN_TEST(test_mpu_sensor_initialization);
RUN_TEST(test_mpu_sensor_reading);
    
    //Test Hall Sensor
RUN_TEST(test_hall_sensor_reading);

    //Test Wifi Connection
//RUN_TEST(test_wifi_connection);

  UNITY_END();
}