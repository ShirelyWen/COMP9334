function T = mmm(lambda,mu,m)
% This function calculates the response time T of an M/M/m 
% queue with 
% lambda = mean arrival rate  
% mu = mean service rate 
% m = number of servers
%
% Chun Tung Chou, UNSW
% 

% utilisation
rho = lambda/mu/m;

% form an array with (m rho)^k / k! for k = 1,...,m
x = zeros(m,1);
x(1) = m*rho;
for k = 2:m
    x(k) = x(k-1)*m*rho/k;
end

% The waiting time expression
C_num = x(m);
C_den = (1-rho)*(1+sum(x(1:m-1))) + x(m);
C = C_num/C_den;


T = (1/mu)*(1+ C/m/(1-rho)) ;