// SupermarketMapper.cpp

#include <Arduino.h>
#include <map>

class SupermarketMapper
{
public:
  SupermarketMapper();
  void updateLocation(int irSignal, float magnetometerReading, int distance, int heading);
  void turnLeft();
  void turnRight();
  void moveForward();
  void moveBackward();
  int displayLocation();
  int getCurrentCell();
  void resetPosition();
  int getLocationX();
  int getLocationY();
  std::pair<int, int> findCellLocation(int cellNumber);
  

private:
  std::pair<int, int> cart_location; // {row, col}
  float cart_direction;              // degrees
  std::map<String, std::pair<int, int>> landmarks;
  static const int row = 20;
  static const int col = 11;
  int supermarketMatrix[row][col] = {
      {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
        {11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21},
        {22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32},
        {33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43},
        {44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54},
        {55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65},
        {66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76},
        {77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87},
        {88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98},
        {99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109},
        {110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120},
        {121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131},
        {132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142},
        {143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153},
        {154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164},
        {165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175},
        {176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186},
        {187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
        {198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208},
        {209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219}
      }; // Example 7x5 matrix, adjust the size as needed

  int currentDistance;
  int imgNorth = 0; // ^ is the north
  int tileLength = 30;
  int currentStation;
  String currentPositon="NW";
  int turnFlag = 0;
};

SupermarketMapper::SupermarketMapper()
{
  // Initialize variables for cart location and direction
  cart_location = findCellLocation(200); // Initial location at the top-left corner
  cart_direction = 0;     // Initial direction (in degrees)

  // Define landmarks in the supermarket (including item racks)
  landmarks["206"] = findCellLocation(206);
  landmarks["178"] = findCellLocation(178);
  landmarks["101"] = findCellLocation(101);
  landmarks["104"] = findCellLocation(104);
  landmarks["181"] = findCellLocation(181);
  landmarks["107"] = findCellLocation(107);
  landmarks["184"] = findCellLocation(184);

  // Add more item racks and landmarks as needed
}


std::pair<int, int> SupermarketMapper::findCellLocation(int cellNumber)
{
  // Iterate through the supermarketMatrix to find the location (x, y) based on the cell number
  for (int i = 0; i < 20; ++i)
  {
    for (int j = 0; j < 11; ++j)
    {
      if (supermarketMatrix[i][j] == cellNumber)
      {
        return {i, j};
      }
    }
  }

  // Return {-1, -1} if the cell number is not found
  return {-1, -1};
}


void SupermarketMapper::updateLocation(int irSignal, float magnetometerReading, int distance, int heading)
{
  // Update cart location based on IR signal

  Serial.print("IR signal getting:");
  Serial.println(irSignal);
  
  
  if (irSignal == 35)
  {
    cart_location = landmarks["BS1N"];
  }
  else if (irSignal == 105)
  {
    cart_location = landmarks["BS1S"];
  }
  else if (irSignal == 53)
  {
    cart_location = landmarks["BS2N"];
  }
  else if (irSignal == 50)
  {
    cart_location = landmarks["BS2S"];
  }
  else if (irSignal == 52)
  {
    cart_location = landmarks["BS3N"];
  }
  else if (irSignal == 51)
  {
    cart_location = landmarks["BS3S"];
  }
  

  // Update cart direction based on magnetometer reading
  cart_direction = magnetometerReading;

  // Correct the direction
  cart_direction = cart_direction - imgNorth;
  if (cart_direction < 0)
  {
    cart_direction += 360;
  }
  if (distance != currentDistance && (distance - currentDistance >= tileLength))
  {
    if (heading == 1)
    {
      if(turnFlag == 1){
        turnFlag = 0;
        return;
      }
      moveForward();
    }
    else
    {
      moveBackward();
    }
    currentDistance = distance;
  }
}

void SupermarketMapper::moveForward()
{

  String prevPosition = currentPositon;
  // Move forward one location point in the matrix based on the current direction
      if (cart_direction >= 305 && cart_direction <= 360 || cart_direction >= 0 && cart_direction <= 64)
    {
      if(cart_location.first>0 && cart_location.first<(row-1))
      cart_location.first--;  // Move to the up
      currentPositon = "N";
    
    }
    else if (cart_direction >= 65 && cart_direction <= 176)
    {
      if(cart_location.second>0 && cart_location.second<(col-1))
      cart_location.second++; // Move to right
      currentPositon = "E";

    }
    else if (cart_direction >= 232 && cart_direction <=304 )
    {
      if(cart_location.second>0 && cart_location.second<(col-1))
      cart_location.second--; // Move left
      currentPositon = "W";
    }
    else if (cart_direction >= 176 && cart_direction <= 231)
    {
      if(cart_location.first>0 && cart_location.first<(row-1))
      cart_location.first++; // Move downward
      currentPositon = "S";
    }  
  

  if(prevPosition != currentPositon){

    if(prevPosition == "N"){
      if(cart_location.first>0 && cart_location.first<(row-1)){
        cart_location.first++; 
        currentDistance = 0; 
        turnFlag = 1;
      }
      
      
    }
    else if(prevPosition == "E"){
      if(cart_location.second>0 && cart_location.second<(col-1)){
        cart_location.second--; 
        currentDistance = 0;
         turnFlag = 1;
      }
      
      
    }
    else if(prevPosition == "W"){
      if(cart_location.second>0 && cart_location.second<(col-1)){
          cart_location.second++; 
          currentDistance=0;
           turnFlag = 1;
      }
      
      
    }
    else if(prevPosition == "S"){
      if(cart_location.first>0 && cart_location.first<(row-1)){
          cart_location.first--;
          currentDistance = 0;
           turnFlag = 1;
      }
      
      
    }
  }
}

void SupermarketMapper::moveBackward()
{
  // Move backward one location point in the matrix based on the current direction
 if(cart_direction >= 355 && cart_direction <= 360 || cart_direction >= 0 && cart_direction <= 33)
  {
    if(cart_location.first>0 && cart_location.first<(row-1))
    cart_location.first++; // Move to the up
  }
  else if(cart_direction >= 95 && cart_direction <= 155)
  {
    if(cart_location.second>0 && cart_location.second<(col-1))
    cart_location.second--; // Move to right
  }
  else if(cart_direction >= 235 && cart_direction <= 250)
  {
    if(cart_location.second>0 && cart_location.second<(col-1))
    cart_location.second++; // Move left
  }
  else if(cart_direction >= 198 && cart_direction <= 224)
  {
    if(cart_location.first>0 && cart_location.first<(row-1))
    cart_location.first--; // Move downward
  }
  
}

void SupermarketMapper::turnLeft()
{
  // Simulate a left turn (adjust direction and matrix position accordingly)
  cart_direction -= 90;
  if (cart_direction < 0)
  {
    cart_direction += 360;
  }
  cart_location.second--;
}

void SupermarketMapper::turnRight()
{
  // Simulate a right turn (adjust direction and matrix position accordingly)
  cart_direction += 90;
  if (cart_direction >= 360)
  {
    cart_direction -= 360;
  }
  cart_location.second++;
}

int SupermarketMapper::displayLocation()
{
  Serial.print("Cart Location: (");
  Serial.print(cart_location.first);
  Serial.print(", ");
  Serial.print(cart_location.second);
  Serial.print(", ");
  Serial.print(supermarketMatrix[cart_location.first][cart_location.second]);
  Serial.print("), Direction: ");
  Serial.print(cart_direction);
  Serial.println(" degrees");

  return supermarketMatrix[cart_location.first][cart_location.second];

}

int SupermarketMapper::getCurrentCell()
{
  // Get the current cell number based on the cart's location
  return supermarketMatrix[cart_location.first][cart_location.second];
}
int SupermarketMapper::getLocationX()
{
  
  return cart_location.first;
}

int SupermarketMapper::getLocationY()
{
  
  return cart_location.second;
}

void SupermarketMapper::resetPosition()
{
  // Reset the cart's position to the top-left corner
  cart_location = {0, 0};
  cart_direction = 0;
}
