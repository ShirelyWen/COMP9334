set NODES; #set of nodes
set EDGES within {i1 in NODES,i2 in NODES: i1 <> i2}; #set of edges
set FLOWS; #set of flows

param sd {k in FLOWS, i in NODES};
param c {(i,j) in EDGES}; 
param f {k in FLOWS}; # flow rate
param b {(i,j) in EDGES}; # link capacity 
var x {(i,j) in EDGES,k in FLOWS} binary; 

minimize totalcost: sum  {(i,j) in EDGES,k in FLOWS} c[i,j] * x[i,j,k];

# flow conservation constraints 
subject to flow_balance {i in NODES, k in FLOWS}: sum {(i,j) in EDGES} 
x[i,j,k] - sum{(j,i) in EDGES} x[j,i,k] = sd[k,i];
subject to link_capacity {(i,j) in EDGES}: 
sum {k in FLOWS} f[k] * x[i,j,k] <= b[i,j];





