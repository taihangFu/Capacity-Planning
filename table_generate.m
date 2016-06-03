load('in', 'all_replications')
ar = all_replications;

T = mean(ar);
S = std(ar);%By default, the standard deviation is normalized by N-1, where N is the number of observations.

ar = [ar; T; S];

ar

