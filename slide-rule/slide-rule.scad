// Slide Rule
// Joe Wingbermuehle
// 2018-02-21

// Dimensions in mm
length = 150;               // Length of the slide rule
width = 5;                  // Width of the slide rule
height = 30;                // Height of the slide rule
tolerance = 0.25;           // Minimum tolerance (for spacing of the slider)
fontsize = 5;               // Font size
fontstyle = "Arial:Bold";   // Font
tick_width = 0.5;           // Width of a tick mark
tick_length0 = 2.5;         // Length of a tick with text
tick_length1 = 3;           // Length of a long tick
tick_length2 = 2;           // Length of a short tick
slider_width = 10;          // Size of the slider
font_depth = 0.5;           // How far the text/ticks sink into the rule.

// Render the wedge to hold the slider in place.
module cutout(w, d) {
    linear_extrude(length) {
       polygon(
         [
            [0, 0], [w, 0], [0, d]
         ]
       );
    }
}

// Render the slide with `spacing` clearance.
module slide(spacing) {
   curve_offset = 0.5;
    translate([0, 0, height / 3 + spacing]) {
        union() {
            cube([length, width - 1 - spacing, height / 3 - spacing * 2]);
            translate([0, width - 1 - spacing, curve_offset]) {
                rotate([0, 90, 0]) {
                    mirror([0, 1, 0]) {
                        cutout(width - 1 - spacing, width - 1 - spacing);
                    }
                }
            }
            translate([0, width - 1 - spacing, height / 3 - curve_offset - spacing]) {
                rotate([0, 90, 0]) {
                    mirror([1, 1, 0]) {
                        cutout(width - 1 - spacing * 2, width - 1 - spacing * 2);
                    }
                }
            }
        }
    }
}

// Ticks to display at each decade.
//               1  2  3  4  5  6  7  8  9 10
display_ticks = [1, 1, 1, 1, 1, 2, 2, 2, 2, 2 ]; 

// Render the indicators.
module indicators(yoffset, below, reversed) {
    tickz = below == 0 ? (fontsize) : (-fontsize);
    for(i = [1 : 10]) {
        rotate([90, 0, 0]) {
            xoffset_tt = tolerance + fontsize / 4 + tick_width + ((reversed == 0)
                ? log(i) * (length - fontsize)
                : (length - fontsize) - log(i) * (length - fontsize));
            translate([xoffset_tt, yoffset + tickz, -font_depth]) {
                cube([tick_width , fontsize / 2, font_depth]);
            }
            xoffset_text = tolerance + ((reversed == 0)
                ? log(i) * (length - fontsize)
                : (length - fontsize) - log(i) * (length - fontsize));
            translate([xoffset_text, yoffset - (below ? 2 : 0.5), -font_depth]) {
                linear_extrude(height = font_depth) {
                    text(str(i)[0], size = fontsize, font=fontstyle);
                }
            }
            if(i < 10) {
                for(j = [1 : 9]) {
                    if (j % display_ticks[i] == 0) {
                        subtick_length = j == 5 ? tick_length1 : tick_length2;
                        xoffset = tolerance + fontsize / 4 + tick_width + ((reversed == 0)
                            ? log(i + j / 10) * (length - fontsize)
                            : (length - fontsize) - log(i + j / 10) * (length - fontsize));
                        translate([xoffset, yoffset + tickz - (below ? 0 : subtick_length - tick_length0), -font_depth]) {
                            cube([tolerance * 2, subtick_length, font_depth]);
                        }
                    }
                }
            }
        }
    }
}

module slider() {
    difference() {
        cube([slider_width, width + 2, height + 2]);
        
        // Opening for rule
        translate([0, 1 - tolerance, 1 - tolerance]) {
            cube([slider_width, width + tolerance * 2, height + tolerance * 2]);
        }
        
        // Window
        translate([1, 0, 1]) {
            cube([slider_width - 2, width - 4, height]);
        }
    }
    
    // Top arrow.
    translate([slider_width / 2, 0, 1 - tolerance]) {
        rotate([270, 30, 0]) {
            cylinder(1 - tolerance * 2, 1, 1, $fn=3);
        }
    }
    
    // Bottom arrow.
    translate([slider_width / 2, 1 - 2 * tolerance, height + 1 + tolerance]) {
        rotate([90, -30, 0]) {
            cylinder(1 - tolerance * 2, 1, 1, $fn=3);
        }
    }
    
    // Line.
    translate([slider_width / 2 - tolerance, 0, tolerance]) {
        cube([tolerance * 2, 1 - tolerance * 2, height + 4 * tolerance]);
    }
}

module outside_text() {
     indicators(height * 1 / 3 - fontsize - 3 + tolerance, 0, 0);
     indicators(height * 2 / 3 + fontsize + tolerance, 1, 1);
}

module outside() {
    difference() {
        cube([length, width, height]);
        outside_text();
        slide(0);
    }
    
}

module inside_text() {
     indicators(height / 3 + fontsize, 1, 0);
}

module inside() {
    difference() {
        slide(tolerance);
        inside_text();
    }
}

//slider();
//outside();
//outside_text();
//inside();
//inside_text();
