// Hummingbird Feeder
// Joe Wingbermuehle
// 2018-05-07

// Part to render
// 0 - top
// 1 - base
// 2 - both (for debugging)
part = 2;

tank_size = 100;
hanger_height = 10;
hanger_width = 10;
hole_radius = 2;
screw_radius = 10;
screw_height = 10;
screw_turns = 3;
base_height = 10;
base_radius = screw_radius + 2;
tube_length = tank_size / 2 + 20;
tube_rise = 10;
tube_radius = 2;

thread_depth = 1;
tolerance = 0.4;
wall_width = 2 * tolerance;


// Screw threads
module threads(height, inner_radius, outer_radius, turns) {
    linear_extrude(height, twist = -turns * 360) {
        scale([1, outer_radius / inner_radius, 1]) circle(inner_radius);
    }
}

// Dodecahedron for the tank.
module dodecahedron(height) {
    // Dodecahedron model from the OpenSCAD User Manual
    // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Commented_Example_Projects
    scale([height, height, height]) {
        intersection() {
            cube([2, 2, 1], center = true);
            intersection_for(i = [0 : 4]) {
                rotate([0, 0, 72*i]) {
                    rotate([116.565, 0, 0]) {
                        cube([2, 2, 1], center = true);
                    }
                }
            }
        }
    }
}

module tank() {
    // Hanger.
    translate([0, 0, -hanger_height / 2]) {
        rotate([90, 0, 0]) {
            rotate_extrude(angle = 90) {
                translate([hanger_height / 2, 0]) circle(hanger_height / 2 - hole_radius, $fn = 40);
            }

        }
        translate([-hanger_width / 2, 0, 0]) {
            cylinder(hanger_height, hanger_height / 2 - hole_radius, hanger_height / 2 - hole_radius, $fn = 40);
        }
        translate([hanger_width / 2, 0, 0]) {
            cylinder(hanger_height, hanger_height / 2 - hole_radius, hanger_height / 2 - hole_radius, $fn = 40);
        }
    }
    
    // Tank part.
    translate([0, 0, tank_size / 2]) {
        difference() {
            dodecahedron(tank_size);
            dodecahedron(tank_size - wall_width * 2);
            cylinder(tank_size / 2, screw_radius, screw_radius);
        }
    }
    
    // Inner wall (mostly for structural support while printing)
    difference() {
        cylinder(tank_size, tank_size / 4, tank_size / 4);
        cylinder(tank_size, tank_size / 4 - wall_width, tank_size / 4 - wall_width);
    }
    
    // Screw for attaching to the base.
    translate([0, 0, tank_size - screw_height]) {
        difference() {
            cylinder(screw_height, screw_radius + 4 * thread_depth, screw_radius + 4 * thread_depth);
            threads(
                screw_height,
                screw_radius - thread_depth + tolerance,
                screw_radius + tolerance,
                screw_turns
            );
        }
    }
}

module feeding_tubes(outside) {
    inner_radius = outside ? tube_radius : (tube_radius - wall_width);
    translate([0, 0, tube_radius * sin(360 / 6)]) {
        for(i = [0 : 4]) {
            rotate([90, 0, i * 360 / 5]) {
                cylinder(tube_length, inner_radius, inner_radius, $fn = 6);
            }
            rotate([0, 0, i * 360 / 5 + 180 / 5]) {
                translate([0, tube_length - wall_width, 0]) {
                    translate([0, tolerance * 2, tolerance]) {
                        if(outside) sphere(inner_radius + tolerance, $fn = 6);
                    }
                    rotate([-45, 0, 0]) {
                        cylinder(tube_rise + (1 - outside), inner_radius, inner_radius, $fn = 6);
                    }
                }
            }
        }
    }
}

module base() {
    // Screw
    translate([0, 0, base_height]) {
        difference() {
            threads(screw_height, screw_radius - thread_depth, screw_radius, screw_turns);
            cylinder(screw_height, base_radius / 2, base_radius / 2);
        }
    }
    
    difference() {
        union() {
            // Feeding tubes
            feeding_tubes(1);
            
            // Base.
            cylinder(base_height, base_radius, base_radius);
        }

        // Base cutout.
        translate([0, 0, wall_width]) {
            cylinder(base_height - wall_width, base_radius / 2, base_radius / 2);
        }

        // Feeding tube cutouts.
        feeding_tubes(0);
    }
}

if (part == 0) tank();
if (part == 1) base();
if (part == 2) {
    translate([0, 0, base_height + tank_size]) {
        rotate([0, 180, 0]) tank();
    }
    base();
}
