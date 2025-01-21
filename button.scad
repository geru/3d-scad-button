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

generate = "default"; // [ default:single, all:all ]

od = 20.25;
thickness = 3.75;
edge_od = 2.25;
margin = 0.25;
threadhole_n = 4;
threadhole_od = 1.75;
threadhole_circle_d = 4.75;

module custom_stopper() {}

IDX_NAME =      0;
IDX_OD =        1;
IDX_THICKNESS = 2;
IDX_EDGE_OD =   3;
IDX_MARGIN =    4;
IDX_TH_N =      5;
IDX_TH_OD =     6;
IDX_TH_CIR_D =  7;
params_data = (generate == "default")
  ? [ [["Default", od, thickness, edge_od, margin, threadhole_n, threadhole_od, threadhole_circle_d],
      ],]
  : models();


module non_custom() {}

module button( od=od, thickness=thickness, edge_od=edge_od, margin=margin, threadhole_n=threadhole_n, threadhole_od=threadhole_od, threadhole_circle_d=threadhole_circle_d ) {
  if( generate == "default" ) {
    output_string = str( "\n[ \"", od, "-", thickness, "-", edge_od, "-", margin, "-", threadhole_n, ":", threadhole_od, ":", threadhole_circle_d, "\", ",
od, ", ", thickness, ", ", edge_od, ", ", margin, ", ", threadhole_n, ", ", threadhole_od, ", ", threadhole_circle_d, " ],\n");
    echo(output_string);
  }
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
      button( params[i][IDX_OD],
              params[i][IDX_THICKNESS],
              params[i][IDX_EDGE_OD],
              params[i][IDX_MARGIN],
              params[i][IDX_TH_N],
              params[i][IDX_TH_OD],
              params[i][IDX_TH_CIR_D] );
}

if( generate == "default" ) {
  button();
} else {
  for ( i=[0 : len( params_data ) - 1] )
  button_set( params_data[i], i * (25) );
}
