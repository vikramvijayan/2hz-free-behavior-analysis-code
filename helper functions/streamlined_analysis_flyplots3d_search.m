function out = streamlined_analysis_flyplots3d_search(eggs, trx, substrate, title_string, dense_out)

%% Seperate plots of y-position (over time) with eggs indicated for each fly in dataset
for i = 1:length(trx)
    [a b] = find(eggs.fly == i);
    times = [];
    times(:,1) = transpose(eggs.explore_start_time(a));
    times(:,2) = transpose(eggs.egg_time(a));
    flyplot_markedtimes3d(trx, eggs, i, times,[1,length(trx(1,i).x)],title_string,dense_out);
end

%% DONE
out =1;
end
