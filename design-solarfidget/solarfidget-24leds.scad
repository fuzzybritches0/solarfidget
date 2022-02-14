//*** DO NOT USE FOR PRINTING - IT WILL NOT WORK ***//
//*** THIS FILE IS HERE FOR DOCUMENTING PURPOSES ONLY ***//


// This was the very first version designed. It uses a 24led ring, where the
// leds look up instead of to the side. I have tried several iterations of a
// charger mechanism but failed every time. I abandoned this design due to the
// space being too limited. Most of the software, however, was written using
// this unfinished design as a development platform.

// (ORIGINAL) SOLARFIDGET Copyright (C) 2021, 2022 Kurt Manucredo

// (ORIGINAL) SOLARFIDGET is licensed under a
// CREATIVE COMMONS ATTRIBUTION-NONCOMMERCIAL 4.0 INTERNATIONAL PUBLIC
// LICENSE

// You should have received a copy of the license along with this
// work.  If not, see:
// <https://creativecommons.org/licenses/by-nc/4.0/legalcode>

arduinoLength=43.45;
arduinoWidth=18.9;
mpuLength=16.1;
mpuWidth=21;
upperLength=17.3;
upperWidth=mpuWidth;
batteryCLength=25.7;
batteryCWidth=19.7;

wall=1.5;
walle = .9;
wallHeight=2.5;
looseFit=.07;

heightBottom=2;
heightLEDS=3;
heightBattery=8.2;
batteryLength=38;
batteryWidth=20;
heightElectronics=7.2;
height=heightBattery+heightElectronics+1;

res=100;

innerRad=33.2 + looseFit;
outerRad=innerRad+wall;

lightsRad=30;
screwShaftRadius=2.4;
screwRadius=1.5;
holeRad=2;
screwOne=[0,23.3,3];
screwTwo=[24,0,3];
screwThree = [0,-23,3];


arduinoX=-23;
arduinoY=-19.5;

mpuX=4;
mpuY=0;
upperX=-mpuLength/2-upperLength-wall;
upperY=-upperWidth/2+1.8;

lowerX=mpuLength/2+wall;
lowerY=-upperWidth/2+1.8;

batteryCX=-22.5;
batteryCY=0;

charging_wire_radius=.7;
ridgesRad=.5;

module batteryCompartment() {
    difference() {
        translate([0,0,0]) rotate([0,0,0]) cube([batteryLength+walle*3, batteryWidth+walle*3, heightBattery/1.3+walle]);
        translate([walle,walle,walle]) rotate([0,0,0]) cube([batteryLength+walle, batteryWidth+walle, heightBattery/1.3+walle]);
        translate([-2,-2,-1]) cube([5,5,10]);    
    }
}

module spacerTowers(hShaft) {
    translate(screwOne) resize([15,0,0]) cylinder(r=1.8,h=hShaft, $fn=res); 
    translate(screwTwo) resize([0,15,0]) cylinder(r=1.8,h=hShaft, $fn=res);
    translate(screwThree) resize([15,0,0]) cylinder(r=1.8,h=hShaft, $fn=res);
}

module holes(count=24) {
    for (i=[1:count]) {
        translate([lightsRad*cos(i*(360/count)), lightsRad*sin(i*(360/count)), 0])
        cylinder(r=holeRad, h=height, $fn=res);
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
    translate([location[0]-walle, location[1]-walle, location[2]-walle]) cube([size[0]+walle*2, size[1]+walle*2, size[2]]);
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
    translate([0,0,-3.05]) ridge(location, size);
    translate([0,size[1],-1]) ridge(location, size);
    translate([0,size[1],-3.05]) ridge(location, size);
}

module electronics() {
    arduinoZ=heightElectronics-wallHeight;
    difference() {
        union() {
                translate([-.8,.5,wallHeight+walle/2]) cylinder(r=innerRad - looseFit - walle * 2, h=walle, $fn=res);
            compartmentOutside([arduinoX, arduinoY, arduinoZ], [arduinoLength, arduinoWidth, wallHeight]);
            compartmentOutside([mpuX,mpuY,arduinoZ], [mpuLength,mpuWidth,wallHeight]);
            compartmentOutside([batteryCX,batteryCY,arduinoZ], [batteryCLength,batteryCWidth,wallHeight]);
        }
        compartmentInside([arduinoX, arduinoY, arduinoZ], [arduinoLength, arduinoWidth, wallHeight]);
        compartmentInside([mpuX,mpuY,arduinoZ], [mpuLength,mpuWidth,wallHeight]);
        compartmentInside([batteryCX,batteryCY,arduinoZ], [batteryCLength,batteryCWidth,wallHeight]);
    }
    ridgesCompartment([arduinoX, arduinoY, arduinoZ*2-walle], [arduinoLength, arduinoWidth, wallHeight]);
    ridgesCompartment([mpuX,mpuY,arduinoZ*2-walle], [mpuLength,mpuWidth,wallHeight]);
    ridgesCompartment([batteryCX,batteryCY,arduinoZ*2-walle], [batteryCLength,batteryCWidth,wallHeight]);
}

module clearings() {
    translate([arduinoX-3,-arduinoWidth/2-wall,+wall*7.7]) rotate([90,0,90])
    resize([11,0,0]) cylinder(r=3, h=arduinoLength+5, $fn=res);
    translate([batteryCX-2,batteryCWidth/2,+wall*7.7]) rotate([90,0,90])
    resize([11,0,0]) cylinder(r=3, h=batteryCLength+wall+3, $fn=res);
}

module electronicsHolder() {
    difference() {
        electronics();
        translate([0,0,-4.2]) clearings();
    }
    spacerTowers(height - heightElectronics / 2);
}

module bottom() {
    //rotate([0,180,0]) difference() {
        union() {
            difference() {
                cylinder(r=outerRad, h=heightBottom, $fn=res);
                clearCorners(outerRad);
            }
            roundCorners(outerRad);
        }
    //}
        difference() {
            translate([0,0,0]) cylinder(r=innerRad - looseFit, h=height-heightLEDS-walle, $fn=res);
            translate([0,0,0]) cylinder(r=innerRad - looseFit - wall, h=height - heightLEDS+0.9, $fn=res);
        }
}


module top() {
    difference() {
        union() {
            difference() {
                cylinder(r=outerRad, h=height, $fn=res);
                clearCorners(outerRad);
            }
            roundCorners(outerRad);
        }
        translate([0,0,wall]) cylinder(r=innerRad, h=height, $fn=res);
        //translate([0,0,-wall])holes();
    }
    translate([-batteryLength/2,-batteryWidth/2,0]) batteryCompartment();
}

module charging_wire(radius) {
	rotate_extrude(convexity = 10, $fn=res)
	translate([radius,0,0]) circle(r=charging_wire_radius, $fn=res);
}

top();
translate([0,0,40]) electronicsHolder();
translate([0,0,80]) difference() {
	bottom();
	//translate([0,0,.5]) charging_wire(radius=15);
	//translate([0,0,.5]) charging_wire(radius=20);
	//translate([0,0,.5]) charging_wire(radius=25);
	//translate([0,0,.5]) charging_wire(radius=30);

	//translate([15,0,-5]) cylinder(r=charging_wire_radius, h=10, $fn=res);
	//translate([20,0,-5]) cylinder(r=charging_wire_radius, h=10, $fn=res);
	//translate([25,0,-5]) cylinder(r=charging_wire_radius, h=10, $fn=res);
	//translate([30,0,-5]) cylinder(r=charging_wire_radius, h=10, $fn=res);
}


//charging_wire(count=50, radius=30);
