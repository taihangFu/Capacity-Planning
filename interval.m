function interval(start, last)
%%%%%%%

load('in', 'all_replications')
ar = all_replications;

T = mean(ar);

S = std(ar);%By default, the standard deviation is normalized by N-1, where N is the number of observations.

plot(start:last,T(start:last), '.', 'markersize',15); % plot mean as a blue small circle
%plot(start:last,T(start:last),'-o','Linewidth',2)

hold on
%
% computes the 95% confidence interval for all columns(number of servers used) then plot vertical lines
Lower = T - tinv(1-.05/2,15-1)*S/sqrt(15-1); % 1*10
Upper = T + tinv(1-.05/2,15-1)*S/sqrt(15-1); % 1*10

for i=start:last
   plot([i i],[Lower(i),Upper(i)],'r','Linewidth',2);
   
end

%
xlabel('Number of servers used')
ylabel('Mean Response Time')

