% COMP9334, Week 4A, Question 1

%% 
% Problem parameters
max_items = 40;    % Maximum number of items 
lamabda = 1;       % Arrival rate 
mu = 15;           % Service rate 

%% Computation

% Store the waiting time in a vector vec_wait
vec_wait = zeros(max_items,1); 
% vec_wait(i) = waiting time if Counter 1 serves 
% customers with $i$ items or less  

% Iterate for i = 1 to 40
for i = 1:max_items
    
    % Counter 1
    lambda1 = i/max_items;         % Arrival rate 
    ES1 = sum((1:i)/mu)/i;         % E[S]
    ES12 = sum(((1:i)/mu).^2)/i;   % E[S^2]
    rho1 = lambda1*ES1;            % rho 
    if rho1 < 1
        W1 = (lambda1 * ES12)/2/(1-rho1);   % PK formula
    else 
        W1 = Inf;
    end    
    
    % Counter 2
    lambda2 = (max_items-i)/max_items;      % Arrival rate 
    ES2 = sum(((i+1):max_items)/mu)/(max_items-i);   % E[S]
    ES22 = sum((((i+1):max_items)/mu).^2)/(max_items-i);  % E[S^2]
    rho2 = lambda2*ES2;
    if rho2 < 1
        W2 = (lambda2 * ES22)/2/(1-rho2);
    else
        W2 = Inf;
    end    
    % average waiting time
    vec_wait(i) = (i/max_items)*W1 + (max_items-i)/max_items*W2;
end

% plot W(x) against x
plot(1:max_items,vec_wait,'.','Markersize',15)
xlabel('x')
ylabel('meaning waiting time')
grid 
print -depsc week04A_q1_plot
    