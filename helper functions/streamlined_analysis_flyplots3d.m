function out = streamlined_analysis_flyplots3d(eggs, trx, substrate, title_string, dense_out)

%% Seperate plots of y-position (over time) with eggs indicated for each fly in dataset
for i = 1:length(trx)
    flyplot_markedtimes3d(trx, eggs, i, [],[1,length(trx(1,i).x)],title_string,dense_out);
end

%% DONE
out =1;
end
