//-- Parametric Spool Hub with 608zz bearing
//-- remixed from thing #545954 by mateddy (James Lee)
//-- redesigned from thing #27139 by QuantumConcepts (Josh McCullough)
//-- and also based on a brilliant design by Sylvain Rochette (labidus),
//-- Thingiverse thing #596838.
//-- AndrewBCN - Barcelona, Spain - December 2014
//-- GPLV3


// Parameters

// Spool Hole Diameter
spool_hole_diam = 52; // [40.0:60.0]
// Internal Spool Thickness
spool_wall_thickness=9; // [5.0:12.0]

br = (15/2)+0.2; // bearing radius with tolerance for insertion
bh = 24;     // bearing height
ir = (8.6/2);  // threaded rod radius + ample tolerance

/* [Hidden] */
//-- the rest are not adjustable

h = 10; // height of the walls
h_base = 3; // height of base

t = 4; 
e = 0.02; 
mc = 0.1; // manifold correction
cw = 3; // core wall thickness

$fn = 64;

// Modules

module cutouts() {
  // make four cutouts (yes, I know I should use a for loop)
    max_h = h + h_base*2 + mc*2;  
    for(i=[0:7])
        rotate([0, 0, 45 * i])
            translate([0, 50+br+t+2, max_h/2-mc])
                cube([5, 100, max_h], center=true);  
}

module new_hub() {
    difference () {
        union() {
            // base
            difference() {
                cylinder(r=spool_hole_diam/2 + 4, h=h_base);
                // space for bearing
                translate([0,0,-e]) cylinder(r=br+e, h=h+e);
                cutouts();
            }
      
            // core which holds 608ZZ bearing
            translate([0, 0, bh/2])
                hub_core(bh, br/4);

            // wall
            difference() {
                cylinder(r=spool_hole_diam/2, h=h+h_base*2, $fn=100);
                translate([0,0,-e])
                    cylinder(r=spool_hole_diam/2-2, h=h+h_base*2+mc);
                cutouts();
            }
            
            // torus-shaped ridge using rotate_extrude, yeah!!
            difference() {
                translate([0,0,h+h_base*2-1.7])
                    rotate_extrude(convexity = 10, $fn=64)
                        translate([spool_hole_diam/2-0.7, 0, 0])
                            circle(r = 1.7, $fn=64);
                translate([0,0,-e])
                    cylinder(r=spool_hole_diam/2-2, h=6+spool_wall_thickness+1);
                cutouts();
            }
            
            // torus-shaped reinforcement
            difference() {
                translate([0,0,3.4])
                    rotate_extrude(convexity = 10, $fn=64)
                        translate([br+4.3, 0, 0])
                            circle(r = 2, $fn=16);
                cutouts();
            }

            // another torus-shaped reinforcement
            difference() {
                translate([0,0,3.4])
                    rotate_extrude(convexity = 10, $fn=64)
                        translate([spool_hole_diam/2-2.1, 0, 0])
                            circle(r = 2, $fn=16);
                cutouts();
            }
            
        }        
        // extra hole at 12 o'clock position
        translate ([0,spool_hole_diam/2+3.9, -mc]) cylinder(r=5.8, h=h+h_base*2+mc*2);
    }
}

module hub_core(h, cap_h=br) {
    difference() {
        union() {
            difference() {
                cylinder(r=br+cw, h=h, center=true);
                cylinder(r=br, h=h+mc, center=true);
            }                
            translate([0, 0, cap_h/2+h/2]) difference() {
                cylinder(r1=br+cw, r2=ir, h=cap_h, center=true);
                cylinder(r1=br, r2=0, h=cap_h, center=true);
            }
        }
        // center hole
        translate([0, 0, h]) cylinder(r=ir, h=br+h, center=true);
        // cut rough edge
        translate([0, 0, h/2+br-0.5]) cube([10*ir, 10*ir, 1], center=true);        
    }
}

// Print the part
new_hub();
