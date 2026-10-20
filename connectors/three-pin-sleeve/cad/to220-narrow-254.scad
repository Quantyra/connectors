/* TO-220 narrow-blade three-channel sleeve, millimetres.
   Copyright Daniel Eric Fredriksen / Quantyra.
   SPDX-License-Identifier: CERN-OHL-S-2.0
   Source Location: https://github.com/Quantyra/connectors
   UNTESTED PROTOTYPE. Narrow distal blades only; shoulders stay outside.
   Bounded CASE 221A-style geometry, not every TO-220 form. */

view = "print"; // print, assembly, cutaway, check_body, check_leads, check_males, check_collars, check_component
package_kind = "TO220";
pitch = 2.54;
length = 6.20;
bore_width = 1.34;
contact_height = 1.40;
mouth_ease = 0.20; // per wall
wall = 0.80;
guide_floor = 0.30; // below the 0.36 mm minimum illustrated blade thickness
component_flare_end = 0.80;
guide_start = 5.20;
guide_crest = 5.80;

// Inspection pose only: does not resize the printable body.
lead_width = 0.80;
lead_thickness = 0.49;
lead_insertion = 4.50; // bounded use: 4.00 to 5.00

include <three-channel-common.scad>
