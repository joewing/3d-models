// Screw with nut
// Joe Wingbermuehle
// 2018-05-06

screw_length = 15;
nut_length = 5;
screw_radius = 4;
nut_radius = 7;
turns = 4;
thread_depth = 1;
tolerance = 0.4;

$fn = 50;

module threads(height, inner_radius, outer_radius, turns) {
    linear_extrude(height, twist = -turns * 360) {
        scale([1, outer_radius / inner_radius, 1]) circle(inner_radius);
    }
}

module screw() {
    cylinder(nut_length, nut_radius, nut_radius);
    threads(screw_length, screw_radius - thread_depth, screw_radius, turns);
}

module nut() {
    difference() {
        cylinder(nut_length, nut_radius, nut_radius);
        threads(
            nut_length,
            screw_radius - thread_depth + tolerance,
            screw_radius + tolerance,
            turns * nut_length / screw_length
        );
    }
}

screw();
translate([nut_radius * 3, 0, 0]) nut();
