#ifndef OLED_FUNCTIONS_H
#define OLED_FUNCTIONS_H

#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>

#define SCREEN_WIDTH  128
#define SCREEN_HEIGHT 64
#define OLED_RESET    -1
#define SCREEN_ADDRESS 0x3C

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);;

void initOLED() {
  if(!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }
  display.clearDisplay();

}

void displayHeader(){
  display.setCursor(0,0);
  display.setTextSize(2);
  display.println("ShopWise");
  display.display();
  display.startscrollright(0x00, 0x01);
}

void displayText(const char* text, uint8_t textSize, uint8_t line) {
  display.setTextColor(WHITE);
  display.setTextSize(textSize);
  display.setCursor(0, line * textSize * 8);  // Each line separated by textSize * 8 pixels
  display.println(text);
  display.display();
 
}

void clearDisplay() {
  display.clearDisplay();
}

void scrollString(const char* text, int16_t startPoint) {
  display.setCursor(0,0);
  display.setTextSize(2);
  display.println("ShopWise");
  display.display();
  display.startscrollright(0x00, 0x01);
}

void batteryLevel(int16_t lev){
  int BATT_X = 0;
  int BATT_Y = 45;
  int BATT_W = 85;
  int LINE_HEIGHT_1 = 15;
  

  display.setTextSize(2);
  display.setCursor(0, 45);
  display.fillRect(BATT_X, BATT_Y, SCREEN_WIDTH, LINE_HEIGHT_1, SSD1306_BLACK);
  display.drawRect(BATT_X, BATT_Y, BATT_W + 2, LINE_HEIGHT_1+1, SSD1306_WHITE);
  display.fillRect(BATT_X +1, BATT_Y, (lev * BATT_W)/100, LINE_HEIGHT_1, SSD1306_WHITE);
  char buf[4];
    sprintf(buf, "%i%%", lev);
    display.setCursor(BATT_W + 5, BATT_Y);
    display.print(buf);
  display.display();

}

void success(){
  displayHeader();
  
}
#endif  // OLED_FUNCTIONS_H
