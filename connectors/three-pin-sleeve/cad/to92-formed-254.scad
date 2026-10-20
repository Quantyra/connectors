/* TO-92 formed-tail three-channel sleeve, millimetres.
   Copyright Daniel Eric Fredriksen / Quantyra.
   SPDX-License-Identifier: CERN-OHL-S-2.0
   Source Location: https://github.com/Quantyra/connectors
   UNTESTED PROTOTYPE. Not for native 1.27 mm lead pitch.
   Form leads separately to 2.54 mm pitch; see ../README.md. */

view = "print"; // print, assembly, cutaway, check_body, check_leads, check_males, check_collars, check_component
package_kind = "TO92";
pitch = 2.54;
length = 6.20;
bore_width = 1.02;
contact_height = 1.26;
mouth_ease = 0.20; // per wall
wall = 0.80;
guide_floor = 0.26; // below the 0.30 mm minimum illustrated lead thickness
component_flare_end = 0.80;
guide_start = 5.20;
guide_crest = 5.80;

// Inspection pose only: does not resize the printable body.
lead_width = 0.50;
lead_thickness = 0.50;
lead_insertion = 4.50; // bounded use: 4.00 to 5.00

include <three-channel-common.scad>
