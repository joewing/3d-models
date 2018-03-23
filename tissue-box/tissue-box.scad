// Tissue Box
// Joe Wingbermuehle
// 2018-03-18

box_height = 136;
box_width = 120;
corner_size = 5;
opening_width = box_width * 0.75;
opening_height = box_width * 0.5;
wall_width = 0.8;

module corner(size, height) {
    difference() {
        translate([0, 0, height / 2]) {
            cube([size, size, height], center = true);
        }
        translate([size / 2, size / 2, height / 2]) {
            cylinder(height, size / 2, size / 2, center = true, $fn = 30);
        }
    }
}

module rounded_cube(x, y, z) {
    difference() {
        cube([x, y, z]);
        corner(corner_size, z);
        translate([x, 0, 0]) {
            rotate([0, 0, 90]) {
                corner(corner_size, z);
            }
        }
        translate([0, y, 0]) {
            rotate([0, 0, -90]) {
                corner(corner_size, z);
            }
        }
        translate([x, y, 0]) {
            rotate([0, 0, 180]) {
                corner(corner_size, z);
            }
        }
        rotate([0, 90, 0]) {
            rotate([0, 0, 90]) {
                corner(corner_size, x);
            }
        }
        translate([0, y, 0]) {
            rotate([0, 90, 0]) {
                rotate([0, 0, 180]) {
                    corner(corner_size, x);
                }
            }
        }
        translate([0, y, 0]) {
            rotate([90, 0, 0]) {
                corner(corner_size, y);
            }
        }
        translate([x, y, 0]) {
            rotate([90, 0, 0]) {
                rotate([0, 0, 90]) {
                    corner(corner_size, y);
                }
            }
        }
    }
}

module opening() {
    linear_extrude(wall_width * 2) {
        resize([opening_width, opening_height]) {
            circle(box_width);
        }   
    }
}

difference() {
    rounded_cube(box_width, box_width, box_height);
    translate([box_width / 2, box_width / 2, 0]) {
        opening();
    }
    translate([wall_width, wall_width, wall_width]) {
        rounded_cube(
            box_width - wall_width * 2,
            box_width - wall_width * 2,
            box_height);
    }
}
