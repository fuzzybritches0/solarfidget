# 		ORIGINAL SOLARFIDGET

Using an LED-Ring (of 32 rgb leds) and an MPU6050 gyro/accel, this
fidget calculates the position of a rotating pendulum that reacts to
acceleration and gravity and simulates the effect of gravity on different
bodies in our solar system (including Pluto).

Concept, Design and Idea **(C)** 2021-2022 Kurt Manucredo, under the
CREATIVE COMMONS ATTRIBUTION-NONCOMMERCIAL 4.0 INTERNATIONAL PUBLIC LICENSE

For more information on Copyright please refer to the respective files and
the LICENSE-* files.

![solarfidget](./assets/solarfidget.gif)
* * *

# 1. MANUAL INSTRUCTIONS

## 1.1 TRAVEL FROM PLANET TO PLANET

You can travel the following bodies in our solarsystem in order:

- Mercury (0.38g)   (white)
- Venus   (0.904g)  (light blue)
- Earth   (1g)      (dark blue)
- Mars    (0.3794g) (red brown)
- Jupiter (2.528g)  (white grey)
- Saturn  (1.065g)  (yellow)
- Uranus  (0.886g)  (violet)
- Neptune (1.14g)   (green)
- Pluto   (0.063g)  (pink)

![solarfidget planet](./assets/solarfidget_planet.gif)\
*To travel from planet to planet hold the fidget horizontally, turn it
twice by 180 degrees. If there is no change, try doing it faster.*
* * *

## 1.2 TURN THE LIGHT ON AND OFF

![solarfidget off](./assets/solarfidget_off.gif)\
*To turn the lightfidget on or off hold the fidget horizontally, turn it
thrice by 180 degrees. If there is no change, try doing it faster.*

* * *

# 2. HOW TO BUILD ONE FOR YOURSELF

## 2.1 PARTS NEEDED

- 1x Arduino Nano or compatible
- 1x MPU6050 breakout board
- 1x TP4056 battery charging breakout board
- 1x 32 addressable LEDs strip (\*)
- 1x 44x24.5x9mm 750mAh LiPo battery with Molex plug
- 1x male Molex plug (\*\*)
- 1x 3d-printed models of both the fidget and charger parts (\*\*\*)
- 1x USB mini cable
- 4x 0.3x4x5 mm compressing spring
- 4x M3 locknut
- 4x M3 nut
- 4x M3x10mm bolt
- 4x M3x4mm bolt
- 8x cylinder magnet d=5mm,h=2mm,
- and a punch of cables one can salvage from old LAN cables or similar.

> (\*):     Use a strip with an LED density of **144 LEDs per metre**.\
> (\*\*):   When buying a set of batteries there is normally a charger
>           included from which you can salvage male Molex plugs.\
> (\*\*\*): all four parts can be found as .3mf files in the
>           design-solarfidget folder and can be imported directly into
>           the 3d slicer software. If you need to make changes to
>           accommodate your own hardware, use the solarfidget.scad file
>           to do so.

## 2.2 OPENSCAD RENDERINGS

![solarfidget](./assets/images/solarfidget-scad.jpg)\
*Pic. 1: The four parts pictured above compose the solarfidget and the
charger*
* * *

## 2.3 BUILD INSTRUCTIONS

### 2.3.1 Magnets

Place four magnets inside the charger and four inside the fidget so that
the both lock in place. Have the magnet's poles in the fidget all oriented
in the same direction. Reverse the poles in the charger. There is no room
for error, since you will have to destroy the parts to remove the magnets.

![solarfidget](./assets/images/magnet_key.jpg)\
*Pic. 2: Use a crooked M6 key, place the magnet on the crooked end and use a hammer
to fix the magnets in place.*
* * *

### 2.3.2 USB mini cable

Cut the USB mini cable about 10cm from the mini USB plug side. Carefully
remove the PVC coat and the shielding. There should be four cables: one
**black**, one **red**, one **white** and one **green**. Also remove as
much of the hard plastic from the mini USB plug as possible - we only
have limited space - but don't break the plug. We won't be using the
**red** or the **black** cable. If you messed them up, we are still good to
go.

### 2.3.3 Fidget

Now, we will work on the part of the fidget that houses all the
electronics, that is, the top part.

Place the top part of the fidget in front of you facing the inside and
having the charging towers face left. Connect the cables of the mini USB
plug as follows from top to bottom: **black**, **white**, **green**,
**red**; and add one cable to the red cable; there is an extra hole for
that. Later, solder this cable to the battery charging breakout board and
ground the board on the Arduino.

Use the **M3 nuts** and **M3x4mm bolts** to secure the cables. Clean the
inside of the towers if there is loose or deformed material inside from
printing the overhang. Use a **longer** M3 bolt to drive the nut into its
place, enough so, that you can still push the cable into the hole below
the nut. Then drive the nuts down all the way and secure the cables. Make
sure there is **only blank wire** between the nut and the tower. Keep the
blank wire **short**. If it's too long it may curl up around the bold,
when fixing it, which we don't want to happen.

Connect the Arduino Nano to the mini USB plug. Push the Arduino inside its
proper place. Push the battery charging breakout board into its proper
place. Finally push the MPU6050 breakout board into its proper place,
next to the battery, on the right side. Have the MPU6050 **face up**. On
the MPU6050 have the **X-axis** point to the **right and left**.

![all installed](./assets/all_installed.jpg)\
*Fig. 3: Magnets and hardware installed. Arduino plugged in.*
* * *

### 2.3.4 LED strip

Solder three cables onto the 32 addressable LED strip. Note the direction
of the arrows on the strip and solder the cables on the right end. If the
arrow points to the end of the strip, it's the wrong end.


![led strip end](./assets/led_stripe_end.jpg)\
*Fig. 4: This is the right end. Solder the cables on to the back,
pointing into the direction of the arrows. You can see a green cable stick
out above in the picture.*
* * *

Place the strip around the inside of the fidget's top part. Start around
the middle of the charging towers and continue **clockwise**.

### 2.3.5 Soldering

Wire all cables around the battery compartment when you solder them on.
Make sure there will be enough place for the LED strip around the inside
of the fidget, should you remove the strip while you solder the rest.
Keep the cables as short as possible. Ground all components on a common
ground.

#### 2.3.5.1 Battery charging breakout board

As I have mentioned before, at the beginning, solder the extra cable we
add to the charging tower to **IN+** on the battery charging breakout
board. Ground it in the next step. **IN-** and **BAT-** are the same.

Solder **BAT+** from the battery charging breakout board to **VIN** on the
Arduino and **ground** the board on the Arduino. 
If you are using an Arduino Nano 33, bridge the contacts marked VUSB on the
back of the Arduino with solder. The contacts are between RST and A7. For
more information why this is required, please visit:
https://support.arduino.cc/hc/en-us/articles/360014779679-About-Nano-boards-with-disabled-5-V-pins

Make sure your Arduino can run with 3.7V. My Arduino Nano was meant for 5V
but it works quite well for a few hours.

#### 2.3.5.2 MPU6050

Solder **VIN** from the MPU6050 to **3V3** on the Arduino and **ground**
the MPU6050.  Now, solder **SCL**, **SDA** and **INT** from the MPU6050 to
**A5**, **A4** and **D2** on the Arduino, respectively. On the Arduino I
used, **A5** and **A4** are for **SCL** and **SDA**. Your Arduino may
differ but both the Arduino Nano and Nano 33 use the same analogue pins.

#### 2.3.5.3 MOLEX plug

Solder two cables to the **male MOLEX plug**. When you connect a battery
to the plug, you can see which cable is which. Make sure the plug and
cable are properly isolated. Use **shrink tubing**. ***Never solder with a
connected battery!***

![molex_plug](./assets/molex_plug.jpg)\
*Fig. 5: Male Molex plug.*
* * *

Solder the two cables to **BAT+** and **BAT-** accordingly.

#### 2.3.5.4 32 addressable LEDs strip

Now, solder **+** from the LED strip to **BAT+**, **DATA** to **D6** on
the Arduino and **ground** the LED strip.

#### 2.3.5.5 Battery

Now, connect the battery to the MOLEX plug and place it inside the fidget.

![fixed up](./assets/fixed_up.jpg)\
*Fig. 6: This is about what it should look now.*
* * *

### 2.3.6 Charging station

Fix up the charging station by placing the four cables from the cut-off
end of the USB cable inside the charging towers of the charging station.
**Don't forget** to route the cable through the bottom part of the charger
station first, before you wire it all up.

![charger wire](./assets/charger_wire.jpg)\
*Fig. 7: That's how we figure out which cable goes where. Fix the cable
with tuck tape.*
* * *

Use the **0.3x4x5 mm compressing springs**, the **M3 locknuts** and the
**M3x10mm bolts** to finish up the charger. Have the springs push down on
the **blank wires** inside the towers. Clean the inside of the towers if
needed.

![blank wire](./assets/blank_wire.jpg)\
*Fig. 8: Here you see the blank wire inside the charger tower.*
* * *

Have the bolts look out
of the charger a bit so that the fidget gets good contact when pushed down
by the magnets.

![charging port](./assets/charging_port.jpg)\
*Fig. 9: Here you see the bolts looking out a little. Have them look out
as little as possible, but make the charger work.*
* * *

Before we close up the fidget we need to do the software and fine-tune the
position of the LED strip.

### 2.3.7 Software

Copy or link the folder in `arduino-solarfidget/libraries/solarfidget` into
your `Arduino/libraries` folder.

Place the files at:
<https://github.com/jrowberg/i2cdevlib/tree/master/Arduino/I2Cdev>
in a subdirectory in your `Arduino/libraries` folder

Place the files at:
<https://github.com/jrowberg/i2cdevlib/tree/master/Arduino/MPU6050>
in a subdirectory in your `Arduino/libraries` folder

Place the files at:
<https://github.com/adafruit/Adafruit_NeoPixel>
in a subdirectory in your `Arduino/libraries` folder

Open the Arduino IDE and load the file:
`arduino-solarfidget/arduino-solarfidget.ino`

Place the fidget on top of the charger, the charger on a level surface and
connect it to your computer.
Open the serial monitor. Compile and upload the programme to the Arduino.
Wait for the Arduino to reset and start. Look at the serial monitor and
note down the **calibration values**. Now, open the file:
`arduino-solarfidget/arduino-solarfidget.ino` and find the follwoing
lines:

```
mpu.CalibrateAccel(6);
mpu.CalibrateGyro(6);
mpu.PrintActiveOffsets();
```

Comment those lines and uncomment the lines above starting with mpu.set???
and replace the values you just noted down for Gyro and Accel.

Then, comment the following line, so the Arduino won't wait for a serial
connection when not connected to USB:

```
#define SERIAL_DEBUG
```

If you want power saving, uncomment the following line.

```
//#define POWERSAVING
```

If in power saving mode, before you try enabling the fidget, hold it for a
few seconds in your hands. If you have trouble enabling it, just flip it
continuously by 180 degrees until it enables. Power saving mode is only
active when the fidget is off and sitting still.

Save the file and upload the programme again.

Finally make sure the LED strip is placed correctly in the fidget and the
light of the pendulum is at the right spot. Do this by holding the fidget
askew and wait for the pendulum to rest. Now, move the strip either left
or right to bring the light into the correct position.

After that, slide the other part of the fidget on.

You should all be set now. Have fun travelling our solar system.

