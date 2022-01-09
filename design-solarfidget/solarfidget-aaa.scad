// This needs clean-up to make it readable and portable but it works for
// rendering and printing.

arduinoLength=43.55;
arduinoWidth=18.7;
arduinoX=-22;
arduinoY=13.5;

mpuLength=16.2;
mpuWidth=21;
mpuX=-10.5;
mpuY=14.8;

boosterLength=18.7;
boosterWidth=21;
boosterX=-10.5;
boosterY=14.8;

LEDsWidth=12;
LEDsHeight=2;

wall=2;
walle = .8;
wallHeight=2.5;

bottomHeight=2;
electronicsHeight=7.2;

innerRad=35.49;

ridgesRad=.5;

res=100;
loose=.3;

aaaLength=45.5;
aaar=10.25/2+loose;

module batteries_side() {
	//translate([-walle*2,0,0]) cube([walle*3,aaar*2,aaar]);
	translate([-walle*2,aaar,aaar]) rotate([0,90,0]) cylinder(r=aaar+1, h=walle*5, $fn=res);
}

module batteries() {
	difference() {
		cube([aaaLength, aaar*3*2,aaar+bottomHeight]);
		translate([-1,5.5,aaar+bottomHeight])
			rotate([0,90,0]) cylinder(r=aaar,h=aaaLength+2, $fn=res);
		translate([-1,5.5+aaar*2,aaar+bottomHeight])
			rotate([0,90,0]) cylinder(r=aaar,h=aaaLength+2, $fn=res);
		translate([-1,5.5+aaar*4,aaar+bottomHeight])
			rotate([0,90,0]) cylinder(r=aaar,h=aaaLength+2, $fn=res);
		translate([-1,-1,aaar-.5]) cube([aaaLength+2, aaar*3*2+2.5,aaar+bottomHeight]);

	}
		//translate([-.3,aaar*3,aaar+bottomHeight-1.5]) rotate([0,90,0]) cylinder(r=3.15, h=2.1, $fn=res);
		//translate([44,aaar,aaar+bottomHeight-1.5]) rotate([0,90,0]) cylinder(r=3.15, h=2.1, $fn=res);
		//translate([44,aaar*5,aaar+bottomHeight-1.5]) rotate([0,90,0]) cylinder(r=3.15, h=2.1, $fn=res);
	difference() {
		union() {
			translate([-2.4,0,1]) batteries_side();
			translate([-2.4,aaar*2,1]) batteries_side();
			translate([-2.4,aaar*4,1]) batteries_side();
			translate([aaaLength+1.6,0,1]) batteries_side();
			translate([aaaLength+1.6,aaar*2,1]) batteries_side();
			translate([aaaLength+1.6,aaar*4,1]) batteries_side();
		}
		translate([-.8,aaar,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3, h=1, $fn=res);
		translate([-2.7,aaar,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3.4, h=2, $fn=res);

		translate([-.8,aaar*5,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3, h=1, $fn=res);
		translate([-2.7,aaar*5,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3.4, h=2, $fn=res);

		translate([aaaLength-.1,aaar*3,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3, h=1, $fn=res);
		translate([aaaLength+.8,aaar*3,aaar+bottomHeight]) rotate([0,90,0]) cylinder(r=3.4, h=2, $fn=res);

		translate([-.9,aaar*3,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.3, h=1, $fn=res);
		translate([-2.1,aaar*3,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.5, h=1.3, $fn=res);

		translate([aaaLength-.1,aaar,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.3, h=1, $fn=res);
		translate([aaaLength+.8,aaar,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.5, h=1.3, $fn=res);

		translate([aaaLength-.1,aaar*5,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.3, h=1, $fn=res);
		translate([aaaLength+.8,aaar*5,aaar+bottomHeight-1]) rotate([0,90,0]) cylinder(r=4.5, h=1.3, $fn=res);
	
		translate([-walle*6,0,11.7])cube([aaaLength+walle*12, aaar*3*2,aaar+bottomHeight]);
	}
	
}



module minus() {
	cube([5,2,3]);
}

module plus() {
	cube([5,2,3]);
	rotate([0,0,90]) translate([-1.5,-3.5,0]) cube([5,2,3]);
}

module aaa_outside() {
	translate([(-aaaLength-springLength-walle*2-2)/2,1.65,bottomHeight])
		cube([aaaLength+springLength+walle*2+loose*2,aaar*2+walle*2,aaar*2+walle*2-2]);
	//translate([(-aaaLength-springLength-walle*2-4.5)/2,3,bottomHeight])
	//	cube([1.5,9,aaar*2-.4]);
	//translate([(aaaLength+springLength+walle*2-1.5)/2,3,bottomHeight])
	//	cube([1.5,9,aaar*2-.4]);
	//translate([(-aaaLength-springLength-walle*2-6.5)/2,4,bottomHeight])
	//	cube([1.5,7,aaar*2-.4]);
	//translate([(aaaLength+springLength+walle*2)/2,4,bottomHeight])
	//	cube([1.5,7,aaar*2-.4]);
}

module aaa_inside() {
	translate([(-aaaLength-springLength-walle*2)/2+3,1.65-1,bottomHeight+aaar])
		cube([aaaLength+springLength+walle*2-7.6,aaar*2+walle*2+2,aaar*2+walle*2+1]);
	translate([(-aaaLength-springLength-walle*2)/2-1,1.65+aaar+walle,aaar+bottomHeight+loose])
		rotate([0,90,0]) cylinder(r=aaar+loose,h=aaaLength+springLength, $fn=res);
	translate([(-aaaLength-springLength+6)/2+walle-1.5,1.65+aaar+walle,aaar+bottomHeight+loose])
		rotate([0,90,0]) cylinder(r=3.25,h=aaaLength+springLength-1, $fn=res);
	//translate([(-aaaLength-springLength)/2+walle-3.5,1.65+aaar+walle,aaar+bottomHeight+loose])
	//	rotate([0,90,0]) cylinder(r=2,h=aaaLength+springLength-2, $fn=res);
	translate([17,9.5,bottomHeight-1.5]) minus();
	translate([-23,4.2,bottomHeight-1.5]) plus();
}

module aaa_batteries() {
	difference() {
		union() {
			translate([-.2,0,0]) aaa_outside();
			rotate([0,0,180]) translate([1.8,-walle*4-.7,0]) aaa_outside();
			translate([-.2,-22.5,0]) aaa_outside();
			translate([23,-17.5,0]) cube([4,31,11.85]);
			translate([-29,-17.5,0]) cube([4,31,11.85]);
		}
		union() {
			translate([-.2,0,0]) aaa_inside();
			rotate([0,0,180]) translate([1.8,-walle*4-.7,0]) aaa_inside();
			translate([-.2,-22.5,0]) aaa_inside();
			translate([24,-17,0]) cube([.6,7,12]);
			translate([23.9,-6.45,0]) cube([.6,16,12]);
			translate([-26.5,-17.75,0]) cube([.6,16,12]);
	translate([22.5,-15,2.5]) rotate([0,90,0]) cylinder(r=.7, h=8, $fn=res);
	translate([-32.5,7.5,2.5]) rotate([0,90,0]) cylinder(r=.7, h=8, $fn=res);
		}
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
	translate([0,0,1]) ridge(location, size);
	translate([0,0,2.85]) ridge(location, size);
	translate([0,size[1],1]) ridge(location, size);
	translate([0,size[1],2.85]) ridge(location, size);
}

module arduino() {
	arduinoZ=10.1;
	difference() {
		compartmentOutside([0, 0, bottomHeight], [arduinoLength, arduinoWidth, arduinoZ]);
		compartmentInside([0, 0, bottomHeight], [arduinoLength, arduinoWidth, arduinoZ]);
		//translate([-2.3,17,0]) rotate([0,0,45]) cube([10,10,13]);
		//translate([40,22.8,0]) rotate([0,0,-45]) cube([10,10,13]);
	}
	ridgesCompartment([0, -.1, bottomHeight+7.8], [arduinoLength, arduinoWidth, arduinoZ]);
}

module mpu() {
	arduinoZ=4;
	difference() {
		compartmentOutside([0,0,bottomHeight], [mpuWidth,mpuLength,arduinoZ]);
		compartmentInside([0,0,bottomHeight], [mpuWidth,mpuLength,arduinoZ]);
	}
	ridgesCompartment([0,-.1,bottomHeight+1.5], [mpuWidth,mpuLength,arduinoZ]);
}

module booster() {
	arduinoZ=4;
	difference() {
		compartmentOutside([0,0,bottomHeight], [boosterWidth-walle,boosterLength,arduinoZ]);
		compartmentInside([0,0,bottomHeight], [boosterWidth,boosterLength,arduinoZ]);
	}
	ridgesCompartment([0,-.1,bottomHeight+1.5], [boosterWidth,boosterLength,arduinoZ]);
}

module bottom() {
	rotate([0,0,0]) difference() {
		union() {
			difference() {
				cylinder(r=innerRad+LEDsHeight+4, h=bottomHeight, $fn=res);
				clearCorners(innerRad+LEDsHeight+4);
			}
			roundCorners(innerRad+LEDsHeight+4);
		}
	}
	difference() {
		translate([0,0,bottomHeight]) cylinder(r=innerRad+LEDsHeight+4, h=LEDsWidth-4, $fn=res);
		translate([0,0,bottomHeight]) cylinder(r=innerRad+LEDsHeight+1.8, h=LEDsWidth+wall, $fn=res);
	}
}

module top() {
	difference() {
		translate([0,0,0]) _top();
		//translate([arduinoLength-15,-arduinoX-4.25,13]) rotate([90,0,90])
		//	rotate([0,0,0]) resize([15,13,0]) cylinder(r=6, 15, $fn=res);
	}
	difference() {
		translate([arduinoX+walle/2,arduinoY-5.5,0]) arduino();
		translate([arduinoLength/2-3,-arduinoX-4.5,11]) rotate([90,0,90])
			resize([11,0,0]) cylinder(r=3, 5, $fn=res);
	}
	translate([.9,mpuY-4.3,0]) mpu();
	translate([-20.8-walle,mpuY-6.8,0]) booster();
	translate([-.8,-.5,0]) difference() {
		translate([-21.8,-24.8,0]) batteries();
		translate([-26,2.3,4.8]) rotate([0,90,0]) cylinder(r=.75, h=5, $fn=res);
		translate([23,-aaar*4+2.5,3.9]) rotate([0,90,0]) cylinder(r=.75, h=5, $fn=res);
		translate([-24,-17,7]) rotate([0,90,90]) cylinder(r=.5, h=12, $fn=res);
		translate([26,-7,7]) rotate([0,90,90]) cylinder(r=.5, h=12, $fn=res);
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

module _fix_towers() {
	rotate([0,90,0]) translate([-10,0,-50]) cylinder(r=2.5, h=100, $fn=res);
	rotate([90,0,0]) translate([0,10,-50]) cylinder(r=2.5, h=100, $fn=res);
}

module __fix_towers() {
	rotate([0,90,0]) translate([-10,0,-50]) cylinder(r=2.3, h=100, $fn=res);
	rotate([90,0,0]) translate([0,10,-50]) cylinder(r=2.3, h=100, $fn=res);
}


module fix_towers() {
	difference() {
		__fix_towers();
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
			translate([0,0,.5]) _fix_towers();
			translate([0,0,.75]) _fix_towers();
			translate([0,0,1]) _fix_towers();
			translate([0,0,1.25]) _fix_towers();
			translate([0,0,1.50]) _fix_towers();
			translate([0,0,1.75]) _fix_towers();
			translate([0,0,2]) _fix_towers();
			translate([0,0,2.25]) _fix_towers();
			translate([0,0,2.50]) _fix_towers();
			translate([0,0,2.75]) _fix_towers();
			translate([0,0,3]) _fix_towers();
			translate([0,0,3.25]) _fix_towers();
			translate([0,0,3.50]) _fix_towers();
			translate([0,0,3.75]) _fix_towers();
			translate([0,0,4]) _fix_towers();
			translate([0,0,.0]) rotate([0,0,1]) _fix_towers(); 
			translate([0,0,.0]) rotate([0,0,2]) _fix_towers();
			translate([0,0,.1]) rotate([0,0,3]) _fix_towers();
			translate([0,0,.1]) rotate([0,0,4]) _fix_towers();
			translate([0,0,.1]) rotate([0,0,5]) _fix_towers();
			translate([0,0,.2]) rotate([0,0,6]) _fix_towers();
			translate([0,0,.2]) rotate([0,0,7]) _fix_towers();
			translate([0,0,.2]) rotate([0,0,8]) _fix_towers();
			translate([0,0,.3]) rotate([0,0,9]) _fix_towers();
			translate([0,0,.3]) rotate([0,0,10]) _fix_towers();
			translate([0,0,.3]) rotate([0,0,11]) _fix_towers(); 
			translate([0,0,.4]) rotate([0,0,12]) _fix_towers();
			translate([0,0,.4]) rotate([0,0,13]) _fix_towers();
			translate([0,0,.4]) rotate([0,0,14]) _fix_towers();
			translate([0,0,.4]) rotate([0,0,15]) _fix_towers();
			translate([0,0,.4]) rotate([0,0,16]) _fix_towers();
			translate([0,0,.4]) rotate([0,0,17]) _fix_towers();
			translate([0,0,.4]) rotate([0,0,18]) _fix_towers();
			translate([0,0,.4]) rotate([0,0,19]) _fix_towers();
			translate([0,0,.4]) rotate([0,0,20]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-1]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-2]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-3]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-4]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-5]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-6]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-7]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-8]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-9]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-10]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-11]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-12]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-13]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-14]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-15]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-16]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-17]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-18]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-19]) _fix_towers();
			translate([0,0,0]) rotate([0,0,-20]) _fix_towers();
		}
		__top();
		translate([0,0,6]) difference() {
			cylinder(r=innerRad+LEDsHeight+wall*10, h=LEDsWidth-4, $fn=res);
			cylinder(r=innerRad+LEDsHeight+2.7, h=LEDsWidth-4, $fn=res);
		}
	}

}

//module button_knob() {
//	cylinder(r=35, h=bottomHeight/2);
//	translate([-31,0,0]) cylinder(r=3.6, h=bottomHeight+1.2, $fn=res);
//}

module LEDstripe() {
	difference() {
		cylinder(r=innerRad+2, h=LEDsWidth, $fn=res);
		translate([0,0,-1])cylinder(r=innerRad, h=LEDsWidth+2, $fn=res);

	}
}

//difference() {
//	union() {
//		fix_towers();
//		difference() {
//			union() {
//				top();
//				translate([-25.75,12.75,bottomHeight]) cylinder(r=3, h=LEDsWidth-4.6, $fn=res);
//				translate([.9,6.5,0]) difference() {
//					translate([-31,2,bottomHeight]) cube([8.5,8.5,LEDsWidth-1]);
//					translate([-30,3,bottomHeight]) cube([6.5,6.5,LEDsWidth-.5]);
//				}
//			}
//			translate([-17,.5,.8]) minus();
//			translate([17,.5,.8]) plus();
//			translate([-22,-aaar*2+.5,.8]) plus();
//			translate([11,-aaar*2+.5,.8]) minus();
//			translate([-17,-aaar*4+.5,.8]) minus();
//			translate([17,-aaar*4+.5,.8]) plus();
//			translate([.7,25,6.5]) rotate([0,90,90]) resize([0,6,0]) cylinder(r=1.2, h=3, $fn=100);
//			translate([-22.8,11,10]) rotate([0,90,0]) resize([10,0,0])cylinder(r=1, h=10, $fn=100);
//			translate([20,11,6.5]) rotate([0,90,0]) cylinder(r=1, h=10, $fn=100);
//			translate([-28,0,10]) rotate([0,90,90]) resize([10,0,0]) cylinder(r=1, h=10, $fn=100);
//		}
//	}
//	translate([0,0,bottomHeight]) LEDstripe();
//}

//rotate([180,0,0])
//translate([0,0,-30])




difference() {
	bottom();
	translate([0,0,-4]) fix_grooves();
}





//difference() {
//	union() {
//		rotate([0,0,10]) button_knob();
//		rotate([0,0,100]) button_knob();
//		rotate([0,0,190]) button_knob();
//		rotate([0,0,280]) button_knob();
//	}
//	rotate([0,0,10]) union() {
//		translate([-50,0,bottomHeight+.6]) rotate([90,0,90]) cylinder(r=.675, h=100, $fn=res);
//		translate([0,-50,bottomHeight+.6]) rotate([90,0,180]) cylinder(r=.675, h=100, $fn=res);
//	}
//}



