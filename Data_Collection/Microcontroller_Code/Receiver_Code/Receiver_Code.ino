#include <Wire.h>
unsigned long a = 1664525;
unsigned long c = 1013904223;
byte randOut;

int rec = -1;
unsigned long seed = 0;
int count = 7;
int mode = -1;
int adrs = 30;
int itgt = 0;

void setup() {
  pinMode(PIN_PA3, INPUT);
  pinMode(PIN_PA6, OUTPUT);
  DACReference(INTERNAL4V3);
  Wire.begin(adrs);
}

void loop() {
  while (Wire.available()) {
    rec = Wire.read();
    if (rec == -1) {
      continue;
    }
    count = 7;
    if (itgt == 0) {
      mode = rec;
      itgt++;
    } else if (itgt == 1) {
      seed = rec;
      itgt = 0;
    }
    if (mode == 0) {
      detachInterrupt(PIN_PA3);
      attachInterrupt(PIN_PA3, randomOut0, CHANGE);
    }else if (mode == 1){
      detachInterrupt(PIN_PA3);
      attachInterrupt(PIN_PA3, randomOut1, CHANGE);
    }else if (mode == 2){
      detachInterrupt(PIN_PA3);
      attachInterrupt(PIN_PA3, randomOut2, CHANGE);
    }
  }
}

void randomOut0() {
  analogWrite(PIN_PA6, (++count==adrs) ? 255 : 126);
  if (count == 107) {
    count = 7;
  }
}

void randomOut1() {
  seed = (a * seed + c);
  randOut = seed / 16777216;
  analogWrite(PIN_PA6, randOut);
}

void randomOut2() {
  seed = (a * seed + c);
  randOut = seed / 16777216;
  analogWrite(PIN_PA6, (randOut < 128) ? 0 : 255);
}
