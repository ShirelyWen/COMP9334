function avg_response_time = sim_mmm_func(lambda,mu,m,time_end)
% COMP9334 Capacity Planning
%
% This Matlab file simulates an M/M/m queue with
% mean arrival rate lambda and service rate mu
% 
% It outputs the mean response time 
% 
% There are 4 user simulation parameters:
% 1. Arrival rate lambda
% 2. Service rate mu
% 3. Number of servers 
% 4. Simulation time Tend  
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accounting parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%
response_time_cumulative = 0; %  The cumulative response time 
num_customer_served = 0; % number of completed customers at the end of the simulation

%
% The mean response time will be given by T/N
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Events
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% There are two events: An arrival event and a departure event
%
% An arrival event is specified by
% next_arrival_time = the time at which the next customer arrives
% service_time_next_arrival = the service time of the next arrival
%
% A departure event is specified by
% next_departure_time = the time at which the next departure occurs
% arrival_time_next_departure = the time at which the next departing
% customer arrives at the system
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialising the events
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Initialising the arrival event 
% 
next_arrival_time = -log(1-rand(1))/lambda;
service_time_next_arrival = -log(1-rand(1))/mu;
% 
% Initialise both departure events to empty
% Note: We use Inf (= infinity) to denote an empty departure event
% 
% next_departure_time is a m-by-1 vector 
next_departure_time = Inf * ones(m,1); 

% For checking
% events = [next_arrival_time service_time_next_arrival]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialising the Master clock, server status, queue_length,
% buffer_content
% 
% server_status = 1 if busy, 0 if idle
% 
% queue_length is the number of customers in the buffer
% 
% buffer_content is a matrix with 2 columns
% buffer_content(k,1) (i.e. k-th row, 1st column of buffer_content)
% contains the arrival time of the k-th customer in the buffer
% buffer_content(k,2) (i.e. k-th row, 2nd column of buffer_content)
% contains the service time of the k-th customer in the buffer
% The buffer_content is to imitate a first-come first-serve queue 
% The 1st row has information on the 1st customer in the queue etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Intialise the master clock 
master_clock = 0; 
% 
% Intialise server status
% Indicates the business of each server
server_busy = zeros(m,1);
arrival_time_next_departure = zeros(m,1);
% 
% Initialise buffer
buffer_content = [];
queue_length = 0;

% Start iteration until the end time
while (master_clock < time_end)
    
    % Find the server with the first departing customer
    [first_departure_time,first_departure_server] = min(next_departure_time);
    % 
    %
    % Find out whether the next event is an arrival or depature
    %
    % We use next_event_type = 1 for arrival and 0 for departure
    % 
    % 
    if (next_arrival_time < first_departure_time)
        next_event_time = next_arrival_time;
        next_event_type = 1;  
    else
        next_event_time = first_departure_time;
        % first departure server has already been found just now
        next_event_type = 0;
    end     

    %     
    % update master clock
    % 
    master_clock = next_event_time;
        
    %
    % take actions depending on the event type
    % 
    if (next_event_type == 1) % an arrival 
        if all(server_busy) 
            % 
            % add customer to buffer_content and
            % increment queue length
            % 
            buffer_content = [buffer_content ; next_arrival_time service_time_next_arrival];
            queue_length = queue_length + 1;        
        else % not all server are busy
            % 
            % Send the customer to any available server
            % 
            % Schedule departure event with 
            % the departure time is arrival time + service time 
            % Also, set server_busy to 1
            % 
            idle_server = min(find(server_busy == 0));
            next_departure_time(idle_server) = ...
                next_arrival_time + service_time_next_arrival;
            arrival_time_next_departure(idle_server) = next_arrival_time;
            server_busy(idle_server) = 1;
        end
        % generate a new job and schedule its arrival 
        next_arrival_time = master_clock - log(1-rand(1))/lambda;
        service_time_next_arrival = -log(1-rand(1))/mu; 
        
        % This is for checking only
        % events = [events ; next_arrival_time service_time_next_arrival]; 
    else % a departure 
        % 
        % Update the variables:
        % 1) Cumulative response time T
        % 2) Number of departed customers N
        % 
        response_time_cumulative = response_time_cumulative + master_clock - arrival_time_next_departure(first_departure_server);
        num_customer_served = num_customer_served + 1;
        % 
        if queue_length % buffer not empty
            % 
            % schedule the next departure event using the first customer 
            % in the buffer, i.e. use the 1st row in buffer_content
            % 
            next_departure_time(first_departure_server) = ...
                master_clock + buffer_content(1,2);
            arrival_time_next_departure(first_departure_server) = ...
                buffer_content(1,1);
            % 
            % remove customer from buffer and decrement queue length
            % 
            buffer_content(1,:) = [];
            queue_length = queue_length - 1;
        else % buffer empty
            next_departure_time(first_departure_server) = Inf;
            server_busy(first_departure_server) = 0;
        end    
    end        
end        
     
avg_response_time = response_time_cumulative/num_customer_served;

            
        