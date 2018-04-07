
base_length = 100;
base_width = 1;
depth = 100;
side_height = 120;
side_width = 5;
triangle_height = 20;

cube([base_length, depth, base_width]);
cube([side_width, depth, side_height]);
difference() {
    translate([0, 0, triangle_height / 2]) {
        rotate([-90, 30, 0]) {
            cylinder(depth, triangle_height, triangle_height, $fn = 3);
        }
    }
    cube([base_length, depth, side_height]);
}