% Week 05A, Question 2
%
% Compare the response time of two queue configurations using simulation
%
% Configuration 1: M/M/1 with lambda = 0.9, mu = 1
% Configuration 2: M/M/2 with lambda = 0.9, mu = 0.5 for both servers
% 
% A simulation program for M/M/m queue has been written, we can use that to
% simulation both configurations
%

% Save the states of the random number generator for reproducibility
% rand_setting = rng;
% save week05A_q2_rand_setting rand_setting
% in order to reproduce exactly the random numbers, we will need to load
% the state first
load week05A_q2_rand_setting 
rng(rand_setting);

% simulation parameters
lambda = 0.9;
mu = 1;
time_end = 1000;

% Store the results in Tave
n = 10;
avg_response_time = zeros(n,2);

for i = 1:n
    avg_response_time(i,1) = sim_mm1_func(lambda,mu,time_end);
    avg_response_time(i,2) = sim_mmm_func(lambda,mu/2,2,time_end);
end 

% Compute the theoretical value
avg_response_time_theoretical_1 = mm1(lambda,mu);
avg_response_time_theoretical_2 = mmm(lambda,mu/2,2);

% Plot a graph on the results
plot(1:n,avg_response_time(:,1),'ro',1:n,avg_response_time(:,2),'bx',1:n,avg_response_time_theoretical_1*ones(n,1),'r-',1:n,avg_response_time_theoretical_2*ones(n,1),'b--','Linewidth',3,'Markersize',12);
axis([0 11 4 22])
legend('M/M/1 - simulation','M/M/2 - simulation','M/M/1 theoretical','M/M/2 theoretical','Location','Best');
xlabel('Experiment number')
ylabel('Mean response time')
%print -depsc week05A_q2_fig
%print -dpng week05A_q2_fig

% Find the number of times that the M/M/1 simulation result gives a smaller
% mean response time compared with M/M/2 simulation result
sum(avg_response_time(:,1) < avg_response_time(:,2))

% save week05A_q2_data
