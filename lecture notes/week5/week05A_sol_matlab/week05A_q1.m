% Revision problem: Week 5A, Question 1
% 
% Run the M/M/1 simulation with length

%%%% 
% If you want to reproduce the results that I give in the tutorial
% solution, you will need to use the setting of the random number 
% generator that I have used. The setting is stored in the file 
% week05A_q1_rand_setting in the variable rand_setting.  
% Comment out the following two lines if you want to use the setting I 
% used. 
load week05A_q1_rand_setting
rng(rand_setting) 
% 
% I used the following two lines to obtain the setting of the random number
% generator and saved it to the file week05A_q1_rand_setting so that I can
% reproduce the results later. I keep the code here to show you how you can
% save the setting.   
% rand_setting = rng;
% save week05A_q1_rand_setting rand_setting

% Define the simulation parameters 
lambda = 0.7;
mu = 1;

% A vector of time_end_array (simulation end time)
time_end_array = [1000 5000 10000 50000];

% Matrix response_time_matrix stores the results of the simulation
% 
% response_time_matrix is a 20-by-4 matrix
% Each column of response_time_matrix stores the simulation results 
% from using a value in time_end_array for simulation
% E.g. response_time_matrix(i,j) contains the simulation by using 
% the i-th value of time_end_array in the j-th replication
response_time_matrix = zeros(20,4);

% iteration 
    for j = 1:4
        for i = 1:20
            response_time_matrix(i,j) = sim_mm1_func(lambda,mu,time_end_array(j));
        end    
    end
  
% expected results from M/M/1 theory
response_time_mm1 = 1/(mu-lambda);

% For a given arrival rate, increase the simulation length
semilogx(time_end_array,response_time_matrix,'bo',time_end_array,response_time_mm1*ones(length(time_end_array),1),'r-','Linewidth',3,'Markersize',12);
xlabel('Length of simulation T')
ylabel('Response time')
title('Horizontal line - theoretical value; circles - simulated values')
% print -depsc week05A_q1_fig

% Mean over 20 replications for each value of T
mean(response_time_matrix)

% standard deviation
std(response_time_matrix)

% save week05A_q1_data
