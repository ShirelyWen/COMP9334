set NODES; #set of nodes
set EDGES within {i1 in NODES,i2 in NODES: i1 <> i2}; #set of edges
param cost {(i,j) in EDGES};
param delay {(i,j) in EDGES};
param remaining_bandwidth {(i,j) in EDGES};
param b := 2;
param delay_max := 8;
param sd {NODES};
var x1 {(i,j) in EDGES} binary; 
var x2 {(i,j) in EDGES} binary; 


minimize totalcost: sum  {(i,j) in EDGES} cost[i,j] * (x1[i,j] + x2[i,j]);
subject to flow_balance_1 {i in NODES}: sum {(i,j) in EDGES} x1[i,j] - sum{(j,i) in EDGES} x1[j,i] = sd[i];
subject to flow_balance_2 {i in NODES}: sum {(i,j) in EDGES} x2[i,j] - sum{(j,i) in EDGES} x2[j,i] = sd[i];
subject to delay_1: sum  {(i,j) in EDGES} delay[i,j] * x1[i,j] <= delay_max;
subject to delay_2: sum  {(i,j) in EDGES} delay[i,j] * x2[i,j] <= delay_max;
subject to capacity_limit {(i,j) in EDGES}: (x1[i,j]+x2[i,j]) * b <= remaining_bandwidth[i,j];
subject to exclusive_or {(i,j) in EDGES}: x1[i,j]+x2[i,j] <= 1;





