
#include <Arduino.h>

#define DISABLE_CODE_FOR_RECEIVER


#include "PinDefinitionsAndMore.h"
#include <IRremote.hpp> // include the library

#define IR_SEND_PIN 3

void setup() {
    Serial.begin(115200);
    Serial.print(F("Send IR signals at pin "));
    Serial.println(IR_SEND_PIN);

}
uint8_t sCommand = 0x34;
uint8_t sRepeats = 0;

void loop() {
    
    Serial.println();
    Serial.print(F("Send now: address=0x00, command=0x"));
    Serial.print(sCommand, HEX);
    Serial.print(F(", repeats="));
    Serial.print(sRepeats);
    Serial.println();

    Serial.println(F("Send standard NEC with 8 bit address"));
    Serial.flush();

    // Receiver output for the first loop must be: Protocol=NEC Address=0x102 Command=0x34 Raw-Data=0xCB340102 (32 bits)
    IrSender.sendNEC(0x00, sCommand, sRepeats);

    

    delay(20);  // delay must be greater than 5 ms (RECORD_GAP_MICROS), otherwise the receiver sees it as one long signal
}