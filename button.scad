include <BOSL2/std.scad>
include <BOSL2/shapes2d.scad>
include <BOSL2/shapes3d.scad>
include <BOSL2/rounding.scad>
include <hkern0_scad/BOSL2_utils.scad>
include <./models.scad>
/*
MIT NON-AI License

Copyright 2024-2025, Hugh Kern

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
IDX_NAME =      0;
IDX_OD =        1;
IDX_THICKNESS = 2;
IDX_EDGE_OD =   3;
IDX_MARGIN =    4;
IDX_TH_N =      5;
IDX_TH_OD =     6;
IDX_TH_CIR_D =  7;
params_data = [
[ [ "Default", 20.57, 3.2, 2.2, 0.5, 4, 2.0, 5 ],
  ],
[ [ "09-a",        9, 1.8, 0.7,   0, 3,  1.5, 2.9 ],
  [ "09-b", 9, 1.8, 0.7, 1, 3, 1.5, 2.9 ],
  [ "09-c", 9, 2.3, 1.1, 0.7, 3, 1.5, 3 ],
  [ "09-d", 9, 2, 0.3, 1.8, 3, 1.5, 2.8 ],
  [ "09-e", 9, 2.3, 1.1, 0.9, 3, 1.5, 3 ],
  [ "09-f", 9, 1.3, 0.6, 1.2, 3, 1.5, 3 ],
  [ "09-g", 9, 2.3, 1.7, 0.5, 3, 1.5, 2.5 ],
  [ "09-h", 9, 1.6, 1.1, 0.45, 2, 1.5, 3 ],
  [ "09-i", 9, 1.7, 0.5, 0.45, 4, 1.5, 3.5 ],
  [ "09-j", 9, 1.8, 1.5, 0.2, 3, 1.5, 3 ],
  [ "09-k", 9, 2.9, 1.5, 0.225, 3, 1.75, 3.3 ],
  ],
  ];


module non_custom() {}

module button( params ) {
  od = params[IDX_OD];
  thickness = params[IDX_THICKNESS];
  edge_od = params[IDX_EDGE_OD];
  margin = params[IDX_MARGIN];
  threadhole_n = params[IDX_TH_N];
  threadhole_od = params[IDX_TH_OD];
  threadhole_circle_d = params[IDX_TH_CIR_D];
  or = od / 2;
  edge_or=edge_od / 2;
  flat_or=or - edge_or - margin;
  t=thickness - edge_or;        // thickness to center flat
  lower_edge_height=thickness - edge_od;
  module body( ) {
    outline=[
        [0, t,],
        [flat_or - edge_od / 3, t,],
        [flat_or, t + edge_or, edge_or / 2],
        [or, t + edge_or, edge_or / 2],
        [or, lower_edge_height, edge_or],
        [or - lower_edge_height, 0,],
        [0, 0,],
      ];

    rotate_extrude( )
      rounded_polygon( outline );
  }
  module cut() {
    threadhole_rounding = 0.5;
    rounding = threadhole_rounding;
    zrot_copies(n=threadhole_n, r=threadhole_circle_d/2)
      cyl(l = t, d=threadhole_od, rounding=-rounding, anchor=BOT);
  }
  difference() {
    body();
    cut();
  }
}

module button_set( params, offset=0 ) {
  spacing = 5;
  for( i = [0 : len(params)-1] )
    translate([offset, i*(params[i][IDX_OD]+spacing), 0])
      button(params[i]);
}

for( i = [0 : len(params_data)-1] )
  button_set(params_data[i], i * (25));