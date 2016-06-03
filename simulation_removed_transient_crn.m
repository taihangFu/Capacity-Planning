function Tavg = simulation_removed_transient_crn(n, End, replication_id)

% output: mean response time 
% 
% inputs:

% n 
% NN
%rand_setting = rng;
%save saved_rand_setting_10_15 rand_setting

%load saved_rand_setting_6_1
%rng(rand_setting)

ns = 6;

s = strcat('saved_rand_setting_', int2str(ns), '_', int2str(replication_id));

load(s)
rng(rand_setting)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accounting parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = 0; % T is the cumulative response time 
N = 0; % number of completed customers at the end of the simulation
%
% The mean response time will be given by T/N
% 


% Arrival rate
lambda = 0.85;
% Service rate
mu = 10/n;

% number of servers
m = 10;

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


% next_arrival_time  = a1K+a2K
% generate N uniformlly distribute random numbers in the interval (a,b) with the formula r = a + (b-a).*rand(N,1).
next_arrival_time = (-log(1-rand(1))/lambda) + (0.05 + (0.25-0.05)*rand(1)); %%%%% CHECKED
service_time_next_arrival = -log(1-rand(1))/mu; %%%%% CHECKED

% X_m = t_m/n^1.65 =  10.3846/ n^1.65
% k  = alpha = 2.08
%range = [t_m/n^1.65 ,Inf) = [0.2325, Inf)
%sub_task_service_time = (10.3846/ n^1.65) / ( (1-rand(1))^(1/2.08) );    %%%%% CHECKED


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

% Servers service time
servers_time = [];

save_arr = [];

% Start iteration until the end time
%while (master_clock < Tend)
while (N < End)
    
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

            % break into sub task and pass to the Servers
            %sub_task_service_time = (10.3846/ n^1.65) / ( (1-rand(1))^(1/2.08) );    %%%%% CHECKED
            %for i = 1:n
            %    servers_time = [servers_time; (10.3846/ n^1.65) / ( (1-rand(1))^(1/2.08) )];
            %end

            %next_departure_time = next_departure_time + max(servers_time);
            %servers_time = [];

        end
        % generate a new job and schedule its arrival 
        next_arrival_time = master_clock + ( (-log(1-rand(1))/lambda) + (0.05 + (0.25-0.05)*rand(1)) );
        service_time_next_arrival = -log(1-rand(1))/mu; 
        
    else % a departure 
        % 
        % Update the variables:
        % 1) Cumulative response time T
        % 2) Number of departed customers N
        
        % skip counting first 3000 request (transients) 
        if (N>3000)
        T = T + master_clock - arrival_time_next_departure;
        end
        N = N + 1;


        % %%%%% after the prev depart, now the time to serve the  first request on server
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
            %has departed
            next_departure_time = Inf;
            server_busy = 0;

        end 

        for i = 1:n
            servers_time = [servers_time; (10.3846/ n^1.65) / ( (1-rand(1))^(1/2.08) )];
        end


        T  = T + max(servers_time);
        servers_time = [];  

        s = T/N;
        save_arr = [[save_arr]; s];

    end        
end

Tavg = T/(N-3000);
save('t1', 'save_arr');

%disp(N);
% The mean response time
disp(['The mean response time is ',num2str(Tavg)])

