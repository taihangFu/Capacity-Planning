load('in', 'all_replications')
ar = all_replications;

T = mean(ar);
S = std(ar);%By default, the standard deviation is normalized by N-1, where N is the number of observations.

ar = [T; S];

% computes the 95% confidence interval for all columns(number of servers used) then plot vertical lines
Lower = T - tinv(1-.05/2,15-1)*S/sqrt(15-1); % 1*10
Upper = T + tinv(1-.05/2,15-1)*S/sqrt(15-1); % 1*10

ar = [ar; Lower; Upper];
ar

