loop = $preview ? pow(0.5*(cos($t*360)+1),2) : 1;
$fn = $preview ? 60 : 600;
debug=false;

pi=180;


$vpr=[-loop*pi*0.1,loop*pi,loop*pi*0.1];


inch_in_cm = 2.54;

module round_in(r=1) {
    offset(r=-r) offset(delta=r) children();
}

module round_out(r=1) {
    offset(r=r) offset(r=-r/2) children();
}

module bezier_one(p1,p2,p3,p4,extra=[],debug=debug) {
  polygon(concat([for (i = [0:1:$fn])
       let (
            x = i/$fn,
            p12 = (p2-p1)*x+p1,
            p23 = (p3-p2)*x+p2,
            p34 = (p4-p3)*x+p3,
            p123 = (p23-p12)*x+p12,
            p234 = (p34-p23)*x+p23,
            p1234 = (p234-p123)*x+p123)
       p1234], extra));
    if (debug) % polygon([p1,p2,p3,p4]);
}

module bezier(pts,extra=[]) {
    s = [for (pt = [0:3:len(pts)-4])
        each [for (i = [0:1:$fn])
           let (
                x = i/$fn,
                p1 = pts[pt],
                p2 = pts[pt+1],
                p3 = pts[pt+2],
                p4 = pts[pt+3],
                p12 = (p2-p1)*x+p1,
                p23 = (p3-p2)*x+p2,
                p34 = (p4-p3)*x+p3,
                p123 = (p23-p12)*x+p12,
                p234 = (p34-p23)*x+p23,
                p1234 = (p234-p123)*x+p123)
           p1234]];

    polygon(concat(s, extra));
}
    
scale(inch_in_cm)
% linear_extrude(1) {
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