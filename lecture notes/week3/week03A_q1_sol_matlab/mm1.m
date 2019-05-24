function T = mm1(lambda,mu)
% This function calculates the response time T of an M/M/1 
% queue with 
% lambda = mean arrival rate  
% mu = mean service rate 
%
% Chun Tung Chou, UNSW
% 

T = 1 / (mu-lambda);