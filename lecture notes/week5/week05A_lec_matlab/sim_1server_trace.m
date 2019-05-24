% COMP9334 Capacity Planning
%
% This Matlab file simulates a single server queue in the trace
% driven mode 
% 
% It outputs the mean response time 
% 
% The user supplies information on arrival time and departure time 
% using two 1-dimensional arrays of the same length
% One array contains information on the arrival times and 
% the other contains information on the service times and 
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arrays for arrival times and service times 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arrival time and service time
arrival_time = [3,8,9,17,18,19,20,25,27];
service_time = [4,3,4,6,3,2,2,3,2];

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accounting parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%
response_time_cumulative = 0; %  The cumulative response time 
num_customer_served = 0; % number of completed customers at the end of the simulation
%
% The mean response time will be given by response_time_cumulative/num_customer_served
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
next_arrival_time = arrival_time(1);
service_time_next_arrival = service_time(1);
% Initialise a two counters 
job_counter = 2; % Points to the next job in the job list 
% Variable to store the number of jobs 
number_of_jobs = length(arrival_time); 
% To store information on departure 
departure_info = []; 

% 
% Initialise the departure event to empty
% Note: We use Inf (= infinity) to denote an empty departure event
% 
next_departure_time = Inf; 

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
server_busy = 0;
% 
% Initialise buffer
buffer_content = [];
queue_length = 0;

% Start iteration until the end time
while 1
    
    % Find out whether the next event is an arrival or depature
    %
    % We use next_event_type = 1 for arrival and 0 for departure
    % 
    if (next_arrival_time < next_departure_time)
        next_event_time = next_arrival_time;
        next_event_type = 1;  
    else
        next_event_time = next_departure_time;
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
        if server_busy
            % 
            % add customer to buffer_content and
            % increment queue length
            % 
            buffer_content = [buffer_content ; next_arrival_time service_time_next_arrival];
            queue_length = queue_length + 1;        
        else % server not busy
            % 
            % Schedule departure event with 
            % the departure time is arrival time + service time 
            % Also, set server_busy to 1
            % 
            next_departure_time = next_arrival_time + service_time_next_arrival;
            arrival_time_next_departure = next_arrival_time;
            server_busy = 1;
        end
        % generate a new job and schedule its arrival 
        if job_counter <= number_of_jobs 
            % Get next job 
            next_arrival_time = arrival_time(job_counter);
            service_time_next_arrival = service_time(job_counter); 
            job_counter = job_counter + 1;
        else
            next_arrival_time = Inf; 
        end     
        
    else % a departure 
        % 
        % Update the variables:
        % 1) Cumulative response time T
        % 2) Number of departed customers N
        % 
        response_time_cumulative = response_time_cumulative + master_clock - arrival_time_next_departure;
        num_customer_served = num_customer_served + 1;
        departure_info = [departure_info; arrival_time_next_departure master_clock];
        % 
        if queue_length % buffer not empty
            % 
            % schedule the next departure event using the first customer 
            % in the buffer, i.e. use the 1st row in buffer_content
            % 
            next_departure_time = master_clock + buffer_content(1,2);
            arrival_time_next_departure = buffer_content(1,1);
            % 
            % remove customer from buffer and decrement queue length
            % 
            buffer_content(1,:) = [];
            queue_length = queue_length - 1;
        else % buffer empty
            next_departure_time = Inf;
            server_busy = 0;
        end    
    end  
    
    % Break the while loop if all jobs have departed
    if num_customer_served == number_of_jobs
        break
    end    
end

% The estimated mean response time
disp(['The estimated mean response time is ',num2str(response_time_cumulative/num_customer_served)])


            
        
