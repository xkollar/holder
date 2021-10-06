loop = $preview ? pow(0.5*(cos($t*360)+1),2) : 1;
$fn = $preview ? 60 : 200;
debug=false;

pi=180;

// $vpr=[-loop*pi*0.1,loop*pi,loop*pi*0.1];


inch_in_cm = 2.54;

module round_in(r=1) {
    offset(r=-r) offset(delta=r) children();
}

module round_out(r=1) {
    offset(r=r) offset(r=-r/2) children();
}

// Caluclae point on bezier curve given by points
function bezier_pt(points, t) = let
    (l = len(points))
    l < 2
    ? points[0]
    : bezier_pt([for (i = [0:l-2]) (points[i+1]-points[i])*t+points[i]],t);

// Generic bezier
function gbezier(points, degree=3, steps=$fn) =
    [for (pt = [0:degree:len(points)-degree-1])
        each [for (i = [0:1:steps])
           bezier_pt([for (j=[pt:pt+degree]) points[j]],i/steps)
        ]
    ];

function bezier(points, steps=$fn) =
    [for (pt = [0:3:len(points)-4])
        each [for (i = [0:1:steps])
           let (
                t = i/steps,
                p0 = points[pt],
                p1 = points[pt+1],
                p2 = points[pt+2],
                p3 = points[pt+3],
                p01 = (p1-p0)*t+p0,
                p12 = (p2-p1)*t+p1,
                p23 = (p3-p2)*t+p2,
                p012 = (p12-p01)*t+p01,
                p123 = (p23-p12)*t+p12,
                p0123 = (p123-p012)*t+p012
           )
           p0123]
    ];


module bezier(points, extra=[], steps=$fn) {
    polygon(concat(gbezier(points, steps=steps), extra));
}

module bo(d=1.25, l=72) {
    cylinder(l, d=d, center=true);
}

module hanbo(d=1.18, l=35) {
    cylinder(l, d=d, center=true);
}

module bokken() {
    module base() {
        hull() {
            circle(d=1);
            translate([0,0.5]) circle(d=1);
        }
    }

    module tsuka() {
        translate([0,0,-10]) linear_extrude(10) base();
    }

    module blade() {
        module profile() {
            linear_extrude(0.000001) intersection() {
                base();
                hull() {
                    circle(d=1);
                    polygon([[0.5,0],[0.5,0.4],[0.05,1],[-0.05,1],[-0.5,0.4],[-0.5,0]]);
                }
            }
        }
        s = bezier([[0,0,0],[0,0,5],[0,0,15],[0,1,30]]);
        for (i = [1:$fn])
        hull()
        {
            translate(s[i-1]) profile();
            translate(s[i]) profile();
        }
    }

    tsuka();
    blade();
}

module holder() {
    linear_extrude(0.5, center=true)
    scale(0.22) difference() {
        bezier([
            [5,0],[5,2.5],[2.5,2.5],[2.5,5],
            [2.5,7.5],[5,10],[5,12.5],
            [5,15],[3,15],[3,12.5],
            [3,10],[-3,10],[-3,12.5],
            [-3,15],[-5,15],[-5,12.5],
            [-5,10],[-2.5,7.5],[-2.5,5],
            [-2.5,2.5],[-5,2.5],[-5,0]
        ], [[0,0]]);
        circle(2);
        translate([0,7.7])
        circle(2);
    }
}

module scene() {
    if ($preview) {
        elevation = 2.95+loop;
        i = 2;
        // translate([i==0 ? 0 : 05,elevation,0]) color("red") bo();
        // translate([i==1 ? 0 : 10,elevation,0]) color("green") hanbo();
        translate([i==2 ? 0 : 15,elevation,-10]) rotate([1.1,0,0]) color("yellow") bokken();
        translate ([0,0,-3]) holder();
        % translate ([0,0,3]) holder();
    } else {
        holder();
    }
}

scale(inch_in_cm) scene();
