// Dual flush actuator replacement for Kohler Persuade K-4419 toilet
// Joe Wingbermuehle
// 2018-02-21

inner_radius = 44 / 2;
outer_radius = 48 / 2;
lip_radius = 56 / 2;
inside_length = 50;
outside_length = 5;
tolerance = 0.2;
bump_radius = 4;
bump_offset = 10 - 1;

small_size = 18;
large_size = inner_radius * 2 - small_size;
small_depth = 216 - inside_length;
large_depth = small_depth;
shaft_radius = 4;

$fn = 100;

module button_guide(size, height) {
   cube([size, size, height]);
}

module button(button_size, button_depth) {
    square_size = inner_radius * 2 + tolerance * 2;
    intersection() {
       difference() {
           cylinder(inside_length + outside_length, inner_radius - tolerance * 3, inner_radius - tolerance * 3);
           translate([button_size - square_size / 2 - tolerance, -square_size / 2, 0]) {
               cube([square_size, square_size, inside_length + outside_length]);
           }
       }
       sphere(inside_length + 9);
    }
    translate([-inner_radius - 1 + tolerance, -1 + tolerance, tolerance]) {
      button_guide(2 - 2 * tolerance, inside_length - 4);
    }
    translate([-inner_radius / 2, 0, inside_length - button_depth]) {
        cylinder(button_depth, shaft_radius, shaft_radius);
    }
}

module small_button() {
    button(small_size, small_depth);
}

module large_button() {
    button(large_size, large_depth);
}

module seal() {
    rotate_extrude() {
        translate([inner_radius - 0.5, 0]) {
            difference() {
                circle(bump_radius);
                circle(bump_radius - 1);
                translate([0, -bump_radius]) {
                    circle(bump_radius);
                }
            }
        }
    }
}

module outside() {
    // Bottom
    difference() {
        union() {
        cylinder(inside_length, outer_radius, outer_radius);
            translate([0, 0, inside_length - bump_offset - bump_radius]) {
                seal();
            }
        }

        cylinder(inside_length, inner_radius, inner_radius);

        // Button guide (small button)
        translate([-inner_radius - 1, -1, 0]) {
            button_guide(2, inside_length);
        }

        // Button guide (large button)
        mirror([1, 0, 0]) {
            translate([-inner_radius - 1, -1, 0]) {
                button_guide(2, inside_length);
            }
        }
    }

    
    // Lip
    translate([0, 0, inside_length]) {
        difference() {
            cylinder(outside_length, lip_radius, lip_radius);
            cylinder(outside_length, inner_radius, inner_radius);
        }
    }
}

outside();
small_button();
mirror([1, 0, 0]) {
    large_button();
}
