/* Internal helper for the two three-channel prototypes; open a primary file.
   Copyright Daniel Eric Fredriksen / Quantyra.
   SPDX-License-Identifier: CERN-OHL-S-2.0
   Source Location: https://github.com/Quantyra/connectors
   Derived from the paired V2 direct-overlap arrangement. Original files unchanged.
   Display proxies and cutaway removals are NOT printable parts. */

eps = 0.01;
male_width = 0.64;
male_exposed = 6.00; // assumed usable exposed metal, including tip; measure actual jumper before use
tip_taper = 0.60;
tip_flat = 0.20;
male_standoff = 0;
collar_width = 2.54; // maximum assumed across pitch AND stack directions
collar_length = 4.00; // illustrative
outer_offset = 0.10; // center stays centered; independent outer jumpers shift out
rail_width = 1.20;
rail_height = 0.60;

mouth_width = bore_width + 2*mouth_ease;
body_width = 2*pitch + mouth_width + 2*wall;
bottom = -mouth_ease-wall;
top = contact_height+mouth_ease+wall;
function cy(i) = (i-1)*pitch; // neutral A, B, C; A adjacent to external rail
function my(i) = cy(i)+(i-1)*outer_offset;

// Axial X: component face = 0; jumper face = length.
// Stations [axial X, width across channels, floor, ceiling].
stations = [
    [0,                   mouth_width, -mouth_ease, contact_height+mouth_ease],
    [component_flare_end,  bore_width,  0,           contact_height],
    [guide_start,          bore_width,  0,           contact_height],
    [guide_crest,          bore_width,  guide_floor, contact_height],
    [length,              mouth_width, guide_floor-mouth_ease, contact_height+mouth_ease]
];

assert(length > guide_crest && guide_crest > guide_start);
assert(guide_start > 5.00 && lead_insertion >= 4 && lead_insertion <= 5);
assert(component_flare_end > 0 && component_flare_end < guide_start);
assert(pitch-mouth_width >= 0.8-0.00001 && wall >= 0.8);
assert(lead_thickness >= guide_floor && contact_height > lead_thickness+male_width);
assert(bore_width > max(lead_width, male_width+2*outer_offset));
assert(pitch+outer_offset >= collar_width+0.09);
assert(length+male_standoff-male_exposed >= 0.20-0.00001);
assert(rail_width <= mouth_width+2*wall);

module box(x0,x1,y0,y1,z0,z1) {
    translate([x0,y0,z0]) cube([x1-x0,y1-y0,z1-z0]);
}
module passage(i) {
    ss = concat([[-eps,mouth_width,-mouth_ease,contact_height+mouth_ease]],
                stations,
                [[length+eps,mouth_width,guide_floor-mouth_ease,contact_height+mouth_ease]]);
    pts = [for(s=ss) each [
        [s[0],cy(i)-s[1]/2,s[2]], [s[0],cy(i)+s[1]/2,s[2]],
        [s[0],cy(i)+s[1]/2,s[3]], [s[0],cy(i)-s[1]/2,s[3]]]];
    n = len(ss);
    faces = concat([[3,2,1,0]],
        [for(j=[0:n-2],k=[0:3])
            [4*j+k,4*j+(k+1)%4,4*(j+1)+(k+1)%4,4*(j+1)+k]],
        [[4*(n-1),4*(n-1)+1,4*(n-1)+2,4*(n-1)+3]]);
    polyhedron(points=pts,faces=faces,convexity=10);
}
module sleeve() {
    difference() {
        union() {
            box(0,length,-body_width/2,body_width/2,bottom,top);
            // Broad continuous external rail beside A. No thinning of any wall.
            box(0,length,cy(0)-rail_width/2,cy(0)+rail_width/2,
                bottom-rail_height,bottom+eps);
        }
        for(i=[0:2]) passage(i);
    }
}
module leads() {
    for(i=[0:2]) {
        if(package_kind=="TO92") {
            // Example only: body face at -7; first 3 mm straight;
            // spread over next 3 mm; last bend ends at -1.
            yc=(i-1)*1.27;
            box(-7,-4,yc-lead_width/2,yc+lead_width/2,0,lead_thickness);
            hull() {
                box(-4-eps,-4,yc-lead_width/2,yc+lead_width/2,0,lead_thickness);
                box(-1,-1+eps,cy(i)-lead_width/2,cy(i)+lead_width/2,0,lead_thickness);
            }
            box(-1,lead_insertion,cy(i)-lead_width/2,cy(i)+lead_width/2,0,lead_thickness);
        } else {
            // Nominal CASE 221A L=13.49, L1=3.45, shoulder b=1.34.
            face=lead_insertion-13.49;
            box(face,face+3.45,cy(i)-1.34/2,cy(i)+1.34/2,0,lead_thickness);
            box(face+3.45,lead_insertion,cy(i)-lead_width/2,cy(i)+lead_width/2,0,lead_thickness);
        }
    }
}
module component() {
    // Simplified envelope only; no electrical labels or fit claim from body shape.
    if(package_kind=="TO92")
        box(-11.83,-7,-2.60,2.60,-1.60,2.60);
    else {
        face=lead_insertion-13.49;
        box(face-10,face,-5.05,5.05,-2,2.45);
        box(face-15.12,face-10,-5.05,5.05,-2,-0.72);
    }
}
module male(i) {
    a=length+male_standoff-male_exposed;
    h=lead_thickness; // touching pose chosen by hand; NOT enforced by the cavity
    box(a+tip_taper,length+male_standoff,my(i)-male_width/2,my(i)+male_width/2,h,h+male_width);
    polyhedron(points=[for(s=[[a,tip_flat],[a+tip_taper,male_width]]) each [
        [s[0],my(i)-s[1]/2,h+(male_width-s[1])/2],
        [s[0],my(i)+s[1]/2,h+(male_width-s[1])/2],
        [s[0],my(i)+s[1]/2,h+(male_width+s[1])/2],
        [s[0],my(i)-s[1]/2,h+(male_width+s[1])/2]]],
        faces=[[3,2,1,0],[0,1,5,4],[1,2,6,5],[2,3,7,6],[3,0,4,7],[4,5,6,7]]);
}
module collars() {
    for(i=[0:2]) box(length+male_standoff,length+male_standoff+collar_length,
        my(i)-collar_width/2,my(i)+collar_width/2,
        lead_thickness+male_width/2-collar_width/2,
        lead_thickness+male_width/2+collar_width/2);
}
module proxies(show_component=true) {
    color([0.95,0.58,0.08]) leads();
    for(i=[0:2]) color([0.76,0.17,0.58]) male(i);
    color([0.25,0.27,0.30]) collars();
    if(show_component) color([0.15,0.17,0.20]) component();
}
module print_orientation() {
    // [axial,pitch,stack] -> [pitch,stack-bottom+rail_height,length-axial]
    multmatrix([[0,1,0,0],[0,0,1,rail_height-bottom],[-1,0,0,length],[0,0,0,1]]) children();
}
if(view=="print") color([0.12,0.55,0.66]) print_orientation() sleeve();
else if(view=="assembly") {
    color([0.12,0.55,0.66]) sleeve();
    proxies();
} else if(view=="cutaway") {
    color([0.12,0.55,0.66]) render(convexity=10) difference() {
        sleeve();
        // Remove upper shell only in this illustration, retaining all three floors/dividers.
        box(-eps,length+eps,-body_width,body_width,lead_thickness+0.10,top+eps);
    }
    intersection() {
        proxies(false);
        box(-0.8,length+4.1,-body_width,body_width,bottom-1,top+2);
    }
} else if(view=="check_body") sleeve();
else if(view=="check_leads") leads();
else if(view=="check_males") for(i=[0:2]) male(i);
else if(view=="check_collars") collars();
else if(view=="check_component") component();
else assert(false,"Unknown view");

echo(prototype=package_kind, status="untested prototype",
    print_bounds_size=[body_width,top-bottom+rail_height,length],
    shared_bore=[bore_width,contact_height], guide=[bore_width,contact_height-guide_floor],
    minimum_exterior_wall=wall, minimum_divider=pitch-mouth_width,
    collar_gap=pitch+outer_offset-collar_width,
    nose=length+male_standoff-male_exposed,
    full_section_overlap=lead_insertion-(length+male_standoff-male_exposed+tip_taper));
