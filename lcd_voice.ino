#include <LiquidCrystal.h>
#include <BluetoothSerial.h>
#include <string.h>

/*
 ESP32-S -> LCD1602 (16x2)
 
 RS -> I023
 E -> I022
 D4 -> I021
 D5 -> I019
 D6 -> I018
 D7 -> I017
 */

LiquidCrystal lcd (23, 22, 21, 19, 18, 17);
BluetoothSerial SerialBT;

int col = 0;
int row = 0;

void setup() {
  lcd.begin(16, 2);
  lcd.clear();

  Serial.begin(115200);
  SerialBt.begin("ESP32-Voice-LCD");

  lcd.setCursor(0,0 );
  lcd.print("Waiting for");
  lcd.setCursor(0, 1);
  lcd.print("voice input...");

}

void loop() {
  if (SerialBT.available()) {
    char c = SerialBT.read();

    // New line command
    if (c == '\n') {
      row++;
      col = 0;
      if (row > 1) {
        lcd.clear();
        row = 0;
      }
      lcd.setCursor(col, row);
      return;
    }

    // Clear screen command
    if (c == '#') { //
      lcd.clear();
      col = 0;
      row = 0;
      lcd.setCursor(col, row);
      return;
    }

    // Print characrer
    lcd.setCursor(col, row);
    lcd.print(c);
    col++;

    // Wrap text
    if (col >= 16) {
      col = 0;
      row++;
      if(row > 1) {
        lcd.clear();
        row = 0;
      }
    }
  }
}
