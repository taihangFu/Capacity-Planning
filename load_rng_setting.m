all_replications = [];
replications = [];
for n = 1:10
	for r = 1:15
		%n
		%r
		repli = simulation_removed_transient(n, 20000, r);
		replications = [replications; repli];
    end
	all_replications =  [all_replications, replications];
    %all_replications
    replications = []; %%updated for next server_id
end

save('in', 'all_replications');