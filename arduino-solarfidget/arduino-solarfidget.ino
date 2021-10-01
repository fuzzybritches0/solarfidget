/*
SOLARFIDGET is placed under a BSD 3-Clause License

The parts marked SOLARFIDGET Copyright (c) 2021 Kurt Manucredo

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.


THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/* ============================================
I2Cdev device library code is placed under the MIT license
Copyright (c) 2012 Jeff Rowberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
===============================================
*/


#include <Adafruit_NeoPixel.h>
// Which pin on the Arduino is connected to the NeoPixels?
#define PIN_NEOPIXEL        6 // On Trinket or Gemma, suggest changing this to 1

// How many NeoPixels are attached to the Arduino?
#define NUMPIXELS_NEOPIXEL 36 // Popular NeoPixel ring size

// When setting up the NeoPixel library, we tell it how many pixels,
// and which pin to use to send signals. Note that for older NeoPixel
// strips you might need to change the third parameter -- see the
// strandtest example for more information on possible values.
Adafruit_NeoPixel pixels(NUMPIXELS_NEOPIXEL, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);


// I2Cdev and MPU6050 must be installed as libraries, or else the .cpp/.h files
// for both classes must be in the include path of your project
#include "I2Cdev.h"

#include "MPU6050_6Axis_MotionApps20.h"
//#include "MPU6050.h" // not necessary if using MotionApps include file

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

// class default I2C address is 0x68
// specific I2C addresses may be passed as a parameter here
// AD0 low = 0x68 (default for SparkFun breakout and InvenSense evaluation board)
// AD0 high = 0x69
MPU6050 mpu;
//MPU6050 mpu(0x69); // <-- use for AD0 high

/* =========================================================================
   NOTE: In addition to connection 3.3v, GND, SDA, and SCL, this sketch
   depends on the MPU-6050's INT pin being connected to the Arduino's
   external interrupt #0 pin. On the Arduino Uno and Mega 2560, this is
   digital I/O pin 2.
 * ========================================================================= */

/* =========================================================================
   NOTE: Arduino v1.0.1 with the Leonardo board generates a compile error
   when using Serial.write(buf, len). The Teapot output uses this method.
   The solution requires a modification to the Arduino USBAPI.h file, which
   is fortunately simple, but annoying. This will be fixed in the next IDE
   release. For more info, see these links:

   http://arduino.cc/forum/index.php/topic,109987.0.html
   http://code.google.com/p/arduino/issues/detail?id=958
 * ========================================================================= */

#define INTERRUPT_PIN 2  // use pin 2 on Arduino Uno & most boards
#define LED_PIN 13 // (Arduino is 13, Teensy is 11, Teensy++ is 6)
bool blinkState = false;

// MPU control/status vars
bool dmpReady = false;  // set true if DMP init was successful
uint8_t mpuIntStatus;   // holds actual interrupt status byte from MPU
uint8_t devStatus;      // return status after each device operation (0 = success, !0 = error)
uint16_t packetSize;    // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount;     // count of all bytes currently in FIFO
uint8_t fifoBuffer[64]; // FIFO storage buffer

// orientation/motion vars
Quaternion q;           // [w, x, y, z]         quaternion container
VectorInt16 aa;         // [x, y, z]            accel sensor measurements
VectorInt16 aaReal;     // [x, y, z]            gravity-free accel sensor measurements
VectorInt16 aaWorld;    // [x, y, z]            world-frame accel sensor measurements
VectorFloat gravity;    // [x, y, z]            gravity vector
float euler[3];         // [psi, theta, phi]    Euler angle container
float ypr[3];           // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector

// packet structure for InvenSense teapot demo
uint8_t teapotPacket[14] = { '$', 0x02, 0,0, 0,0, 0,0, 0,0, 0x00, 0x00, '\r', '\n' };



// ================================================================
// ===               INTERRUPT DETECTION ROUTINE                ===
// ================================================================

volatile bool mpuInterrupt = false;     // indicates whether MPU interrupt pin has gone high
void dmpDataReady() {
    mpuInterrupt = true;
}

// ================================================================
// ===                       SOLARFIDGET                        ===
// ================================================================

int led_bright_max = 255;
float max_rad_quad = 1.57;
int quad_led = 9;
int multiply_led = 100;

int max_led = quad_led * multiply_led;
float per_led = max_led / max_rad_quad;
float brightness = led_bright_max / multiply_led;

int accel_led;
float accel;
int grav_led;
float grav;
bool flipped;

int led;
float speed;
float speed_grav;
float speed_accel;

int ms;
int ms_1 = millis();

void calc_accel() {

	int diff = accel_led - led;

	if (diff > max_led * 2) diff = -1;
	else if (diff > 0 && diff <= max_led * 2) diff = 1;
	else if (diff < 0 && diff >= -max_led * 2) diff = -1;
	else if (diff < -(max_led * 2)) diff = 1;
	speed_accel = diff * accel * 33;
}

void calc_grav() {

	int diff = grav_led - led;

	if (diff > max_led * 2) diff = -1;
	else if (diff > 0 && diff <= max_led * 2) diff = 1;
	else if (diff < 0 && diff >= -max_led * 2) diff = -1;
	else if (diff < -(max_led * 2)) diff = 1;
	speed_grav = diff * grav * 2;
}

void calc_pos() {

	ms = millis();

	if (speed > 0) speed -= .25;
	else if (speed < 0) speed += .25;
	if (led > max_led * 4 - 1) led -= max_led * 4;
	if (led < 0) led += max_led * 4;

	calc_grav();
	speed += speed_grav;

	calc_accel();
	speed += speed_accel;

	led += round((ms-ms_1) * speed / 10);

	_pixels(led, 1, 0, 1);

	ms_1 = ms;
}

void accel_point(float x,float y) {

	int quad;
	float angle_accel = atan(y/x);

	accel = sqrt(x*x + y*y) / 16384;

	     if (x > 0 && y < 0) quad = 0;
	else if (x < 0 && y < 0) quad = 1;
	else if (x < 0 && y > 0) quad = 2;
	else if (x > 0 && y > 0) quad = 3;

	accel_led = max_led * quad;

	if (quad == 0 || quad == 2) accel_led += round(angle_accel * per_led) * -1;
	else if (quad == 1 || quad == 3) accel_led += max_led - round(angle_accel * per_led);
	if (accel_led != 0) accel_led -= 1;
}

void grav_point(float pitch,float roll) {

	int quad;
	float angle_grav = atan(sin(roll) / tan(pitch));

	grav = acos(cos(pitch) * cos(roll));

	     if (pitch > 0 && roll < 0) quad = 0;
	else if (pitch < 0 && roll < 0) quad = 1;
	else if (pitch < 0 && roll > 0) quad = 2;
	else if (pitch > 0 && roll > 0) quad = 3;
	
	if (quad == 0 && angle_grav > 0) {
		quad = 1;
		flipped = true;
	}
	else if (quad == 1 && angle_grav < 0) {
		quad = 0;
		flipped = true;
	}
	else if (quad == 2 && angle_grav > 0) {
		quad = 3;
		flipped = true;
	}
	else if (quad == 3 && angle_grav < 0) {
		quad = 2;
		flipped = true;
	}
	else flipped = false;

	grav_led = max_led * quad;

	if (quad == 0 || quad == 2) grav_led += round(angle_grav * per_led) * -1;
	else if (quad == 1 || quad == 3) grav_led += max_led - round(angle_grav * per_led);
	if (flipped) {
		grav_led = max_led * 4 - grav_led;
		grav_led += max_led * 2;
		if (grav_led > max_led * 4) grav_led -= max_led * 4;
	}
	if (grav_led != 0) grav_led -= 1;
}

void _pixels(int led, int r, int g, int b) {

	int remainder = round(led % multiply_led * brightness);
	int actual_led = led / multiply_led;
	int actual_led_1 = actual_led + 1;
	int led_1 = led_bright_max - remainder;

	if (actual_led_1 == quad_led * 4) actual_led_1 = 0;

  	pixels.clear(); // Set all NeoPixel leds to 'off'
	pixels.setPixelColor(actual_led, pixels.Color(led_1*r, led_1*g, led_1*b));
	pixels.setPixelColor(actual_led_1, pixels.Color(remainder*r, remainder*g, remainder*b));
	pixels.show();
}

// ================================================================
// ===                      INITIAL SETUP                       ===
// ================================================================

void setup() {

    // INITIALIZE NeoPixel strip object
    pixels.begin();

    // join I2C bus (I2Cdev library doesn't do this automatically)
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
        Wire.setClock(400000); // 400kHz I2C clock. Comment this line if having compilation difficulties
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    // initialize serial communication
    // (115200 chosen because it is required for Teapot Demo output, but it's
    // really up to you depending on your project)
    Serial.begin(115200);
    //while (!Serial); // wait for Leonardo enumeration, others continue immediately

    // NOTE: 8MHz or slower host processors, like the Teensy @ 3.3V or Arduino
    // Pro Mini running at 3.3V, cannot handle this baud rate reliably due to
    // the baud timing being too misaligned with processor ticks. You must use
    // 38400 or slower in these cases, or use some kind of external separate
    // crystal solution for the UART timer.

    // initialize device
    //Serial.println(F("Initializing I2C devices..."));
    mpu.initialize();
    pinMode(INTERRUPT_PIN, INPUT);

    // verify connection
    //Serial.println(F("Testing device connections..."));
    //Serial.println(mpu.testConnection() ? F("MPU6050 connection successful") : F("MPU6050 connection failed"));

    // wait for ready
    //Serial.println(F("\nSend any character to begin DMP programming and demo: "));
    //while (Serial.available() && Serial.read()); // empty buffer
    //while (!Serial.available());                 // wait for data
    //while (Serial.available() && Serial.read()); // empty buffer again

    // load and configure the DMP
    //Serial.println(F("Initializing DMP..."));
    devStatus = mpu.dmpInitialize();

    // supply your own gyro offsets here, scaled for min sensitivity
    //mpu.setXGyroOffset(-139);
    //mpu.setYGyroOffset(40);
    //mpu.setZGyroOffset(-17);
    //mpu.setXAccelOffset(-4391);
    //mpu.setYAccelOffset(821);
    //mpu.setZAccelOffset(975); // 1688 factory default for my test chip

    // make sure it worked (returns 0 if so)
    if (devStatus == 0) {
        // Calibration Time: generate offsets and calibrate our MPU6050
        mpu.CalibrateAccel(6);
        mpu.CalibrateGyro(6);
        //mpu.PrintActiveOffsets();
        // turn on the DMP, now that it's ready
        //Serial.println(F("Enabling DMP..."));
        mpu.setDMPEnabled(true);

        // enable Arduino interrupt detection
        //Serial.print(F("Enabling interrupt detection (Arduino external interrupt "));
        //Serial.print(digitalPinToInterrupt(INTERRUPT_PIN));
        //Serial.println(F(")..."));
        attachInterrupt(digitalPinToInterrupt(INTERRUPT_PIN), dmpDataReady, RISING);
        mpuIntStatus = mpu.getIntStatus();

        // set our DMP Ready flag so the main loop() function knows it's okay to use it
        //Serial.println(F("DMP ready! Waiting for first interrupt..."));
        dmpReady = true;

        // get expected DMP packet size for later comparison
        packetSize = mpu.dmpGetFIFOPacketSize();
    } else {
        // ERROR!
        // 1 = initial memory load failed
        // 2 = DMP configuration updates failed
        // (if it's going to break, usually the code will be 1)
        //Serial.print(F("DMP Initialization failed (code "));
        //Serial.print(devStatus);
        //Serial.println(F(")"));
    }

    // configure LED for output
    pinMode(LED_PIN, OUTPUT);
}



// ================================================================
// ===                    MAIN PROGRAM LOOP                     ===
// ================================================================

void loop() {
    // if programming failed, don't try to do anything
    if (!dmpReady) return;

    // wait for MPU interrupt or extra packet(s) available
    while (!mpuInterrupt && fifoCount < packetSize) {
        if (mpuInterrupt && fifoCount < packetSize) {
          // try to get out of the infinite loop 
          fifoCount = mpu.getFIFOCount();
        }  
        // other program behavior stuff here
        // .
        // .
        // .
        // if you are really paranoid you can frequently test in between other
        // stuff to see if mpuInterrupt is true, and if so, "break;" from the
        // while() loop to immediately process the MPU data
        // .
        // .
        // .
    }

    // reset interrupt flag and get INT_STATUS byte
    mpuInterrupt = false;
    mpuIntStatus = mpu.getIntStatus();

    // get current FIFO count
    fifoCount = mpu.getFIFOCount();
	if(fifoCount < packetSize){
	        //Lets go back and wait for another interrupt. We shouldn't be here, we got an interrupt from another event
			// This is blocking so don't do it   while (fifoCount < packetSize) fifoCount = mpu.getFIFOCount();
	}
    // check for overflow (this should never happen unless our code is too inefficient)
    else if ((mpuIntStatus & _BV(MPU6050_INTERRUPT_FIFO_OFLOW_BIT)) || fifoCount >= 1024) {
        // reset so we can continue cleanly
        mpu.resetFIFO();
      //  fifoCount = mpu.getFIFOCount();  // will be zero after reset no need to ask
        //Serial.println(F("FIFO overflow!"));

    // otherwise, check for DMP data ready interrupt (this should happen frequently)
    } else if (mpuIntStatus & _BV(MPU6050_INTERRUPT_DMP_INT_BIT)) {

        // read a packet from FIFO
	while(fifoCount >= packetSize){ // Lets catch up to NOW, someone is using the dreaded delay()!
		mpu.getFIFOBytes(fifoBuffer, packetSize);
		// track FIFO count here in case there is > 1 packet available
		// (this lets us immediately read more without waiting for an interrupt)
		fifoCount -= packetSize;
	}
        mpu.dmpGetQuaternion(&q, fifoBuffer);
        mpu.dmpGetAccel(&aa, fifoBuffer);
        mpu.dmpGetGravity(&gravity, &q);
	mpu.dmpGetYawPitchRoll(ypr, &q, &gravity);
        mpu.dmpGetLinearAccel(&aaReal, &aa, &gravity);
        grav_point(ypr[1],ypr[2]);
        accel_point(aaReal.x, aaReal.y);
        calc_pos();

        // blink LED to indicate activity
        blinkState = !blinkState;
        digitalWrite(LED_PIN, blinkState);
    }
}
