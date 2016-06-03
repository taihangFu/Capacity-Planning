all_crn_replications = [];
crn_replications = [];
for n = 6:2:8
	for r = 1:15
        repli = simulation_removed_transient_crn(n, 20000, r);
        crn_replications = [crn_replications; repli];        
    end
	all_crn_replications =  [all_crn_replications, crn_replications];
    %all_replications
    crn_replications = []; %%updated for next server_id
end

save('crn', 'common_random_number_replications');