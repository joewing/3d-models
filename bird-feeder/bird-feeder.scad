// Simple Bird Feeder
// Joe Wingbermuehle
// 2018-03-13 <> 2018-04-28

// The part to print:
//  0 - Top
//  1 - Base
//  2 - Hopper
//  3 - Everything (for debugging)
part = 3;

// Size of the print area (used to make the feeder as big as possible):
print_width = 210;
print_height = 200;

sides = 6;                          // Number of sides (to change the shape).
tolerance = 0.2;                    // Tolerance for the pole
wall_width = 4 * tolerance;         // Width of walls

// Height parameters based off the print height.
top_height = 50;                    // Height of the roof
hanger_height = 10;                 // Height of the hanger (amount above the roof).
base_height = 25;                   // Height of the base
hopper_height = print_height - top_height - hanger_height - hanger_height / 2 - wall_width;

// Radius/width parameters based off the print width.
top_overhang_radius = 4;
base_radius = print_width / 2 - top_overhang_radius;          // Radius of the base area
hopper_radius = base_radius - 40;       // Radius of the hopper (leaves some room for the feed area)
pole_radius = 10;
perch_radius = 4;

// Drainage hole parameters.
hole_count = 8;         // Number of drainage holes in the base (will be limited to the number of sides)
hole_radius = 2;        // Radius of the drainage holes.

// The number of sides of various components.
hopper_sides = sides;
base_sides = sides;
top_sides = sides;

overhang = base_radius - hopper_radius;
roof_height_at_hopper = overhang * top_height / (base_radius - pole_radius);

module hopper() {
    difference() {
        // Outside
        cylinder(hopper_height, hopper_radius, hopper_radius, $fn = hopper_sides);
        
        // Inside cutout
        cylinder(hopper_height, hopper_radius - wall_width, hopper_radius - wall_width, $fn = hopper_sides);
        
        // Seed cutout.
        rotate([0, 0, 180 / hopper_sides]) {
            bottom_radius = hopper_radius * (1 + 0.5 / hopper_sides);
            cylinder(base_height * 0.75, bottom_radius, hopper_radius, $fn = hopper_sides);
        }
    }
}

module base() {

    // Seed area
    difference() {
        cylinder(base_height, base_radius, base_radius, $fn = base_sides);
        cylinder(base_height, base_radius - wall_width, base_radius - wall_width, $fn = base_sides);
    }
    
    // Bottom
    difference() {
        cylinder(wall_width, base_radius, base_radius, $fn = base_sides);
        for(i = [0 : min(sides, hole_count) - 1]) {
            angle_offset = 90;
            hole_offset = hopper_radius + (base_radius - hopper_radius) / 2;
            translate([
                sin(360 * i / min(sides, hole_count) + angle_offset) * hole_offset,
                cos(360 * i / min(sides, hole_count) + angle_offset) * hole_offset,
                0
            ]) {
                cylinder(wall_width, hole_radius, hole_radius);
            }
        }
    }
    
    // Perch
    face_length = 2 * base_radius * sin(180 / base_sides);
    for(i = [0 : base_sides - 1]) {
        angle_offset = 180 / base_sides;
        rotate([0, 0, 360 * i / base_sides + angle_offset]) {
            translate([base_radius * cos(180 / base_sides), 0, base_height]) {
                rotate([90, 0, 0]) {
                    translate([0, 0, -face_length / 2]) {
                        cylinder(face_length, perch_radius, perch_radius);
                        sphere(perch_radius);
                    }
                }
            }
        }
    }

    // Funnel
    cylinder(base_height, hopper_radius, 1, $fn = base_sides);
    
    // Pole
    cylinder(hopper_height + top_height, pole_radius, pole_radius, $fn = base_sides);
    translate([0, 0, hopper_height + top_height]) {
        cylinder(hanger_height / 2, pole_radius, pole_radius / 4, $fn = base_sides);
    }
    
    // Hanger
    translate([0, 0, hopper_height + top_height + hanger_height - hole_radius]) {
        translate([-pole_radius / 2, 0, -hanger_height]) {
            cylinder(hanger_height, pole_radius / 2 - hole_radius, pole_radius / 2 - hole_radius, $fn = 40);
        }
        translate([pole_radius / 2, 0, -hanger_height]) {
            cylinder(hanger_height, pole_radius / 2 - hole_radius, pole_radius / 2 - hole_radius, $fn = 40);
        }
        rotate([90, 0, 0]) {
            rotate_extrude(angle = 90, convexity = 10) {
                translate([pole_radius / 2, 0]) circle(pole_radius / 2 - hole_radius, $fn = 40);
            }
        }
    }
}

module top() {
    translate([0, 0, hopper_height + wall_width - wall_width * 4]) {
        difference() {
            cylinder(
                top_height,
                base_radius + top_overhang_radius,
                pole_radius,
                $fn = top_sides
            );
            cylinder(
                top_height,
                pole_radius + tolerance * 3,
                pole_radius + tolerance * 3,
                $fn = base_sides
            );
            difference() {
                cylinder(
                    wall_width * 4,
                    hopper_radius + wall_width * 5,
                    hopper_radius + wall_width * 5,
                    $fn = hopper_sides
                );
                cylinder(
                    wall_width * 4,
                    hopper_radius - wall_width * 5,
                    hopper_radius - wall_width * 5,
                    $fn = hopper_sides
                );
            }
        }
    }
}

if (part == 0 || part == 3) top();
if (part == 1 || part == 3) base();
if (part == 2 || part == 3) hopper();
