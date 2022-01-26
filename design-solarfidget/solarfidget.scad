// (ORIGINAL) SOLARFIDGET (C) 2021,2022 Kurt Manucredo

// (ORIGINAL) SOLARFIDGET is licensed under a
// CREATIVE COMMONS ATTRIBUTION-NONCOMMERCIAL 4.0 INTERNATIONAL PUBLIC
// LICENSE

// You should have received a copy of the license along with this
// work.  If not, see:
// <https://creativecommons.org/licenses/by-nc/4.0/legalcode>


LEDsWidth=12;
LEDsHeight=2;

arduinoLength=43.55;
arduinoWidth=18.7;

mpuLength=16.2;
mpuWidth=21;

batteryCLength=28.5;
batteryCWidth=17.9;

batteryLength=45;
batteryWidth=25;
batteryHeight=8.55+4;

wall=2;
walle = .8;
wallHeight=2.5;

bottomHeight=2;
electronicsHeight=7.2;

innerRad=35.45;

screwShaftRadius=2.4;
screwRadius=1.5;
holeRad=2;
screwOne=[0,23.3,3];
screwTwo=[24,0,3];
screwThree = [0,-23,3];

ridgesRad=.5;

res=100;

module _batteryC() {

	difference() {
		translate([-22+walle/2,8,0]) batteryC();
		translate([batteryCWidth/2-5,17.5,5]) rotate([90,0,90])
			resize([11,0,0]) cylinder(r=3,5,$fn=res);
	}
}

module batteryC() {

	Z=3.5;
	difference() {
		compartmentOutside([0,0,bottomHeight],[batteryCLength,batteryCWidth,Z]);
		compartmentInside([0,0,bottomHeight],[batteryCLength,batteryCWidth,Z]);
	}
	ridgesCompartment([0,-.05,bottomHeight+5],[batteryCLength,batteryCWidth,Z]);
}

module _arduino() {

	difference() {
		translate([-22+walle/2,8,0]) arduino();
		translate([arduinoLength/2-3,17.5,8]) rotate([90,0,90])
			resize([11,0,0]) cylinder(r=3,5,$fn=res);
	}
}

module arduino() {

	Z=6;
	difference() {
		compartmentOutside([0,0,bottomHeight],[arduinoLength,arduinoWidth,Z]);
		compartmentInside([0,0,bottomHeight],[arduinoLength,arduinoWidth,Z]);
	}
	ridgesCompartment([0,-.05,bottomHeight+7],[arduinoLength,arduinoWidth,Z]);
}

module mpu() {

	Z=4;
	difference() {
		compartmentOutside([0,0,bottomHeight],[mpuWidth,mpuLength,Z]);
		compartmentInside([0,0,bottomHeight],[mpuWidth,mpuLength,Z]);
	}
	ridgesCompartment([0,-.05,bottomHeight+5],[mpuWidth,mpuLength,Z]);
}

module magnets () {
	translate([22,24,.45]) cylinder(r=2.47,h=1.6, $fn=res);
	translate([0,34.5,.45]) cylinder(r=2.47,h=1.6, $fn=res);
	translate([0,17,.45]) cylinder(r=2.47,h=1.6, $fn=res);
	translate([-22,24,.45]) cylinder(r=2.47,h=1.6, $fn=res);
}

module LEDstripe() {
	difference() {
		cylinder(r=innerRad+2, h=LEDsWidth, $fn=res);
		translate([0,0,-1]) cylinder(r=innerRad, h=LEDsWidth+2, $fn=res);

	}
}

module batteryCompartment() {
	difference() {
		translate([0,0,0]) rotate([0,0,0]) cube([batteryLength+walle*3, batteryWidth+walle*3, batteryHeight]);
		translate([walle,walle,walle]) rotate([0,0,0]) cube([batteryLength+walle, batteryWidth+walle, batteryHeight]);
		translate([-1,batteryWidth,-1]) cube([5,5,15]);    
		translate([45,batteryWidth,-1]) cube([5,5,15]);    
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

module clearings() {
	translate([8,-19,-1.5]) cube([batteryCWidth,2,7]);

	translate([-17,17.5,0]) rotate([90,0,90])
	resize([11,0,0]) cylinder(r=3, 5, $fn=res);
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
		magnets();
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
		translate([0,-39,7])rotate([90,0,0]) cylinder(r=2, h=2, $fn=res);
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
	difference() {
		union() {
			_top();
			translate([-2,-3.6,0]) union() {
				translate([-4.5,-2.6,0]) _arduino();
				translate([-22,-22,0]) batteryCompartment();
				translate([-5,-21.2,0]) rotate([0,0,90]) mpu();
				translate([-4,-21,0]) batteryC();
			}
		}
		translate([0,0,bottomHeight]) LEDstripe();
	}
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
				magnets();
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
	cylinder(r=5.5, h=8, $fn=res);
}

module charging_contact_post_c_i() {
	cylinder(r=3, h=6, $fn=res);
	cylinder(r=1.7, h=9, $fn=res);
	translate([0,0,-3]) cylinder(r1=9.5, r2=0, h=5, $fn=res);
}

module charging_contact_posts_c() {
	translate([15,28,0]) charging_contact_post_c();
	translate([5,28,0]) charging_contact_post_c();
	translate([-5,28,0]) charging_contact_post_c();
	translate([-15,28,0]) charging_contact_post_c();
}

module charging_contact_posts_c_i() {
	translate([15,28,0]) charging_contact_post_c_i();
	translate([5,28,0]) charging_contact_post_c_i();
	translate([-5,28,0]) charging_contact_post_c_i();
	translate([-15,28,0]) charging_contact_post_c_i();
}

module charging_contact_posts() {
	translate([15,28,0]) charging_contact_post();
	translate([5,28,0]) charging_contact_post();
	translate([-5,28,0]) charging_contact_post();
	translate([-15,28,0]) charging_contact_post();
}

module charging_contact_posts_i() {
	translate([15,28,0]) charging_contact_post_i();
	translate([5,28,0]) charging_contact_post_i();
	translate([-5,28,0]) charging_contact_post_i();
	translate([-15,28,0]) charging_contact_post_i();

}

top();
translate([0,0,-30])
bottom();
translate([0,0,40])
charger_top();
translate([0,0,-60])
charger_bottom();
