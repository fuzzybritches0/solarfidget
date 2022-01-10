res=100;
innerRad=35.49;

wall=2;
walle=.8;
wallHeight=2.5;

ridgesRad=.5;

bottomHeight=2;
electronicsHeight=7.2;

arduinoLength=43.55;
arduinoWidth=18.7;

mpuLength=16.2;
mpuWidth=21;

boosterLength=18.7;
boosterWidth=21;

LEDsWidth=12;
LEDsHeight=2;

aaaLength=45.5;
aaar=10.25/2+.3;

module spring_inserts() {

	translate([-.8,aaar,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3,h=1,$fn=res);
	translate([-2.7,aaar,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3.4,h=2,$fn=res);

	translate([-.8,aaar*5,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3,h=1,$fn=res);
	translate([-2.7,aaar*5,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3.4,h=2,$fn=res);

	translate([aaaLength-.1,aaar*3,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3,h=1,$fn=res);
	translate([aaaLength+.8,aaar*3,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3.4,h=2,$fn=res);
}

module washer_inserts() {

	translate([-.9,aaar*3,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.3,h=1,$fn=res);
	translate([-2.1,aaar*3,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.5,h=1.3,$fn=res);

	translate([aaaLength-.1,aaar,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.3,h=1,$fn=res);
	translate([aaaLength+.8,aaar,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.5,h=1.3,$fn=res);

	translate([aaaLength-.1,aaar*5,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.3,h=1,$fn=res);
	translate([aaaLength+.8,aaar*5,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.5,h=1.3,$fn=res);
}

module battery_wiring_holes() {

	translate([-26,2.3,4.8]) rotate([0,90,0]) cylinder(r=.75, h=5, $fn=res);
	translate([22.2,-aaar*4+2.5,3.9]) rotate([0,90,0]) cylinder(r=.75, h=5, $fn=res);
	translate([-24.8,-17,7]) rotate([0,90,90]) cylinder(r=.5, h=12, $fn=res);
	translate([25.2,-7,7]) rotate([0,90,90]) cylinder(r=.5, h=12, $fn=res);
}

module battery_side() {

	translate([-walle*2,aaar,aaar]) rotate([0,90,0]) cylinder(r=aaar+1,h=walle*5,$fn=res);
}

module battery_sides() {

	translate([-2.4,0,1]) battery_side();
	translate([-2.4,aaar*2,1]) battery_side();
	translate([-2.4,aaar*4,1]) battery_side();
	translate([aaaLength+1.6,0,1]) battery_side();
	translate([aaaLength+1.6,aaar*2,1]) battery_side();
	translate([aaaLength+1.6,aaar*4,1]) battery_side();
}

module batteries() {

	difference() {
		translate([-22.6,-25.2,0]) _batteries();
		battery_wiring_holes();
	}
}

module _batteries() {

	difference() {
		cube([aaaLength,aaar*6,aaar+bottomHeight]);
		for (i=[0:2:4]) {
			translate([-1,aaar*i+5.5,aaar+bottomHeight]) rotate([0,90,0])
				cylinder(r=aaar,h=aaaLength+2, $fn=res);
		}
		translate([-1,-1,aaar-.5]) cube([aaaLength+2,aaar*6+2.5,aaar+bottomHeight]);
	}
	difference() {
		battery_sides();
		spring_inserts();
		washer_inserts();
		translate([-walle*6,0,11.7]) cube([aaaLength+walle*12,aaar*6,aaar+bottomHeight]);
	}
}

module battery_ori_ind() {

	translate([-17,.5,.8]) minus();
	translate([17,.5,.8]) plus();
	translate([-22,-aaar*2+.5,.8]) plus();
	translate([11,-aaar*2+.5,.8]) minus();
	translate([-17,-aaar*4+.5,.8]) minus();
	translate([17,-aaar*4+.5,.8]) plus();
}

module minus() {

	cube([5,2,3]);
}

module plus() {

	cube([5,2,3]);
	rotate([0,0,90]) translate([-1.5,-3.5,0]) cube([5,2,3]);
}

module clearCorners(ra) {

	translate([0,0,0]) rotate_extrude(convexity=10,$fn=res)
	translate([ra,0,0]) circle(r=1,$fn=res);
}

module roundCorners(ra) {

	translate([0,0,1]) rotate_extrude(convexity=10,$fn=res)
	translate([ra-1,0,0]) circle(r=1,$fn=res);
}

module compartmentOutside(location,size) {

	translate([location[0]-walle,location[1]-walle,location[2]-walle*2])
		cube([size[0]+walle*2,size[1]+walle*2,size[2]+walle]);
}
module compartmentInside(location,size) {

	translate([location[0],location[1],location[2]-4]) cube([size[0],size[1],size[2]+5]);
}

module ridge(location,size) {

	translate(location) translate([wall,0,-2]) rotate([0,90,0])
		cylinder(r=ridgesRad,h=size[0]-wall*2,$fn=res);
	translate(location) translate([wall,0,-2]) sphere(r=ridgesRad,$fn=res);
	translate(location) translate([wall+size[0]-wall*2,0,-2]) sphere(r=ridgesRad,$fn=res);
}

module ridgesCompartment(location,size) {

	translate([0,0,1]) ridge(location,size);
	translate([0,0,2.85]) ridge(location,size);
	translate([0,size[1],1]) ridge(location,size);
	translate([0,size[1],2.85]) ridge(location,size);
}

module _arduino() {

	difference() {
		translate([-22+walle/2,8,0]) arduino();
		translate([arduinoLength/2-3,17.5,11]) rotate([90,0,90])
			resize([11,0,0]) cylinder(r=3,5,$fn=res);
	}
}

module arduino() {

	Z=10.1;
	difference() {
		compartmentOutside([0,0,bottomHeight],[arduinoLength,arduinoWidth,Z]);
		compartmentInside([0,0,bottomHeight],[arduinoLength,arduinoWidth,Z]);
	}
	ridgesCompartment([0,-.1,bottomHeight+7.8],[arduinoLength,arduinoWidth,Z]);
}

module mpu() {

	Z=4;
	difference() {
		compartmentOutside([0,0,bottomHeight],[mpuWidth,mpuLength,Z]);
		compartmentInside([0,0,bottomHeight],[mpuWidth,mpuLength,Z]);
	}
	ridgesCompartment([0,-.1,bottomHeight+1.5],[mpuWidth,mpuLength,Z]);
}

module booster() {

	Z=4;
	difference() {
		compartmentOutside([0,0,bottomHeight],[boosterWidth-walle,boosterLength,Z]);
		compartmentInside([0,0,bottomHeight],[boosterWidth,boosterLength,Z]);
	}
	ridgesCompartment([0,-.1,bottomHeight+1.5],[boosterWidth,boosterLength,Z]);
}

module electronics() {
	_arduino();
	translate([.9,10.5,0]) mpu();
	translate([-20.8-walle,8,0]) booster();
}

module electronics_wiring_holes() {

	translate([.7,25,6.5]) rotate([0,90,90]) resize([0,6,0]) cylinder(r=1.2,h=3,$fn=100);
	translate([-22.8,11,10]) rotate([0,90,0]) resize([10,0,0])cylinder(r=1,h=10,$fn=100);
	translate([20,11,6.5]) rotate([0,90,0]) cylinder(r=1,h=10,$fn=100);
	translate([-28,0,10]) rotate([0,90,90]) resize([10,0,0]) cylinder(r=1,h=10,$fn=100);
}

module button_holder() {

	translate([-25.75,12.75,bottomHeight])
		cylinder(r=3, h=LEDsWidth-4.6, $fn=res);
	difference() {
		translate([-30.1,8.5,bottomHeight]) cube([8.5,8.5,LEDsWidth-1]);
		translate([-29.1,9.5,bottomHeight]) cube([6.5,6.5,LEDsWidth-.5]);
	}
}

module top() {

	difference() {
		union() {
			fix_towers();
			difference() {
				union() {
					translate([0,0,0]) _top();
					electronics();
					batteries();
					button_holder();
				}
				battery_ori_ind();
				electronics_wiring_holes();
			}
		}
		translate([0,0,bottomHeight]) LEDstripe();
	}
}

module _top() {

	difference() {
		__top();
		translate([0,0,2]) cylinder(r=innerRad+LEDsHeight, h=LEDsWidth+2, $fn=res);
	}
}

module __top() {

	union() {
		cylinder(r=innerRad+LEDsHeight+1.3, h=LEDsWidth+bottomHeight, $fn=res);
		difference() {
			cylinder(r=innerRad+LEDsHeight+4, h=bottomHeight+4, $fn=res);
			clearCorners(innerRad+LEDsHeight+4);
		}
		roundCorners(innerRad+LEDsHeight+4);
	}

}

module bottom() {

	difference() {
		cylinder(r=innerRad+LEDsHeight+4,h=bottomHeight,$fn=res);
		clearCorners(innerRad+LEDsHeight+4);
	}
	roundCorners(innerRad+LEDsHeight+4);
	difference() {
		translate([0,0,bottomHeight]) cylinder(r=innerRad+LEDsHeight+4,h=LEDsWidth-4,$fn=res);
		translate([0,0,bottomHeight]) cylinder(r=innerRad+LEDsHeight+1.8,h=LEDsWidth+wall,$fn=res);
		translate([0,0,-4]) fix_grooves();
	}
}

module _fix_towers(rad=2.5) {

	rotate([0,90,0]) translate([-10,0,-50]) cylinder(r=rad, h=100, $fn=res);
	rotate([90,0,0]) translate([0,10,-50]) cylinder(r=rad, h=100, $fn=res);
}

module fix_towers() {

	difference() {
		_fix_towers(2.3);
		__top();
		translate([0,0,6]) difference() {
			cylinder(r=innerRad+LEDsHeight+wall*10, h=LEDsWidth-4, $fn=res);
			cylinder(r=innerRad+LEDsHeight+2.4, h=LEDsWidth-4, $fn=res);
		}
	}
}

module fix_grooves() {

	difference() {
		union() {
			for (i = [.5:.25:4]) {
				translate([0,0,i]) _fix_towers();
			}
			for (i = [1:1:3]) {
				translate([0,0,.0]) rotate([0,0,i]) _fix_towers();
			}
			for (i = [4:1:6]) {
				translate([0,0,.1]) rotate([0,0,i]) _fix_towers();
			}
			for (i = [7:1:9]) {
				translate([0,0,.2]) rotate([0,0,i]) _fix_towers();
			}
			for (i = [10:1:12]) {
				translate([0,0,.3]) rotate([0,0,i]) _fix_towers();
			}
			for (i = [13:1:20]) {
				translate([0,0,.4]) rotate([0,0,i]) _fix_towers();
			}
			for (i = [-1:-1:-20]) {
				translate([0,0,0]) rotate([0,0,i]) _fix_towers();
			}
		}
		__top();
		translate([0,0,6]) difference() {
			cylinder(r=innerRad+LEDsHeight+wall*10, h=LEDsWidth-4, $fn=res);
			cylinder(r=innerRad+LEDsHeight+2.7, h=LEDsWidth-4, $fn=res);
		}
	}

}

module LEDstripe() {
	difference() {
		cylinder(r=innerRad+2, h=LEDsWidth, $fn=res);
		translate([0,0,-1]) cylinder(r=innerRad, h=LEDsWidth+2, $fn=res);

	}
}

//top();
translate([0,0,-40]) bottom();

