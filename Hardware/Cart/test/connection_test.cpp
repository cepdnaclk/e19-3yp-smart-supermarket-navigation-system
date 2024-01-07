#include <unity.h>
#include <WiFi.h>  
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "Secret.h"
#include <WiFiClientSecure.h>



void test_wifi_connection() {
  // Connect to Wi-Fi using your credentials
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  // Wait for connection and verify successful connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }
  TEST_ASSERT_EQUAL(WL_CONNECTED, WiFi.status());
}

// //AWS connection test

// WiFiClientSecure net = WiFiClientSecure();
// PubSubClient client(net);

// void test_aws_connection() {

    
//   // Connect to AWS using your credentials and configuration
//   // Configure WiFiClientSecure to use the AWS IoT device credentials
//   net.setCACert(AWS_CERT_CA);
//   net.setCertificate(AWS_CERT_CRT);
//   net.setPrivateKey(AWS_CERT_PRIVATE);
 
//   // Connect to the MQTT broker on the AWS endpoint we defined earlier
//   client.setServer(AWS_IOT_ENDPOINT, 8883);
 
//   // Create a message handler
 
//   while (!client.connect(THINGNAME))
//   {
//     delay(100);
//   }

//   // Verify successful connection
//   TEST_ASSERT_EQUAL(true, client.connected());
// }

// void test_aws_publish_Data() {

//   StaticJsonDocument<200> doc;
//   doc["message"] = "Test Data";
//   char jsonBuffer[512];
//   serializeJson(doc, jsonBuffer); // print to client
 
//   int publishResult=client.publish("esp32/pub", jsonBuffer);

//   // Verify successful connection
//   TEST_ASSERT_EQUAL(true, publishResult!=0);
// }

void setup() {
  UNITY_BEGIN();
}

void loop() {
  RUN_TEST(test_wifi_connection);
  //RUN_TEST(test_aws_connection);

  UNITY_END();
}

