// Self-watering planter
// Joe Wingbermuehle
// 2018-04-19

render_inside = 0;          // Render inside (1) or outside (0).

wall_width = 1.6;           // Width of walls
radius = 50;                // Radius of the pot
filler_radius = 12;         // Radius of the filler hole
hole_radius = 1;            // Radius of the holes in the inner pot
outside_height = 100;       // Height of the outer pot
lip_height = 10;            // Amount the inner pot sticks over the outer pot.
pot_height = 20;            // Depth of the pot before it starts bending in
sides = 6;                  // Number of sides (3 or more)
tolerance = 0.8;            // Tolerance between pots

inside_height = outside_height + lip_height - wall_width - tolerance;
inside_radius = radius - wall_width - tolerance;
bottom_radius = inside_radius / 3;

// Draw the filler (used with the outside part).
module filler() {
    translate([radius - filler_radius, 0, 0]) {
        difference() {
            cylinder(outside_height + lip_height, filler_radius, filler_radius, $fn = sides);
            translate([0, 0, wall_width]) {
                cylinder(
                    outside_height + lip_height,
                    filler_radius - wall_width,
                    filler_radius - wall_width,
                    $fn = sides
                );
            }
            side_length = 2 * filler_radius * sin(180 / sides);
            translate([0, 0, side_length / 2]) {
                rotate([0, 90, 0]) {
                    for(i = [0 : sides - 1]) {
                        rotate([i * 360 / sides + 180 / sides, 0, 0]) {
                            cylinder(filler_radius, side_length / 2 - wall_width / 2, side_length / 2 - wall_width / 2);
                        }
                    }
                }
            }
        }
    }
}

// Draw the outside.
module outside() {
    difference() {
        cylinder(outside_height, radius, radius, $fn = sides);
        translate([0, 0, wall_width]) {
            cylinder(outside_height, radius - wall_width, radius - wall_width, $fn = sides);
        }
    }
    filler();
}

// Draw the shape for the inner pot.
module pot_solid(top_size, bottom_size) {
    // Top part
    translate([0, 0, inside_height - pot_height]) {
        cylinder(pot_height, top_size, top_size, $fn = sides);
    }
    
    // Bottom part.
    cylinder(inside_height - pot_height, bottom_size, top_size, $fn = sides);
}

// Draw the inner pot.
module inside() {
    difference() {
        union() {
            // The pot outline
            difference() {
                pot_solid(inside_radius, bottom_radius);
                pot_solid(inside_radius - wall_width, bottom_radius - wall_width);
            }
            
            // The bottom.
            cylinder(wall_width, bottom_radius, bottom_radius, $fn = sides);
            
            // Filler border.
            intersection() {
                translate([radius - filler_radius, 0, 0]) {
                    cylinder(
                        inside_height,
                        filler_radius + wall_width + tolerance,
                        filler_radius + wall_width + tolerance,
                        $fn = sides
                    );
                }
                pot_solid(inside_radius, bottom_radius);
            }
        }
        
        // Filler cutout.
        translate([radius - filler_radius, 0, 0]) {
            cylinder(inside_height, filler_radius + tolerance, filler_radius + tolerance, $fn = sides);
        }
        
        // Holes.
        for(z = [0 : 3]) {
            translate([0, 0, wall_width * 2 + z * wall_width * 4]) {
                rotate([0, 90, 0]) {
                    for(i = [0 : sides]) {
                        rotate([i * 360 / sides + 180 / sides, 0, 0]) {
                            cylinder(2 * radius, hole_radius, hole_radius);
                        }
                    }
                }
            }
        }
    }
}

if(render_inside)
    translate([0, 0, wall_width + tolerance]) inside();
else
    outside();