include <BOSL2/std.scad>
include <BOSL2/shapes2d.scad>
include <BOSL2/shapes3d.scad>
include <BOSL2/rounding.scad>
include <hkern0_scad/BOSL2_utils.scad>

$fn = 90;

module no_params() {}

button_od = 20.5;
button_or = button_od / 2;

button_edge_od = 2.5;
button_edge_or = button_edge_od / 2;

button_flat_or = button_or - button_edge_or;
button_thickness = 4;
button_t = button_thickness - button_edge_or;        // thickness to center flat
button_lower_edge_height = button_thickness - button_edge_od;
echo(button_t, button_edge_or);
threadhole_od = 2.75;

module button_body() {
  outline = [
      [                               0,                  button_t,      ], //      ],
      [ button_flat_or-button_edge_od/3,                  button_t,      ], //     0 ],
      [                  button_flat_or, button_t + button_edge_or,     button_edge_or/2 ],
      [                       button_or, button_t + button_edge_or,     button_edge_or/2 ],
      [                       button_or, button_lower_edge_height,      button_edge_or ],
      [ button_or - button_lower_edge_height,                         0,      ], //     button_od ],
      [                               0,                         0,      ], //      ],
    ];

  rotate_extrude()
    rounded_polygon(outline);
}

module button_cut() {
  rounding = 0.5;
  zrot_copies(n=4, r=2.5)
  cyl(l = button_t, d=threadhole_od, rounding=-rounding, anchor=BOT);
}

difference() {
  button_body( );
  button_cut( );
}
