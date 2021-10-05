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

// Caluclae point on bezier curve given by points
function bezier_base(points, t) = let
    (l = len(points))
    l < 2
    ? points[0]
    : bezier_base([for (i = [0:l-2]) (points[i+1]-points[i])*t+points[i]],t);

// Generic bezier
function bezier(points, degree=3, steps=$fn) =
    [for (pt = [0:degree:len(points)-degree-1])
        each [for (i = [0:1:steps])
           bezier_base([for (j=[pt:pt+degree]) points[j]],i/steps)
        ]
    ];

module bezier(points, extra=[], steps=$fn) {
    polygon(concat(bezier(points, steps=steps), extra));
}

module bo(d=1.25, l=72) {
    cylinder(l, d=d, center=true);
}

module hanbo(d=1.18, l=35) {
    cylinder(35, d=1.18, center=true);
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

module holder() {
    linear_extrude(1, center=true)
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
}

module scene() {
    translate([0,10,0]) color("red") bo();
    translate([20,10,0]) color("green") hanbo();
    color("yellow") bokken();
    holder();
}

scale(inch_in_cm) scene();