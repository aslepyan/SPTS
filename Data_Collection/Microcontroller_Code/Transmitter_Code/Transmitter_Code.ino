#include <Wire.h>

// Do Not Change!
int state = 0;
int res = 0;
int framePosition = 0;
const uint8_t clkPin = 4;
const uint8_t outputPin = A0;
int old_min = 1024;
int new_min = 1024;
int startSave = 0;
// Change Here!
int clkItv = 11;
int initThres = 400; //495 for random, 400 for raster 
int sampling_delay = 1300; //raster is 1300!!! random is 1400
const int M = 100; // number of measurement for each frame
const int numFrame = 1000; // number of frames for 2s-measurement
int resArr[M * numFrame] = {0};


void setup() {
  Serial.begin(9600);
  analogReadAveraging(0);
  Wire.begin(); // Initialize the I2C communication as Master
  pinMode(clkPin, OUTPUT);
  pinMode(outputPin, INPUT);
}

void loop() {
  // Change here depending on whether you use raster or compressive sensing
  if (state == 0 && Serial.available()) {
    if (Serial.read() == 42) { // acsii of '*' is 42
      state = 1;
      res = 0;
      Serial.print("Sending.\n");
      for (int i = 0; i < M; i++) {
        Wire.beginTransmission(i + 8);
        Wire.write(1); // change to 0 if raster, or 2 if compressive sensing
        Wire.endTransmission();
        delay(1);

        Wire.beginTransmission(i + 8);
        Wire.write(0); // change to 0 if raster, or i+8 if compressive sensing
        Wire.endTransmission();
        delay(1);
      }
      Serial.print("Sent!.\n");
    }
  }
  // Send squarewave
  else if (state == 1) {
    new_min = findMin();
    //Serial.println(new_min); // check the pressure when no touch.
    if ((old_min > initThres) && (new_min <= initThres) && (old_min-new_min >= 5)) {
      //Serial.print("old_min:");
      //Serial.print(old_min);
      //Serial.print("new_min:");
      //Serial.println(new_min);
      startSave = 1;
    }
    old_min = new_min;
    if (startSave == 1) {
      //int timer1 = micros();
      sampling();
      //timer1 = micros() - timer1;
      //Serial.print(timer1);
      //Serial.println(" ms per frame"); // cheack the time per frame.
      sendMatlab();
    }
  }
}

int findMin() {
  // in the raster scanning style
  // return max value
  int sensorMin = 1024;
  int temp;
  
  delay(9);

  for (int j = 0; j < 50; j++) {
    digitalWriteFast(clkPin, HIGH);
    delayMicroseconds(clkItv);
    temp = analogRead(outputPin);
    if (temp < sensorMin) sensorMin = temp;

    digitalWriteFast(clkPin, LOW);
    delayMicroseconds(clkItv);
    temp = analogRead(outputPin);
    if (temp < sensorMin) sensorMin = temp;
  }
  framePosition++;
  return sensorMin;
}

void sampling() {
  delay(sampling_delay);
  digitalWrite(LED_BUILTIN, HIGH);
  for (int frame = 0; frame < numFrame; frame++) {
    for (int j = 0; j < 50; j++) { // changed i increment
      digitalWriteFast(clkPin, HIGH);
      delayMicroseconds(clkItv);
      res = analogRead(outputPin);
      resArr[frame * M + 2*j] = res;

      digitalWriteFast(clkPin, LOW);
      delayMicroseconds(clkItv);
      res = analogRead(outputPin);
      resArr[frame * M + 2*j + 1] = res;
    }    
  }
  startSave = 0;
  framePosition = framePosition+1000;
  digitalWrite(LED_BUILTIN, LOW);
}

 
void sendMatlab() {
  Serial.print(framePosition);
  Serial.print(",");
  for (int j = 0; j < M * numFrame - 1; j++) {
    Serial.print(resArr[j]);
    Serial.print(",");
  }
  Serial.println(" ");
  
  
}
