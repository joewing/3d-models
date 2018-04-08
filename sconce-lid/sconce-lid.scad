

top_width = 155;
inside_width = 145;
lip_width = 5;
top_height = 5;
height = 16;

union() {
    cube([top_width, top_width, top_height]);
    inside_offset = (top_width - inside_width) / 2;
    translate([inside_offset, inside_offset, top_height]) {
        difference() {
            cube([inside_width, inside_width, height - top_height]);
            translate([lip_width, lip_width, 0]) {
                cube([inside_width - lip_width * 2, inside_width - lip_width * 2, height - top_height]);
            }
        }
    }
}