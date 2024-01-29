// Send Testing data to AWS
// void publishTestData()
// {
//   Serial.print("Publishing Test Data:");

//   StaticJsonDocument<200> doc;
//   doc["message"] = "This is Test Data , Connection was Successful";
//   doc["distance_Readings"] = distance;
//   doc["current_Station"] = currentStation;
//   doc["current_Location"] = currentLocation;
//   doc["current_Direction"] = getMAGSensorReadings();
//   doc["current_Acceleration"] = getMPUSensorReadings();
//   char jsonBuffer[512];
//   serializeJson(doc, jsonBuffer); // print to client

//   client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);

//   Serial.print("Successfully Publlished Test Data");
// }