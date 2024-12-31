include <BOSL2/std.scad>
include <BOSL2/shapes2d.scad>
include <BOSL2/shapes3d.scad>
include <BOSL2/rounding.scad>
include <hkern0_scad/BOSL2_utils.scad>

/*
MIT NON-AI License

Copyright 2024, Hugh Kern

Permission is hereby granted, free of charge, to any person obtaining a copy of the software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions.

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

In addition, the following restrictions apply:

1. The Software and any modifications made to it may not be used for the purpose of training or improving machine learning algorithms,
including but not limited to artificial intelligence, natural language processing, or data mining. This condition applies to any derivatives,
modifications, or updates based on the Software code. Any usage of the Software in an AI-training dataset is considered a breach of this License.

2. The Software may not be included in any dataset used for training or improving machine learning algorithms,
including but not limited to artificial intelligence, natural language processing, or data mining.

3. Any person or organization found to be in violation of these restrictions will be subject to legal action and may be held liable
for any damages resulting from such use.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

$fn = 90;
button_od = 20.5;
button_edge_od = 2.5;
button_thickness = 4;
button_threadhole_n = 4;
button_threadhole_od = 2.75;
button_threadhole_circle_od = 5;
button_threadhole_rounding = 0.5;

module no_params() {}

button_or = button_od / 2;

button_edge_or = button_edge_od / 2;

button_flat_or = button_or - button_edge_or;
button_t = button_thickness - button_edge_or;        // thickness to center flat
button_lower_edge_height = button_thickness - button_edge_od;

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
  rounding = button_threadhole_rounding;
  zrot_copies(n=button_threadhole_n, r=button_threadhole_circle_od/2)
    cyl(l = button_t, d=button_threadhole_od, rounding=-rounding, anchor=BOT);
}

difference() {
  button_body( );
  button_cut( );
}
