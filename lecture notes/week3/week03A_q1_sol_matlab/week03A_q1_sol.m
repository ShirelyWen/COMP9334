%% COMP9334, Revision problem Week 3B, Question 2 
% 

%% Solution 

% Use a range of arrival rate 
vec_lambda = 0.1:0.1:9.0;
len_vec_lambda = length(vec_lambda);

% The service rate 
mu = 1/0.1;

% Create zero arrays to store the results of response time calculation
T_mm1 = zeros(len_vec_lambda,1);
T_CPU2times = zeros(len_vec_lambda,1); 
T_2queues = zeros(len_vec_lambda,1);
T_1queue = zeros(len_vec_lambda,1);

% For each arrival rate, calculate the response time 
for i = 1:len_vec_lambda
    % M/M/1
    lambda = vec_lambda(i);
    T_mm1(i) = mm1(lambda,mu);
    %
    % Alternative 1 - a server 2 times faster
    T_CPU2times(i) = mm1(lambda,2*mu);
    %
    % Alternative 2 - Two servers, each with a queue
    T_2queues(i) = mm1(lambda/2,mu);
    %
    % Alternative 3 - Two servers, 1 queue
    T_1queue(i) = mmm(lambda,mu,2);
end

plot(vec_lambda,T_mm1,'-o',vec_lambda,T_CPU2times,'-x', ...
     vec_lambda,T_2queues,'-d',vec_lambda,T_1queue,'-h','Linewidth',3)
legend('Original system','CPU - 2 times faster', ...
    'Two servers, 2 queues','Two servers, 1 queue', ...
    'Location','NorthWest')
xlabel('Arrival rate')
ylabel('Response time')
% print -dpng prob_q1 