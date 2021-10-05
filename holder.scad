loop = $preview ? pow(0.5*(cos($t*360)+1),2) : 1;
$fn = $preview ? 60 : 600;
debug=false;

pi=180;


//$vpr=[-loop*pi*0.1,loop*pi,loop*pi*0.1];


inch_in_cm = 2.54;

module round_in(r=1) {
    offset(r=-r) offset(delta=r) children();
}

module round_out(r=1) {
    offset(r=r) offset(r=-r/2) children();
}

// Caluclae point on bezier curve
function bezier_base(points, t) = let
    (l = len(points))
    l < 2
    ? points[0]
    : bezier_base([for (i = [0:l-2]) (points[i+1]-points[i])*t+points[i]],t);

// Generic bezier
function bezier_gen(points, degree=3, steps=$fn) =
    [for (pt = [0:degree:len(points)-degree-1])
        each [for (i = [0:1:steps])
           bezier_base([for (j=[pt:pt+degree]) points[j]],i/steps)
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
    polygon(concat(bezier_gen(points, 3, steps=steps), extra));
}

module bo() {
    translate([0,0,-36])
    cylinder(72, d=1.25);
}

module hanbo() {
    translate([0,0,-17.5])
    cylinder(35,d=1.18);
}

module bokken() {
    module base() {
        hull() {
            circle(d=1);
            translate([0,0.5]) circle(d=1);
        }
    }

    translate([0,0,-10]) linear_extrude(10) base();
    linear_extrude(30) intersection() {
        base();
        hull() {
            circle(d=1);
            polygon([[0.5,0],[0.5,0.6],[0.1,1],[-0.1,1],[-0.5,0.6],[-0.5,0]]);
        }
    }
}

scale(inch_in_cm)
linear_extrude(1, center=true) {
    difference() {
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
};
scale(inch_in_cm) {
    translate([0,10,0]) color("red") bo();
    translate([20,10,0]) color("green") hanbo();
    color("yellow") bokken();
}
