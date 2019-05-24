% Week 6A, Question 2

%% Part(a) To compute the 95% confidence interval

% vector of mean response time form the replications
mrt_vec = [4.56, 5.23, 5.12, 6.15, 5.57, 5.34];
num_replications = length(mrt_vec);

% mean and standard deviation
mean_mrt = mean(mrt_vec);
std_mrt = std(mrt_vec);

% 95% confidence interval => alpha = 0.05 
alpha1 = 0.05;

% multiplier for confidence interval
mf1 = tinv(1-alpha1/2,num_replications-1)/sqrt(num_replications);

% confidence interval
mean_mrt + [-1 1] * mf1 * std_mrt 

%% Part(b) To compute the 90% confidence interval

% 90% confidence interval => alpha = 0.1 
alpha2 = 0.1;

% multiplier for confidence interval
mf2 = tinv(1-alpha2/2,num_replications-1)/sqrt(num_replications);

% confidence interval
mean_mrt + [-1 1] * mf2 * std_mrt 

