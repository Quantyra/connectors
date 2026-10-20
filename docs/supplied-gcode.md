# Supplied G-code profile

The original attachment is included byte-for-byte under its original filename with the transport prefix removed. The filename identifies **Ender-3 V3 KE**, 0.4 mm nozzle and CR-PETG. Association with this connector rests on the filename and the user's successful connector report; the exact source slice is not cryptographically proven. KE and SE profiles are not claimed universally interchangeable. Review in a slicer and re-slice the exact STL for another printer; this package has not uploaded or executed the file.

Header findings: Marlin flavor, machine name F005, CR-PETG_1.75, 0.2 mm layers, two walls / 0.8 mm, outer/inner line widths 0.4/0.42 mm, 15% grid infill, support false, support time 0, skirt/brim time 0, 31 layers and estimated time 124.431 seconds. Infill time is also 0; configured density does not establish actual infill deposition in this small part. Raft settings in the header are configuration fields; no raft layer sequence was found.

Start commands wait for an 80 °C bed (`M190 S80`), set/wait for a 230 °C hotend (`M104`/`M109`), select absolute extrusion (`M82`), reset feed/flow, home (`G28`), reset extrusion and purge along X=-2/-1.7, Y=20–145 at Z=0.28. `M900 K0.050000` sets a firmware-dependent advance value. These temperatures are supplied-profile values. Object layers are indexed 0–30.

Positive-extrusion XY segment centerline bounds after the object mesh marker are **[[107.431, 108.581, 0.2], [112.569, 111.419, 6.2]]** (XYZ, mm). These are toolpath centerlines, not outside dimensions: extrusion width extends beyond them. The deposition layer heights are consistent with a 6.20 mm upright part at 0.20 mm layers; this supports dimensional consistency, not exact mesh-to-slice identity.

The header's MAXZ=20.101 and broad XY bounds include non-object travel; a travel to X=2.1, Y=2.142, Z=20.101 occurs before object deposition. Purge paths also lie away from the part. They do not make the model 20 mm tall. Parsed overall motion endpoint bounds are **[[-2.0, 0.0, 0.2], [175.0, 218.0, 20.101]]**; object deposition must be considered separately.

End commands retract, turn the bed off, move to X=170 Y=200 Z=6.5, disable the main fan and auxiliary fan (`M106 P2 S0`), switch to relative motion for retract/wipe/Z lifts, restore absolute motion, present at X=2 Y=218, turn heaters/fan off and disable X/Y/E steppers (`M84 X Y E`). The auxiliary fan and advance commands reinforce the need to check printer/firmware compatibility before use.
