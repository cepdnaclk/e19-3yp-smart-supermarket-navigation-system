// SupermarketMapper.cpp

#include <Arduino.h>
#include <map>

class SupermarketMapper {
public:
  SupermarketMapper();
  void updateLocation(int irSignal, float magnetometerReading,int distance, int heading);
  void turnLeft();
  void turnRight();
  void moveForward();
  void moveBackward();
  void displayLocation();
  int getCurrentCell();
  void resetPosition();

private:
  std::pair<int, int> cart_location;  // {row, col}
  float cart_direction;               // degrees
  std::map<String, std::pair<int, int>> landmarks;
  int supermarketMatrix[7][5] = {
    {1, 2, 3, 4, 5},
    {6, 7, 8, 9, 10},
    {11, 12, 13, 14, 15},
    {16, 17, 18, 19, 20},
    {21, 22, 23, 24, 25},
    {26, 27, 28, 29, 30},
    {31, 32, 33, 34, 35}
};  // Example 7x5 matrix, adjust the size as needed
  
  int currentDistance;
  int imgNorth = 0; // ^ is the north
};

SupermarketMapper::SupermarketMapper() {
  // Initialize variables for cart location and direction
  cart_location = {0, 0};  // Initial location at the top-left corner
  cart_direction = 0;       // Initial direction (in degrees)


// Define landmarks in the supermarket (including item racks)
  landmarks["Entrance"] = {0, 0};
  landmarks["BS1N"] = {2, 0};
  landmarks["BS1S"] = {5, 0};
  landmarks["BS2N"] = {2, 2};
  landmarks["BS2S"] = {5, 2};
  landmarks["BS3N"] = {2, 4};
  landmarks["BS3S"] = {5, 4};
  
  // Add more item racks and landmarks as needed
}

void SupermarketMapper::updateLocation(int irSignal, float magnetometerReading,int distance,int heading) {
  // Update cart location based on IR signal
  if (irSignal == 54) {
    cart_location = landmarks["BS1N"];
  }else if (irSignal == 49)
  {
    cart_location = landmarks["BS1S"];
  }else if (irSignal == 53)
  {
    cart_location = landmarks["BS2N"];
  }else if (irSignal == 50)
  {
    cart_location = landmarks["BS2S"];
  }else if (irSignal == 52)
  {
    cart_location = landmarks["BS3N"];
  }else if (irSignal == 51)
  {
    cart_location = landmarks["BS3S"];
  }
  

  // Update cart direction based on magnetometer reading
  cart_direction = magnetometerReading;

  //Correct the direction
  cart_direction = cart_direction - imgNorth;
  if (cart_direction < 0) {
    cart_direction += 360;
  }
  if(distance != currentDistance){
    if(heading == 1){
    moveForward();
    }else{
      moveBackward();
    }
    currentDistance = distance;
}

}

void SupermarketMapper::moveForward() {    


  // Move forward one location point in the matrix based on the current direction
  if (cart_direction >= 340 && cart_direction <= 360 || cart_direction >= 0 && cart_direction <= 20 ) {
    cart_location.first--;  // Move to the up
  } else if (cart_direction >= 40 && cart_direction <= 120) {
    cart_location.second++;  // Move to right
  } else if (cart_direction >= 240 && cart_direction <= 300) {
    cart_location.second--;   // Move left
  } else if (cart_direction >= 150 && cart_direction <= 210) {
    cart_location.first++;   // Move downward
  }
}

void SupermarketMapper::moveBackward() {
  // Move backward one location point in the matrix based on the current direction
  if (cart_direction >= 340 && cart_direction <= 360 || cart_direction >= 0 && cart_direction <= 20 ) {
    cart_location.first++;  // Move to the up
  } else if (cart_direction >= 40 && cart_direction <= 120) {
    cart_location.second--;  // Move to right
  } else if (cart_direction >= 240 && cart_direction <= 300) {
    cart_location.second++;   // Move left
  } else if (cart_direction >= 150 && cart_direction <= 210) {
    cart_location.first--;   // Move downward
  }
}

void SupermarketMapper::turnLeft() {
  // Simulate a left turn (adjust direction and matrix position accordingly)
  cart_direction -= 90;
  if (cart_direction < 0) {
    cart_direction += 360;
  }
  cart_location.second--;
}

void SupermarketMapper::turnRight() {
  // Simulate a right turn (adjust direction and matrix position accordingly)
  cart_direction += 90;
  if (cart_direction >= 360) {
    cart_direction -= 360;
  }
  cart_location.second++;
}

void SupermarketMapper::displayLocation() {
  Serial.print("Cart Location: (");
  Serial.print(cart_location.first);
  Serial.print(", ");
  Serial.print(cart_location.second);
  Serial.print(", ");
  Serial.print(supermarketMatrix[cart_location.first][cart_location.second]);
  Serial.print("), Direction: ");
  Serial.print(cart_direction);
  Serial.println(" degrees");

}

int SupermarketMapper::getCurrentCell() {
  // Get the current cell number based on the cart's location
  return supermarketMatrix[cart_location.first][cart_location.second];
}

void SupermarketMapper::resetPosition() {
  // Reset the cart's position to the top-left corner
  cart_location = {0, 0};
  cart_direction = 0;
}
