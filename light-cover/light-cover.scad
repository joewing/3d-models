
radius = 80;
wall_width = 1.2;
lip_radius1 = 50;
lip_radius2 = 55;
lip_height = 10;
lip_width = 5;

module dodecahedron(height) {
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
rotate([0, 180, 0]) {
    translate([0, 0, -radius]) {
        difference() {
            cylinder(radius * 2, lip_radius1 - lip_width + wall_width, lip_radius1 - lip_width + wall_width);
            cylinder(radius * 2, lip_radius1 - lip_width, lip_radius1 - lip_width);
        }
    }
    difference() {
        dodecahedron(radius * 2);
        dodecahedron(radius * 2 - wall_width * 2);
        translate([0, 0, -radius]) {
            cylinder(wall_width * 2, lip_radius1 - wall_width, lip_radius1 - wall_width);
        }
    }
    translate([0, 0, -radius - lip_height]) {
        difference() {
            cylinder(lip_height, lip_radius2, lip_radius1);
            cylinder(lip_height, lip_radius2 - lip_width, lip_radius1 - lip_width);
        }
    }
}