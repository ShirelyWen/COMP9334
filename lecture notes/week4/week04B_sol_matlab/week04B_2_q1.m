% COMP9334 Revision Problems. Week 4B_2, Question 1
% 

% If you want to reproduce the graph in the solution, you will need to
% uncomment the two command lines so that the script uses the state of
% the random number generator stored in week04B_2_q1_rand_setting 
% Note: Reproducibility is discussed in Week 5A 
%
% Uncomment the following two lines to reproduce the results 
% load week04B_2_q1_rand_setting 
% rng(rand_setting);


% Generate 10,000 numbers with Weibull distribution with parameters
% alpha = 1.5
% beta = 6
%
n = 10000;
alpha = 5;
beta = 6;
y = (-log(1-rand(n,1))/alpha).^(1/beta);

% To check the numbers are distributed according to Weibull distribution
% Get an an histogram of the number 
nb = 50; % Number of bins in histogram 
[n_hist,x_hist] = hist(y,nb);

% We now plot the expected distribution
bin_width = x_hist(2)-x_hist(1);
% lower and upper limits of the bins
lower = x_hist - bin_width/2;
upper = x_hist + bin_width/2;
% expected number of exponentially distributed numbers in each bin
y_expected = n*(exp(-alpha*lower.^beta)-exp(-alpha*upper.^beta));

% plot the histogram and expected distribution
bar(x_hist,n_hist);
hold on
plot(x_hist,y_expected,'r-','Linewidth',3)
hold off
title('Histogram of 10^4 psuedo-random numbers with Wiebull distribution')

