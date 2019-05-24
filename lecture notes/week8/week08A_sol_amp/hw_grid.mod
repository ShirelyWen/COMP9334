set COMP;   #COMPANY
param cost {COMP};
param speed {COMP};
param setup {COMP};
param Tmax;
param P; 
var x {i in COMP} >= 0;
var y {i in COMP} binary; 
var T >= 0;
var C >= 0; 
minimize totalcost: C;
subject to T_Constraint {i in COMP}: T >= P * x[i] / speed[i];
subject to Tmax_constraint: T <= Tmax;
subject to cost_definition: C = sum {i in COMP} (P * cost[i] * x[i] / speed[i] + setup[i] * y[i]);
subject to complete: sum {i in COMP} x[i] = 1;
subject to restriction {i in COMP}: x[i] <= y[i];
