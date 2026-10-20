/* Paired pin sleeve V2, millimetres.
   Copyright Daniel Eric Fredriksen / Quantyra.
   SPDX-License-Identifier: CERN-OHL-S-2.0
   Source Location: https://github.com/Quantyra/connectors
   Default export: one enclosed body, vertical bores, jumper end at Z=0.
   User-reported basic functional demonstration: yellow LED works and flashes.
   Colored pins/collars and cutaway removal are inspection views only. */
view = "print"; // print, assembly, cutaway, check_body, check_leds, check_males, check_collars
eps = 0.01;

length = 6.20;
pitch = 2.54;
bore_width = 1.02;
contact_height = 1.26; // 0.12 clearance above nominal touching 0.50+0.64 stack
mouth_ease = 0.20;    // per wall, not total width
wall = 0.80;
led_flare_end = 0.80;
guide_start = 5.20;   // 0.20 beyond the assumed maximum 5.00 straight LED tail
guide_crest = 5.80;
guide_floor = 0.40;   // continuous whole-floor ramp; no separate pressure element

// Inspection assumptions; these do NOT resize the printable body.
actual_led = [0.50, 0.50];
actual_male = [0.64, 0.64];
led_insertions = [4.00, 5.00];
male_exposed = 6.00;
tip_taper = 0.60;
tip_flat = 0.20;
collar_width = 2.54;
collar_length = 4.00; // display only; cross-section is also assumed
jumper_outward_offset = 0.10; // individual jumpers, not a fixed-pitch header
male_standoff = 0;
led_display_extension = 0.80; // identifies entry in images, NOT additional available tail

mouth_width = bore_width + 2*mouth_ease;
pair_width = pitch + mouth_width + 2*wall;
bottom = -mouth_ease-wall;
top = contact_height+mouth_ease+wall;
body_height = top-bottom;
function cy(i) = (i-0.5)*pitch;
function my(i) = cy(i)+(2*i-1)*jumper_outward_offset;

// Stations [axial X, width, lower Z, upper Z]. Each connecting face is a
// continuous planar taper. No transverse shoulder crosses the passage.
stations = [
    [0,             mouth_width, -mouth_ease, contact_height+mouth_ease],
    [led_flare_end,  bore_width,  0,           contact_height],
    [guide_start,    bore_width,  0,           contact_height],
    [guide_crest,    bore_width,  guide_floor, contact_height],
    [length,        mouth_width, guide_floor-mouth_ease, contact_height+mouth_ease]
];

assert(length > guide_crest && guide_crest > guide_start);
assert(guide_start > max(led_insertions));
assert(pitch-mouth_width >= 2*0.4);
assert(wall >= 2*0.4);
assert(contact_height > max([for(i=[0,1]) actual_led[i]+actual_male[i]]),
       "Inspection stack exceeds rigid clearance: do not assume wall flex");

module box(x0,x1,y0,y1,z0,z1) {
    translate([x0,y0,z0]) cube([x1-x0,y1-y0,z1-z0]);
}

module passage(i) {
    // One closed negative polyhedron. End caps lie OUTSIDE the body.
    ss = concat([[-eps, mouth_width, -mouth_ease, contact_height+mouth_ease]],
        stations, [[length+eps, mouth_width, guide_floor-mouth_ease, contact_height+mouth_ease]]);
    pts = [for(s=ss) each [
        [s[0],cy(i)-s[1]/2,s[2]], [s[0],cy(i)+s[1]/2,s[2]],
        [s[0],cy(i)+s[1]/2,s[3]], [s[0],cy(i)-s[1]/2,s[3]]]];
    n = len(ss);
    faces = concat([[3,2,1,0]],
        [for(j=[0:n-2], k=[0:3])
            [4*j+k,4*j+(k+1)%4,4*(j+1)+(k+1)%4,4*(j+1)+k]],
        [[4*(n-1),4*(n-1)+1,4*(n-1)+2,4*(n-1)+3]]);
    polyhedron(points=pts,faces=faces,convexity=10);
}

module sleeve() {
    difference() {
        box(0,length,-pair_width/2,pair_width/2,bottom,top);
        for(i=[0,1]) passage(i);
    }
}

module led(i) {
    box(-led_display_extension,led_insertions[i],cy(i)-actual_led[i]/2,cy(i)+actual_led[i]/2,0,actual_led[i]);
}
module male(i) {
    w = actual_male[i];
    a = length+male_standoff-male_exposed;
    h = actual_led[i]; // deliberately touching pose, NOT enforced by clearance bore
    box(a+tip_taper,length+male_standoff,my(i)-w/2,my(i)+w/2,h,h+w);
    polyhedron(points=[for(s=[[a,tip_flat],[a+tip_taper,w]]) each [
        [s[0],my(i)-s[1]/2,h+(w-s[1])/2], [s[0],my(i)+s[1]/2,h+(w-s[1])/2],
        [s[0],my(i)+s[1]/2,h+(w+s[1])/2], [s[0],my(i)-s[1]/2,h+(w+s[1])/2]]],
        faces=[[3,2,1,0],[0,1,5,4],[1,2,6,5],[2,3,7,6],[3,0,4,7],[4,5,6,7]]);
}
module collars() {
    for(i=[0,1]) box(length+male_standoff,length+male_standoff+collar_length,
        my(i)-collar_width/2,my(i)+collar_width/2,
        actual_led[i]+actual_male[i]/2-collar_width/2,
        actual_led[i]+actual_male[i]/2+collar_width/2);
}
module colored_proxies() {
    for(i=[0,1]) {
        color([1.0,0.58,0.02]) led(i);   // orange/gold: straight LED tails
        color([0.72,0.12,0.67]) male(i); // magenta: opposing male jumpers
    }
    color([0.24,0.26,0.29]) collars();
}
module print_orientation() {
    // [axial X,pitch Y,stack Z] -> [pitch X,stack Z-bottom,length-axial X]
    multmatrix([[0,1,0,0],[0,0,1,-bottom],[-1,0,0,length],[0,0,0,1]]) children();
}

if(view=="print") color([0.12,0.55,0.66]) print_orientation() sleeve();
else if(view=="assembly") {
    color([0.12,0.55,0.66]) sleeve();
    colored_proxies();
}
else if(view=="cutaway") {
    color([0.12,0.55,0.66]) render(convexity=10) difference() {
        sleeve();
        // Display-only longitudinal section through each pin pair.
        for(i=[0,1]) box(-eps,length+eps,i==0 ? -pair_width/2-eps : 0,cy(i),bottom-eps,top+eps);
    }
    colored_proxies();
}
else if(view=="check_body") sleeve();
else if(view=="check_leds") for(i=[0,1]) led(i);
else if(view=="check_males") for(i=[0,1]) male(i);
else if(view=="check_collars") collars();
else assert(false,"Unknown view");

echo(body=[pair_width,body_height,length], common_bore=[bore_width,contact_height],
     led_mouth=[mouth_width,contact_height+2*mouth_ease],
     male_mouth=[mouth_width,contact_height-guide_floor+2*mouth_ease],
     male_guide=[bore_width,contact_height-guide_floor],
     nose=length+male_standoff-male_exposed,
     full_section_overlap=[for(i=[0,1]) led_insertions[i]-(length+male_standoff-male_exposed+tip_taper)]);
