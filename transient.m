
load ('t1', 'save_arr')

m = 20000;  % number of data points in each simulation

mt = save_arr;
% smooth it out with different values of w
% vary the value of w here 
w = 500;
mt_smooth = zeros(1,m-w);

    for i = 1:(m-w)
        if (i <= w)
            mt_smooth(i) = mean(mt(1:(2*i-1)));
        else
            mt_smooth(i) = mean(mt((i-w):(i+w)));
        end
    end

% plot the smoothed batch mean
xv = 1:(m-w);
plot(mt_smooth','Linewidth',3);
title(['w = ',int2str(w)],'FontSize',16)









