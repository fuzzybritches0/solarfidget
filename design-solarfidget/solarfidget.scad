// SOLARFIDGET (C) 2021 Kurt Manucredo

// SOLARFIDGET is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.

// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.

arduinoLength=43.55;
arduinoWidth=18.85;
arduinoX=-13.5;
arduinoY=8.5;

mpuLength=16.2;
mpuWidth=21;
mpuX=-13.8;
mpuY=-30.7;

LEDsWidth=12;
LEDsHeight=2;

batteryCLength=25.7;
batteryCWidth=20;
batteryCX=8;
batteryCY=-18;

batteryLength=38;
batteryWidth=20;
batteryHeight=7.4;

wall=2;
walle = .8;
wallHeight=2.5;

bottomHeight=2;
electronicsHeight=7.2;

innerRad=39.95;

screwShaftRadius=2.4;
screwRadius=1.5;
holeRad=2;
screwOne=[0,23.3,3];
screwTwo=[24,0,3];
screwThree = [0,-23,3];

ridgesRad=.5;

res=100;

module magnets () {
	for (i=[1:4]) {
		translate([38*cos(i*(360/4)), 38*sin(i*(360/4)), 0]) cylinder(r=2.47,h=1.6, $fn=res);
	}
}

module batteryCompartment() {
	difference() {
		translate([0,0,0]) rotate([0,0,0]) cube([batteryLength+walle*3, batteryWidth+walle*3, batteryHeight]);
		translate([walle,walle,walle]) rotate([0,0,0]) cube([batteryLength+walle, batteryWidth+walle, batteryHeight]);
		translate([-1,batteryWidth,-1]) cube([5,5,10]);    
	}
}

module clearCorners(r) {
	translate([0,0,0]) rotate_extrude(convexity = 10, $fn=res)
	translate([r, 0, 0])
	circle(r=1, $fn=res);
}

module roundCorners(r) {
	translate([0,0,1]) rotate_extrude(convexity = 10, $fn=res)
	translate([r-1, 0, 0])
	circle(r=1, $fn=res);
}

module compartmentOutside(location, size) {
	translate([location[0]-walle, location[1]-walle, location[2]-walle*2])
		cube([size[0]+walle*2, size[1]+walle*2, size[2]+walle]);
}
module compartmentInside(location, size) {
	translate([location[0], location[1], location[2]-4]) cube([size[0], size[1], size[2]+5]);
}

module ridge(location,size) {
	translate(location) translate([wall,0,-2]) rotate([0,90,0]) cylinder(r=ridgesRad,h=size[0]-wall*2, $fn=res);
	translate(location) translate([wall,0,-2]) sphere(r=ridgesRad, $fn=res);
	translate(location) translate([wall+size[0]-wall*2,0,-2]) sphere(r=ridgesRad, $fn=res);
}

module ridgesCompartment(location, size) {
	translate([0,0,-1]) ridge(location, size);
	translate([0,0,-2.85]) ridge(location, size);
	translate([0,size[1],-1]) ridge(location, size);
	translate([0,size[1],-2.85]) ridge(location, size);
}

module electronics() {
	arduinoZ=electronicsHeight-wallHeight;
	difference() {
		union() {
			compartmentOutside([arduinoX, arduinoY, arduinoZ], [arduinoLength, arduinoWidth, wallHeight+2]);
			compartmentOutside([mpuX,mpuY,arduinoZ], [mpuWidth,mpuLength,wallHeight]);
			compartmentOutside([batteryCX,batteryCY,arduinoZ], [batteryCWidth,batteryCLength,wallHeight+3]);
		}
		compartmentInside([arduinoX, arduinoY, arduinoZ], [arduinoLength, arduinoWidth, wallHeight+2]);
		compartmentInside([mpuX,mpuY,arduinoZ], [mpuWidth,mpuLength,wallHeight]);
		compartmentInside([batteryCX,batteryCY,arduinoZ], [batteryCWidth,batteryCLength,wallHeight+3]);
	}
	ridgesCompartment([arduinoX, arduinoY-.05, arduinoZ*2+1], [arduinoLength, arduinoWidth, wallHeight]);
	ridgesCompartment([mpuX,mpuY-.05,arduinoZ*2-1], [mpuWidth,mpuLength,wallHeight]);
	rotate([0,0,90])
		ridgesCompartment([batteryCY,-28.1,arduinoZ*2+2], [batteryCLength,batteryCWidth,wallHeight]);
}

module clearings() {
	translate([8,-19,-1.5]) cube([batteryCWidth,2,7]);

	translate([-17,17.5,0]) rotate([90,0,90])
	resize([11,0,0]) cylinder(r=3, 5, $fn=res);
}

module electronicsHolder() {
	difference() {
		electronics();
		translate([0,0,8]) clearings();
	}
	translate([-32.5,-14.6,bottomHeight]) batteryCompartment();
}

module charger_top() {
	difference() {
		union() {
			difference() {
				cylinder(r=innerRad+LEDsHeight+wall*1.5, h=bottomHeight, $fn=res);
				clearCorners(innerRad+LEDsHeight+wall*1.5);
	    		}
			roundCorners(innerRad+LEDsHeight+wall*1.5);
			difference() {
				cylinder(r=innerRad+LEDsHeight+wall, h=14, $fn=res);
				translate([0,0,0]) cylinder(r=innerRad+LEDsHeight+wall/2, h=15, $fn=res);
			}
			charging_contact_posts_c();
		}
		charging_contact_posts_c_i();
		translate([0,0,.45]) rotate([0,0,45]) magnets();
		translate([0,-35,10])rotate([90,0,0]) resize([5,15,0]) cylinder(r=2, h=10, $fn=res);
	}
}

module charger_bottom() {
	difference() {
		union() {
			difference() {
				cylinder(r=innerRad+LEDsHeight+wall*1.5, h=bottomHeight, $fn=res);
				clearCorners(innerRad+LEDsHeight+wall*1.5);
			}
			roundCorners(innerRad+LEDsHeight+wall*1.5);
			translate([0,0,bottomHeight])
			difference() {
				cylinder(r=innerRad+LEDsHeight+wall*1.5, h=14, $fn=res);
				cylinder(r=innerRad+LEDsHeight+wall, h=15, $fn=res);
			}
		}
		translate([0,-43,7])rotate([90,0,0]) cylinder(r=2, h=2, $fn=res);
	}
}

module bottom() {
	rotate([0,0,0]) difference() {
		union() {
			difference() {
				cylinder(r=innerRad+LEDsHeight+wall*1.5, h=bottomHeight, $fn=res);
				clearCorners(innerRad+LEDsHeight+wall*1.5);
			}
			roundCorners(innerRad+LEDsHeight+wall*1.5);
		}
	}
	difference() {
		translate([0,0,bottomHeight]) cylinder(r=innerRad+LEDsHeight+wall*1.5, h=LEDsWidth, $fn=res);
		translate([0,0,bottomHeight]) cylinder(r=innerRad+LEDsHeight+wall/2 , h=LEDsWidth+wall, $fn=res);
	}
}

module top() {
	_top();
	translate([0,-5,-1.3]) electronicsHolder();
}

module _top() {
	difference() {
		union() {
			difference() {
				union() {
					cylinder(r=innerRad+LEDsHeight+wall/2, h=LEDsWidth+bottomHeight, $fn=res);
					difference() {
						cylinder(r=innerRad+LEDsHeight+wall*1.5, h=bottomHeight, $fn=res);
						clearCorners(innerRad+LEDsHeight+wall*1.5);
					}
					roundCorners(innerRad+LEDsHeight+wall*1.5);
				}
				translate([0,0,wall]) cylinder(r=innerRad+LEDsHeight, h=LEDsWidth+wall, $fn=res);
				translate([0,0,.45]) rotate([0,0,45]) magnets();
			}
			charging_contact_posts();
		}
		charging_contact_posts_i();
	}
}

module charging_contact_post() {
	cylinder(r=4, h=7.4, $fn=res);
}

module charging_contact_post_i() {
	cylinder(r=2.7, h=3.3, $fn=res);
	cylinder(r=1.5, h=6, $fn=res);
	translate([0,0,-3]) cylinder(r1=9.5, r2=0, h=5, $fn=res);
	translate([0,0,5]) cylinder(r=3.2, h=3, $fn=6);
	translate([0,0,5.75]) rotate([90,0,0]) cylinder(r=0.75, h=4, $fn=res);
	translate([0,0,5.75]) rotate([90,0,-60]) cylinder(r=0.75, h=4, $fn=res);
}

module charging_contact_post_c() {
	cylinder(r=6, h=8, $fn=res);
}

module charging_contact_post_c_i() {
	cylinder(r=3, h=6, $fn=res);
	cylinder(r=1.7, h=9, $fn=res);
	translate([0,0,6.5]) rotate([90,0,0]) cylinder(r=0.75, h=10, $fn=res);
	translate([0,0,-3]) cylinder(r1=9.5, r2=0, h=5, $fn=res);
}

module charging_contact_posts_c() {
	translate([12,33,0]) charging_contact_post_c();
	translate([4,33,0]) charging_contact_post_c();
	translate([-4,33,0]) charging_contact_post_c();
	translate([-12,33,0]) charging_contact_post_c();
}

module charging_contact_posts_c_i() {
	translate([12,33,0]) charging_contact_post_c_i();
	translate([4,33,0]) charging_contact_post_c_i();
	translate([-4,33,0]) charging_contact_post_c_i();
	translate([-12,33,0]) charging_contact_post_c_i();
}

module charging_contact_posts() {
	translate([12,33,0]) charging_contact_post();
	translate([4,33,0]) charging_contact_post();
	translate([-4,33,0]) charging_contact_post();
	translate([-12,33,0]) charging_contact_post();
}

module charging_contact_posts_i() {
	translate([12,33,0]) charging_contact_post_i();
	translate([4,33,0]) charging_contact_post_i();
	translate([-4,33,0]) charging_contact_post_i();
	translate([-12,33,0]) charging_contact_post_i();
}

top();
translate([0,0,-30])
bottom();
translate([0,0,40])
charger_top();
translate([0,0,-60])
charger_bottom();
