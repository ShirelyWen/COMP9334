% Week 4, Tutorial Question
% To determine the factor by which the CPU must be sped up
% in order to reduce the response time to 0.65 minute per 
% transaction

% We use the code in cpu_speedup.m and put it in a for-loop 

% We will do this a range of values of k 
kv = 1:0.05:2;    % k from 1 to 2 with step size of 0.05 
nkv = length(kv);

% initialisatipn
system_throughput = zeros(nkv,1);
response_time = zeros(nkv,1);

% for each value of k
% we find the response time
for i = 1:nkv
    k = kv(i);


    % The steady state probability is the solution to
    % A x = b
    % where A and b are the following matrices
    % The elemens of x is 
    % x = [P(2,0,0) P(1,1,0) P(1,0,1) P(0,2,0) P(0,1,1) P(0,0,2)]
    % 
    A = [ 6*k     -4        -2   0   0   0
         -3*k  6*k+4         0  -4  -2   0
         -3*k      0     6*k+2   0  -4  -2
            0     -3*k       0   4   0   0
            0     -3*k    -3*k   0   6   0
            1        1       1   1   1   1];
    b = [0 0 0 0 0 1]';
    x = A\b;

    % The throughput in transactions per minute is
    % 6/k*(P(2,0,0)+P(1,1,0)+P(1,0,1))
    % =6/k*(x(1)+x(2)+x(3))
    system_throughput(i) = 6*k*(x(1)+x(2)+x(3));

    % The response time is
    response_time(i) = 2 / system_throughput(i);
end

% plot how response time varies with k
plot(kv,response_time)
xlabel('Speed up factor of CPU')
ylabel('response time (in minutes)')
grid
% print -dpng cpu_speedup_responsetime
