set COMP;   #Set of resources
param c {COMP}; #Cost
param p {COMP}; #Speed
param s {COMP}; #Set up cost
param Tmax;
param Cmax;
param N; 
var x {i in COMP} >= 0;
var y {i in COMP} binary; 
var T >= 0;
minimize time: T;
subject to T_constraint {i in COMP}:
    T >= N * x[i] / p[i];
subject to Tmax_constraint: T <= Tmax;
subject to Cmax_constraint: sum {i in COMP}
    (N * c[i] * x[i] / p[i] + s[i] * y[i]) <= Cmax;
subject to x_sum: sum {i in COMP} x[i] = 1;
subject to restriction {i in COMP}: x[i] <= y[i];
