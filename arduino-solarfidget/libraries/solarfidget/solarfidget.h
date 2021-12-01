// 
// BSD 3-Clause License
// 
// SOLARFIDGET programme code Copyright (C) 2021 Kurt Manucredo
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
// 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

// ================================================================
// ===                       SOLARFIDGET                        ===
// ================================================================

#define QUAD_LED	NUMPIXELS_NEOPIXEL / 4
#define LED_BRIGHT_MAX	255
#define MULTIPLY_LED	100
#define MAX_LED		QUAD_LED * MULTIPLY_LED
#define PER_LED		MAX_LED / MAX_RAD_QUAD
#define BRIGHTNESS	LED_BRIGHT_MAX / MULTIPLY_LED

int accel_led;
float accel;
int grav_led;
float grav;
bool flipped;

int led;
float speed;
float speed_grav;
float speed_accel;

bool orientation;
bool orientation_last;
int counter_on;
int counter;
int action;

bool active = true;
int idle_counter;

int body;

// Mercury(0.38g) Venus(0.904g) Earth(1g) Mars(0.3794g) Jupiter(2.528g)
// Saturn(1.065g) Uranus(0.886g) Neptune(1.14g) Pluto(0.063g)
float bgrav[9] = {.38, .904, 1, .3794, 2.528, 1.065 , .886, 1.14, .063};
float br[9] = {.3, .1,  0, .8, .5, .5, .2, .1, .6};
float bg[9] = {.3, .3,  0, .1, .3, .4, .1, .7,  0};
float bb[9] = {.3, .5, .9,  0, .1,  0, .6, .1, .3};
//             ME  VE  EA  MA  JU  SA  UR  NE  PL

void calc_accel() {

	int diff = accel_led - led;

	if (diff > MAX_LED * 2) diff = -1;
	else if (diff > 0 && diff <= MAX_LED * 2) diff = 1;
	else if (diff < 0 && diff >= -MAX_LED * 2) diff = -1;
	else if (diff < -(MAX_LED * 2)) diff = 1;
	speed_accel = diff * accel * 33;
}

void calc_grav() {

	int diff = grav_led - led;

	if (diff > MAX_LED * 2) diff = -1;
	else if (diff > 0 && diff <= MAX_LED * 2) diff = 1;
	else if (diff < 0 && diff >= -MAX_LED * 2) diff = -1;
	else if (diff < -(MAX_LED * 2)) diff = 1;
	speed_grav = diff * grav * 3 * bgrav[body];
}

void _pixels() {

	int remainder = round(led % MULTIPLY_LED * BRIGHTNESS);
	int actual_led = led / MULTIPLY_LED;
	int actual_led_1 = actual_led + 1;
	int led_1 = LED_BRIGHT_MAX - remainder;

	if (actual_led_1 == QUAD_LED * 4) actual_led_1 = 0;

  	pixels.clear(); // Set all NeoPixel leds to 'off'
	pixels.setPixelColor(actual_led, pixels.Color(
		round(led_1*br[body]), round(led_1*bg[body]), round(led_1*bb[body])));
	pixels.setPixelColor(actual_led_1, pixels.Color(
		round(remainder*br[body]), round(remainder*bg[body]), round(remainder*bb[body])));
	pixels.show();
}

void calc_pos() {

	if (speed > 0) speed -= .3 * bgrav[body];
	else if (speed < 0) speed += .3 * bgrav[body];

	calc_grav();
	speed += speed_grav;

	calc_accel();
	speed += speed_accel;

	led += round(speed);

	if (led >= MAX_LED * 4) led -= MAX_LED * 4;
	else if (led < 0) led += MAX_LED * 4;

	_pixels();
}

void accel_point() {

	int quad;
	float angle_accel = atan(ACCELY/ACCELX);

	accel = sqrt(ACCELX*ACCELX + ACCELY*ACCELY) / 16384;

	     if (ACCELX > 0 && ACCELY < 0) quad = 0;
	else if (ACCELX < 0 && ACCELY < 0) quad = 1;
	else if (ACCELX < 0 && ACCELY > 0) quad = 2;
	else if (ACCELX > 0 && ACCELY > 0) quad = 3;

	accel_led = MAX_LED * quad;

	if (quad == 0 || quad == 2) accel_led += round(angle_accel * PER_LED) * -1;
	else if (quad == 1 || quad == 3) accel_led += MAX_LED - round(angle_accel * PER_LED);
}

void grav_point() {
	int quad;

	float angle_grav = atan(sin(ROLL) / tan(PITCH));

	grav = acos(cos(PITCH) * cos(ROLL));

	     if (PITCH > 0 && ROLL < 0) quad = 0;
	else if (PITCH < 0 && ROLL < 0) quad = 1;
	else if (PITCH < 0 && ROLL > 0) quad = 2;
	else if (PITCH > 0 && ROLL > 0) quad = 3;
	
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

	grav_led = MAX_LED * quad;

	if (quad == 0 || quad == 2) grav_led += round(angle_grav * PER_LED) * -1;
	else if (quad == 1 || quad == 3) grav_led += MAX_LED - round(angle_grav * PER_LED);
	if (flipped) {
		grav_led = MAX_LED * 4 - grav_led;
		grav_led += MAX_LED * 2;
		if (grav_led > MAX_LED * 4) grav_led -= MAX_LED * 4;
	}
}

void next_body() {
	body++;
	if (body == 9) body = 0;
}

void flip_active() {
	active=!active;
	if (!active) {
		pixels.clear();
		pixels.show();
	}
}

void do_action() {
	if (action == 1 && active) next_body();
	if (action == 2) flip_active();
}

void actions() {

	if (PITCH > -.4 && PITCH < .4 && ROLL > -.4 && ROLL < .4) {
		orientation=true;
	}
	else if ((PITCH < -2.74 || PITCH >2.74) && (ROLL < -2.74 || ROLL > 2.74)) {
		orientation=false;
	}

	if (orientation != orientation_last) counter_on++;
	orientation_last = orientation;
	if (counter_on) counter++;
	if (counter < 120 && counter_on == 3) {
		action=2;
	}
	else if (counter < 120 && counter_on == 2) {
		action=1;
	}
	if (counter > 120) {
		if (action) do_action();
		action=0;
		counter_on=0;
		counter=0;
	}
}

void detect_motion() {
	if (speed < 5 && speed > -5 && ACCELX > -30 && ACCELX < 30 &&
	    ACCELY > -30 && ACCELY < 30) idle_counter++;
	else idle_counter = 0;

	if (idle_counter > 1000) {
		idle_counter=0;
		flip_active();
	}
}

void solarfidget() {
	if (active) {
		grav_point();
		accel_point();
		calc_pos();
		detect_motion();
	}
	actions();
}
