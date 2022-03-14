

top_height = 0.5 * 25.4;
bottom_height = 1 * 25.4;
diameter = 25.4 * 6;
hole_diameter = diameter - top_height * 2;


rotate_extrude(angle = 360, $fn = 128) {
    translate([diameter / 2 - top_height / 2, 0]) circle(top_height, $fn = 64);
}


difference() {
    translate([0, 0, -top_height - bottom_height]) {
        difference() {
            cylinder(top_height * 2 + bottom_height, diameter / 2, diameter / 2, $fn = 64);
            translate([0, 0, -top_height - bottom_height]) {
                cylinder((top_height * 2 + bottom_height * 2) * 2, hole_diameter / 2, hole_diameter / 2, $fn = 64);
            }
    
        }
    }
    translate([0, 0,  -top_height - bottom_height]) {
        translate([0, diameter / 2, 0])
        rotate([90, 0, 0]) {
            cylinder(diameter, diameter / 5, diameter / 5, $fn = 64);
        }
    }
    rotate([0, 0, 90]) translate([0, 0,  -top_height - bottom_height]) {
        translate([0, diameter / 2, 0])
        rotate([90, 0, 0]) {
            cylinder(diameter, diameter / 5, diameter / 5, $fn = 64);
        }
    }
}
