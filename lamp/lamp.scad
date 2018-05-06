// Dodecahedron Lamp
// Joe Wingbermuehle
// 2018-05-06

// Which part to render:
//  0 - base
//  1 - shade
//  2 - both (for debugging)
part = 1;

bottom_radius = 200 / 2;
stem_radius = 24 / 2;
bottom_height = 10;
base_height = 200;
cord_radius = 5;
socket_radius = 20 / 2;
socket_height = 40;
screw_height = 10;
screw_turns = 2;
thread_depth = 1;
tolerance = 0.4;

top_size = 150;
wall_width = tolerance * 2;

$fn = 50;

// Screw threads
module threads(height, inner_radius, outer_radius, turns) {
    linear_extrude(height, twist = -turns * 360) {
        scale([1, outer_radius / inner_radius, 1]) circle(inner_radius);
    }
}

// Dodecahedron for the shade.
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

// Base of the lamp.
module base() {
    difference() {
        union() {
            cylinder(bottom_height, bottom_radius, bottom_radius, $fn = 5);
            translate([0, 0, bottom_height]) {
                cylinder(base_height - bottom_height - screw_height, stem_radius, stem_radius);
            }
            translate([0, 0, base_height - screw_height]) {
                threads(screw_height, stem_radius - thread_depth, stem_radius, screw_turns);
            }
        }
        translate([0, 0, cord_radius * 3 / 4]) {
            rotate([90, 0, -90 / 5]) cylinder(bottom_radius, cord_radius, cord_radius);
        }
        cylinder(base_height, cord_radius, cord_radius);
        cylinder(bottom_height, socket_radius, cord_radius);
        translate([0, 0, base_height - socket_height]) {
            cylinder(socket_height, socket_radius, socket_radius);
        }
    }
}

// Lamp shade.
module shade() {
    translate([0, 0, top_size / 2]) {
        difference() {
            dodecahedron(top_size);
            dodecahedron(top_size - wall_width * 2);
            cylinder(top_size / 2, stem_radius, stem_radius);
        }
    }
    difference() {
        cylinder(top_size, top_size / 4, top_size / 4);
        cylinder(top_size, top_size / 4 - wall_width, top_size / 4 - wall_width);
    }
    translate([0, 0, top_size]) {
        difference() {
            cylinder(screw_height, stem_radius + 4 * thread_depth, stem_radius + 4 * thread_depth);
            threads(
                screw_height,
                stem_radius - thread_depth + tolerance,
                stem_radius + tolerance,
                screw_turns
            );
        }
    }
}

if (part == 0) base();
if (part == 1) shade();
if (part == 2) {
    base();
    translate([0, 0, base_height + top_size]) {
        rotate([0, 180, 0]) shade();
    }
}
