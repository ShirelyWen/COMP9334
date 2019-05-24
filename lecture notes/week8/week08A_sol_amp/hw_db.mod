set LOCATION;   #LOCATION
set DB; #DB
param dsize {LOCATION};
param time {LOCATION};
param fsize {DB};
param freq {DB};
var x {i in LOCATION,j in DB} binary;
var T >= 0;
minimize avtime: T;
subject to Texp : T = sum {i in LOCATION} (sum {j in DB} freq[j]*time[i]*x[i,j]);
subject to Dsize {i in LOCATION}: sum {j in DB} fsize[j] * x[i,j] <= dsize[i];
subject to SelectOne {j in DB}: sum {i in LOCATION} x[i,j] = 1; 


