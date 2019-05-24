set NODES; #set of nodes
set EDGES within {i1 in NODES,i2 in NODES: i1 <> i2}; #set of edges

param sd {i in NODES};
param cost {(i,j) in EDGES};
#var x {(i,j) in EDGES} binary; 
var x {(i,j) in EDGES} >= 0; 

minimize totalcost: sum  {(i,j) in EDGES} x[i,j] * cost[i,j];

# flow conservation constraints 
subject to flow_balance {i in NODES}: sum {(i,j) in EDGES} 
x[i,j] - sum{(j,i) in EDGES} x[j,i] = sd[i];
