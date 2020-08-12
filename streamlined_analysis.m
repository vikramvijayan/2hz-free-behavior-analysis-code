function out = streamlined_analysis(eggs, trx, substrate, title_string)


%% Setting path and font size and no display

addpath('F:\Drive\Postdoc\most current data analysis folders\06.15.15 new matlab analysis\distributionPlot\');
addpath('F:\Drive\Postdoc\most current data analysis folders\06.15.15 new matlab analysis\distributionPlot\distributionPlot');

set(0,'DefaultAxesFontName', 'helvetica');
set(0,'DefaultAxesFontSize', 8);
set(0,'DefaultFigureVisible','off');

%% Scatter (w/ contour) of eggs laid per fly versus egg-laying preference per fly, and make histogram of eggs/fly

ratio = [];
total = [];

for i = 1:1:length(trx)
    [a , ~] = find(eggs.fly == i);
    [a1 , ~] = find(eggs.substrate(a) == eggs.first_substrate);
    ratio(i) = length(a1)./length(a);
    total(i) = length(a);
end
ratio = transpose(ratio);
total = transpose(total);

figure; hold on; box on;
[n, c] = hist3([total,ratio],'Edges',{[0:4:100];[-.025:.05:1.025]});
n2 = filter2([.5, 1, .5; .5, 1, .5],n,'same');
contourf(c{2},c{1},(n2),'LineStyle','none','LevelStep',.5);
colorbar; colormap(jet);
scatter(ratio, total+(rand(length(total),1)*.6-.3),20,'filled','sk');
xlabel('Eggs on preferred substrate / Total'); ylabel('Total eggs'); set(gca,'xlim',[0 1]); title(title_string);

figure; hold on; title(title_string); box on;
histogram(total,'binedges',[0:5:100],'facecolor','k','facealpha',.5,'Normalization','probability');

text(70,.1,['median = ' num2str(median(total))],'Fontsize',8);
text(70,.11,['mean = ' num2str(mean(total))],'Fontsize',8);
ratiog5 = [];
totalg5 = [];
c = 1;
for i = 1:1:length(trx)
    [a , ~] = find(eggs.fly == i);
    if(length(a) > 5)
        [a1 , ~] = find(eggs.substrate(a) == eggs.first_substrate);
        ratiog5(c) = length(a1)./length(a);
        totalg5(c) = length(a);
        c = c+1;
    end
end
text(70,.12,['median (>5) = ' num2str(median(totalg5))],'Fontsize',8);
text(70,.13,['mean (>5) = ' num2str(mean(totalg5))],'Fontsize',8);
xlabel('Total eggs per fly'); ylabel('Normalized Counts');

%% Histograms of inter-egg intervals for all eggs
figure; hold on; box on; grid on;
title(title_string); xlabel('Time between egg-laying events (minutes)'); ylabel('Normalized Counts');
set(gca,'xlim',[0 60]); set(gca,'xtick',[0:2:60]);

inter_egg = [];
for i =1:1:max(eggs.fly)
    [a, ~] = find(eggs.fly == i);
    if(length(a) > 1)
        inter_egg = [inter_egg; (eggs.egg_time(a(2:end))-eggs.egg_time(a(1:(end-1))))./120];
    end
end

histogram(inter_egg, [0:.5:60],'facecolor','k','Facealpha',.5,'Normalization','probability');
text(40,.02,['median = ' num2str(median(inter_egg))],'Fontsize',8);
text(40,.03,['mean = ' num2str(mean(inter_egg))],'Fontsize',8);
text(40,.04,['minimum = ' num2str(min(inter_egg))],'Fontsize',8);
text(40,.05,['std = ' num2str(std(inter_egg))],'Fontsize',8);
%% Histograms of transition to egg time for all eggs
figure; hold on; box on; grid on;
title(title_string); xlabel('Time from last actual substrate transition to egg-laying event (seconds)');
set(gca,'xlim',[0 240]); set(gca,'xtick',[0:30:240]);

[a , ~] =find(eggs.substrate == 0);
histogram((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:2:240],'Facecolor','r','Facealpha',.5);

[a , ~] =find(eggs.substrate == 2);
histogram((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:2:240],'Facecolor','g','Facealpha',.5);

[a , ~] =find(eggs.substrate == 5);
histogram((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:2:240],'Facecolor','b','Facealpha',.5);

%% Histograms of transition to egg distance for all eggs
figure; hold on; box on; grid on;
title(title_string); xlabel('Distance from last actual substrate transition to egg-laying event (mm)');
set(gca,'xlim',[0 240]); set(gca,'xtick',[0:30:240]);

[a , ~] =find(eggs.substrate == 0);
histogram(eggs.etrans_dist_sub(a,1),[0:2:240],'Facecolor','r','Facealpha',.5);

[a , ~] =find(eggs.substrate == 2);
histogram(eggs.etrans_dist_sub(a,1),[0:2:240],'Facecolor','g','Facealpha',.5);

[a , ~] =find(eggs.substrate == 5);
histogram(eggs.etrans_dist_sub(a,1),[0:2:240],'Facecolor','b','Facealpha',.5);

%% Histograms of residence times (transition periods in exploration that did not lead to egg-laying)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition or transition to egg
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore(trx, eggs, i, 0, 'time');
    if(eggs.substrate(i) ==0)
        s0_time = [s0_time, trans_dur_0(2:1:end)./2];
        s200_time = [s200_time, trans_dur_200./2];
        s500_time = [s500_time, trans_dur_500./2];
    end
    if (eggs.substrate(i) == 2)
        s0_time = [s0_time, trans_dur_0./2];
        s200_time = [s200_time, trans_dur_200(2:1:end)./2];
        s500_time = [s500_time, trans_dur_500./2];
    end
    if (eggs.substrate(i) == 5)
        s0_time = [s0_time, trans_dur_0./2];
        s200_time = [s200_time, trans_dur_200./2];
        s500_time = [s500_time, trans_dur_500(2:1:end)./2];
    end
end

figure; hold on; box on;
title(title_string); xlabel('Normalized Residence times during exploration (seconds)');
set(gca,'xlim',[0 60]); set(gca,'xtick',[0:5:60]); grid on;

histogram(s0_time,[0:.5:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.5:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.5:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(40,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(40,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(40,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(40,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(40,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(40,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence times (transition periods in exploration including that which led to egg laying)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore(trx, eggs, i, 0, 'time');
    s0_time = [s0_time, trans_dur_0./2];
    s200_time = [s200_time, trans_dur_200./2];
    s500_time = [s500_time, trans_dur_500./2];
    
end

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence times during exploration (seconds)', 'includes egg laying transition'});
set(gca,'xlim',[0 60]); set(gca,'xtick',[0:5:60]); grid on;

histogram(s0_time,[0:.5:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.5:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.5:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(40,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(40,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(40,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(40,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(40,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(40,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence times (transition periods in exploration that did not lead to egg-laying) (remove 1st transition onto a substrate)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition or transition to egg
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore(trx, eggs, i, 1, 'time');
    if(eggs.substrate(i) ==0)
        s0_time = [s0_time, trans_dur_0(2:1:end)./2];
        s200_time = [s200_time, trans_dur_200./2];
        s500_time = [s500_time, trans_dur_500./2];
    end
    if (eggs.substrate(i) == 2)
        s0_time = [s0_time, trans_dur_0./2];
        s200_time = [s200_time, trans_dur_200(2:1:end)./2];
        s500_time = [s500_time, trans_dur_500./2];
    end
    if (eggs.substrate(i) == 5)
        s0_time = [s0_time, trans_dur_0./2];
        s200_time = [s200_time, trans_dur_200./2];
        s500_time = [s500_time, trans_dur_500(2:1:end)./2];
    end
end

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence times during exploration (seconds)', 'does not include 1st transition onto a substrate'});
set(gca,'xlim',[0 60]); set(gca,'xtick',[0:5:60]); grid on;
histogram(s0_time,[0:.5:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.5:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.5:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(40,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(40,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(40,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(40,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(40,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(40,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence times (transition periods in exploration including that which led to egg laying) (remove 1st transition onto a substrate)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore(trx, eggs, i, 1, 'time');
    s0_time = [s0_time, trans_dur_0./2];
    s200_time = [s200_time, trans_dur_200./2];
    s500_time = [s500_time, trans_dur_500./2];
    
end

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence times during exploration (seconds)', 'includes egg laying transition', 'does not include 1st transition onto a substrate'});
set(gca,'xlim',[0 60]); set(gca,'xtick',[0:5:60]); grid on;

histogram(s0_time,[0:.5:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.5:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.5:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(40,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(40,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(40,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(40,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(40,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(40,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence distances (transition periods in exploration that did not lead to egg-laying)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition or transition to egg
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore(trx, eggs, i, 0, 'dist');
    if(eggs.substrate(i) ==0)
        s0_time = [s0_time, trans_dur_0(2:1:end)];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 2)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200(2:1:end)];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 5)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500(2:1:end)];
    end
end

figure; hold on; box on;
title(title_string); xlabel('Normalized Residence distances during exploration (mm)');
set(gca,'xlim',[0 120]); set(gca,'xtick',[0:10:120]); grid on;

histogram(s0_time,[0:1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(80,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(80,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(80,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(80,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(80,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(80,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence distances (transition periods in exploration including that which led to egg laying)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore(trx, eggs, i, 0, 'dist');
    s0_time = [s0_time, trans_dur_0];
    s200_time = [s200_time, trans_dur_200];
    s500_time = [s500_time, trans_dur_500];
    
end

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence distances during exploration (mm)', 'includes egg laying transition'});
set(gca,'xlim',[0 120]); set(gca,'xtick',[0:10:120]); grid on;

histogram(s0_time,[0:1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(80,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(80,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(80,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(80,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(80,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(80,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence distances (transition periods in exploration that did not lead to egg-laying) (remove 1st transition onto a substrate)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition or transition to egg
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore(trx, eggs, i, 1, 'dist');
    if(eggs.substrate(i) ==0)
        s0_time = [s0_time, trans_dur_0(2:1:end)];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 2)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200(2:1:end)];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 5)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500(2:1:end)];
    end
end

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence distances during exploration (mm)', 'does not include 1st transition onto a substrate'});
set(gca,'xlim',[0 120]); set(gca,'xtick',[0:10:120]); grid on;

histogram(s0_time,[0:1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(80,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(80,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(80,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(80,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(80,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(80,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence distances (transition periods in exploration including that which led to egg laying) (remove 1st transition onto a substrate)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore(trx, eggs, i, 1, 'dist');
    s0_time = [s0_time, trans_dur_0];
    s200_time = [s200_time, trans_dur_200];
    s500_time = [s500_time, trans_dur_500];
    
end

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence distances during exploration (mm)', 'includes egg laying transition', 'does not include 1st transition onto a substrate'});
set(gca,'xlim',[0 120]); set(gca,'xtick',[0:10:120]); grid on;

histogram(s0_time,[0:1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(80,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(80,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(80,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(80,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(80,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(80,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence speed (transition periods in exploration that did not lead to egg-laying)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition or transition to egg
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0D, trans_dur_200D, trans_dur_500D, trans_dur_500_from0D, trans_dur_500_from200D, trans_listD] = alltransinexplore(trx, eggs, i, 0, 'dist');
    [trans_dur_0T, trans_dur_200T, trans_dur_500T, trans_dur_500_from0T, trans_dur_500_from200T, trans_listT] = alltransinexplore(trx, eggs, i, 0, 'time');
    
    trans_dur_0 = 2.*trans_dur_0D./trans_dur_0T;
    trans_dur_200 = 2.*trans_dur_200D./trans_dur_200T;
    trans_dur_500 = 2.*trans_dur_500D./trans_dur_500T;
    
    if(eggs.substrate(i) ==0)
        s0_time = [s0_time, trans_dur_0(2:1:end)];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 2)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200(2:1:end)];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 5)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500(2:1:end)];
    end
end

figure; hold on; box on;
title(title_string); xlabel('Normalized Residence speed during exploration (mm/sec)');
set(gca,'xlim',[0 10]); set(gca,'xtick',[0:.5:10]); grid on;

histogram(s0_time,[0:.1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');


if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(6,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(6,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(6,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(6,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(6,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(6,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence speed (transition periods in exploration including that which led to egg laying)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0D, trans_dur_200D, trans_dur_500D, trans_dur_500_from0D, trans_dur_500_from200D, trans_listD] = alltransinexplore(trx, eggs, i, 0, 'dist');
    [trans_dur_0T, trans_dur_200T, trans_dur_500T, trans_dur_500_from0T, trans_dur_500_from200T, trans_listT] = alltransinexplore(trx, eggs, i, 0, 'time');
    
    trans_dur_0 = 2.*trans_dur_0D./trans_dur_0T;
    trans_dur_200 = 2.*trans_dur_200D./trans_dur_200T;
    trans_dur_500 = 2.*trans_dur_500D./trans_dur_500T;
    
    s0_time = [s0_time, trans_dur_0];
    s200_time = [s200_time, trans_dur_200];
    s500_time = [s500_time, trans_dur_500];
    
end

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence speed during exploration (mm/sec)', 'includes egg laying transition'});
set(gca,'xlim',[0 10]); set(gca,'xtick',[0:.5:10]); grid on;

histogram(s0_time,[0:.1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');


if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(6,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(6,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(6,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(6,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(6,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(6,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence speed (transition periods in exploration that did not lead to egg-laying) (remove 1st transition onto a substrate)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition or transition to egg
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0D, trans_dur_200D, trans_dur_500D, trans_dur_500_from0D, trans_dur_500_from200D, trans_listD] = alltransinexplore(trx, eggs, i, 1, 'dist');
    [trans_dur_0T, trans_dur_200T, trans_dur_500T, trans_dur_500_from0T, trans_dur_500_from200T, trans_listT] = alltransinexplore(trx, eggs, i, 1, 'time');
    
    trans_dur_0 = 2.*trans_dur_0D./trans_dur_0T;
    trans_dur_200 = 2.*trans_dur_200D./trans_dur_200T;
    trans_dur_500 = 2.*trans_dur_500D./trans_dur_500T;
    
    if(eggs.substrate(i) ==0)
        s0_time = [s0_time, trans_dur_0(2:1:end)];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 2)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200(2:1:end)];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 5)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500(2:1:end)];
    end
end

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence speed during exploration (mm/sec)', 'does not include 1st transition onto a substrate'});
set(gca,'xlim',[0 10]); set(gca,'xtick',[0:.5:10]); grid on;

histogram(s0_time,[0:.1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');


if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(6,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(6,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(6,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(6,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(6,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(6,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence speed (transition periods in exploration including that which led to egg laying) (remove 1st transition onto a substrate)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0D, trans_dur_200D, trans_dur_500D, trans_dur_500_from0D, trans_dur_500_from200D, trans_listD] = alltransinexplore(trx, eggs, i, 1, 'dist');
    [trans_dur_0T, trans_dur_200T, trans_dur_500T, trans_dur_500_from0T, trans_dur_500_from200T, trans_listT] = alltransinexplore(trx, eggs, i, 1, 'time');
    
    trans_dur_0 = 2.*trans_dur_0D./trans_dur_0T;
    trans_dur_200 = 2.*trans_dur_200D./trans_dur_200T;
    trans_dur_500 = 2.*trans_dur_500D./trans_dur_500T;
    
    s0_time = [s0_time, trans_dur_0];
    s200_time = [s200_time, trans_dur_200];
    s500_time = [s500_time, trans_dur_500];
    
end

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence speed during exploration (mm/sec)', 'includes egg laying transition', 'does not include 1st transition onto a substrate'});
set(gca,'xlim',[0 10]); set(gca,'xtick',[0:.5:10]); grid on;

histogram(s0_time,[0:.1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');


if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(6,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(6,.0125,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(6,.015,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(6,.0175,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(6,.02,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(6,.0225,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of residence log2(x/y) distance (transition periods in exploration that did not lead to egg-laying)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition or transition to egg
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0D, trans_dur_200D, trans_dur_500D, trans_dur_500_from0D, trans_dur_500_from200D, trans_listD] = alltransinexplore(trx, eggs, i, 0, 'distx');
    [trans_dur_0T, trans_dur_200T, trans_dur_500T, trans_dur_500_from0T, trans_dur_500_from200T, trans_listT] = alltransinexplore(trx, eggs, i, 0, 'disty');
    
    trans_dur_0 = trans_dur_0D./trans_dur_0T;
    trans_dur_200 = trans_dur_200D./trans_dur_200T;
    trans_dur_500 = trans_dur_500D./trans_dur_500T;
    
    if(eggs.substrate(i) ==0)
        s0_time = [s0_time, trans_dur_0(2:1:end)];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 2)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200(2:1:end)];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 5)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500(2:1:end)];
    end
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel('Normalized Residence log2 x/y distance during exploration (mm/mm)');
set(gca,'xlim',[-4 4]); set(gca,'xtick',[-4:.5:4]); grid on;

histogram(log2(s0_time),[-4:.1:4],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(log2(s200_time),[-4:.1:4],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(log2(s500_time),[-4:.1:4],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(log2(s0_time), log2(s200_time),'tail','right');
    text(1,.03,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(log2(s0_time), log2(s500_time),'tail','right');
    text(1,.04,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(log2(s200_time), log2(s500_time),'tail','right');
    text(1,.05,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(1,.06,['median 0 = ' num2str(median(log2(s0_time)))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(1,.07,['median 200 = ' num2str(median(log2(s200_time)))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(1,.08,['median 500 = ' num2str(median(log2(s500_time)))],'Fontsize',8);
end

%% Histograms of residence log2(x/y) distance (transition periods in exploration including that which led to egg laying)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0D, trans_dur_200D, trans_dur_500D, trans_dur_500_from0D, trans_dur_500_from200D, trans_listD] = alltransinexplore(trx, eggs, i, 0, 'distx');
    [trans_dur_0T, trans_dur_200T, trans_dur_500T, trans_dur_500_from0T, trans_dur_500_from200T, trans_listT] = alltransinexplore(trx, eggs, i, 0, 'disty');
    
    trans_dur_0 = trans_dur_0D./trans_dur_0T;
    trans_dur_200 = trans_dur_200D./trans_dur_200T;
    trans_dur_500 = trans_dur_500D./trans_dur_500T;
    
    s0_time = [s0_time, trans_dur_0];
    s200_time = [s200_time, trans_dur_200];
    s500_time = [s500_time, trans_dur_500];
    
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence log2 x/y distance during exploration (mm/mm)', 'includes egg laying transition'});
set(gca,'xlim',[-4 4]); set(gca,'xtick',[-4:.5:4]); grid on;

histogram(log2(s0_time),[-4:.1:4],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(log2(s200_time),[-4:.1:4],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(log2(s500_time),[-4:.1:4],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(log2(s0_time), log2(s200_time),'tail','right');
    text(1,.03,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(log2(s0_time), log2(s500_time),'tail','right');
    text(1,.04,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(log2(s200_time), log2(s500_time),'tail','right');
    text(1,.05,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(1,.06,['median 0 = ' num2str(median(log2(s0_time)))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(1,.07,['median 200 = ' num2str(median(log2(s200_time)))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(1,.08,['median 500 = ' num2str(median(log2(s500_time)))],'Fontsize',8);
end

%% Histograms of residence log2(x/y) distance (transition periods in exploration that did not lead to egg-laying) (remove 1st transition onto a substrate)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition or transition to egg
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0D, trans_dur_200D, trans_dur_500D, trans_dur_500_from0D, trans_dur_500_from200D, trans_listD] = alltransinexplore(trx, eggs, i, 1, 'distx');
    [trans_dur_0T, trans_dur_200T, trans_dur_500T, trans_dur_500_from0T, trans_dur_500_from200T, trans_listT] = alltransinexplore(trx, eggs, i, 1, 'disty');
    
    trans_dur_0 = trans_dur_0D./trans_dur_0T;
    trans_dur_200 = trans_dur_200D./trans_dur_200T;
    trans_dur_500 = trans_dur_500D./trans_dur_500T;
    
    if(eggs.substrate(i) ==0)
        s0_time = [s0_time, trans_dur_0(2:1:end)];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 2)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200(2:1:end)];
        s500_time = [s500_time, trans_dur_500];
    end
    if (eggs.substrate(i) == 5)
        s0_time = [s0_time, trans_dur_0];
        s200_time = [s200_time, trans_dur_200];
        s500_time = [s500_time, trans_dur_500(2:1:end)];
    end
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence log2 x/y distance during exploration (mm/mm)', 'does not include 1st transition onto a substrate'});
set(gca,'xlim',[-4 4]); set(gca,'xtick',[-4:.5:4]); grid on;

histogram(log2(s0_time),[-4:.1:4],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(log2(s200_time),[-4:.1:4],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(log2(s500_time),[-4:.1:4],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(log2(s0_time), log2(s200_time),'tail','right');
    text(1,.03,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(log2(s0_time), log2(s500_time),'tail','right');
    text(1,.04,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(log2(s200_time), log2(s500_time),'tail','right');
    text(1,.05,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(1,.06,['median 0 = ' num2str(median(log2(s0_time)))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(1,.07,['median 200 = ' num2str(median(log2(s200_time)))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(1,.08,['median 500 = ' num2str(median(log2(s500_time)))],'Fontsize',8);
end

%% Histograms of residence log2(x/y) distance (transition periods in exploration including that which led to egg laying) (remove 1st transition onto a substrate)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0D, trans_dur_200D, trans_dur_500D, trans_dur_500_from0D, trans_dur_500_from200D, trans_listD] = alltransinexplore(trx, eggs, i, 1, 'distx');
    [trans_dur_0T, trans_dur_200T, trans_dur_500T, trans_dur_500_from0T, trans_dur_500_from200T, trans_listT] = alltransinexplore(trx, eggs, i, 1, 'disty');
    
    trans_dur_0 = trans_dur_0D./trans_dur_0T;
    trans_dur_200 = trans_dur_200D./trans_dur_200T;
    trans_dur_500 = trans_dur_500D./trans_dur_500T;
    
    s0_time = [s0_time, trans_dur_0];
    s200_time = [s200_time, trans_dur_200];
    s500_time = [s500_time, trans_dur_500];
    
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence log2 x/y distance during exploration (mm/mm)', 'includes egg laying transition', 'does not include 1st transition onto a substrate'});
set(gca,'xlim',[-4 4]); set(gca,'xtick',[-4:.5:4]); grid on;

histogram(log2(s0_time),[-4:.1:4],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(log2(s200_time),[-4:.1:4],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(log2(s500_time),[-4:.1:4],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(log2(s0_time), log2(s200_time),'tail','right');
    text(1,.03,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(log2(s0_time), log2(s500_time),'tail','right');
    text(1,.04,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(log2(s200_time), log2(s500_time),'tail','right');
    text(1,.05,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(1,.06,['median 0 = ' num2str(median(log2(s0_time)))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(1,.07,['median 200 = ' num2str(median(log2(s200_time)))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(1,.08,['median 500 = ' num2str(median(log2(s500_time)))],'Fontsize',8);
end

%% Histograms of residence log2(x/y) distance (only transition to egg)
% This is the newer code that looks at all the inter transition times, but
% will not include exploration start to transition
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    [trans_dur_0D, trans_dur_200D, trans_dur_500D, trans_dur_500_from0D, trans_dur_500_from200D, trans_listD] = alltransinexplore(trx, eggs, i, 0, 'distx');
    [trans_dur_0T, trans_dur_200T, trans_dur_500T, trans_dur_500_from0T, trans_dur_500_from200T, trans_listT] = alltransinexplore(trx, eggs, i, 0, 'disty');
    
    trans_dur_0 = trans_dur_0D./trans_dur_0T;
    trans_dur_200 = trans_dur_200D./trans_dur_200T;
    trans_dur_500 = trans_dur_500D./trans_dur_500T;
    
    if(eggs.substrate(i) ==0 && ~isempty(trans_dur_0))
        s0_time = [s0_time, trans_dur_0(1)];
        
    end
    if (eggs.substrate(i) == 2 && ~isempty(trans_dur_200))
        s200_time = [s200_time, trans_dur_200(1)];
    end
    if (eggs.substrate(i) == 5 && ~isempty(trans_dur_500))
        s500_time = [s500_time, trans_dur_500(1)];
    end
    
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence log2 x/y distance during exploration (mm/mm)', 'only egg laying transition'});
set(gca,'xlim',[-4 4]); set(gca,'xtick',[-4:.5:4]); grid on;

histogram(log2(s0_time),[-4:.1:4],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(log2(s200_time),[-4:.1:4],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(log2(s500_time),[-4:.1:4],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(log2(s0_time), log2(s200_time),'tail','right');
    text(1.5,.03,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(log2(s0_time), log2(s500_time),'tail','right');
    text(1.5,.04,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(log2(s200_time), log2(s500_time),'tail','right');
    text(1.5,.05,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(1.5,.06,['median 0 = ' num2str(median(log2(s0_time)))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(1.5,.07,['median 200 = ' num2str(median(log2(s200_time)))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(1.5,.08,['median 500 = ' num2str(median(log2(s500_time)))],'Fontsize',8);
end

%% Histograms of log2(x/y) distance (from exploration start to either transition or egg-laying)
s0_time = [];
s200_time = [];
s500_time = [];

s0_time2 = [];
s200_time2 = [];
s500_time2 = [];

for i = 1:1:eggs.total
    
    if(eggs.explore_trans_sub(i) == 0)
        distx_tmp = sum(flydistance_xmm(trx,eggs.fly(i),eggs.explore_start_time(i),eggs.egg_time(i)));
        disty_tmp = sum(flydistance_ymm(trx,eggs.fly(i),eggs.explore_start_time(i),eggs.egg_time(i)));
        if(eggs.explore_start_substrate(i) == 0)
            s0_time = [s0_time, distx_tmp/disty_tmp];
            s0_time2 = [s0_time2, distx_tmp+disty_tmp];
        end
        if(eggs.explore_start_substrate(i) == 2)
            s200_time = [s200_time, distx_tmp/disty_tmp];
            s200_time2 = [s200_time2, distx_tmp+disty_tmp];
        end
        if(eggs.explore_start_substrate(i) == 5)
            s500_time = [s500_time, distx_tmp/disty_tmp];
            s500_time2 = [s500_time2, distx_tmp+disty_tmp];
        end
    end
    
    if(eggs.explore_trans_sub(i) > 0)
        t_tmp = find_next_trans(trx(1,eggs.fly(i)).transition_sub,eggs.explore_start_time(i));
        distx_tmp = sum(flydistance_xmm(trx,eggs.fly(i),eggs.explore_start_time(i),t_tmp));
        disty_tmp = sum(flydistance_ymm(trx,eggs.fly(i),eggs.explore_start_time(i),t_tmp));
        if(eggs.explore_start_substrate(i) == 0)
            s0_time = [s0_time, distx_tmp/disty_tmp];
            s0_time2 = [s0_time2, distx_tmp+disty_tmp];
        end
        if(eggs.explore_start_substrate(i) == 2)
            s200_time = [s200_time, distx_tmp/disty_tmp];
            s200_time2 = [s200_time2, distx_tmp+disty_tmp];
        end
        if(eggs.explore_start_substrate(i) == 5)
            s500_time = [s500_time, distx_tmp/disty_tmp];
            s500_time2 = [s500_time2, distx_tmp+disty_tmp];
        end
    end
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence log2 x/y distance during exploration start', 'to either egg-laying or 1st substrate transition (mm/mm)'});
set(gca,'xlim',[-4 4]); set(gca,'xtick',[-4:.5:4]); grid on;

histogram(log2(s0_time),[-4:.1:4],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(log2(s200_time),[-4:.1:4],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(log2(s500_time),[-4:.1:4],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(log2(s0_time), log2(s200_time),'tail','right');
    text(1.5,.035,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(log2(s0_time), log2(s500_time),'tail','right');
    text(1.5,.04,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(log2(s200_time), log2(s500_time),'tail','right');
    text(1.5,.045,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(1.5,.05,['median 0 = ' num2str(median(log2(s0_time)))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(1.5,.055,['median 200 = ' num2str(median(log2(s200_time)))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(1.5,.06,['median 500 = ' num2str(median(log2(s500_time)))],'Fontsize',8);
end

%% Histograms of log2(x/y) distance (from exploration start to egg for eggs w/ 0 transitions)
s0_time = [];
s200_time = [];
s500_time = [];

s0_time2 = [];
s200_time2 = [];
s500_time2 = [];

for i = 1:1:eggs.total
    
    if(eggs.explore_trans_sub(i) == 0)
        distx_tmp = sum(flydistance_xmm(trx,eggs.fly(i),eggs.explore_start_time(i),eggs.egg_time(i)));
        disty_tmp = sum(flydistance_ymm(trx,eggs.fly(i),eggs.explore_start_time(i),eggs.egg_time(i)));
        if(eggs.explore_start_substrate(i) == 0)
            s0_time = [s0_time, distx_tmp/disty_tmp];
            s0_time2 = [s0_time2, distx_tmp+disty_tmp];
        end
        if(eggs.explore_start_substrate(i) == 2)
            s200_time = [s200_time, distx_tmp/disty_tmp];
            s200_time2 = [s200_time2, distx_tmp+disty_tmp];
        end
        if(eggs.explore_start_substrate(i) == 5)
            s500_time = [s500_time, distx_tmp/disty_tmp];
            s500_time2 = [s500_time2, distx_tmp+disty_tmp];
        end
    end
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence log2 x/y distance during exploration start', 'to egg-laying for eggs with 0 transitions (mm/mm)'});
set(gca,'xlim',[-4 4]); set(gca,'xtick',[-4:.5:4]); grid on;

histogram(log2(s0_time),[-4:.1:4],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(log2(s200_time),[-4:.1:4],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(log2(s500_time),[-4:.1:4],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(log2(s0_time), log2(s200_time),'tail','right');
    text(2,.035,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(log2(s0_time), log2(s500_time),'tail','right');
    text(2,.04,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(log2(s200_time), log2(s500_time),'tail','right');
    text(2,.045,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(2,.05,['median 0 = ' num2str(median(log2(s0_time)))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(2,.055,['median 200 = ' num2str(median(log2(s200_time)))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(2,.06,['median 500 = ' num2str(median(log2(s500_time)))],'Fontsize',8);
end

%% Histograms of distance (from exploration start to egg for eggs w/ 0 transitions)
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    
    if(eggs.explore_trans_sub(i) == 0)
        dist_tmp = sum(flydistance_mm(trx,eggs.fly(i),eggs.explore_start_time(i),eggs.egg_time(i)));
        if(eggs.explore_start_substrate(i) == 0)
            s0_time = [s0_time, dist_tmp];
        end
        if(eggs.explore_start_substrate(i) == 2)
            s200_time = [s200_time, dist_tmp];
        end
        if(eggs.explore_start_substrate(i) == 5)
            s500_time = [s500_time, dist_tmp];
        end
    end
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence distance during exploration start', 'to egg-laying for eggs with 0 transitions (mm)'});
set(gca,'xlim',[0 120]); set(gca,'xtick',[0:10:120]); grid on;

histogram(s0_time,[0:1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(60,.02,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(60,.03,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(60,.04,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(60,.05,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(60,.07,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(60,.08,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of duration (from exploration start to egg for eggs w/ 0 transitions)
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    
    if(eggs.explore_trans_sub(i) == 0)
        dist_tmp = (eggs.egg_time(i)-eggs.explore_start_time(i))./2;
        if(eggs.explore_start_substrate(i) == 0)
            s0_time = [s0_time, dist_tmp];
        end
        if(eggs.explore_start_substrate(i) == 2)
            s200_time = [s200_time, dist_tmp];
        end
        if(eggs.explore_start_substrate(i) == 5)
            s500_time = [s500_time, dist_tmp];
        end
    end
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence duration during exploration start', 'to egg-laying for eggs with 0 transitions (sec)'});
set(gca,'xlim',[0 60]); set(gca,'xtick',[0:5:60]); grid on;

histogram(s0_time,[0:.5:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.5:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.5:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(40,.02,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(40,.04,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(40,.06,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(40,.08,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(40,.11,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(40,.13,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of log2(x/y) distance (from exploration start to transition for eggs w/ >0 transitions)
s0_time = [];
s200_time = [];
s500_time = [];

s0_time2 = [];
s200_time2 = [];
s500_time2 = [];

for i = 1:1:eggs.total
    
    if(eggs.explore_trans_sub(i) > 0)
        distx_tmp = sum(flydistance_xmm(trx,eggs.fly(i),eggs.explore_start_time(i),find_next_trans(trx(1,eggs.fly(i)).transition_sub, eggs.explore_start_time(i))));
        disty_tmp = sum(flydistance_ymm(trx,eggs.fly(i),eggs.explore_start_time(i),find_next_trans(trx(1,eggs.fly(i)).transition_sub, eggs.explore_start_time(i))));
        if(eggs.explore_start_substrate(i) == 0)
            s0_time = [s0_time, distx_tmp/disty_tmp];
            s0_time2 = [s0_time2, distx_tmp+disty_tmp];
        end
        if(eggs.explore_start_substrate(i) == 2)
            s200_time = [s200_time, distx_tmp/disty_tmp];
            s200_time2 = [s200_time2, distx_tmp+disty_tmp];
        end
        if(eggs.explore_start_substrate(i) == 5)
            s500_time = [s500_time, distx_tmp/disty_tmp];
            s500_time2 = [s500_time2, distx_tmp+disty_tmp];
        end
    end
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence log2 x/y distance during exploration start', 'to transition for eggs with >0 transitions (mm/mm)'});
set(gca,'xlim',[-4 4]); set(gca,'xtick',[-4:.5:4]); grid on;

histogram(log2(s0_time),[-4:.1:4],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(log2(s200_time),[-4:.1:4],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(log2(s500_time),[-4:.1:4],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(log2(s0_time), log2(s200_time),'tail','right');
    text(1.5,.035,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(log2(s0_time), log2(s500_time),'tail','right');
    text(1.5,.04,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(log2(s200_time), log2(s500_time),'tail','right');
    text(1.5,.045,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(1.5,.05,['median 0 = ' num2str(median(log2(s0_time)))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(1.5,.055,['median 200 = ' num2str(median(log2(s200_time)))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(1.5,.06,['median 500 = ' num2str(median(log2(s500_time)))],'Fontsize',8);
end

%% Histograms of distance (from exploration start to transition for eggs w/ >0 transitions)
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    
    if(eggs.explore_trans_sub(i) > 0)
        dist_tmp = sum(flydistance_mm(trx,eggs.fly(i),eggs.explore_start_time(i),find_next_trans(trx(1,eggs.fly(i)).transition_sub, eggs.explore_start_time(i))));
        if(eggs.explore_start_substrate(i) == 0)
            s0_time = [s0_time, dist_tmp];
        end
        if(eggs.explore_start_substrate(i) == 2)
            s200_time = [s200_time, dist_tmp];
        end
        if(eggs.explore_start_substrate(i) == 5)
            s500_time = [s500_time, dist_tmp];
        end
    end
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence distance during exploration start', 'to transition for eggs with >0 transitions (mm)'});
set(gca,'xlim',[0 120]);
set(gca,'xtick',[0:10:120]);
grid on;
histogram(s0_time,[0:1:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:1:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:1:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(60,.02,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(60,.0225,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(60,.025,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(60,.0275,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(60,.03,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(60,.0325,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Histograms of duration (from exploration start to transition for eggs w/ >0 transitions)
s0_time = [];
s200_time = [];
s500_time = [];

for i = 1:1:eggs.total
    
    if(eggs.explore_trans_sub(i) > 0)
        dist_tmp = (find_next_trans(trx(1,eggs.fly(i)).transition_sub, eggs.explore_start_time(i))-eggs.explore_start_time(i))./2;
        if(eggs.explore_start_substrate(i) == 0)
            s0_time = [s0_time, dist_tmp];
        end
        if(eggs.explore_start_substrate(i) == 2)
            s200_time = [s200_time, dist_tmp];
        end
        if(eggs.explore_start_substrate(i) == 5)
            s500_time = [s500_time, dist_tmp];
        end
    end
end

s0_time(isnan(s0_time))=1;
s200_time(isnan(s0_time))=1;
s500_time(isnan(s0_time))=1;

figure; hold on; box on;
title(title_string); xlabel({'Normalized Residence duration during exploration start', 'to transition for eggs with >0 transitions (sec)'});
set(gca,'xlim',[0 60]);
set(gca,'xtick',[0:5:60]);
grid on;

histogram(s0_time,[0:.5:240],'Facecolor','r','Facealpha',.5,'Normalization','probability');
histogram(s200_time,[0:.5:240],'Facecolor','g','Facealpha',.5,'Normalization','probability');
histogram(s500_time,[0:.5:240],'Facecolor','b','Facealpha',.5,'Normalization','probability');

if(~isempty(s0_time) && ~isempty(s200_time))
    p = ranksum(s0_time, s200_time,'tail','right');
    text(40,.01,['p (0 > 200) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time) && ~isempty(s500_time))
    p = ranksum(s0_time, s500_time,'tail','right');
    text(40,.015,['p (0 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s200_time) && ~isempty(s500_time))
    p = ranksum(s200_time, s500_time,'tail','right');
    text(40,.02,['p (200 > 500) = ' num2str(p)],'Fontsize',8);
end

if(~isempty(s0_time))
    text(40,.025,['median 0 = ' num2str(median(s0_time))],'Fontsize',8);
end

if(~isempty(s200_time))
    text(40,.03,['median 200 = ' num2str(median(s200_time))],'Fontsize',8);
end

if(~isempty(s500_time))
    text(40,.035,['median 500 = ' num2str(median(s500_time))],'Fontsize',8);
end

%% Plot substrate around an egg laying event ordered by time chamber for all eggs
%(eliminate boundary condition eggs)

[a , ~] =find(eggs.explore_trans_sub >= 0);
window = 480; % window on each side in frames
c = [];
for i = 1:1:length(a)
    if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
        c = [c a(i)];
    end
end
sp = []; pos = [];  th = []; sub = []; et = [];rt = []; eggt = [];
for i =1:1:length(c)
    sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
    pos(i,:) = trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window);
    th(i,:) = ((trx(1,eggs.fly(c(i))).theta((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    sub(i,:) = ((trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
    rt(i) = (eggs.run_end_time(c(i))-eggs.egg_time(c(i)))./2;
    eggt(i) = eggs.egg_time(c(i));
end
[~, b] = sort(eggt);
figure; hold on; subplot(5,5,[1,2,3,4,6,7,8,9,11,12,13,14,16,17,18,19,21,22,23,24]); imagesc(sub(b,:)); hold on;
box on; set(gca,'xlim',[0 window*2]); title(title_string); colormap(gca,[1 0 0; 0 1 0; 0 0 0]); caxis([0 4]); set(gca,'xtick',[0:120:window*2]); set(gca,'xticklabel',{'-4','-3','-2','-1','0','1','2','3','4'});
xlabel('Time with respect to egg-laying event (minutes)'); ylabel({'Substrate of individual egg-laying events','ordered by time in chamber'});

subplot(5,5,[5,10,15,20,25]); hold on;  title(title_string);
plot(eggt(b)./7200,1:1:length(eggt),'k'); set(gca,'ylim',[0 length(eggt)]); grid on; set(gca,'Ydir','reverse'); set(gca,'yticklabel',[]); set(gca,'xtick',0:2:20); set(gca,'xticklabel',{'0','','','6','','','12','','','18',''});
xlabel('Hour in chamber');

%% Plot substrate around an egg laying event ordered by time in chamber for eggs with substrate transitions in exploration
% (eliminate boundary condition eggs)

[a , ~] =find(eggs.explore_trans_sub > 0);
window = 480; % window on each side in frames
c = [];
for i = 1:1:length(a)
    if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
        c = [c a(i)];
    end
end
sp = []; pos = [];  th = []; sub = []; et = [];rt = []; eggt = [];
for i =1:1:length(c)
    sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
    pos(i,:) = trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window);
    th(i,:) = ((trx(1,eggs.fly(c(i))).theta((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    sub(i,:) = ((trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
    rt(i) = (eggs.run_end_time(c(i))-eggs.egg_time(c(i)))./2;
    eggt(i) = eggs.egg_time(c(i));
end
[~, b] = sort(eggt);
figure; hold on; subplot(5,5,[1,2,3,4,6,7,8,9,11,12,13,14,16,17,18,19,21,22,23,24]); imagesc(sub(b,:)); hold on;
box on; set(gca,'xlim',[0 window*2]); title(title_string); colormap(gca,[1 0 0; 0 1 0; 0 0 0]); caxis([0 4]); set(gca,'xtick',[0:120:window*2]); set(gca,'xticklabel',{'-4','-3','-2','-1','0','1','2','3','4'});
xlabel('Time with respect to egg-laying event (minutes)'); ylabel({'Substrate of individual egg-laying events','where fly made actual sub trans ordered by time in chamber'});

subplot(5,5,[5,10,15,20,25]); hold on;  title(title_string);
plot(eggt(b)./7200,1:1:length(eggt),'k'); set(gca,'ylim',[0 length(eggt)]); grid on; set(gca,'Ydir','reverse'); set(gca,'yticklabel',[]); set(gca,'xtick',0:2:20); set(gca,'xticklabel',{'0','','','6','','','12','','','18',''});
xlabel('Hour in chamber');

%% Plot substrate around an egg laying event ordered by time in chamber with fly encountered both best and second best option in explore
% (eliminate boundary condition eggs)

[a , ~] =find(eggs.explore_start_time < eggs.last_first  & eggs.explore_start_time < eggs.last_second);
window = 480; % window on each side in frames
c = [];
for i = 1:1:length(a)
    if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
        c = [c a(i)];
    end
end
sp = []; pos = [];  th = []; sub = []; et = [];rt = []; eggt = [];
for i =1:1:length(c)
    sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
    pos(i,:) = trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window);
    th(i,:) = ((trx(1,eggs.fly(c(i))).theta((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    sub(i,:) = ((trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
    rt(i) = (eggs.run_end_time(c(i))-eggs.egg_time(c(i)))./2;
    eggt(i) = eggs.egg_time(c(i));
end
[~, b] = sort(eggt);
figure; hold on; subplot(5,5,[1,2,3,4,6,7,8,9,11,12,13,14,16,17,18,19,21,22,23,24]); imagesc(sub(b,:)); hold on;
box on; set(gca,'xlim',[0 window*2]); title(title_string); colormap(gca,[1 0 0; 0 1 0; 0 0 0]); caxis([0 4]); set(gca,'xtick',[0:120:window*2]); set(gca,'xticklabel',{'-4','-3','-2','-1','0','1','2','3','4'});
xlabel('Time with respect to egg-laying event (minutes)'); ylabel({'Substrate of individual egg-laying events where fly encountered', 'best and second best option ordered by time in chamber'});

subplot(5,5,[5,10,15,20,25]); hold on;  title(title_string);
plot(eggt(b)./7200,1:1:length(eggt),'k'); set(gca,'ylim',[0 length(eggt)]); grid on; set(gca,'Ydir','reverse'); set(gca,'yticklabel',[]); set(gca,'xtick',0:2:20); set(gca,'xticklabel',{'0','','','6','','','12','','','18',''});
xlabel('Hour in chamber');

%% Plot substrate around an egg laying event ordered by duration of exploration
%(eliminate boundary condition eggs)

[a , ~] =find(eggs.explore_trans_sub >= 0);
window = 480; % window on each side in frames
c = [];
for i = 1:1:length(a)
    if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
        c = [c a(i)];
    end
end
sp = []; pos = [];  th = []; sub = []; et = [];rt = []; eggt = [];
for i =1:1:length(c)
    sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
    pos(i,:) = trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window);
    th(i,:) = ((trx(1,eggs.fly(c(i))).theta((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    sub(i,:) = ((trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
    rt(i) = (eggs.run_end_time(c(i))-eggs.egg_time(c(i)))./2;
    eggt(i) = eggs.egg_time(c(i));
end
[~, b] = sort(et);
figure; hold on; subplot(5,5,[1,2,3,4,6,7,8,9,11,12,13,14,16,17,18,19,21,22,23,24]);  imagesc(sub(b,:)); hold on; scatter(window-et(b).*2,1:1:length(et),8,[.5 .5 .5],'filled');
box on; set(gca,'xlim',[0 window*2]); title(title_string); colormap(gca,[1 0 0; 0 1 0; 0 0 0]); caxis([0 4]); set(gca,'xtick',[0:120:window*2]); set(gca,'xticklabel',{'-4','-3','-2','-1','0','1','2','3','4'});
xlabel('Time with respect to egg-laying event (minutes)'); ylabel({'Substrate of individual egg-laying events','ordered by exploration duration'});

subplot(5,5,[5,10,15,20,25]); hold on;  title(title_string);
plot(eggt(b)./7200,1:1:length(eggt),'k'); set(gca,'ylim',[0 length(eggt)]); grid on; set(gca,'Ydir','reverse'); set(gca,'yticklabel',[]); set(gca,'xtick',0:2:20); set(gca,'xticklabel',{'0','','','6','','','12','','','18',''});
xlabel('Hour in chamber');

%% Plot substrate around an egg laying event for explores with > 0 trans, sorted by first trans
%(eliminate boundary condition eggs)

[a , ~] =find(eggs.explore_trans_sub > 0);
window = 480; % window on each side in frames
c = [];
for i = 1:1:length(a)
    if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
        c = [c a(i)];
    end
end
sp = []; pos = [];  th = []; sub = []; et = [];rt = []; eggt = []; transt = [];
for i =1:1:length(c)
    sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
    pos(i,:) = trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window);
    th(i,:) = ((trx(1,eggs.fly(c(i))).theta((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    sub(i,:) = ((trx(1,eggs.fly(c(i))).sucrose((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window)));
    et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
    rt(i) = (eggs.run_end_time(c(i))-eggs.egg_time(c(i)))./2;
    eggt(i) = eggs.egg_time(c(i));
    transt(i) = eggs.etrans_time(c(i),1);
end
[~, b] = sort(eggt-transt);
figure; hold on; subplot(5,5,[1,2,3,4,6,7,8,9,11,12,13,14,16,17,18,19,21,22,23,24]);  imagesc(sub(b,:)); hold on; 
scatter(window-eggt(b).*2,1:1:length(et),8,[.5 .5 .5],'filled');
box on; set(gca,'xlim',[0 window*2]); title(title_string); colormap(gca,[1 0 0; 0 1 0; 0 0 0]); caxis([0 4]); set(gca,'xtick',[0:120:window*2]); set(gca,'xticklabel',{'-4','-3','-2','-1','0','1','2','3','4'});
xlabel('Time with respect to egg (minutes)'); ylabel({'Substrate of individual egg-laying events, > 0 trans in explore','ordered by trans to egg time'});

figure; hold on; box on; title(title_string);
standard_error =std(sp(b,:))./sqrt(length(b));
mean_data = mean(sp(b,:));
fill([(0:1:2*window),fliplr(0:1:2*window)],[mean_data+standard_error,fliplr(mean_data-standard_error)],[0 0 .9],'linestyle','none');
plot((0:1:2*window),mean(sp),'k'); set(gca,'xtick',0:60:window*2); set(gca,'xticklabel',(-1.*window/2):30:(window/2)); set(gca,'xlim',[0, window*2]);
xlabel('Time with respect to egg-laying event (seconds)'); ylabel({'Mean speed (mm/sec) of all individual egg-laying events with SEM', '> 0 trans in explore'});

%% Plot of speed around an egg laying event ordered by exploration duration
% (eliminate boundary condition eggs)

[a , ~] =find(eggs.explore_trans_sub >= 0);
window = 480; % window on each side in frames
c = [];
for i = 1:1:length(a)
    if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
        c = [c a(i)];
    end
end
sp = []; pos = [];  th = []; sub = []; et = [];rt = [];
for i =1:1:length(c)
    sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
    et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
end
[~, b] = sort(et);
figure; imagesc(sp(b,:)); hold on; scatter(window-et(b).*2,1:1:length(et),8,[.5 .5 .5],'filled')
box on; set(gca,'xlim',[0 window*2]); title(title_string); colormap(gca,'cool'); caxis([0 5]); set(gca,'xtick',[0:120:window*2]); set(gca,'xticklabel',{'-4','-3','-2','-1','0','1','2','3','4'});
xlabel('Time with respect to egg-laying event (minutes)'); ylabel('Speed (mm/sec) of individual egg-laying events'); colorbar;

figure; hold on; box on; title(title_string);
standard_error =std(sp(b,:))./sqrt(length(b));
mean_data = mean(sp(b,:));
fill([(0:1:2*window),fliplr(0:1:2*window)],[mean_data+standard_error,fliplr(mean_data-standard_error)],[0 0 .9],'linestyle','none');
plot((0:1:2*window),mean(sp),'k'); set(gca,'xtick',0:60:window*2); set(gca,'xticklabel',(-1.*window/2):30:(window/2)); set(gca,'xlim',[0, window*2]);
xlabel('Time with respect to egg-laying event (seconds)'); ylabel('Mean speed (mm/sec) of all individual egg-laying events with SEM');

figure; hold on; box on; title(title_string);
standard_error =std(sp(b,:))./sqrt(length(b));
mean_data = mean(sp(b,:));
fill([(0:1:2*window),fliplr(0:1:2*window)],[mean_data+standard_error,fliplr(mean_data-standard_error)],[0 0 .9],'linestyle','none');
plot((0:1:2*window),mean(sp),'k'); set(gca,'xtick',0:6:window*2); set(gca,'xticklabel',(-1.*window/2):3:(window/2)); set(gca,'xlim',[window*(7/8), window*(9/8)]); grid on;
xlabel('Time with respect to egg-laying event (seconds)'); ylabel({'Mean speed (mm/sec) of all individual', 'egg-laying events with SEM'});



%% Plot of speed around an explore start ordered by exploration duration
% (eliminate boundary condition eggs)

[a , ~] =find(eggs.explore_trans_sub >= 0);
window = 480; % window on each side in frames
c = [];
for i = 1:1:length(a)
    if(eggs.explore_start_time(a(i)) > (window+1) && (eggs.explore_start_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
        c = [c a(i)];
    end
end
sp = []; pos = [];  th = []; sub = []; et = [];rt = [];
for i =1:1:length(c)
    sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.explore_start_time(c(i))-window):eggs.explore_start_time(c(i))+window));
    et(i) = -1.*(eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
end
[~, b] = sort(et,'descend');
figure; imagesc(sp(b,:)); hold on; scatter(window-et(b).*2,1:1:length(et),8,[.5 .5 .5],'filled')
box on; set(gca,'xlim',[0 window*2]); title(title_string); colormap(gca,'cool'); caxis([0 5]); set(gca,'xtick',[0:120:window*2]); set(gca,'xticklabel',{'-4','-3','-2','-1','0','1','2','3','4'});
xlabel('Time with respect to explore start event (minutes)'); ylabel('Speed (mm/sec) of individual explore start events'); colorbar;

figure; hold on; box on; title(title_string);
standard_error =std(sp(b,:))./sqrt(length(b));
mean_data = mean(sp(b,:));
fill([(0:1:2*window),fliplr(0:1:2*window)],[mean_data+standard_error,fliplr(mean_data-standard_error)],[0 0 .9],'linestyle','none');
plot((0:1:2*window),mean(sp),'k'); set(gca,'xtick',0:60:window*2); set(gca,'xticklabel',(-1.*window/2):30:(window/2)); set(gca,'xlim',[0, window*2]);
xlabel('Time with respect to explore start event (seconds)'); ylabel('Mean speed (mm/sec) of all individual explore start events with SEM');

figure; hold on; box on; title(title_string);
standard_error =std(sp(b,:))./sqrt(length(b));
mean_data = mean(sp(b,:));
fill([(0:1:2*window),fliplr(0:1:2*window)],[mean_data+standard_error,fliplr(mean_data-standard_error)],[0 0 .9],'linestyle','none');
plot((0:1:2*window),mean(sp),'k'); set(gca,'xtick',0:6:window*2); set(gca,'xticklabel',(-1.*window/2):3:(window/2)); set(gca,'xlim',[window*(7/8), window*(9/8)]); grid on;
xlabel('Time with respect to explore start (seconds)'); ylabel({'Mean speed (mm/sec) of all individual', 'explore start events with SEM'});




%% Plot of speed around an egg laying event seperately for eggs laid on each substrate
% (eliminate boundary condition eggs)

[a , ~] =find(eggs.substrate == 0);
if(~isempty(a))
    window = 480; % window on each side in frames
    c = [];
    for i = 1:1:length(a)
        if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
            c = [c a(i)];
        end
    end
    sp = []; pos = [];  th = []; sub = []; et = [];rt = [];
    for i =1:1:length(c)
        sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
        et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
    end
    [~, b] = sort(et);
    
    figure; hold on; box on; title(title_string);
    standard_error =std(sp(b,:))./sqrt(length(b));
    mean_data = mean(sp(b,:));
    fill([(0:1:2*window),fliplr(0:1:2*window)],[mean_data+standard_error,fliplr(mean_data-standard_error)],[0 0 .9],'linestyle','none');
    plot((0:1:2*window),mean(sp),'k'); set(gca,'xtick',0:6:window*2); set(gca,'xticklabel',(-1.*window/2):3:(window/2)); set(gca,'xlim',[window*(7/8), window*(9/8)]); grid on;
    xlabel('Time with respect to egg-laying event (seconds)'); ylabel({'Mean speed (mm/sec) of all individual', 'egg-laying events on 0mM with SEM'});
end

[a , ~] =find(eggs.substrate == eggs.first_substrate & eggs.explore_trans_sub > 0);
if(~isempty(a))
    window = 480; % window on each side in frames
    c = [];
    for i = 1:1:length(a)
        if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
            c = [c a(i)];
        end
    end
    sp = []; pos = [];  th = []; sub = []; et = [];rt = [];
    for i =1:1:length(c)
        sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
        et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
    end
    [~, b] = sort(et);
    
    figure; hold on; box on; title(title_string);
    standard_error =std(sp(b,:))./sqrt(length(b));
    mean_data = mean(sp(b,:));
    fill([(0:1:2*window),fliplr(0:1:2*window)],[mean_data+standard_error,fliplr(mean_data-standard_error)],[0 0 .9],'linestyle','none');
    plot((0:1:2*window),mean(sp),'k'); set(gca,'xtick',0:6:window*2); set(gca,'xticklabel',(-1.*window/2):3:(window/2)); set(gca,'xlim',[window*(7/8), window*(9/8)]); grid on;
    xlabel('Time with respect to egg-laying event (seconds)'); ylabel({'Mean speed (mm/sec) of all individual egg-laying events', 'on BEST substrate option with actual substrate transitions and SEM'});
end

[a , ~] =find(eggs.substrate == 2);
if(~isempty(a))
    window = 480; % window on each side in frames
    c = [];
    for i = 1:1:length(a)
        if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
            c = [c a(i)];
        end
    end
    sp = []; pos = [];  th = []; sub = []; et = [];rt = [];
    for i =1:1:length(c)
        sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
        et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
    end
    [~, b] = sort(et);
    
    figure; hold on; box on; title(title_string);
    standard_error =std(sp(b,:))./sqrt(length(b));
    mean_data = mean(sp(b,:));
    fill([(0:1:2*window),fliplr(0:1:2*window)],[mean_data+standard_error,fliplr(mean_data-standard_error)],[0 0 .9],'linestyle','none');
    plot((0:1:2*window),mean(sp),'k'); set(gca,'xtick',0:6:window*2); set(gca,'xticklabel',(-1.*window/2):3:(window/2)); set(gca,'xlim',[window*(7/8), window*(9/8)]); grid on;
    xlabel('Time with respect to egg-laying event (seconds)'); ylabel({'Mean speed (mm/sec) of all individual', 'egg-laying events on 200 mM with SEM'});
end

[a , ~] =find(eggs.substrate == 5);
if(~isempty(a))
    window = 480; % window on each side in frames
    c = [];
    for i = 1:1:length(a)
        if(eggs.egg_time(a(i)) > (window+1) && (eggs.egg_time(a(i))+window) <= length(trx(1,eggs.fly(a(i))).x))
            c = [c a(i)];
        end
    end
    sp = []; pos = [];  th = []; sub = []; et = [];rt = [];
    for i =1:1:length(c)
        sp(i,:) = (trx(1,eggs.fly(c(i))).speed((eggs.egg_time(c(i))-window):eggs.egg_time(c(i))+window));
        et(i) = (eggs.egg_time(c(i))-eggs.explore_start_time(c(i)))./2;
    end
    [~, b] = sort(et);
    
    figure; hold on; box on; title(title_string);
    standard_error =std(sp(b,:))./sqrt(length(b));
    mean_data = mean(sp(b,:));
    fill([(0:1:2*window),fliplr(0:1:2*window)],[mean_data+standard_error,fliplr(mean_data-standard_error)],[0 0 .9],'linestyle','none');
    plot((0:1:2*window),mean(sp),'k'); set(gca,'xtick',0:6:window*2); set(gca,'xticklabel',(-1.*window/2):3:(window/2)); set(gca,'xlim',[window*(7/8), window*(9/8)]); grid on;
    xlabel('Time with respect to egg-laying event (seconds)'); ylabel({'Mean speed (mm/sec) of all individual', 'egg-laying events on 500 mM with SEM'});
end

%% For each individual fly, plot time since last substrate transition for each egg
figure; hold on; box on;
title(title_string); xlabel('Fly Number'); ylabel({'Time from last actual substrate', 'transition to egg-laying event (seconds)'});
set(gca,'xlim',[0 length(trx)+1]); set(gca,'xtick',[1:1:length(trx)]); set(gca,'yscale','log'); set(gca,'ylim',[1 100000]);
[a , ~] = find(eggs.substrate == 0);
hold on; scatter(eggs.fly(a)+.2*rand(length(eggs.fly(a)),1)-.4,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,6,'r','fill','markeredgecolor','k');
[a , ~] = find(eggs.substrate == 2);
scatter(eggs.fly(a)+.2*rand(length(eggs.fly(a)),1)-.1,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,6,'g','fill','markeredgecolor','k');
[a , ~] = find(eggs.substrate == 5);
scatter(eggs.fly(a)+.2*rand(length(eggs.fly(a)),1)+.2,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,6,'b','fill','markeredgecolor','k');
grid on;

%% For each individual fly, plot time since entering chamber for each egg
figure; hold on; box on;
title(title_string); xlabel('Fly Number'); ylabel('Time since entering chamber (hours)');
set(gca,'xlim',[0 length(trx)+1]); set(gca,'xtick',[1:1:length(trx)]);  set(gca,'ylim',[0 24]);
[a , ~] = find(eggs.substrate == 0);
hold on; scatter(eggs.fly(a)+.2*rand(length(eggs.fly(a)),1)-.4,(eggs.egg_time(a))./7200,6,'r','fill','markeredgecolor','k');
[a , ~] = find(eggs.substrate == 2);
scatter(eggs.fly(a)+.2*rand(length(eggs.fly(a)),1)-.1,(eggs.egg_time(a))./7200,6,'g','fill','markeredgecolor','k');
[a , ~] = find(eggs.substrate == 5);
scatter(eggs.fly(a)+.2*rand(length(eggs.fly(a)),1)+.2,(eggs.egg_time(a))./7200,6,'b','fill','markeredgecolor','k');
grid on;

%% For each individual fly, plot time since entering chamber for each egg, (flies w/ > 1 egg, ordered by time of 2nd egg), all eggs
figure; hold on; box on;
title(title_string); xlabel('Fly Number'); ylabel({'Time since entering chamber (hours)' , ' flies with more than 1 egg ordered by time of 2nd egg', 'all eggs'});
c = 1;
store_i = [];
store_egg2 = [];
for i =1:1:max(eggs.fly)
    [a , ~] = find(eggs.fly == i);
    
    if(length(a) > 1)
        store_i(c) = i;
        store_egg2(c) = eggs.egg_time(a(2));
        c = c+1;
    end
end

[~, b] = sort(store_egg2,'ascend');
store_i = store_i(b);

c = 1;
for i = 1:1:length(store_i)
    [a , ~] = find(eggs.substrate == 0 & eggs.fly == store_i(i));
    hold on; scatter(c+.2*rand(length(eggs.fly(a)),1)-.1,(eggs.egg_time(a))./7200,8,'.r','fill','markeredgecolor','k');
    [a , ~] = find(eggs.substrate == 2 & eggs.fly == store_i(i));
    scatter(c+.2*rand(length(eggs.fly(a)),1)-.1,(eggs.egg_time(a))./7200,8,'.g','fill','markeredgecolor','k');
    [a , ~] = find(eggs.substrate == 5 & eggs.fly == store_i(i));
    scatter(c+.2*rand(length(eggs.fly(a)),1)-.1,(eggs.egg_time(a))./7200,8,'.b','fill','markeredgecolor','k');
    c = c+1;
% 
%     [a , ~] = find(eggs.substrate == 0 & eggs.fly == store_i(i));
%     hold on; scatter(c+zeros(length(eggs.fly(a)),1),(eggs.egg_time(a))./7200,8,'.r','fill','markeredgecolor','k');
%     [a , ~] = find(eggs.substrate == 2 & eggs.fly == store_i(i));
%     scatter(c+.2*zeros(length(eggs.fly(a)),1),(eggs.egg_time(a))./7200,8,'.g','fill','markeredgecolor','k');
%     [a , ~] = find(eggs.substrate == 5 & eggs.fly == store_i(i));
%     scatter(c+.2*zeros(length(eggs.fly(a)),1),(eggs.egg_time(a))./7200,8,'.b','fill','markeredgecolor','k');
%     c = c+1;
end

set(gca,'xlim',[0 c]); set(gca,'xtick',1:1:c);  set(gca,'ylim',[0 24]); set(gca,'xticklabel',store_i); grid on;

%% For each individual fly, plot time since entering chamber for each egg, (flies w/ > 1 egg, ordered by time of 2nd egg), only eggs laid when best and second best option was seen in explore
figure; hold on; box on;
title(title_string); xlabel('Fly Number'); ylabel({'Time since entering chamber (hours)' , ' flies with more than 1 egg ordered by time of 2nd egg', 'best ans second best seen in explore'});
c = 1;
store_i = [];
store_egg2 = [];
for i =1:1:max(eggs.fly)
    [a , ~] = find(eggs.fly == i);
    
    if(length(a) > 1)
        store_i(c) = i;
        store_egg2(c) = eggs.egg_time(a(2));
        c = c+1;
    end
end

[~, b] = sort(store_egg2,'ascend');
store_i = store_i(b);

c = 1;
for i = 1:1:length(store_i)
    [a , ~] = find(eggs.substrate == 0 & eggs.fly == store_i(i) & eggs.explore_start_time < eggs.last_first  & eggs.explore_start_time < eggs.last_second);
    hold on; scatter(c+.2*rand(length(eggs.fly(a)),1)-.4,(eggs.egg_time(a))./7200,8,'r','fill','markeredgecolor','k');
    [a , ~] = find(eggs.substrate == 2 & eggs.fly == store_i(i) & eggs.explore_start_time < eggs.last_first & eggs.explore_start_time < eggs.last_second);
    scatter(c+.2*rand(length(eggs.fly(a)),1)-.1,(eggs.egg_time(a))./7200,8,'g','fill','markeredgecolor','k');
    [a , ~] = find(eggs.substrate == 5 & eggs.fly == store_i(i) & eggs.explore_start_time < eggs.last_first & eggs.explore_start_time < eggs.last_second);
    scatter(c+.2*rand(length(eggs.fly(a)),1)+.2,(eggs.egg_time(a))./7200,8,'b','fill','markeredgecolor','k');
    c = c+1;
end

set(gca,'xlim',[0 c]); set(gca,'xtick',1:1:c);  set(gca,'ylim',[0 24]); set(gca,'xticklabel',store_i); grid on;

%% For each individual fly, plot time since entering chamber for each egg, (flies w/ > 1 egg, ordered by time of 2nd egg), only eggs laid when fly visited both edges of chamber in explore and did not lay an egg in middle
figure; hold on; box on;
title(title_string); xlabel('Fly Number'); ylabel({'Time since entering chamber (hours)' , ' flies with more than 1 egg ordered by time of 2nd egg', 'visited both edges in explore and did not lay egg in middle'});
c = 1;
store_i = [];
store_egg2 = [];

egg_bi = [];
max_bi = [];
min_bi = [];
[atmp, ~] = find(eggs.substrate >=0);
for ij = 1:1:length(atmp)
    egg_bi(ij) = trx(1,eggs.fly(atmp(ij))).binary(eggs.egg_time(atmp(ij)));
    min_bi(ij) = min(trx(1,eggs.fly(atmp(ij))).binary(eggs.explore_start_time(atmp(ij)):eggs.egg_time(atmp(ij))));
    max_bi(ij) = max(trx(1,eggs.fly(atmp(ij))).binary(eggs.explore_start_time(atmp(ij)):eggs.egg_time(atmp(ij))));
end
egg_bi = transpose(egg_bi);
max_bi = transpose(max_bi);
min_bi = transpose(min_bi);

for i =1:1:max(eggs.fly)
    [a , ~] = find(eggs.fly == i);
    
    if(length(a) > 1)
        store_i(c) = i;
        store_egg2(c) = eggs.egg_time(a(2));
        c = c+1;
    end
end

[~, b] = sort(store_egg2,'ascend');
store_i = store_i(b);

c = 1;
  
for i = 1:1:length(store_i) 
    [a , ~] = find(eggs.substrate == 0 & eggs.fly == store_i(i) & egg_bi ~= 1 & eggs.explore_trans_sub > 0  & min_bi == 0 &  max_bi == 2);
    hold on; scatter(c+.2*rand(length(eggs.fly(a)),1)-.4,(eggs.egg_time(a))./7200,8,'r','fill','markeredgecolor','k');
    [a , ~] = find(eggs.substrate == 2 & eggs.fly == store_i(i) & egg_bi ~= 1 & eggs.explore_trans_sub > 0  & min_bi == 0 &  max_bi == 2);
    scatter(c+.2*rand(length(eggs.fly(a)),1)-.1,(eggs.egg_time(a))./7200,8,'g','fill','markeredgecolor','k');
    [a , ~] = find(eggs.substrate == 5 & eggs.fly == store_i(i) & egg_bi ~= 1 & eggs.explore_trans_sub > 0  & min_bi == 0 &  max_bi == 2);
    scatter(c+.2*rand(length(eggs.fly(a)),1)+.2,(eggs.egg_time(a))./7200,8,'b','fill','markeredgecolor','k');
    c = c+1;
end

set(gca,'xlim',[0 c]); set(gca,'xtick',1:1:c);  set(gca,'ylim',[0 24]); set(gca,'xticklabel',store_i); grid on;

%% Number of actual substrate transitions versus time of egg after transition (as violin plots)

% for 0mM
if(any(eggs.all_substrates == 0))
    figure; hold on; box on; title(title_string);
    
    for i =1:1:11
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub == i-1);
        if(~isempty(a))
            distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(eggs.explore_trans_sub(a)+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'r','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
        end
    end
    
    [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub > 1);
    if(~isempty(a))
        distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',11,'color',[.8 .8 .8],'showMM',0);
        scatter(11+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'r','fill');
        scatter(11,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
    end
    
    [a1 , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub == 1);
    if(~isempty(a1))
        distributionPlot(log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),'histOpt',1.1,'xValues',12,'color',[.8 .8 .8],'showMM',0);
        scatter(12+rand(length(a1),1).*.25-.125, log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),3,'r','fill');
        scatter(12,median(log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2)),6,'sk','fill');
    end
    
    set(gca,'xlim',[-.5,12.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:12]);
    set(gca,'xticklabel',{'0','1','2','3','4','5','6','7','8','9','10','>1','1'});
    grid on;
    xlabel('Number of actual substrate transitions in egg-laying exploration'); ylabel({'Log2 time from last transition to egg-laying event (seconds)', 'Median labeled in black'});
    if(~isempty(a) && ~isempty(a1))
        p = ranksum((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,(eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2,'tail','right');
        text(10.5,7,['p(>1>1)=' num2str(p)],'Fontsize',8);
        line([11,12],[6 6],'Color','k');
    end
    [a1 , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub == 1);
    [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub == 2);
    if(~isempty(a) && ~isempty(a1))
        p = ranksum((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,(eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2,'tail','right');
        text(.75,7,['p(2>1)=' num2str(p)],'Fontsize',8);
        line([1,2],[6 6],'Color','k');
    end
end
% for 200mM
if(any(eggs.all_substrates == 2))
    figure; hold on; box on; title(title_string);
    
    for i =1:1:11
        [a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub == i-1);
        if(~isempty(a))
            distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(eggs.explore_trans_sub(a)+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'g','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
        end
    end
    
    [a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub > 1);
    if(~isempty(a))
        distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',11,'color',[.8 .8 .8],'showMM',0);
        scatter(11+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'g','fill');
        scatter(11,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
    end
    
    [a1 , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub == 1);
    if(~isempty(a1))
        distributionPlot(log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),'histOpt',1.1,'xValues',12,'color',[.8 .8 .8],'showMM',0);
        scatter(12+rand(length(a1),1).*.25-.125, log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),3,'g','fill');
        scatter(12,median(log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2)),6,'sk','fill');
    end
    
    set(gca,'xlim',[-.5,12.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:12]);
    set(gca,'xticklabel',{'0','1','2','3','4','5','6','7','8','9','10','>1','1'});
    grid on;
    xlabel('Number of actual substrate transitions in egg-laying exploration'); ylabel({'Log2 time from last transition to egg-laying event (seconds)', 'Median labeled in black'});
    if(~isempty(a) && ~isempty(a1))
        p = ranksum((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,(eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2,'tail','right');
        text(10.5,7,['p(>1>1)=' num2str(p)],'Fontsize',8);
        line([11,12],[6 6],'Color','k');
    end
    [a1 , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub == 1);
    [a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub == 2);
    if(~isempty(a) && ~isempty(a1))
        p = ranksum((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,(eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2,'tail','right');
        text(.75,7,['p(2>1)=' num2str(p)],'Fontsize',8);
        line([1,2],[6 6],'Color','k');
    end
end
% for 500mM
if(any(eggs.all_substrates == 5))
    
    figure; hold on; box on; title(title_string);
    
    for i =1:1:11
        [a , ~] =find(eggs.substrate == 5 & eggs.explore_trans_sub == i-1);
        if(~isempty(a))
            distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(eggs.explore_trans_sub(a)+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'b','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
        end
    end
    
    [a , ~] =find(eggs.substrate == 5 & eggs.explore_trans_sub > 1);
    if(~isempty(a))
        distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',11,'color',[.8 .8 .8],'showMM',0);
        scatter(11+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'b','fill');
        scatter(11,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
    end
    
    [a1 , ~] =find(eggs.substrate == 5 & eggs.explore_trans_sub == 1);
    if(~isempty(a1))
        distributionPlot(log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),'histOpt',1.1,'xValues',12,'color',[.8 .8 .8],'showMM',0);
        scatter(12+rand(length(a1),1).*.25-.125, log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),3,'b','fill');
        scatter(12,median(log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2)),6,'sk','fill');
    end
    
    set(gca,'xlim',[-.5,12.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:12]);
    set(gca,'xticklabel',{'0','1','2','3','4','5','6','7','8','9','10','>1','1'});
    grid on;
    xlabel('Number of actual substrate transitions in egg-laying exploration'); ylabel({'Log2 time from last transition to egg-laying event (seconds)', 'Median labeled in black'});
    if(~isempty(a) && ~isempty(a1))
        p = ranksum((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,(eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2,'tail','right');
        text(10.5,7,['p(>1>1)=' num2str(p)],'Fontsize',8);
        line([11,12],[6 6],'Color','k');
    end
    [a1 , ~] =find(eggs.substrate == 5 & eggs.explore_trans_sub == 1);
    [a , ~] =find(eggs.substrate == 5 & eggs.explore_trans_sub == 2);
    if(~isempty(a) && ~isempty(a1))
        p = ranksum((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,(eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2,'tail','right');
        text(.75,7,['p(2>1)=' num2str(p)],'Fontsize',8);
        line([1,2],[6 6],'Color','k');
    end
end

%% Number of actual substrate transitions versus time of egg after transition (as simple scatter plot)
figure; hold on; box on; title(title_string);
[a , ~] =find(eggs.substrate == 0);
scatter(eggs.explore_trans_sub(a)+rand(length(a),1).*.25-.125, (eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,5,'r','fill','markeredgecolor','k')

set(gca,'yscale','log'); set(gca,'xlim',[-.5,10.5]); set(gca,'ylim',[1 100000]);
xlabel('Number of actual substrate transitions in egg-laying exploration'); ylabel('Time from last transition to egg-laying event (seconds)');

figure; hold on; box on; title(title_string);
[a , ~] =find(eggs.substrate == 2);
scatter(eggs.explore_trans_sub(a)+rand(length(a),1).*.25-.125, (eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,5,'g','fill','markeredgecolor','k')

set(gca,'yscale','log'); set(gca,'xlim',[-.5,10.5]); set(gca,'ylim',[1 100000]);
xlabel('Number of actual substrate transitions in egg-laying exploration'); ylabel('Time from last transition to egg-laying event (seconds)');

figure; hold on; box on; title(title_string);
[a , ~] =find(eggs.substrate == 5);
scatter(eggs.explore_trans_sub(a)+rand(length(a),1).*.25-.125, (eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,5,'b','fill','markeredgecolor','k')

set(gca,'yscale','log'); set(gca,'xlim',[-.5,10.5]); set(gca,'ylim',[1 100000]);
xlabel('Number of actual substrate transitions in egg-laying exploration'); ylabel('Time from last transition to egg-laying event (seconds)');

%% Duration on substrates for egg -laying transition and previous dwell times (as violin plots)

% for 0mM
if(any(eggs.all_substrates == 0))
    figure; hold on; box on; title([title_string ' eggs laid on 0 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub >= i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'r','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2-5)),8,'sk','fill');
            store_prev = (eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2;
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),6,'sk','fill');
            p = ranksum(store_prev,(eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2,'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = (eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2;
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel('Dwell times in transitions before egg-laying (0 is the egg-laying transition)');
    ylabel({'Log2 dwell time (seconds)', 'Median labeled in black', 'Median -5 also shown for T0'});
end
% for 200mM
if(any(eggs.all_substrates == 2))
    figure; hold on; box on; title([title_string ' eggs laid on 200 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub >= i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'g','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2-5)),8,'sk','fill');
            store_prev = (eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2;
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),6,'sk','fill');
            p = ranksum(store_prev,(eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2,'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = (eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2;
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel('Dwell times in transitions before egg-laying (0 is the egg-laying transition)');
    ylabel({'Log2 dwell time (seconds)', 'Median labeled in black', 'Median -5 also shown for T0'});
end
% for 500mM
if(any(eggs.all_substrates == 5))
    figure; hold on; box on; title([title_string ' eggs laid on 500 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub >= i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'b','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2-5)),8,'sk','fill');
            store_prev = (eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2;
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),6,'sk','fill');
            p = ranksum(store_prev,(eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2,'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = (eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2;
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel('Dwell times in transitions before egg-laying (0 is the egg-laying transition)');
    ylabel({'Log2 dwell time (seconds)', 'Median labeled in black', 'Median -5 also shown for T0'});
end

%% Distance on substrates for egg -laying transition and previous dwell times (as violin plots)

% for 0mM
if(any(eggs.all_substrates == 0))
    figure; hold on; box on; title([title_string ' eggs laid on 0 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub >= i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)),3,'r','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1))),6,'sk','fill');
            store_prev = eggs.etrans_dist_sub(a,1);
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),3,col,'fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))),6,'sk','fill');
            p = ranksum(store_prev,eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1),'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1);
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel('Dwell distances in transitions before egg-laying (0 is the egg-laying transition)');
    ylabel({'Log2 dwell distance (mm)', 'Median labeled in black'});
end
% for 200mM
if(any(eggs.all_substrates == 2))
    figure; hold on; box on; title([title_string ' eggs laid on 200 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub >= i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)),3,'g','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1))),6,'sk','fill');
            store_prev = eggs.etrans_dist_sub(a,1);
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),3,col,'fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))),6,'sk','fill');
            p = ranksum(store_prev,eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1),'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1);
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel('Dwell distances in transitions before egg-laying (0 is the egg-laying transition)');
    ylabel({'Log2 dwell distance (mm)', 'Median labeled in black'});
end
% for 500mM
if(any(eggs.all_substrates == 5))
    figure; hold on; box on; title([title_string ' eggs laid on 500 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 5 & eggs.explore_trans_sub >= i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)),3,'b','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1))),6,'sk','fill');
            store_prev = eggs.etrans_dist_sub(a,1);
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),3,col,'fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))),6,'sk','fill');
            p = ranksum(store_prev,eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1),'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1);
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel('Dwell distances in transitions before egg-laying (0 is the egg-laying transition)');
    ylabel({'Log2 dwell distance (mm)', 'Median labeled in black'});
end

%% Speed on substrates for egg -laying transition and previous dwell times (as violin plots)

% for 0mM
if(any(eggs.all_substrates == 0))
    figure; hold on; box on; title([title_string ' eggs laid on 0 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub >= i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),3,'r','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2))),6,'sk','fill');
            store_prev = (eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2));
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2))),6,'sk','fill');
            p = ranksum(store_prev,((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'tail','right');
            text(i-2,1.3+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[1.2+i*.1 1.2+i*.1],'Color','k');
            store_prev = ((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2));
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[-2 4]);
    set(gca,'ytick',[-2:1:4]);
    set(gca,'yticklabel',2.^([-2:1:4]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel('Speed in transitions before egg-laying (0 is the egg-laying transition)');
    ylabel({'Log2 speed (mm/sec)', 'Median labeled in black'});
end
% for 200mM
if(any(eggs.all_substrates == 2))
    figure; hold on; box on; title([title_string ' eggs laid on 200 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub >= i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),3,'g','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2))),6,'sk','fill');
            store_prev = (eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2));
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2))),6,'sk','fill');
            p = ranksum(store_prev,((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'tail','right');
            text(i-2,1.3+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[1.2+i*.1 1.2+i*.1],'Color','k');
            store_prev = ((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2));
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[-2 4]);
    set(gca,'ytick',[-2:1:4]);
    set(gca,'yticklabel',2.^([-2:1:4]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel('Speed in transitions before egg-laying (0 is the egg-laying transition)');
    ylabel({'Log2 speed (mm/sec)', 'Median labeled in black'});
end

% for 500mM
if(any(eggs.all_substrates == 5))
    figure; hold on; box on; title([title_string ' eggs laid on 500 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub >= i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),3,'b','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2))),6,'sk','fill');
            store_prev = (eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2));
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2))),6,'sk','fill');
            p = ranksum(store_prev,((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'tail','right');
            text(i-2,1.3+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[1.2+i*.1 1.2+i*.1],'Color','k');
            store_prev = ((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2));
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[-2 4]);
    set(gca,'ytick',[-2:1:4]);
    set(gca,'yticklabel',2.^([-2:1:4]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel('Speed in transitions before egg-laying (0 is the egg-laying transition)');
    ylabel({'Log2 speed (mm/sec)', 'Median labeled in black'});
end

%% Duration on substrates for egg -laying transition and previous dwell times, not including first transition into a substrate (as violin plots)

% for 0mM
if(any(eggs.all_substrates == 0))
    figure; hold on; box on; title([title_string ' eggs laid on 0 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub > i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'r','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2-5)),8,'sk','fill');
            store_prev = (eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2;
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),6,'sk','fill');
            p = ranksum(store_prev,(eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2,'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = (eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2;
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel({'Dwell times in transitions before egg-laying (0 is the egg-laying transition)',' not including first transition into a substrate'});
    ylabel({'Log2 dwell time (seconds)', 'Median labeled in black', 'Median -5 also shown for T0'});
end
% for 200mM
if(any(eggs.all_substrates == 2))
    figure; hold on; box on; title([title_string ' eggs laid on 200 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub > i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'g','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2-5)),8,'sk','fill');
            store_prev = (eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2;
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),6,'sk','fill');
            p = ranksum(store_prev,(eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2,'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = (eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2;
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel({'Dwell times in transitions before egg-laying (0 is the egg-laying transition)',' not including first transition into a substrate'});
    ylabel({'Log2 dwell time (seconds)', 'Median labeled in black', 'Median -5 also shown for T0'});
end
% for 500mM
if(any(eggs.all_substrates == 5))
    figure; hold on; box on; title([title_string ' eggs laid on 500 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub > i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),3,'b','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),6,'sk','fill');
            scatter(i-1,median(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2-5)),8,'sk','fill');
            store_prev = (eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2;
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),6,'sk','fill');
            p = ranksum(store_prev,(eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2,'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = (eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2;
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel({'Dwell times in transitions before egg-laying (0 is the egg-laying transition)',' not including first transition into a substrate'});
    ylabel({'Log2 dwell time (seconds)', 'Median labeled in black', 'Median -5 also shown for T0'});
end

%% Distance on substrates for egg -laying transition and previous dwell times, not including first transition into a substrate  (as violin plots)

% for 0mM
if(any(eggs.all_substrates == 0))
    figure; hold on; box on; title([title_string ' eggs laid on 0 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub > i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)),3,'r','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1))),6,'sk','fill');
            store_prev = eggs.etrans_dist_sub(a,1);
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),3,col,'fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))),6,'sk','fill');
            p = ranksum(store_prev,eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1),'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1);
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel({'Dwell distances in transitions before egg-laying (0 is the egg-laying transition)',' not including first transition into a substrate'});
    ylabel({'Log2 dwell distance (mm)', 'Median labeled in black'});
end
% for 200mM
if(any(eggs.all_substrates == 2))
    figure; hold on; box on; title([title_string ' eggs laid on 200 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub > i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)),3,'g','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1))),6,'sk','fill');
            store_prev = eggs.etrans_dist_sub(a,1);
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),3,col,'fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))),6,'sk','fill');
            p = ranksum(store_prev,eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1),'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1);
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel({'Dwell distances in transitions before egg-laying (0 is the egg-laying transition)',' not including first transition into a substrate'});
    ylabel({'Log2 dwell distance (mm)', 'Median labeled in black'});
end
% for 500mM
if(any(eggs.all_substrates == 5))
    figure; hold on; box on; title([title_string ' eggs laid on 500 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 5 & eggs.explore_trans_sub > i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)),3,'b','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1))),6,'sk','fill');
            store_prev = eggs.etrans_dist_sub(a,1);
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1)),3,col,'fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))),6,'sk','fill');
            p = ranksum(store_prev,eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1),'tail','right');
            text(i-2,5.1+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[5+i*.1 5+i*.1],'Color','k');
            store_prev = eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1);
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[0 8]);
    set(gca,'ytick',[0:1:8]);
    set(gca,'yticklabel',2.^([0:1:8]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel({'Dwell distances in transitions before egg-laying (0 is the egg-laying transition)',' not including first transition into a substrate'});
    ylabel({'Log2 dwell distance (mm)', 'Median labeled in black'});
end

%% Speed on substrates for egg -laying transition and previous dwell times, not including first transition into a substrate  (as violin plots)

% for 0mM
if(any(eggs.all_substrates == 0))
    figure; hold on; box on; title([title_string ' eggs laid on 0 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub > i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),3,'r','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2))),6,'sk','fill');
            store_prev = (eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2));
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2))),6,'sk','fill');
            p = ranksum(store_prev,((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'tail','right');
            text(i-2,1.3+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[1.2+i*.1 1.2+i*.1],'Color','k');
            store_prev = ((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2));
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[-2 4]);
    set(gca,'ytick',[-2:1:4]);
    set(gca,'yticklabel',2.^([-2:1:4]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel({'Speed in transitions before egg-laying (0 is the egg-laying transition)',' not including first transition into a substrate'});
    ylabel({'Log2 speed (mm/sec)', 'Median labeled in black'});
end
% for 200mM
if(any(eggs.all_substrates == 2))
    figure; hold on; box on; title([title_string ' eggs laid on 200 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub > i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),3,'g','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2))),6,'sk','fill');
            store_prev = (eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2));
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2))),6,'sk','fill');
            p = ranksum(store_prev,((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'tail','right');
            text(i-2,1.3+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[1.2+i*.1 1.2+i*.1],'Color','k');
            store_prev = ((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2));
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[-2 4]);
    set(gca,'ytick',[-2:1:4]);
    set(gca,'yticklabel',2.^([-2:1:4]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel({'Speed in transitions before egg-laying (0 is the egg-laying transition)',' not including first transition into a substrate'});
    ylabel({'Log2 speed (mm/sec)', 'Median labeled in black'});
end

% for 500mM
if(any(eggs.all_substrates == 5))
    figure; hold on; box on; title([title_string ' eggs laid on 500 mM']);
    for i =1:1:8
        [a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub > i);
        if(~isempty(a) && i == 1)
            distributionPlot(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            scatter(i-1+rand(length(a),1).*.25-.125, log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2)),3,'b','fill');
            scatter(i-1,median(log2(eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2))),6,'sk','fill');
            store_prev = (eggs.etrans_dist_sub(a,1)./((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2));
        end
        if(~isempty(a) && i > 1)
            distributionPlot(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'histOpt',1.1,'xValues',i-1,'color',[.8 .8 .8],'showMM',0);
            col = [];
            for j =1:1:length(a)
                colr = trx(1,eggs.fly(a(j))).sucrose(eggs.etrans_time_sub(a(j),i));
                if(colr == 0)
                    col = [col; [1,0,0]];
                end
                if(colr == 2)
                    col = [col; [0,1,0]];
                end
                if(colr == 5)
                    col = [col; [0,0,1]];
                end
            end
            scatter(i-1+rand(length(a),1).*.25-.125, log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),3,col,'fill');
            scatter(i-1,median(log2((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2))),6,'sk','fill');
            p = ranksum(store_prev,((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2)),'tail','right');
            text(i-2,1.3+i*.3,['p ' num2str(i-2) '>' num2str(i-1) ' =' num2str(p)],'Fontsize',8);
            line([i-2,i-1],[1.2+i*.1 1.2+i*.1],'Color','k');
            store_prev = ((eggs.etrans_dist_sub(a,i)-eggs.etrans_dist_sub(a,i-1))./((eggs.etrans_time_sub(a,i-1)-eggs.etrans_time_sub(a,i))./2));
        end
    end
    
    
    set(gca,'xlim',[-.5,7.5]);
    set(gca,'ylim',[-2 4]);
    set(gca,'ytick',[-2:1:4]);
    set(gca,'yticklabel',2.^([-2:1:4]));
    set(gca,'xtick',[0:1:7]);
    grid on;
    xlabel({'Speed in transitions before egg-laying (0 is the egg-laying transition)',' not including first transition into a substrate'});
    ylabel({'Log2 speed (mm/sec)', 'Median labeled in black'});
end

%% Scatter plots of time since chamber entering for all eggs

figure; hold on; box on; title(title_string);

[a , ~] =find(eggs.substrate == 0);
if(~isempty(a))
    distributionPlot((eggs.egg_time(a))./7200,'histOpt',1.1,'xValues',1,'color',[.8 .8 .8],'showMM',0);
    scatter(1+rand(length(a),1).*.8-.4, (eggs.egg_time(a))./7200,2,'r','fill')
    scatter(1,median((eggs.egg_time(a))./7200),20,'sk','fill');
end

[a1 , ~] =find(eggs.substrate == 2);
if(~isempty(a1))
    distributionPlot((eggs.egg_time(a1))./7200,'histOpt',1.1,'xValues',2,'color',[.8 .8 .8],'showMM',0);
    scatter(2+rand(length(a1),1).*.8-.4, (eggs.egg_time(a1))./7200,2,'g','fill')
    scatter(2,median((eggs.egg_time(a1))./7200),20,'sk','fill');
end

[a2 , ~] =find(eggs.substrate == 5);
if(~isempty(a2))
    distributionPlot((eggs.egg_time(a2))./7200,'histOpt',1.1,'xValues',3,'color',[.8 .8 .8],'showMM',0);
    scatter(3+rand(length(a2),1).*.8-.4, (eggs.egg_time(a2))./7200,2,'b','fill')
    scatter(3,median((eggs.egg_time(a2))./7200),20,'sk','fill');
end

if(~isempty(a) && ~isempty(a1))
    p = ranksum((eggs.egg_time(a))./7200,(eggs.egg_time(a1))./7200,'tail','right');
    text(1.4,14,['p=' num2str(p)],'Fontsize',8);
    line([1,2],[13,13],'Color','k');
end

if(~isempty(a1) && ~isempty(a2))
    p = ranksum((eggs.egg_time(a1))./7200,(eggs.egg_time(a2))./7200,'tail','right');
    text(2.4,11,['p=' num2str(p)],'Fontsize',8);
    line([2,3],[10,10],'Color','k');
end

if(~isempty(a) && ~isempty(a2))
    p = ranksum((eggs.egg_time(a))./7200,(eggs.egg_time(a2))./7200,'tail','right');
    text(1.9,18,['p=' num2str(p)],'Fontsize',8);
    line([1,3],[17,17],'Color','k');
end

[a3 , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub > 0);
if(~isempty(a3))
    distributionPlot((eggs.egg_time(a3))./7200,'histOpt',1.1,'xValues',4,'color',[.8 .8 .8],'showMM',0);
    scatter(4+rand(length(a3),1).*.8-.4, (eggs.egg_time(a3))./7200,2,'r','fill')
    scatter(4,median((eggs.egg_time(a3))./7200),20,'sk','fill');
end

[a4 , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub > 0);
if(~isempty(a4))
    distributionPlot((eggs.egg_time(a4))./7200,'histOpt',1.1,'xValues',5,'color',[.8 .8 .8],'showMM',0);
    scatter(5+rand(length(a4),1).*.8-.4, (eggs.egg_time(a4))./7200,2,'g','fill')
    scatter(5,median((eggs.egg_time(a4))./7200),20,'sk','fill');
end

[a5 , ~] =find(eggs.substrate == 5 & eggs.explore_trans_sub > 0);
if(~isempty(a5))
    distributionPlot((eggs.egg_time(a5))./7200,'histOpt',1.1,'xValues',6,'color',[.8 .8 .8],'showMM',0);
    scatter(6+rand(length(a5),1).*.8-.4, (eggs.egg_time(a5))./7200,2,'b','fill')
    scatter(6,median((eggs.egg_time(a5))./7200),20,'sk','fill');
end

if(~isempty(a3) && ~isempty(a4))
    p = ranksum((eggs.egg_time(a3))./7200,(eggs.egg_time(a4))./7200,'tail','right');
    text(4.4,14,['p=' num2str(p)],'Fontsize',8);
    line([4,5],[13,13],'Color','k');
end

if(~isempty(a4) && ~isempty(a5))
    p = ranksum((eggs.egg_time(a4))./7200,(eggs.egg_time(a5))./7200,'tail','right');
    text(5.4,11,['p=' num2str(p)],'Fontsize',8);
    line([5,6],[10,10],'Color','k');
end

if(~isempty(a3) && ~isempty(a5))
    p = ranksum((eggs.egg_time(a3))./7200,(eggs.egg_time(a5))./7200,'tail','right');
    text(4.9,18,['p=' num2str(p)],'Fontsize',8);
    line([4,6],[17,17],'Color','k');
end

ylabel({'Time since entering chamber (hours)', 'All eggs (actual substrate transitions)'});
set(gca,'xtick',[1 2 3 4 5 6]);
set(gca,'xticklabel',{'0 mM','200 mM','500 mM','0 w/subtran','200 w/subtran','500 w/subtran' });
set(gca,'ylim',[0, 20]);

%% Scatter plots of time from last transition to egg for all eggs (0/0/200)

if(strcmp(title_string,'0 0 200'))
    figure; hold on; box on; title(title_string);
    
    [a , ~] =find(eggs.substrate == 0);
    distributionPlot(log2((eggs.egg_time(a)-(eggs.last200(a)+1))./2),'histOpt',1.1,'xValues',1,'color',[.8 .8 .8],'showMM',0);
    scatter(1+rand(length(a),1).*.5-.25, log2((eggs.egg_time(a)-(eggs.last200(a)+1))./2),2,'r','fill')
    
    [a2 , ~] =find(eggs.substrate == 0);
    distributionPlot(log2((eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2),'histOpt',1.1,'xValues',2,'color',[.8 .8 .8],'showMM',0);
    scatter(2+rand(length(a2),1).*.5-.25, log2((eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2),2,'r','fill')
    
    [a1 , ~] =find(eggs.substrate == 2);
    distributionPlot(log2((eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2),'histOpt',1.1,'xValues',3,'color',[.8 .8 .8],'showMM',0);
    scatter(3+rand(length(a1),1).*.5-.25, log2((eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2),2,'g','fill')
    
    p = ranksum((eggs.egg_time(a)-(eggs.last200(a)+1))./2,(eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2,'tail','left');
    text(1.75,14,['p=' num2str(p)],'Fontsize',8);
    line([1,3],[13,13],'Color','k');
    
    ylabel({'Log2 time from last transition to egg-laying', 'event (seconds) All eggs'});
    set(gca,'xtick',[1 2 3]);
    set(gca,'xticklabel',{'200->0','0/200->0', '0->200'});
    set(gca,'ytick',[0:1:16]);
    set(gca,'yticklabel',2.^([0:1:16]));
    grid on;
end

%% Scatter plots of time from last transition to egg for all eggs (0/500/200)

if(strcmp(title_string,'0 500 200'))
    
    figure; hold on; box on; title(title_string);
    
    [a , ~] =find(eggs.substrate == 0);
    distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time(a,1))./2),'histOpt',1.1,'xValues',1,'color',[.8 .8 .8],'showMM',0);
    scatter(1+rand(length(a),1).*.5-.25, log2((eggs.egg_time(a)-eggs.etrans_time(a,1))./2),2,'r','fill')
    
    [a5 , ~] =find(eggs.substrate == 0);
    distributionPlot(log2((eggs.egg_time(a5)-(1+eggs.last200(a5,1)))./2),'histOpt',1.1,'xValues',2,'color',[.8 .8 .8],'showMM',0);
    scatter(2+rand(length(a5),1).*.5-.25, log2((eggs.egg_time(a5)-(1+eggs.last200(a5,1)))./2),2,'r','fill')
    
    [a1 , ~] =find(eggs.substrate == 2);
    distributionPlot(log2((eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2),'histOpt',1.1,'xValues',3,'color',[.8 .8 .8],'showMM',0);
    scatter(3+rand(length(a1),1).*.5-.25, log2((eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2),2,'g','fill')
    
    [a4 , ~] =find(eggs.substrate == 2);
    distributionPlot(log2((eggs.egg_time(a4)-(1+eggs.last0(a4)))./2),'histOpt',1.1,'xValues',4,'color',[.8 .8 .8],'showMM',0);
    scatter(4+rand(length(a4),1).*.5-.25, log2((eggs.egg_time(a4)-(1+eggs.last0(a4)))./2),2,'g','fill')
    
    [a6 , ~] =find(eggs.substrate == 5);
    distributionPlot(log2((eggs.egg_time(a6)-eggs.etrans_time(a6,1))./2),'histOpt',1.1,'xValues',5,'color',[.8 .8 .8],'showMM',0);
    scatter(5+rand(length(a6),1).*.5-.25, log2((eggs.egg_time(a6)-eggs.etrans_time(a6,1))./2),2,'b','fill')
    
    [a2 , ~] =find(eggs.substrate == 5 & ((eggs.last200+1) == eggs.etrans_time(:,1)));
    distributionPlot(log2((eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2),'histOpt',1.1,'xValues',6,'color',[.8 .8 .8],'showMM',0);
    scatter(6+rand(length(a2),1).*.5-.25, log2((eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2),2,'b','fill')
    
    [a3 , ~] =find(eggs.substrate == 5 & ((eggs.last0+1) == eggs.etrans_time(:,1)));
    distributionPlot(log2((eggs.egg_time(a3)-eggs.etrans_time(a3,1))./2),'histOpt',1.1,'xValues',7,'color',[.8 .8 .8],'showMM',0);
    scatter(7+rand(length(a3),1).*.5-.25, log2((eggs.egg_time(a3)-eggs.etrans_time(a3,1))./2),2,'b','fill')
    
    ylabel({'Log2 time from last transition to egg-laying', 'event (seconds) All eggs'});
    set(gca,'xtick',[1 2 3 4 5 6 7]);
    set(gca,'xticklabel',{'500->0','200->0', '500->200', '0->200', '0/200->500', '200->500', '0->500'});
    set(gca,'ytick',[0:1:16]);
    set(gca,'yticklabel',2.^([0:1:16]));
    p = ranksum((eggs.egg_time(a)-eggs.etrans_time(a,1))./2,(eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2,'tail','left');
    text(1.75,14,['p=' num2str(p)],'Fontsize',8);
    line([1,3],[13,13],'Color','k');
    p = ranksum((eggs.egg_time(a5)-(1+eggs.last200(a5,1)))./2,(eggs.egg_time(a4)-(1+eggs.last0(a4)))./2,'tail','left');
    text(2.75,12,['p=' num2str(p)],'Fontsize',8);
    line([2,4],[11,11],'Color','k');
    grid on;
end

%% Scatter plots of time from last transition to egg for all eggs (0/500/500)

if(strcmp(title_string,'0 500 500'))
    
    figure; hold on; box on; title(title_string);
    
    [a , ~] =find(eggs.substrate == 0);
    distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time(a,1))./2),'histOpt',1.1,'xValues',1,'color',[.8 .8 .8],'showMM',0);
    scatter(1+rand(length(a),1).*.5-.25, log2((eggs.egg_time(a)-eggs.etrans_time(a,1))./2),2,'r','fill')
    
    [a1 , ~] =find(eggs.substrate == 5);
    distributionPlot(log2((eggs.egg_time(a1)-eggs.etrans_time(a1))./2),'histOpt',1.1,'xValues',2,'color',[.8 .8 .8],'showMM',0);
    scatter(2+rand(length(a1),1).*.5-.25, log2((eggs.egg_time(a1)-eggs.etrans_time(a1))./2),2,'b','fill')
    
    [a2 , ~] =find(eggs.substrate == 5);
    distributionPlot(log2((eggs.egg_time(a2)-(1+eggs.last0(a2)))./2),'histOpt',1.1,'xValues',3,'color',[.8 .8 .8],'showMM',0);
    scatter(3+rand(length(a2),1).*.5-.25, log2((eggs.egg_time(a2)-(1+eggs.last0(a2)))./2),2,'b','fill')
    
    ylabel({'Log2 time from last transition to egg-laying', 'event (seconds) All eggs'});
    set(gca,'xtick',[1 2 3]);
    set(gca,'xticklabel',{'500->0','0/500->500','0->500'});
    set(gca,'ytick',[0:1:16]);
    set(gca,'yticklabel',2.^([0:1:16]));
    p = ranksum((eggs.egg_time(a)-eggs.etrans_time(a,1))./2,(eggs.egg_time(a2)-(1+eggs.last0(a2)))./2,'tail','left');
    text(1.75,12,['p=' num2str(p)],'Fontsize',8);
    line([1,3],[11,11],'Color','k');
    grid on;
end

%% Scatter plots of time from last transition to egg for all eggs (200/500/500)

if(strcmp(title_string,'200 500 500'))
    
    figure; hold on; box on; title(title_string);
    
    [a , ~] =find(eggs.substrate == 2);
    distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time(a,1))./2),'histOpt',1.1,'xValues',1,'color',[.8 .8 .8],'showMM',0);
    scatter(1+rand(length(a),1).*.5-.25, log2((eggs.egg_time(a)-eggs.etrans_time(a,1))./2),2,'g','fill')
    
    [a1 , ~] =find(eggs.substrate == 5);
    distributionPlot(log2((eggs.egg_time(a1)-eggs.etrans_time(a1))./2),'histOpt',1.1,'xValues',2,'color',[.8 .8 .8],'showMM',0);
    scatter(2+rand(length(a1),1).*.5-.25, log2((eggs.egg_time(a1)-eggs.etrans_time(a1))./2),2,'b','fill')
    
    [a2 , ~] =find(eggs.substrate == 5);
    distributionPlot(log2((eggs.egg_time(a2)-(1+eggs.last200(a2)))./2),'histOpt',1.1,'xValues',3,'color',[.8 .8 .8],'showMM',0);
    scatter(3+rand(length(a2),1).*.5-.25, log2((eggs.egg_time(a2)-(1+eggs.last200(a2)))./2),2,'b','fill')
    
    ylabel({'Log2 time from last transition to egg-laying', 'event (seconds) All eggs'});
    set(gca,'xtick',[1 2 3]);
    set(gca,'xticklabel',{'500->200','200/500->500', '200->500'});
    set(gca,'ytick',[0:1:16]);
    set(gca,'yticklabel',2.^([0:1:16]));
    p = ranksum((eggs.egg_time(a)-eggs.etrans_time(a,1))./2,(eggs.egg_time(a2)-(1+eggs.last200(a2)))./2,'tail','left');
    text(1.75,12,['p=' num2str(p)],'Fontsize',8);
    line([1,3],[11,11],'Color','k');
    grid on;
end

%% Scatter plots of time from last transition to egg for all eggs (500/0/200)

if(strcmp(title_string,'500 0 200'))
    
    figure; hold on; box on; title(title_string);
    
    [a3 , ~] =find(eggs.substrate == 0);
    distributionPlot(log2((eggs.egg_time(a3)-eggs.etrans_time(a3,1))./2),'histOpt',1.1,'xValues',1,'color',[.8 .8 .8],'showMM',0);
    scatter(1+rand(length(a3),1).*.5-.25, log2((eggs.egg_time(a3)-eggs.etrans_time(a3,1))./2),2,'r','fill')
    
    [a , ~] =find(eggs.substrate == 0 & (eggs.last200 +1) == eggs.etrans_time(:,1));
    distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time(a,1))./2),'histOpt',1.1,'xValues',2,'color',[.8 .8 .8],'showMM',0);
    scatter(2+rand(length(a),1).*.5-.25, log2((eggs.egg_time(a)-eggs.etrans_time(a,1))./2),2,'r','fill')
    
    [a0 , ~] =find(eggs.substrate == 0 & (eggs.last500 +1) == eggs.etrans_time(:,1));
    distributionPlot(log2((eggs.egg_time(a0)-eggs.etrans_time(a0,1))./2),'histOpt',1.1,'xValues',3,'color',[.8 .8 .8],'showMM',0);
    scatter(3+rand(length(a0),1).*.5-.25, log2((eggs.egg_time(a0)-eggs.etrans_time(a0,1))./2),2,'r','fill')
    
    [a1 , ~] =find(eggs.substrate == 2);
    distributionPlot(log2((eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2),'histOpt',1.1,'xValues',4,'color',[.8 .8 .8],'showMM',0);
    scatter(4+rand(length(a1),1).*.5-.25, log2((eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2),2,'g','fill')
    
    [a2 , ~] =find(eggs.substrate == 5);
    distributionPlot(log2((eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2),'histOpt',1.1,'xValues',5,'color',[.8 .8 .8],'showMM',0);
    scatter(5+rand(length(a2),1).*.5-.25, log2((eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2),2,'b','fill')
    
    ylabel({'Log2 time from last transition to egg-laying', 'event (seconds) All eggs'});
    set(gca,'xtick',[1 2 3 4 5]);
    set(gca,'xticklabel',{'200/500->0', '200->0','500->0','0->200', '0->500'});
    set(gca,'ytick',[0:1:16]);
    set(gca,'yticklabel',2.^([0:1:16]));
    p = ranksum((eggs.egg_time(a3)-eggs.etrans_time(a3,1))./2,(eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2,'tail','left');
    text(1.75,11,['p=' num2str(p)],'Fontsize',8);
    line([1,4],[10,10],'Color','k');
    p = ranksum((eggs.egg_time(a3)-eggs.etrans_time(a3,1))./2,(eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2,'tail','left');
    text(2.75,13,['p=' num2str(p)],'Fontsize',8);
    line([1,5],[12,12],'Color','k');
    grid on;
end

%% Scatter plots of time from last transition to egg for all eggs (500/0/500)
if(strcmp(title_string,'500 0 500'))
    
    figure; hold on; box on; title(title_string);
    
    [a3 , ~] =find(eggs.substrate == 0);
    distributionPlot(log2((eggs.egg_time(a3)-eggs.etrans_time(a3,1))./2),'histOpt',1.1,'xValues',1,'color',[.8 .8 .8],'showMM',0);
    scatter(1+rand(length(a3),1).*.5-.25, log2((eggs.egg_time(a3)-eggs.etrans_time(a3,1))./2),2,'r','fill')
    
    [a2 , ~] =find(eggs.substrate == 5);
    distributionPlot(log2((eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2),'histOpt',1.1,'xValues',2,'color',[.8 .8 .8],'showMM',0);
    scatter(2+rand(length(a2),1).*.5-.25, log2((eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2),2,'b','fill')
    
    ylabel({'Log2 time from last transition to egg-laying', 'event (seconds) All eggs'});
    set(gca,'xtick',[1 2]);
    set(gca,'xticklabel',{'500->0', '0->500'});
    set(gca,'ytick',[0:1:16]);
    set(gca,'yticklabel',2.^([0:1:16]));
    p = ranksum((eggs.egg_time(a3)-eggs.etrans_time(a3,1))./2,(eggs.egg_time(a2)-eggs.etrans_time(a2,1))./2,'tail','left');
    text(1.2,13,['p=' num2str(p)],'Fontsize',8);
    line([1,2],[12,12],'Color','k');
    grid on;
end

%% Scatter plots of time from last transition to egg for all eggs (2 choice chamber)
if(eggs.chamber_style == 2)
    figure; hold on; box on; title(title_string);
    
    [a , ~] =find(eggs.substrate == eggs.first_substrate);
    distributionPlot(log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),'histOpt',1.1,'xValues',1,'color',[.8 .8 .8],'showMM',0);
    if(eggs.first_substrate == 0)
        scatter(1+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),2,'r','fill')
    end
    if(eggs.first_substrate == 2)
        scatter(1+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),2,'g','fill')
    end
    if(eggs.first_substrate == 5)
        scatter(1+rand(length(a),1).*.25-.125, log2((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2),2,'b','fill')
    end
    [a1 , ~] =find(eggs.substrate == eggs.second_substrate);
    distributionPlot(log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),'histOpt',1.1,'xValues',2,'color',[.8 .8 .8],'showMM',0);
    if(eggs.second_substrate == 0)
        scatter(2+rand(length(a1),1).*.25-.125, log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),2,'r','fill')
    end
    if(eggs.second_substrate == 2)
        scatter(2+rand(length(a1),1).*.25-.125, log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),2,'g','fill')
    end
    if(eggs.second_substrate == 5)
        scatter(2+rand(length(a1),1).*.25-.125, log2((eggs.egg_time(a1)-eggs.etrans_time_sub(a1,1))./2),2,'b','fill')
    end
    
    ylabel({'Log2 time from last actual transition to egg-laying', 'event (seconds) All eggs'});
    set(gca,'xtick',[1 2]);
    set(gca,'xticklabel',{'bad->good','good->bad'});
    set(gca,'ytick',[0:1:16]);
    set(gca,'yticklabel',2.^([0:1:16]));
    p = ranksum((eggs.egg_time(a)-eggs.etrans_time(a,1))./2,(eggs.egg_time(a1)-eggs.etrans_time(a1,1))./2,'tail','left');
    text(1.2,13,['p=' num2str(p)],'Fontsize',8);
    line([1,2],[12,12],'Color','k');
    grid on;
end

%% Egg distribution in smoothing window over experiment time
z_0 = zeros(1,24*60*60*2);
z_200 = zeros(1,24*60*60*2);
z_500 = zeros(1,24*60*60*2);

[a , ~] = find(eggs.substrate == 0);
z_0(eggs.egg_time(a)) = z_0(eggs.egg_time(a))+1;

[a , ~] = find(eggs.substrate == 2);
z_200(eggs.egg_time(a)) = z_200(eggs.egg_time(a))+1;

[a , ~] = find(eggs.substrate == 5);
z_500(eggs.egg_time(a)) = z_500(eggs.egg_time(a))+1;

figure; hold on; box on; title(title_string);
plot((1:1:length(z_0)),smooth(z_0,7200).*7200,'r','linewidth',1);
plot((1:1:length(z_200)),smooth(z_200,7200).*7200,'g','linewidth',1);
plot((1:1:length(z_500)),smooth(z_500,7200).*7200,'b','linewidth',1);
ylabel({'Occurances of egg-laying events (eggs / hour) all flies combined' , 'smooth 60 min'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:7200:20*7200);
set(gca,'xticklabel',0:1:20);
set(gca,'xlim',[0 20*7200]);

figure; hold on; box on; title(title_string);
plot((1:1:length(z_0)),smooth(z_0,7200)./sum(smooth(z_0,7200)),'r','linewidth',1);
plot((1:1:length(z_200)),smooth(z_200,7200)./sum(smooth(z_200,7200)),'g','linewidth',1);
plot((1:1:length(z_500)),smooth(z_500,7200)./sum(smooth(z_500,7200)),'b','linewidth',1);
ylabel({'Normalized occurances of egg-laying events' , 'smooth 60 min'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:7200:20*7200);
set(gca,'xticklabel',0:1:20);
set(gca,'xlim',[0 20*7200]);

%% Egg distribution in smoothing window over experiment time (when fly has visited best and second best in exploration)
z_0 = zeros(1,24*60*60*2);
z_200 = zeros(1,24*60*60*2);
z_500 = zeros(1,24*60*60*2);

[a , ~] = find(eggs.substrate == 0 & eggs.explore_start_time < eggs.last_first & eggs.explore_start_time < eggs.last_second);
z_0(eggs.egg_time(a)) = z_0(eggs.egg_time(a))+1;

[a , ~] = find(eggs.substrate == 2 & eggs.explore_start_time < eggs.last_first & eggs.explore_start_time < eggs.last_second);
z_200(eggs.egg_time(a)) = z_200(eggs.egg_time(a))+1;

[a , ~] = find(eggs.substrate == 5 & eggs.explore_start_time < eggs.last_first & eggs.explore_start_time < eggs.last_second);
z_500(eggs.egg_time(a)) = z_500(eggs.egg_time(a))+1;

figure; hold on; box on; title(title_string);
plot((1:1:length(z_0)),smooth(z_0,7200).*7200,'r','linewidth',1);
plot((1:1:length(z_200)),smooth(z_200,7200).*7200,'g','linewidth',1);
plot((1:1:length(z_500)),smooth(z_500,7200).*7200,'b','linewidth',1);
ylabel({'Occurances of egg-laying events (eggs / hour) all flies combined',' (explorations where fly has visited best and second best option)', 'smooth 60 min'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:7200:20*7200);
set(gca,'xticklabel',0:1:20);
set(gca,'xlim',[0 20*7200]);

figure; hold on; box on; title(title_string);
plot((1:1:length(z_0)),smooth(z_0,7200)./sum(smooth(z_0,7200)),'r','linewidth',1);
plot((1:1:length(z_200)),smooth(z_200,7200)./sum(smooth(z_200,7200)),'g','linewidth',1);
plot((1:1:length(z_500)),smooth(z_500,7200)./sum(smooth(z_500,7200)),'b','linewidth',1);
ylabel({'Normalized of egg-laying events',' (explorations where fly has visited best and second best option)', 'smooth 60 min'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:7200:20*7200);
set(gca,'xticklabel',0:1:20);
set(gca,'xlim',[0 20*7200]);

%% Egg distribution in smoothing window over experiment time (when fly has visited best and second best in exploration) shifted by second egg (1st and 2nd egg not included)
z_0 = zeros(1,24*60*60*2);
z_200 = zeros(1,24*60*60*2);
z_500 = zeros(1,24*60*60*2);

c2 = 0;
for j = 1:1:max(eggs.fly)
    [a1 , ~] = find(eggs.fly == j);
    a1 = sort(a1);
    if(length(a1) > 1)
        a1 = a1(2:end);
        sub_eggtime = eggs.egg_time(a1) - (eggs.egg_time(a1(1))-1);
        [a , ~] = find(eggs.substrate(a1) == 0 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        z_0(sub_eggtime(a)) = z_0(sub_eggtime(a))+1;
        [a , ~] = find(eggs.substrate(a1) == 2 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        z_200(sub_eggtime(a)) = z_200(sub_eggtime(a))+1;
        [a , ~] = find(eggs.substrate(a1) == 5 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        z_500(sub_eggtime(a)) = z_500(sub_eggtime(a))+1;
    end
end

z_0 = z_0(2:end);
z_200 = z_200(2:end);
z_500 = z_500(2:end);

figure; hold on; box on; title(title_string);
plot((1:1:length(z_0)),smooth(z_0,7200).*7200,'r','linewidth',1);
plot((1:1:length(z_200)),smooth(z_200,7200).*7200,'g','linewidth',1);
plot((1:1:length(z_500)),smooth(z_500,7200).*7200,'b','linewidth',1);
ylabel({'Occurances of egg-laying events (eggs / hour) all flies combined shifted by second egg',' (explorations where fly has visited best and second best option)', 'smooth 60 min'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:7200:20*7200);
set(gca,'xticklabel',0:1:20);
set(gca,'xlim',[0 20*7200]);

figure; hold on; box on; title(title_string);
plot((1:1:length(z_0)),smooth(z_0,7200)./sum(smooth(z_0,7200)),'r','linewidth',1);
plot((1:1:length(z_200)),smooth(z_200,7200)./sum(smooth(z_200,7200)),'g','linewidth',1);
plot((1:1:length(z_500)),smooth(z_500,7200)./sum(smooth(z_500,7200)),'b','linewidth',1);
ylabel({'Normalized of egg-laying events shifted by second egg',' (explorations where fly has visited best and second best option)', 'smooth 60 min'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:7200:20*7200);
set(gca,'xticklabel',0:1:20);
set(gca,'xlim',[0 20*7200]);

%% Egg distribution in smoothing window over experiment time (when fly has visited best and second best in exploration) shifted by 1st egg (1st egg not included)
z_0 = zeros(1,24*60*60*2);
z_200 = zeros(1,24*60*60*2);
z_500 = zeros(1,24*60*60*2);

c2 = 0;
for j = 1:1:max(eggs.fly)
    [a1 , ~] = find(eggs.fly == j);
    a1 = sort(a1);
    if(~isempty(a1))
        sub_eggtime = eggs.egg_time(a1) - (eggs.egg_time(a1(1))-1);
        [a , ~] = find(eggs.substrate(a1) == 0 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        z_0(sub_eggtime(a)) = z_0(sub_eggtime(a))+1;
        [a , ~] = find(eggs.substrate(a1) == 2 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        z_200(sub_eggtime(a)) = z_200(sub_eggtime(a))+1;
        [a , ~] = find(eggs.substrate(a1) == 5 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        z_500(sub_eggtime(a)) = z_500(sub_eggtime(a))+1;
    end
end

z_0 = z_0(2:end);
z_200 = z_200(2:end);
z_500 = z_500(2:end);

figure; hold on; box on; title(title_string);
plot((1:1:length(z_0)),smooth(z_0,7200).*7200,'r','linewidth',1);
plot((1:1:length(z_200)),smooth(z_200,7200).*7200,'g','linewidth',1);
plot((1:1:length(z_500)),smooth(z_500,7200).*7200,'b','linewidth',1);
ylabel({'Occurances of egg-laying events (eggs / hour) all flies combined shifted by first egg',' (explorations where fly has visited best and second best option)', 'smooth 60 min'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:7200:20*7200);
set(gca,'xticklabel',0:1:20);
set(gca,'xlim',[0 20*7200]);

figure; hold on; box on; title(title_string);
plot((1:1:length(z_0)),smooth(z_0,7200)./sum(smooth(z_0,7200)),'r','linewidth',1);
plot((1:1:length(z_200)),smooth(z_200,7200)./sum(smooth(z_200,7200)),'g','linewidth',1);
plot((1:1:length(z_500)),smooth(z_500,7200)./sum(smooth(z_500,7200)),'b','linewidth',1);
ylabel({'Normalized of egg-laying events (eggs / hour) shifted by first egg',' (explorations where fly has visited best and second best option)', 'smooth 60 min'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:7200:20*7200);
set(gca,'xticklabel',0:1:20);
set(gca,'xlim',[0 20*7200]);

%% Scatter experiment time versus transition time for errors
figure; hold on; box on; title(title_string);

[a , ~] = find(eggs.substrate == 0);
scatter(eggs.egg_time(a)./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,15,'r','fill','markeredgecolor','k');

[a , ~] = find(eggs.substrate == 2);
scatter(eggs.egg_time(a)./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,15,'g','fill','markeredgecolor','k');

[a , ~] = find(eggs.substrate == 5);
scatter(eggs.egg_time(a)./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,15,'b','fill','markeredgecolor','k');

ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:1:20);
set(gca,'yscale','log');

%% Scatter clutch time versus transition time for errors
figure; hold on; box on; title(title_string);

c = 1;
store_i = [];
store_egg2 = [];
for i =1:1:max(eggs.fly)
    [a , ~] = find(eggs.fly == i);
    
    if(length(a) > 1)
        store_i(c) = i;
        store_egg2(c) = eggs.egg_time(a(2));
        
        [a , ~] = find(eggs.substrate == 0 & eggs.fly == i);
        scatter((eggs.egg_time(a)-store_egg2(c))./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,8,'r','fill','markeredgecolor','k');
        [a , ~] = find(eggs.substrate == 2 & eggs.fly == i);
        scatter((eggs.egg_time(a)-store_egg2(c))./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,8,'g','fill','markeredgecolor','k');
        [a , ~] = find(eggs.substrate == 5 & eggs.fly == i);
        scatter((eggs.egg_time(a)-store_egg2(c))./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,8,'b','fill','markeredgecolor','k');
        c = c+1;
    end
end

ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)'});
xlabel('Hours spent in chamber (starting from clutch, 2nd egg)');
set(gca,'xtick',0:1:10);
set(gca,'xlim',[0 10]);
set(gca,'yscale','log');

%% Scatter experiment time versus transition time with density contour
[a , ~] = find(eggs.substrate == 0);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on plain']);
    [n,c] = hist3([eggs.egg_time(a)./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggs.egg_time(a)./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)'});
    xlabel('Hours spent in chamber');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 20]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 10000]);
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 2);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 200mM']);
    [n,c] = hist3([eggs.egg_time(a)./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggs.egg_time(a)./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)'});
    xlabel('Hours spent in chamber');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 20]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 10000]);
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 5);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 500mM']);
    [n,c] = hist3([eggs.egg_time(a)./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggs.egg_time(a)./7200,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)'});
    xlabel('Hours spent in chamber');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 20]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 10000]);
    colormap(jet);
    colorbar;
end

%% Scatter experiment time versus transition time with density contour (when fly has visited best and second best in exploration) shifted by first egg
eggt_0 = [];
eggt_200 = [];
eggt_500 = [];

eggtra_0 = [];
eggtra_200 = [];
eggtra_500 = [];

c2 = 0;
for j = 1:1:max(eggs.fly)
    [a1 , ~] = find(eggs.fly == j);
    a1 = sort(a1);
    if(~isempty(a1))
        sub_eggtime = (eggs.egg_time(a1) - (eggs.egg_time(a1(1))-1))./7200;
        sub_transtime = (eggs.egg_time(a1) - eggs.etrans_time_sub(a1,1))./2;
        [a , ~] = find(eggs.substrate(a1) == 0 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        eggt_0 = [eggt_0; sub_eggtime(a)];
        eggtra_0 = [eggtra_0; sub_transtime(a)];
        [a , ~] = find(eggs.substrate(a1) == 2 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        eggt_200 = [eggt_200; sub_eggtime(a)];
        eggtra_200 = [eggtra_200; sub_transtime(a)];
        [a , ~] = find(eggs.substrate(a1) == 5 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        eggt_500 = [eggt_500; sub_eggtime(a)];
        eggtra_500 = [eggtra_500; sub_transtime(a)];
    end
end

if(~isempty(eggt_0))
    figure; hold on; box on; title([title_string ' Eggs laid on plain']);
    [n,c] = hist3([eggt_0,eggtra_0],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_0,eggtra_0,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'only eggs where fly has seen best and second best option in explore'});
    xlabel('Hours spent in chamber shifted by egg 1');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

if(~isempty(eggt_200))
    figure; hold on; box on; title([title_string ' Eggs laid on 200']);
    [n,c] = hist3([eggt_200,eggtra_200],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_200,eggtra_200,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'only eggs where fly has seen best and second best option in explore'});
    xlabel('Hours spent in chamber shifted by egg 1');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

if(~isempty(eggt_500))
    figure; hold on; box on; title([title_string ' Eggs laid on 500']);
    [n,c] = hist3([eggt_500,eggtra_500],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_500,eggtra_500,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'only eggs where fly has seen best and second best option in explore'});
    xlabel('Hours spent in chamber shifted by egg 1');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

%% Scatter experiment time versus transition time with density contour (when fly has visited best and second best in exploration) shifted by second egg (first egg not included)
eggt_0 = [];
eggt_200 = [];
eggt_500 = [];

eggtra_0 = [];
eggtra_200 = [];
eggtra_500 = [];

c2 = 0;
for j = 1:1:max(eggs.fly)
    [a1 , ~] = find(eggs.fly == j);
    a1 = sort(a1);
    if(length(a1) > 1)
        a1 = a1(2:end);
        sub_eggtime = (eggs.egg_time(a1) - (eggs.egg_time(a1(1))-1))./7200;
        sub_transtime = (eggs.egg_time(a1) - eggs.etrans_time_sub(a1,1))./2;
        [a , ~] = find(eggs.substrate(a1) == 0 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        eggt_0 = [eggt_0; sub_eggtime(a)];
        eggtra_0 = [eggtra_0; sub_transtime(a)];
        [a , ~] = find(eggs.substrate(a1) == 2 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        eggt_200 = [eggt_200; sub_eggtime(a)];
        eggtra_200 = [eggtra_200; sub_transtime(a)];
        [a , ~] = find(eggs.substrate(a1) == 5 & eggs.explore_start_time(a1) < eggs.last_first(a1) & eggs.explore_start_time(a1) < eggs.last_second(a1));
        eggt_500 = [eggt_500; sub_eggtime(a)];
        eggtra_500 = [eggtra_500; sub_transtime(a)];
    end
end

if(~isempty(eggt_0))
    figure; hold on; box on; title([title_string ' Eggs laid on plain']);
    [n,c] = hist3([eggt_0,eggtra_0],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_0,eggtra_0,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'only eggs where fly has seen best and second best option in explore'});
    xlabel('Hours spent in chamber shifted by egg 2');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

if(~isempty(eggt_200))
    figure; hold on; box on; title([title_string ' Eggs laid on 200']);
    [n,c] = hist3([eggt_200,eggtra_200],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_200,eggtra_200,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'only eggs where fly has seen best and second best option in explore'});
    xlabel('Hours spent in chamber shifted by egg 2');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

if(~isempty(eggt_500))
    figure; hold on; box on; title([title_string ' Eggs laid on 500']);
    [n,c] = hist3([eggt_500,eggtra_500],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_500,eggtra_500,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'only eggs where fly has seen best and second best option in explore'});
    xlabel('Hours spent in chamber shifted by egg 2');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

%% Scatter experiment time versus transition time with density contour (when fly has made actual substrate transition) shifted by first egg
eggt_0 = [];
eggt_200 = [];
eggt_500 = [];

eggtra_0 = [];
eggtra_200 = [];
eggtra_500 = [];

c2 = 0;
for j = 1:1:max(eggs.fly)
    [a1 , ~] = find(eggs.fly == j);
    a1 = sort(a1);
    if(~isempty(a1))
        sub_eggtime = (eggs.egg_time(a1) - (eggs.egg_time(a1(1))-1))./7200;
        sub_transtime = (eggs.egg_time(a1) - eggs.etrans_time_sub(a1,1))./2;
        [a , ~] = find(eggs.substrate(a1) == 0 & eggs.explore_trans_sub(a1) > 0);
        eggt_0 = [eggt_0; sub_eggtime(a)];
        eggtra_0 = [eggtra_0; sub_transtime(a)];
        [a , ~] = find(eggs.substrate(a1) == 2 & eggs.explore_trans_sub(a1) > 0);
        eggt_200 = [eggt_200; sub_eggtime(a)];
        eggtra_200 = [eggtra_200; sub_transtime(a)];
        [a , ~] = find(eggs.substrate(a1) == 5 & eggs.explore_trans_sub(a1) > 0);
        eggt_500 = [eggt_500; sub_eggtime(a)];
        eggtra_500 = [eggtra_500; sub_transtime(a)];
    end
end

if(~isempty(eggt_0))
    figure; hold on; box on; title([title_string ' Eggs laid on plain']);
    [n,c] = hist3([eggt_0,eggtra_0],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_0,eggtra_0,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'eggs with actual substrate transitions in explore'});
    xlabel('Hours spent in chamber shifted by egg 1');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

if(~isempty(eggt_200))
    figure; hold on; box on; title([title_string ' Eggs laid on 200']);
    [n,c] = hist3([eggt_200,eggtra_200],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_200,eggtra_200,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'eggs with actual substrate transitions in explore'});
    xlabel('Hours spent in chamber shifted by egg 1');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

if(~isempty(eggt_500))
    figure; hold on; box on; title([title_string ' Eggs laid on 500']);
    [n,c] = hist3([eggt_500,eggtra_500],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_500,eggtra_500,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'eggs with actual substrate transitions in explore'});
    xlabel('Hours spent in chamber shifted by egg 1');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

%% Scatter experiment time versus transition time with density contour (when fly has made actual substrate transition in exploration) shifted by second egg (first egg not included)
eggt_0 = [];
eggt_200 = [];
eggt_500 = [];

eggtra_0 = [];
eggtra_200 = [];
eggtra_500 = [];

c2 = 0;
for j = 1:1:max(eggs.fly)
    [a1 , ~] = find(eggs.fly == j);
    a1 = sort(a1);
    if(length(a1) > 1)
        a1 = a1(2:end);
        sub_eggtime = (eggs.egg_time(a1) - (eggs.egg_time(a1(1))-1))./7200;
        sub_transtime = (eggs.egg_time(a1) - eggs.etrans_time_sub(a1,1))./2;
        [a , ~] = find(eggs.substrate(a1) == 0 & eggs.explore_trans_sub(a1) > 0);
        eggt_0 = [eggt_0; sub_eggtime(a)];
        eggtra_0 = [eggtra_0; sub_transtime(a)];
        [a , ~] = find(eggs.substrate(a1) == 2 & eggs.explore_trans_sub(a1) > 0);
        eggt_200 = [eggt_200; sub_eggtime(a)];
        eggtra_200 = [eggtra_200; sub_transtime(a)];
        [a , ~] = find(eggs.substrate(a1) == 5 & eggs.explore_trans_sub(a1) > 0);
        eggt_500 = [eggt_500; sub_eggtime(a)];
        eggtra_500 = [eggtra_500; sub_transtime(a)];
    end
end

if(~isempty(eggt_0))
    figure; hold on; box on; title([title_string ' Eggs laid on plain']);
    [n,c] = hist3([eggt_0,eggtra_0],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_0,eggtra_0,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'eggs with actual substrate transitions in explore'});
    xlabel('Hours spent in chamber shifted by egg 2');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

if(~isempty(eggt_200))
    figure; hold on; box on; title([title_string ' Eggs laid on 200']);
    [n,c] = hist3([eggt_200,eggtra_200],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_200,eggtra_200,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'eggs with actual substrate transitions in explore'});
    xlabel('Hours spent in chamber shifted by egg 2');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

if(~isempty(eggt_500))
    figure; hold on; box on; title([title_string ' Eggs laid on 500']);
    [n,c] = hist3([eggt_500,eggtra_500],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggt_500,eggtra_500,1,'k');
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'eggs with actual substrate transitions in explore'});
    xlabel('Hours spent in chamber shifted by egg 2');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 12]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    colormap(jet);
    colorbar;
end

%% Percent time spent on best substrate in past X hours (before egg-laying transition) versus time from transition to egg-laying
X_hours = [1, .5, 1/6, 1/12, 1/30];
for j = 1:1:length(X_hours)
    figure; hold on; box on; title([title_string ' Eggs laid on best substrate']);
    [a , ~] = find(eggs.substrate == eggs.first_substrate & eggs.explore_trans_sub > 0 & eggs.etrans_time_sub(:,1) > (X_hours(j)*7200));
    per_time = [];
    for i = 1:1:length(a)
        [a1 , ~] = find(trx(1,eggs.fly(a(i))).sucrose((eggs.etrans_time_sub(a(i),1)-(X_hours(j)*7200)):eggs.etrans_time_sub(a(i),1)) == eggs.first_substrate);
        per_time(i) = length(a1)/((X_hours(j)*7200)+1);
    end
    [n,c] = hist3([transpose(per_time),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2],'Edges',{[-.025:.05:1.025];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(per_time,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,1,'k');
    set(gca,'yscale','log');
    set(gca,'ylim',[2 200]);
    set(gca,'xlim',[0 1]); colormap(jet);
    ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'eggs with at least 1 actual substrate transitions in explore'});
    xlabel(['Fraction of last ' num2str((X_hours(j)*60)) ' minutes spent on best substrate before egg-laying transition']);
end

%% Percent time spent on best substrate in past X hours (before egg-laying exploration start) versus rate of egg-laying on best option during exploration (Normalized in x axis)
X_hours = [1, .5, 1/6, 1/12, 1/30];
for j = 1:1:length(X_hours)
    figure; hold on; box on; title([title_string ' Eggs laid on best substrate']);
    [a , ~] = find(eggs.substrate == eggs.first_substrate & eggs.explore_trans_sub > 0 & eggs.explore_start_time > (X_hours(j)*7200));
    per_time = [];
    for i = 1:1:length(a)
        [a1 , ~] = find(trx(1,eggs.fly(a(i))).sucrose((eggs.explore_start_time(a(i))-(X_hours(j)*7200)):eggs.explore_start_time(a(i))) == eggs.first_substrate);
        per_time(i) = length(a1)/((X_hours(j)*7200)+1);
    end
    
    rate_time = [];
    for i = 1:1:length(a)
        [a1 , ~] = find(trx(1,eggs.fly(a(i))).sucrose(eggs.explore_start_time(a(i)):eggs.egg_time(a(i))) == eggs.first_substrate);
        rate_time(i) = 2/length(a1);
    end
    
    [n,c] = hist3([transpose(per_time),transpose(rate_time)],'Edges',{[-.05:.1:1.05];logspace(-3,0,20)});
    contourf(c{1},c{2},bsxfun(@rdivide,transpose(n),sum(transpose(n))),'LineStyle','none');
    scatter(per_time,rate_time,1,'k');
    set(gca,'yscale','log');
    set(gca,'ylim',[0 .2]);
    set(gca,'xlim',[0 1]); colormap(jet); caxis([0 .3]); colorbar;
    ylabel({'Rate of egg-laying (eggs/sec) on best substrate during exploration', 'eggs with at least 1 actual substrate transitions in explore'});
    xlabel({['Fraction of last ' num2str((X_hours(j)*60)) ' minutes spent on best substrate before egg-laying exploration start'], 'Each x bin is normalized to 1'});
end

%% Time spent on an inferior substrate before first transition in exploration versus rate of egg-laying on best option during exploration (Normalized in x axis)
if(eggs.first_substrate ~= eggs.second_substrate)
    figure; hold on; box on; title([title_string ' Eggs laid on best substrate']);
    [a , ~] = find(eggs.substrate == eggs.first_substrate & eggs.explore_trans_sub > 0 & eggs.explore_start_substrate ~= eggs.first_substrate);
    
    previous_time = [];
    for i = 1:1:length(a)
        previous_time(i) = (find_next_trans(trx(1,eggs.fly(a(i))).transition_sub,eggs.explore_start_time(a(i))) - eggs.estart_trans_time_sub(a(i),1))./2;
    end
    
    rate_time = [];
    for i = 1:1:length(a)
        [a1 , ~] = find(trx(1,eggs.fly(a(i))).sucrose(eggs.explore_start_time(a(i)):eggs.egg_time(a(i))) == eggs.first_substrate);
        rate_time(i) = 2/length(a1);
    end
    
    [n,c] = hist3([transpose(previous_time),transpose(rate_time)],'Edges',{logspace(0,4,16);logspace(-3,0,14)});
    contourf(c{1},c{2},bsxfun(@rdivide,transpose(n),sum(transpose(n))),'LineStyle','none','LevelStep',.02);
    scatter(previous_time,rate_time,1,'k');
    set(gca,'yscale','log');
    set(gca,'xscale','log');
    set(gca,'ylim',[c{1,2}(1) .2]);
    set(gca,'xlim',[10 10000]);
    colormap(jet); caxis([0 .3]); colorbar;
    ylabel({'Rate of egg-laying (eggs/sec) on best substrate during exploration', 'eggs with at least 1 actual substrate transitions in explore', 'explorations had to start on an inferior substrate'});
    xlabel({'Time (seconds) spent on inferior substrate before 1st transition off it', 'Each x bin is normalized to 1'});
end

%% Time spent on an inferior substrate (that an egg was laid on) before first transition in exploration versus rate of egg-laying on best option during exploration
if(eggs.first_substrate ~= eggs.second_substrate)
    figure; hold on; box on; title([title_string ' Eggs laid on best substrate']);
    [a , ~] = find(eggs.substrate == eggs.first_substrate & eggs.explore_trans_sub > 0 & eggs.explore_start_substrate ~= eggs.first_substrate & eggs.num > 1);
    
    previous_timeE = []; 
    rate_timeE = [];
    subE = [];
    previous_time = []; 
    rate_time = [];
    sub = [];
    c = 1;
    cE = 1;
    colrs = 'rrgggbb';
    for i = 1:1:length(a)
        if(eggs.estart_trans_time_sub(a(i),1) < eggs.egg_time(a(i)-1))
            previous_timeE(cE) = (find_next_trans(trx(1,eggs.fly(a(i))).transition_sub,eggs.explore_start_time(a(i))) - eggs.estart_trans_time_sub(a(i),1))./2;
            
            [a1 , ~] = find(trx(1,eggs.fly(a(i))).sucrose(eggs.explore_start_time(a(i)):eggs.egg_time(a(i))) == eggs.first_substrate);
            rate_timeE(cE) = 2/length(a1);
            
            subE(cE) = trx(1,eggs.fly(a(i))).sucrose(eggs.explore_start_time(a(i),1));
            
            scatter(previous_timeE(cE),rate_timeE(cE),10,colrs(subE(cE)+1),'filled');
            scatter(previous_timeE(cE),rate_timeE(cE),15,'k');
    
            cE = cE+1;
        else
            previous_time(c) = (find_next_trans(trx(1,eggs.fly(a(i))).transition_sub,eggs.explore_start_time(a(i))) - eggs.estart_trans_time_sub(a(i),1))./2;
           
            [a1 , ~] = find(trx(1,eggs.fly(a(i))).sucrose(eggs.explore_start_time(a(i)):eggs.egg_time(a(i))) == eggs.first_substrate);
            rate_time(c) = 2/length(a1);
            
            sub(c) = trx(1,eggs.fly(a(i))).sucrose(eggs.explore_start_time(a(i),1));
  
            scatter(previous_time(c),rate_time(c),10,colrs(sub(c)+1),'filled');

            c = c+1;
        end
    end
    
    %[n,c] = hist3([transpose(previous_time),transpose(rate_time)],'Edges',{logspace(0,4,16);logspace(-3,0,14)});
    %contourf(c{1},c{2},bsxfun(@rdivide,transpose(n),sum(transpose(n))),'LineStyle','none','LevelStep',.02);    

    set(gca,'yscale','log');
    set(gca,'xscale','log');
    set(gca,'ylim',[0.001 .2]);
    set(gca,'xlim',[10 10000]);
    ylabel({'Rate of egg-laying (eggs/sec) on best substrate during exploration', 'eggs with at least 1 actual substrate transitions in explore', 'explorations had to start on an inferior substrate, egg was laid on that substrate if circled'});
    xlabel({'Time (seconds) spent on inferior substrate before 1st transition off it'});
end

%% Time spent on previous substrate versus time till egg after transition
[a , ~] = find(eggs.substrate == eggs.first_substrate & eggs.explore_trans_sub > 0);
figure; hold on; box on; title([title_string ' Eggs laid on best substrate']);
[n,c] = hist3([(eggs.etrans_time_sub(a,1)-eggs.etrans_time_sub(a,2))./2,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2],'Edges',{logspace(0,4,20);logspace(0,4,20)});
contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
scatter((eggs.etrans_time_sub(a,1)-eggs.etrans_time_sub(a,2))./2,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,1,'k');
set(gca,'yscale','log');
set(gca,'xscale','log');
set(gca,'ylim',[2 200]);
set(gca,'xlim',[2 2000]); colormap(jet);
ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'eggs with actual substrate transitions in explore'});
xlabel('Time spent on previous substrate before the transition (seconds)');

%% Time spent on previous substrate versus time till egg after transition (single transition eggs only)
[a , ~] = find(eggs.substrate == eggs.first_substrate & eggs.explore_trans_sub == 1);
figure; hold on; box on; title([title_string ' Eggs laid on best substrate']);
[n,c] = hist3([(eggs.etrans_time_sub(a,1)-eggs.etrans_time_sub(a,2))./2,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2],'Edges',{logspace(0,4,20);logspace(0,4,20)});
contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
scatter((eggs.etrans_time_sub(a,1)-eggs.etrans_time_sub(a,2))./2,(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,1,'k');
set(gca,'yscale','log');
set(gca,'xscale','log');
set(gca,'ylim',[2 200]);
set(gca,'xlim',[2 2000]); colormap(jet);
ylabel({'Time from last actual substrate transition', 'to egg-laying event (seconds)', 'eggs with only 1 actual substrate transitions in explore'});
xlabel('Time spent on previous substrate before the transition (seconds)');

%% Scatter experiment time versus distance traveled
figure; hold on; box on; title(title_string);

[a , ~] = find(eggs.substrate == 0);
scatter(eggs.egg_time(a)./7200,eggs.etrans_dist_sub(a,1),15,'r','fill','markeredgecolor','k');

[a , ~] = find(eggs.substrate == 2);
scatter(eggs.egg_time(a)./7200,eggs.etrans_dist_sub(a,1),15,'g','fill','markeredgecolor','k');

[a , ~] = find(eggs.substrate == 5);
scatter(eggs.egg_time(a)./7200,eggs.etrans_dist_sub(a,1),15,'b','fill','markeredgecolor','k');

ylabel({'Distance travled from last actual substrate transition', 'to egg-laying event (mm)'});
xlabel('Hours spent in chamber');
set(gca,'xtick',0:1:20);
set(gca,'yscale','log');

%% Scatter experiment time versus distance traveled with density contour
[a , ~] = find(eggs.substrate == 0);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on plain']);
    [n,c] = hist3([eggs.egg_time(a)./7200,eggs.etrans_dist_sub(a,1)],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggs.egg_time(a)./7200,eggs.etrans_dist_sub(a,1),1,'k');
    ylabel({'Distance travled from last actual substrate transition', 'to egg-laying event (mm)'});
    xlabel('Hours spent in chamber');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 20]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 1000]);
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 2);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 200mM']);
    [n,c] = hist3([eggs.egg_time(a)./7200,eggs.etrans_dist_sub(a,1)],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggs.egg_time(a)./7200,eggs.etrans_dist_sub(a,1),1,'k');
    ylabel({'Distance travled from last actual substrate transition', 'to egg-laying event (mm)'});
    xlabel('Hours spent in chamber');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 20]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 1000]);
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 5);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 500mM']);
    [n,c] = hist3([eggs.egg_time(a)./7200,eggs.etrans_dist_sub(a,1)],'Edges',{[0:1:24];logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggs.egg_time(a)./7200,eggs.etrans_dist_sub(a,1),1,'k');
    ylabel({'Distance travled from last actual substrate transition', 'to egg-laying event (mm)'});
    xlabel('Hours spent in chamber');
    set(gca,'xtick',0:1:20);
    set(gca,'xlim',[.5 20]);
    set(gca,'yscale','log');
    set(gca,'ylim',[2 1000]);
    colormap(jet);
    colorbar;
end

%% Scatter distance traveled since last transition versus time since last transition
figure; hold on;
title([title_string]); box on;
xlabel('Distance traveled (mm) from last actual substrate transition to egg-laying event');
ylabel('Time (seconds) from last actual substrate transition to egg-layng event');

[a , ~] = find(eggs.substrate == 0);
scatter(eggs.etrans_dist_sub(a,1),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,10,'r','fill','MarkerEdgeColor','k');
[a , ~] = find(eggs.substrate == 2);
hold on; scatter(eggs.etrans_dist_sub(a,1),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,10,'g','fill','MarkerEdgeColor','k');
[a , ~] = find(eggs.substrate == 5);
hold on; scatter(eggs.etrans_dist_sub(a,1),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,10,'g','fill','MarkerEdgeColor','k');
set(gca,'xscale','log');
set(gca,'yscale','log');

%% Scatter distance traveled since last transition versus time since last transition with density contour
[a , ~] = find(eggs.substrate == 0);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on plain']);
    [n,c] = hist3([eggs.etrans_dist_sub(a,1),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2],'Edges',{logspace(0,4,20),logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggs.etrans_dist_sub(a,1),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,1,'k');
    xlabel({'Distance traveled (mm) from last actual', 'substrate transition to egg-laying event'});
    ylabel('Time (seconds) from last actual substrate transition to egg-layng event');
    set(gca,'ylim',[2 10000]);
    set(gca,'yscale','log');
    set(gca,'xlim',[2 1000]);
    set(gca,'xscale','log');
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 2);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 200mM']);
    [n,c] = hist3([eggs.etrans_dist_sub(a,1),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2],'Edges',{logspace(0,4,20),logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggs.etrans_dist_sub(a,1),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,1,'k');
    xlabel({'Distance traveled (mm) from last actual', 'substrate transition to egg-laying event'});
    ylabel('Time (seconds) from last actual substrate transition to egg-layng event');
    set(gca,'ylim',[2 10000]);
    set(gca,'yscale','log');
    set(gca,'xlim',[2 1000]);
    set(gca,'xscale','log');
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 5);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 500mM']);
    [n,c] = hist3([eggs.etrans_dist_sub(a,1),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2],'Edges',{logspace(0,4,20),logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter(eggs.etrans_dist_sub(a,1),(eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,1,'k');
    xlabel({'Distance traveled (mm) from last actual', 'substrate transition to egg-laying event'});
    ylabel('Time (seconds) from last actual substrate transition to egg-layng event');
    set(gca,'ylim',[2 10000]);
    set(gca,'yscale','log');
    set(gca,'xlim',[2 1000]);
    set(gca,'xscale','log');
    colormap(jet);
    colorbar;
end

%% Different variables over time in chamber or egg number in chamber
for i = 0:1:8
    timeinchamber_analysis_wshift(eggs,trx,title_string,0,3600,i);
    timeinchamber_analysis_wshift(eggs,trx,title_string,1,3600,i);
    timeinchamber_analysis_wshift(eggs,trx,title_string,2,3600,i);
    
    egginchamber_analysis_wsort(eggs,trx,title_string,4,i);
end

%% Egg position histograms

[a , ~] = find(eggs.explore_trans_sub >= 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.egg_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*2+1);

figure; hold on; box on; title({[title_string ' position of all eggs, smooth gauss 3']});
imagesc(imgaussfilt(img,'FilterSize',3));
colormap(jet); axis tight; colorbar;
figure; hold on; box on; title({[title_string ' position of all eggs']});
contourf(img,'LineStyle','none','LevelStep',.5);
colormap(jet); axis tight; colorbar;

[a , ~] = find(eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.egg_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*2+1);

figure; hold on; box on; title({[title_string ' position of all eggs w actual substrate transitions, smooth gauss 3']});
imagesc(imgaussfilt(img,'FilterSize',3));
colormap(jet); axis tight; colorbar;
figure; hold on; box on; title({[title_string ' position of all eggs w actual substrate transitions']});
contourf(img,'LineStyle','none','LevelStep',.5);
colormap(jet); axis tight; colorbar;


[a , ~] = find(eggs.explore_trans_sub == 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.egg_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*2+1);

figure; hold on; box on; title({[title_string ' position of all eggs w/o actual substrate transitions, smooth gauss 3']});
imagesc(imgaussfilt(img,'FilterSize',3));
colormap(jet); axis tight; colorbar;
figure; hold on; box on; title({[title_string ' position of all eggs w/o actual substrate transitions']});
contourf(img,'LineStyle','none','LevelStep',.5);
colormap(jet); axis tight; colorbar;

%% Fly position histograms

[a , ~] = find(eggs.egg_time <= (7200*3) & eggs.explore_trans_sub == 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string ' explorations in first 3 hours'], '0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

    figure; hold on; box on; title({[title_string ' explorations in first 3 hours'], '0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end 

[a , ~] = find(eggs.egg_time <= (7200*3) & eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string ' explorations in first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]); colorbar;

    figure; hold on; box on; title({[title_string ' explorations in first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]); colorbar;
end

[a , ~] = find(eggs.egg_time <= (7200*3) & eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.etrans_time_sub(a,1), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string ' explorations in first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'sub transition to egg, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]); colorbar;
    
    figure; hold on; box on; title({[title_string ' explorations in first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'sub transition to egg, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]); colorbar;
end

[a , ~] = find(eggs.egg_time <= (7200*3) & eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.etrans_time_sub(a,1)-1, eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string ' explorations in first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore before last substrate transition, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

    figure; hold on; box on; title({[title_string ' explorations in first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore before last substrate transition, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

end

[a , ~] = find(eggs.egg_time > (7200*3) & eggs.explore_trans_sub == 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string ' explorations after first 3 hours'], '0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
   
    figure; hold on; box on; title({[title_string ' explorations after first 3 hours'], '0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

[a , ~] = find(eggs.egg_time > (7200*3) & eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string ' explorations after first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
   
    figure; hold on; box on; title({[title_string ' explorations after first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

[a , ~] = find(eggs.egg_time > (7200*3) & eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.etrans_time_sub(a,1), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string ' explorations after first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'sub transition to egg, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

    figure; hold on; box on; title({[title_string ' explorations after first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'sub transition to egg, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

[a , ~] = find(eggs.egg_time > (7200*3) & eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.etrans_time_sub(a,1)-1, eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string ' explorations after first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore before last substrate transition, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

    %figure; hold on; box on; title({[title_string ' explorations after first 3 hours'], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore before last substrate transition, log2 over null, smooth gauss 3'});
    %imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

[a , ~] = find(eggs.explore_trans_sub == 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string], '0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

    figure; hold on; box on; title({[title_string], '0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

[a , ~] = find(eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

    figure; hold on; box on; title({[title_string], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

[a , ~] = find(eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.etrans_time_sub(a,1), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string], '> 0 actual substrate trans (best option on an edge is on top)', 'sub transition to egg, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

    figure; hold on; box on; title({[title_string], '> 0 actual substrate trans (best option on an edge is on top)', 'sub transition to egg, log2 over null, smooth gauss 3'});
    imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

[a , ~] = find(eggs.explore_trans_sub > 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.etrans_time_sub(a,1)-1, eggs.fly(a)],eggs.chamber_style,16*3+1);
 [z1,z2,z3] = timeonsucrose(eggs,trx,[eggs.explore_start_time(a), eggs.etrans_time_sub(a,1)-1, eggs.fly(a)]);
 z1/(z1+z2+z3)
  z2/(z1+z2+z3)
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore before last substrate transition, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

%     figure; hold on; box on; title({[title_string], '> 0 actual substrate trans (best option on an edge is on top)', 'full explore before last substrate transition, log2 over null, smooth gauss 3'});
%     imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

[a , ~] = find(eggs.explore_trans_sub >= 0);
img = positionheatmap_specifictimes(trx,substrate,[eggs.explore_start_time(a), eggs.egg_time(a), eggs.fly(a)],eggs.chamber_style,16*3+1);
 [z1,z2,z3] = timeonsucrose(eggs,trx,[eggs.explore_start_time(a), eggs.egg_time(a), eggs.fly(a)]);
 z1/(z1+z2+z3)
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string], '>= 0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;

%     figure; hold on; box on; title({[title_string], '>= 0 actual substrate trans (best option on an edge is on top)', 'full explore, log2 over null, smooth gauss 3'});
%     imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

c = 1;
store_i = [];
sub_eggtime = [];
max_time = [];
for j = 1:1:max(eggs.fly)
    [a1 , ~] = find(eggs.fly == j);
    a1 = sort(a1);
    if(length(a1) > 1)
        sub_eggtime(c) = eggs.egg_time(a1(2));
        max_time(c) = length(trx(1,j).x_mm);
        store_i(c) = j;
        c = c+1;
    end
end

[a , ~] = find(eggs.explore_trans_sub >= 0);
img = positionheatmap_specifictimes(trx,substrate,transpose([sub_eggtime; min(sub_eggtime+7200*5,max_time); store_i]),eggs.chamber_style,16*3+1);
 [z1,z2,z3] = timeonsucrose(eggs,trx,transpose([sub_eggtime; min(sub_eggtime+7200*5,max_time); store_i]));
 z1/(z1+z2+z3)
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string], 'position during clutch (egg 2 + 5 hours)', 'log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
    
%     figure; hold on; box on; title({[title_string], 'position during clutch (egg 2 + 5 hours)', 'log2 over null, smooth gauss 3'});
%     imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

l = [];
for i =1:1:length(trx(1,:))
    l(i) = length(trx(1,i).x_mm);
end

[a , ~] = find(eggs.explore_trans_sub >= 0);
img = positionheatmap_specifictimes(trx,substrate,[ones(length(trx(1,:)),1), transpose(l), transpose(1:1:length(trx(1,:)))],eggs.chamber_style,16*3+1);
 [z1,z2,z3] = timeonsucrose(eggs,trx,[ones(length(trx(1,:)),1), transpose(l), transpose(1:1:length(trx(1,:)))]);
 z1/(z1+z2+z3)
[d1, d2] = size(img);
if(~isempty(a))
    %contourf(log2((img./(sum(sum(img))))*d1*d2+0.000001),'LineStyle','none','LevelStep',1);
    figure; hold on; box on; title({[title_string], 'position during experiment', 'log2 over null'});
    imagesc(log2((img./(sum(sum(img))))*d1*d2+0.000001)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
    
%     figure; hold on; box on; title({[title_string], 'position during experiment', 'log2 over null, smooth gauss 3'});
%     imagesc(imgaussfilt(log2((img./(sum(sum(img))))*d1*d2+0.000001),'FilterSize',3)); colormap(jet); axis tight;  caxis([-4 4]);colorbar;
end

%% Fly trajectories
[a , ~] = find(eggs.explore_trans > 0 & eggs.substrate == eggs.first_substrate);
plottrackincolor(trx,eggs.fly(a),eggs,eggs.etrans_time_sub(a,1), eggs.egg_time(a),'time');
hold on; box on; title({[title_string 'individual trajectories from transition to egg'], '(eggs w/ > 0 substrate transitions, only eggs on best substrate'});
caxis([0 .5]);

[a , ~] = find(eggs.explore_trans == 0 & eggs.substrate == eggs.first_substrate);
plottrackincolor(trx,eggs.fly(a),eggs,eggs.etrans_time_sub(a,1), eggs.egg_time(a),'time');
hold on; box on; title({[title_string 'individual trajectories from transition to egg'], '(eggs w/ 0 substrate transitions, only eggs on best substrate'});
caxis([0 .5]);

%% Total duration of exploration
[a, ~] = find(eggs.substrate >= 0);
bin_width = 5;

figure; hold on; box on; title(title_string); xlabel('Total duration (seconds) of exploration');
histogram((eggs.egg_time(a)-eggs.explore_start_time(a))./2,[0:bin_width:300],'facecolor','k');
[a1 , ~] = histcounts((eggs.egg_time(a)-eggs.explore_start_time(a))./2,[0:bin_width:300]);

figure; hold on; box on; title(title_string); xlabel('Total duration (seconds) of exploration'); ylabel('Cumulative distribution');
plot((bin_width/2):bin_width:(300-bin_width/2),cumsum(a1)./sum(a1),'k');

%% Mean speed on individual explorations
[a , ~] = find(eggs.substrate >= 0);
bin_width = .1;

figure; hold on; box on; title(title_string); xlabel('Mean speed (mm/sec) of individual explorations');
histogram(eggs.explore_dist(a)./((eggs.egg_time(a)-eggs.explore_start_time(a))./2),[0:bin_width:5],'facecolor','k');
[a1 , ~] = histcounts(eggs.explore_dist(a)./((eggs.egg_time(a)-eggs.explore_start_time(a))./2),[0:bin_width:5]);

figure; hold on; box on; title(title_string); xlabel('Mean speed (mm/sec) of individual explorations'); ylabel('Cumulative distribution');
plot((bin_width/2):bin_width:(5-bin_width/2),cumsum(a1)./sum(a1),'k');

%% Total distance traveled in exploration
[a , ~] = find(eggs.substrate >= 0);
bin_width = 2;

figure; hold on; box on; title(title_string); xlabel('Total distance (mm) of exploration');
histogram(eggs.explore_dist(a),[0:bin_width:500],'facecolor','k');
[a1 , ~] = histcounts(eggs.explore_dist(a),[0:bin_width:500]);

figure; hold on; box on; title(title_string); xlabel('Total distance (mm) of exploration'); ylabel('Cumulative distribution');
plot((bin_width/2):bin_width:(500-bin_width/2),cumsum(a1)./sum(a1),'k');

%% Number of transitions in exploration
[a , ~] = find(eggs.substrate >= 0);
bin_width = 1;

figure; hold on; box on; title(title_string); xlabel('Total actual substrate transitions in exploration');
histogram(eggs.explore_trans_sub(a),[0:bin_width:50],'facecolor','k');
[a1 , ~] = histcounts(eggs.explore_trans_sub(a),[0:bin_width:50]);

figure; hold on; box on; title(title_string); xlabel('Total actual substrate transitions exploration'); ylabel('Cumulative distribution');
plot((bin_width/2):bin_width:(50-bin_width/2),cumsum(a1)./sum(a1),'k');

%% Number of plastic transitions in exploration
[a, ~] = find(eggs.substrate >= 0);
bin_width = 1;

figure; hold on; box on; title(title_string); xlabel('Total plastic transitions in exploration');
histogram(eggs.explore_trans(a),[0:bin_width:50],'facecolor','k');
[a1, ~] = histcounts(eggs.explore_trans(a),[0:bin_width:50]);

figure; hold on; box on; title(title_string); xlabel('Total plastic transitions exploration'); ylabel('Cumulative distribution');
plot((bin_width/2):bin_width:(50-bin_width/2),cumsum(a1)./sum(a1),'k');

%% Scatter distance traveled in explore versus duration of explore
figure; hold on; box on; title(title_string);
[a , ~] =find(eggs.substrate >= 0);
scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a), 3,'k','fill','markeredgecolor','k');
xlabel('Time spent during exploration (seconds)'); ylabel('Distance traveled during exploration (mm)');
set(gca,'xscale','log');
set(gca,'yscale','log');

%% Scatter distance traveled in explore versus time spent in explore for eggs laid on different substrates
figure; hold on; box on; title(title_string);
[a , ~] =find(eggs.substrate == 0);
scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a), 5,'r','fill','markeredgecolor','k');
xlabel('Time spent during exploration (seconds)'); ylabel('Distance traveled during exploration (mm)');
[a , ~] =find(eggs.substrate == 2);
scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a), 5,'g','fill','markeredgecolor','k');
xlabel('Time spent during exploration (seconds)'); ylabel('Distance traveled during exploration (mm)');
[a , ~] =find(eggs.substrate == 5);
scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a), 5,'b','fill','markeredgecolor','k');
xlabel('Time spent during exploration (seconds)'); ylabel('Distance traveled during exploration (mm)');
set(gca,'xscale','log');
set(gca,'yscale','log');
[a , ~] = find(eggs.substrate == 0);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on plain']);
    [n,c] = hist3([(eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a)],'Edges',{logspace(0,4,20),logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a),1,'k');
    xlabel('Time spent during exploration (seconds)'); ylabel('Distance traveled during exploration (mm)');
    set(gca,'ylim',[2 10000]);
    set(gca,'yscale','log');
    set(gca,'xlim',[2 10000]);
    set(gca,'xscale','log');
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 2);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 200mM']);
    [n,c] = hist3([(eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a)],'Edges',{logspace(0,4,20),logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a),1,'k');
    xlabel('Time spent during exploration (seconds)'); ylabel('Distance traveled during exploration (mm)');
    set(gca,'ylim',[2 10000]);
    set(gca,'yscale','log');
    set(gca,'xlim',[2 10000]);
    set(gca,'xscale','log');
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 5);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 500mM']);
    [n,c] = hist3([(eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a)],'Edges',{logspace(0,4,20),logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a),1,'k');
    xlabel('Time spent during exploration (seconds)'); ylabel('Distance traveled during exploration (mm)');
    set(gca,'ylim',[2 10000]);
    set(gca,'yscale','log');
    set(gca,'xlim',[2 10000]);
    set(gca,'xscale','log');
    colormap(jet);
    colorbar;
end

%% Scatter distance traveled in explore versus time spent in explore (for explorations with > 0 transitions) for eggs laid on different substrates
figure; hold on; box on; title(title_string);
[a , ~] =find(eggs.substrate == 0 & eggs.explore_trans_sub > 0);
scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a), 5,'r','fill','markeredgecolor','k');
xlabel('Time spent during exploration (seconds) w/ > 0 transitions'); ylabel('Distance traveled during exploration (mm)');
[a , ~] =find(eggs.substrate == 2 & eggs.explore_trans_sub > 0);
scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a), 5,'g','fill','markeredgecolor','k');
xlabel('Time spent during exploration (seconds) w/ > 0 transitions'); ylabel('Distance traveled during exploration (mm)');
[a , ~] =find(eggs.substrate == 5 & eggs.explore_trans_sub > 0);
scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a), 5,'b','fill','markeredgecolor','k');
xlabel('Time spent during exploration (seconds) w/ > 0 transitions'); ylabel('Distance traveled during exploration (mm)');
set(gca,'xscale','log');
set(gca,'yscale','log');
[a , ~] = find(eggs.substrate == 0 & eggs.explore_trans_sub > 0);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on plain']);
    [n,c] = hist3([(eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a)],'Edges',{logspace(0,4,20),logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a),1,'k');
    xlabel('Time spent during exploration (seconds) w/ > 0 transitions'); ylabel('Distance traveled during exploration (mm)');
    set(gca,'ylim',[2 10000]);
    set(gca,'yscale','log');
    set(gca,'xlim',[2 10000]);
    set(gca,'xscale','log');
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 2 & eggs.explore_trans_sub > 0);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 200mM']);
    [n,c] = hist3([(eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a)],'Edges',{logspace(0,4,20),logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a),1,'k');
    xlabel('Time spent during exploration (seconds) w/ > 0 transitions'); ylabel('Distance traveled during exploration (mm)');
    set(gca,'ylim',[2 10000]);
    set(gca,'yscale','log');
    set(gca,'xlim',[2 10000]);
    set(gca,'xscale','log');
    colormap(jet);
    colorbar;
end

[a , ~] = find(eggs.substrate == 5 & eggs.explore_trans_sub > 0);
if(~isempty(a))
    figure; hold on; box on; title([title_string ' Eggs laid on 500mM']);
    [n,c] = hist3([(eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a)],'Edges',{logspace(0,4,20),logspace(0,4,20)});
    contourf(c{1},c{2},transpose(n),'LineStyle','none','LevelStep',1);
    scatter((eggs.egg_time(a)-eggs.explore_start_time(a))./2, eggs.explore_dist(a),1,'k');
    xlabel('Time spent during exploration (seconds) w/ > 0 transitions'); ylabel('Distance traveled during exploration (mm)');
    set(gca,'ylim',[2 10000]);
    set(gca,'yscale','log');
    set(gca,'xlim',[2 10000]);
    set(gca,'xscale','log');
    colormap(jet);
    colorbar;
end

%% Plot probability (in specific bins) of  transitioning in a given exploration over time since last transition before exploration to start of exploration

v = [0, 60, 120, 240, 480, 720, 1200, 3600, 3600*10];
vx = [];
for i =1:1:(length(v)-1)
    vx(i) = (v(i) +v(i+1))./2;
end

[a , ~] =find(eggs.explore_start_substrate == 0 & eggs.explore_trans_sub == 0 );
[a0NT , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);
[a , ~] =find(eggs.explore_start_substrate == 0 & eggs.explore_trans_sub > 0 );
[a0T , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);

[a , ~] =find(eggs.explore_start_substrate == 2 & eggs.explore_trans_sub == 0 );
[a2NT , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);
[a , ~] =find(eggs.explore_start_substrate == 2 & eggs.explore_trans_sub > 0 );
[a2T , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);

[a , ~] =find(eggs.explore_start_substrate == 5 & eggs.explore_trans_sub == 0 );
[a5NT , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);
[a , ~] =find(eggs.explore_start_substrate == 5 & eggs.explore_trans_sub > 0 );
[a5T , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);

eb0 = [];
eb2 = [];
eb5 = [];

for i = 1:1:length(a0NT)
    [~,pci] = binofit(a0T(i),a0T(i)+a0NT(i),.05);
    mean_ratio =a0T(i)./(a0T(i)+a0NT(i));
    eb0(i,:) = [mean_ratio,pci(1), pci(2)];
    
    [~,pci] = binofit(a2T(i),a2T(i)+a2NT(i),.05);
    mean_ratio =a2T(i)./(a2T(i)+a2NT(i));
    eb2(i,:) = [mean_ratio,pci(1), pci(2)];
    
    [~,pci] = binofit(a5T(i),a5T(i)+a5NT(i),.05);
    mean_ratio =a5T(i)./(a5T(i)+a5NT(i));
    eb5(i,:) = [mean_ratio,pci(1), pci(2)];
end


figure; hold on; title(title_string); box on;
if(any(eggs.all_substrates == 0))
    h = fill([vx,fliplr(vx)],[eb0(:,2);flipud(eb0(:,3))],[1 0 0],'linestyle','none');
    set(h,'facealpha',.15);
end

if(any(eggs.all_substrates == 2))
    h = fill([vx,fliplr(vx)],[eb2(:,2);flipud(eb2(:,3))],[0 1 0],'linestyle','none');
    set(h,'facealpha',.15);
end
if(any(eggs.all_substrates == 5))
    h = fill([vx,fliplr(vx)],[eb5(:,2);flipud(eb5(:,3))],[0 0 1],'linestyle','none');
    set(h,'facealpha',.15);
end


if(any(eggs.all_substrates == 0))
    plot(vx,eb0(:,1),'-or','Markerfacecolor','r','MarkerSize',2,'Linewidth',1);
end
if(any(eggs.all_substrates == 2))
    plot(vx,eb2(:,1),'-og','Markerfacecolor','g','MarkerSize',2,'Linewidth',1);
end
if(any(eggs.all_substrates == 5))
    plot(vx,eb5(:,1),'-ob','Markerfacecolor','b','MarkerSize',2,'Linewidth',1);
end

ylabel('Probability of leaving substrate (transitioning) in current exploration');
set(gca, 'xtick',v(1:end));
set(gca,'ylim',[0 1]);
set(gca,'xlim',[v(1), v(end)]);
xlabel('Time (seconds) since last transition (before exploration start) to exploration start');
set(gca,'xscale','log');

%% Plot probability (in specific bins) of fake plastic transitioning in a given exploration over time since last transition before exploration to start of exploration

v = [0, 60, 120, 240, 480, 720, 1200, 3600, 3600*10];
vx = [];
for i =1:1:(length(v)-1)
    vx(i) = (v(i) +v(i+1))./2;
end

[a , ~] = find(eggs.substrate >= 0);
plastic_trans = [];
realsub_trans = [];
for jj = 1:1:length(a)
    plastic_trans(jj) = find_next_trans(trx(1,eggs.fly(a(jj))).transition_invert, eggs.explore_start_time(a(jj)));
    realsub_trans(jj) = find_next_trans(trx(1,eggs.fly(a(jj))).transition_sub, eggs.explore_start_time(a(jj)));
end

[a , ~] =find(eggs.explore_start_substrate == 0 & (eggs.explore_trans_invert+eggs.explore_trans_sub) > 0 & transpose(plastic_trans) < transpose(realsub_trans));
[a0NT , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);
[a , ~] =find(eggs.explore_start_substrate == 0 & (eggs.explore_trans_invert+eggs.explore_trans_sub) > 0 & transpose(plastic_trans) >= transpose(realsub_trans));
[a0T , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);

[a , ~] =find(eggs.explore_start_substrate == 2 & (eggs.explore_trans_invert+eggs.explore_trans_sub) > 0 & transpose(plastic_trans) < transpose(realsub_trans));
[a2NT , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);
[a , ~] =find(eggs.explore_start_substrate == 2 & (eggs.explore_trans_invert+eggs.explore_trans_sub) > 0 & transpose(plastic_trans) >= transpose(realsub_trans));
[a2T , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);

[a , ~] =find(eggs.explore_start_substrate == 5 & (eggs.explore_trans_invert+eggs.explore_trans_sub) > 0 & transpose(plastic_trans) < transpose(realsub_trans));
[a5NT , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);
[a , ~] =find(eggs.explore_start_substrate == 5 & (eggs.explore_trans_invert+eggs.explore_trans_sub) > 0 & transpose(plastic_trans) >= transpose(realsub_trans));
[a5T , ~] = histcounts((eggs.explore_start_time(a)-eggs.estart_trans_time_sub(a,1))./2,v);

eb0 = [];
eb2 = [];
eb5 = [];

for i = 1:1:length(a0NT)
    [~,pci] = binofit(a0NT(i),a0T(i)+a0NT(i),.05);
    mean_ratio =a0NT(i)./(a0T(i)+a0NT(i));
    eb0(i,:) = [mean_ratio,pci(1), pci(2)];
    
    [~,pci] = binofit(a2NT(i),a2T(i)+a2NT(i),.05);
    mean_ratio =a2NT(i)./(a2T(i)+a2NT(i));
    eb2(i,:) = [mean_ratio,pci(1), pci(2)];
    
    [~,pci] = binofit(a5NT(i),a5T(i)+a5NT(i),.05);
    mean_ratio =a5NT(i)./(a5T(i)+a5NT(i));
    eb5(i,:) = [mean_ratio,pci(1), pci(2)];
end


figure; hold on; title(title_string); box on;
if(any(eggs.all_substrates == 0))
    h = fill([vx,fliplr(vx)],[eb0(:,2);flipud(eb0(:,3))],[1 0 0],'linestyle','none');
    set(h,'facealpha',.15);
end

if(any(eggs.all_substrates == 2))
    h = fill([vx,fliplr(vx)],[eb2(:,2);flipud(eb2(:,3))],[0 1 0],'linestyle','none');
    set(h,'facealpha',.15);
end
if(any(eggs.all_substrates == 5))
    h = fill([vx,fliplr(vx)],[eb5(:,2);flipud(eb5(:,3))],[0 0 1],'linestyle','none');
    set(h,'facealpha',.15);
end


if(any(eggs.all_substrates == 0))
    plot(vx,eb0(:,1),'-or','Markerfacecolor','r','MarkerSize',2,'Linewidth',1);
end
if(any(eggs.all_substrates == 2))
    plot(vx,eb2(:,1),'-og','Markerfacecolor','g','MarkerSize',2,'Linewidth',1);
end
if(any(eggs.all_substrates == 5))
    plot(vx,eb5(:,1),'-ob','Markerfacecolor','b','MarkerSize',2,'Linewidth',1);
end

ylabel({'Probability of making a fake plastic transition before', 'making a real substrate transition in current exploration', 'only explorations where one or the other occured'});
set(gca, 'xtick',v(1:end));
set(gca,'ylim',[0 1]);
set(gca,'xlim',[v(1), v(end)]);
xlabel('Time (seconds) since last transition (before exploration start) to exploration start');
set(gca,'xscale','log');

%% Plot cumulative sucess rate over time since last transition
bin_width = 5;

[a , ~] =find(eggs.substrate == eggs.first_substrate);
[aB , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:bin_width:(3600*10)]);
[a , ~] =find(eggs.substrate == 0 );
[a0 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:bin_width:(3600*10)]);
[a , ~] =find(eggs.substrate == 2 );
[a2 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:bin_width:(3600*10)]);
[a , ~] =find(eggs.substrate == 5 );
[a5 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:bin_width:(3600*10)]);

num = cumsum(aB);
den = cumsum(a0+a2+a5);

eb = [];
for i = 1:1:length(aB)
    [~,pci] = binofit(num(i),den(i),.05);
    mean_ratio = num(i)/den(i);
    eb(i,:) = [mean_ratio,pci(1), pci(2)];
end

figure; hold on; title(title_string); box on;
h = fill([(bin_width/2):bin_width:((3600*10)-bin_width/2),fliplr((bin_width/2):bin_width:((3600*10)-bin_width/2))],[eb(:,2);flipud(eb(:,3))],[.3 .3 .3],'linestyle','none');
set(h,'facealpha',.15);
plot((bin_width/2):bin_width:((3600*10)-bin_width/2),cumsum(aB)./cumsum(a0+a2+a5), '-ok','Markersize',2);
ylabel({'Cumulative success/fail (on best option available) before time', 'line drawn at percent time spent on best substrate over all flies'});
set(gca,'ylim',[0 1]);
xlabel(['Time (seconds) since last transition binned at width ' num2str(bin_width)]);
set(gca,'xlim',[0 (3600*10)]);
set(gca,'xscale','log');
best_time = 0;
total_time = 0;
for i = 1:1:length(trx)
    total_time = total_time+length(trx(1,i).sucrose(1:length(trx(1,i).x)));
    best_time = best_time+sum(trx(1,i).sucrose(1:length(trx(1,i).x)) == eggs.first_substrate);
end
line([bin_width/2, (3600*10)],[(best_time)/total_time, (best_time)/total_time],'Color','k');

%% Plot cumulative sucess rate over distance traveled since last transition
bin_width = 5;

[a , ~] =find(eggs.substrate == eggs.first_substrate);
[aB , ~] = histcounts(eggs.etrans_dist_sub(a,1),[0:bin_width:1000]);
[a , ~] =find(eggs.substrate == 0 );
[a0 , ~] = histcounts(eggs.etrans_dist_sub(a,1),[0:bin_width:1000]);
[a , ~] =find(eggs.substrate == 2 );
[a2 , ~] = histcounts(eggs.etrans_dist_sub(a,1),[0:bin_width:1000]);
[a , ~] =find(eggs.substrate == 5 );
[a5 , ~] = histcounts(eggs.etrans_dist_sub(a,1),[0:bin_width:1000]);

num = cumsum(aB);
den = cumsum(a0+a2+a5);

eb = [];
for i = 1:1:length(aB)
    [~,pci] = binofit(num(i),den(i),.05);
    mean_ratio = num(i)/den(i);
    eb(i,:) = [mean_ratio,pci(1), pci(2)];
end

figure; hold on; title(title_string); box on;
h = fill([(bin_width/2):bin_width:(1000-bin_width/2),fliplr((bin_width/2):bin_width:(1000-bin_width/2))],[eb(:,2);flipud(eb(:,3))],[.3 .3 .3],'linestyle','none');
set(h,'facealpha',.15);
plot((bin_width/2):bin_width:(1000-bin_width/2),cumsum(aB)./cumsum(a0+a2+a5), '-ok','Markersize',2);
ylabel({'Cumulative success/fail (on best option available) before distance', 'line drawn at percent time spent on best substrate over all flies'});
set(gca,'ylim',[0 1]);
xlabel(['Distance (mm) since last transition binned at width ' num2str(bin_width)]);
set(gca,'xlim',[0 1000]);
set(gca,'xscale','log');

%% Plot cumulative success rate (after a given time) over time since last transition
bin_width = 5;

[a , ~] =find(eggs.substrate == eggs.first_substrate);
[aB , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:bin_width:(3600*10)]);
[a , ~] =find(eggs.substrate == 0 );
[a0 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:bin_width:(3600*10)]);
[a , ~] =find(eggs.substrate == 2 );
[a2 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:bin_width:(3600*10)]);
[a , ~] =find(eggs.substrate == 5 );
[a5 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,[0:bin_width:(3600*10)]);

aB_csi = [];
a0_csi = [];
a2_csi = [];
a5_csi = [];

for i = 1:1:length(a0)
    aB_csi(i) = sum(aB(i:length(aB)));
    a0_csi(i) = sum(a0(i:length(a0)));
    a2_csi(i) = sum(a2(i:length(a2)));
    a5_csi(i) = sum(a5(i:length(a5)));
end

eb = [];
for i = 1:1:length(aB_csi)
    [~,pci] = binofit(aB_csi(i),(a0_csi(i)+a2_csi(i)+a5_csi(i)),.05);
    mean_ratio = aB_csi(i)/(a0_csi(i)+a2_csi(i)+a5_csi(i));
    eb(i,:) = [mean_ratio, pci(1), pci(2)];
end

figure; hold on; title(title_string); box on;
h = fill([(bin_width/2):bin_width:((3600*10)-bin_width/2),fliplr((bin_width/2):bin_width:((3600*10)-bin_width/2))],[eb(:,2);flipud(eb(:,3))],[.3 .3 .3],'linestyle','none');
set(h,'facealpha',.15);
plot((bin_width/2):bin_width:((3600*10)-bin_width/2),aB_csi./(a0_csi+a2_csi+a5_csi),'-ok','Markersize',2);
ylabel({'Cumulative success/fail (on best option available) after time', 'line drawn at percent time spent on best substrate over all flies'});
set(gca,'ylim',[0 1]);
xlabel(['Time (seconds) since last transition binned at width ' num2str(bin_width)]);
set(gca,'xlim',[0 (3600*10)]);
set(gca,'xscale','log');
best_time = 0;
total_time = 0;
for i = 1:1:length(trx)
    total_time = total_time+length(trx(1,i).sucrose(1:length(trx(1,i).x)));
    best_time = best_time+sum(trx(1,i).sucrose(1:length(trx(1,i).x)) == eggs.first_substrate);
end
line([bin_width/2, (3600*10)],[(best_time)/total_time, (best_time)/total_time],'Color','k');

%% Plot cumulative success rate (after a given distance) over distance traveled since last transition
bin_width = 5;

[a , ~] =find(eggs.substrate == eggs.first_substrate);
[aB , ~] = histcounts(eggs.etrans_dist_sub(a,1),[0:bin_width:1000]);
[a , ~] =find(eggs.substrate == 0 );
[a0 , ~] = histcounts(eggs.etrans_dist_sub(a,1),[0:bin_width:1000]);
[a , ~] =find(eggs.substrate == 2 );
[a2 , ~] = histcounts(eggs.etrans_dist_sub(a,1),[0:bin_width:1000]);
[a , ~] =find(eggs.substrate == 5 );
[a5 , ~] = histcounts(eggs.etrans_dist_sub(a,1),[0:bin_width:1000]);

aB_csi = [];
a0_csi = [];
a2_csi = [];
a5_csi = [];


for i = 1:1:length(aB)
    aB_csi(i) = sum(aB(i:length(aB)));
    a0_csi(i) = sum(a0(i:length(a0)));
    a2_csi(i) = sum(a2(i:length(a2)));
    a5_csi(i) = sum(a5(i:length(a5)));
end

eb = [];
for i = 1:1:length(aB_csi)
    [~,pci] = binofit(aB_csi(i),(a0_csi(i)+a2_csi(i)+a5_csi(i)),.05);
    mean_ratio = aB_csi(i)/(a0_csi(i)+a2_csi(i)+a5_csi(i));
    eb(i,:) = [mean_ratio, pci(1), pci(2)];
end

figure; hold on; title(title_string); box on;
h = fill([(bin_width/2):bin_width:(1000-bin_width/2),fliplr((bin_width/2):bin_width:(1000-bin_width/2))],[eb(:,2);flipud(eb(:,3))],[.3 .3 .3],'linestyle','none');
set(h,'facealpha',.15);
plot((bin_width/2):bin_width:(1000-bin_width/2),aB_csi./(a0_csi+a2_csi+a5_csi),'-ok','Markersize',2);
ylabel({'Cumulative success/fail (on best option available) after distance'});
set(gca,'ylim',[0 1]);
xlabel(['Distance (mm) traveled since last transition binned at width ' num2str(bin_width)]);
set(gca,'xlim',[0 1000]);
set(gca,'xscale','log');

%% Plot success rate (non cumulative) over time since last transition
bins = [0:5:60, 90, 120, 240, 360, 600, 1200, 3600, 3600*10];
vx = [];
for i =1:1:(length(bins)-1)
    vx(i) = (bins(i) +bins(i+1))./2;
end

[a , ~] =find(eggs.substrate == eggs.first_substrate);
[aB , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,bins);
[a , ~] =find(eggs.substrate == 0 );
[a0 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,bins);
[a , ~] =find(eggs.substrate == 2 );
[a2 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,bins);
[a , ~] =find(eggs.substrate == 5 );
[a5 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,bins);

eb = [];
for i = 1:1:length(aB)
    [~,pci] = binofit(aB(i),(a0(i)+a2(i)+a5(i)),.05);
    mean_ratio = aB(i)/(a0(i)+a2(i)+a5(i));
    eb(i,:) = [mean_ratio, pci(1), pci(2)];
end

figure; hold on; title(title_string); box on;
h = fill([vx,fliplr(vx)],[eb(:,2);flipud(eb(:,3))],[.3 .3 .3],'linestyle','none');
set(h,'facealpha',.15);
plot(vx,aB./(a0+a2+a5),'-ok','Markersize',2);
ylabel({'Success/fail (on best option available)', 'line drawn at percent time spent on best substrate over all flies'});
set(gca,'ylim',[0 1]);
xlabel('Time (seconds) since last transition');
set(gca,'xlim',[0 (3600*10)]);
set(gca,'xscale','log');
best_time = 0;
total_time = 0;
for i = 1:1:length(trx)
    total_time = total_time+length(trx(1,i).sucrose(1:length(trx(1,i).x)));
    best_time = best_time+sum(trx(1,i).sucrose(1:length(trx(1,i).x)) == eggs.first_substrate);
end
line([vx(1), (3600*10)],[(best_time)/total_time, (best_time)/total_time],'Color','k');

%% Plot success rate (non cumulative) over distance traveled since last transition
bins = [0:10:500];
vx = [];
for i =1:1:(length(bins)-1)
    vx(i) = (bins(i) +bins(i+1))./2;
end

[a , ~] =find(eggs.substrate == eggs.first_substrate);
[aB , ~] = histcounts(eggs.etrans_dist_sub(a,1),bins);
[a , ~] =find(eggs.substrate == 0 );
[a0 , ~] = histcounts(eggs.etrans_dist_sub(a,1),bins);
[a , ~] =find(eggs.substrate == 2 );
[a2 , ~] = histcounts(eggs.etrans_dist_sub(a,1),bins);
[a , ~] =find(eggs.substrate == 5 );
[a5 , ~] = histcounts(eggs.etrans_dist_sub(a,1),bins);

eb = [];
for i = 1:1:length(aB)
    [~,pci] = binofit(aB(i),(a0(i)+a2(i)+a5(i)),.05);
    mean_ratio = aB(i)/(a0(i)+a2(i)+a5(i));
    eb(i,:) = [mean_ratio, pci(1), pci(2)];
end

figure; hold on; title(title_string); box on;
h = fill([vx,fliplr(vx)],[eb(:,2);flipud(eb(:,3))],[.3 .3 .3],'linestyle','none');
set(h,'facealpha',.15);
plot(vx,aB./(a0+a2+a5),'-ok','Markersize',2);
ylabel({'Success/fail (on best option available)'});
set(gca,'ylim',[0 1]);
xlabel('Distance (mm) since last transition');
set(gca,'xlim',[0 500]);
set(gca,'xscale','linear');
best_time = 0;
total_time = 0;
for i = 1:1:length(trx)
    total_time = total_time+length(trx(1,i).sucrose(1:length(trx(1,i).x)));
    best_time = best_time+sum(trx(1,i).sucrose(1:length(trx(1,i).x)) == eggs.first_substrate);
end
line([vx(1), 500],[(best_time)/total_time, (best_time)/total_time],'Color','k');

%% Rate graphs
if(eggs.first_substrate == eggs.second_substrate)
    single_choice = 1;
else
    single_choice = 0;
end

makerate(eggs, trx, title_string, [0:5:60, 90, 120, 240, 360, 600, 1200, 3600, 3600*10], 'eggtime', 0, 1,single_choice,length(0:5:60)-1);
%makerate(eggs, trx, title_string, [0:5:60, 90, 120, 240, 360, 600, 1200, 3600, 3600*10], 'eggnum', 20, 0,single_choice,length(0:5:60)-1);
%makerate(eggs, trx, title_string, [0:5:60, 90, 120, 240, 360, 600, 1200, 3600, 3600*10], 'eggnum', 20, 1,single_choice,length(0:5:60)-1);
makerate(eggs, trx, title_string, [0:5:60, 90, 120, 240, 360, 600, 1200, 3600, 3600*10], 'eggtime', 3, 0,single_choice,length(0:5:60)-1);
%makerate(eggs, trx, title_string, [0:5:60, 90, 120, 240, 360, 600, 1200, 3600, 3600*10], 'eggtime', 3, 1,single_choice,length(0:5:60)-1);

% rate graphs with more time than just explore
% Find all inter-egg intervals less than 15 minutes and have 3 minutes of data before first egg in this interval
%times_c = select_intereggintervals(trx, eggs, 15, 3);
%makerate_outexplore(eggs, trx, title_string,[0:5:60, 90, 120, 240, 360, 600, 1200, 3600, 3600*10], times_c, ' inter-egg less than 15 minutes, plus 3 minutes before inter-egg period',single_choice,length(0:5:60)-1);

% rate graphs with more time than just explore
times_c = select_timebeforeeggs(trx, eggs, 5, 1);
makerate_outexplore(eggs, trx, title_string, [0:5:60, 90, 120, 240, 360, 600, 1200, 3600, 3600*10], times_c, ' max of 5 minutes before egg or last transition',single_choice,length(0:5:60)-1);

% rate graphs with more time than just explore
%times_c = select_timebeforeeggs(trx, eggs, 10, 1);
%makerate_outexplore(eggs, trx, title_string, [0:5:60, 90, 120, 240, 360, 600, 1200, 3600, 3600*10], times_c, ' max of 10 minutes before egg or last transition',single_choice,length(0:5:60)-1);
%makerate_outexplore(eggs, trx, title_string, [0:.5:60], times_c, ' max of 10 minutes before egg or last transition',single_choice,length(0:.5:60)-1);

[bincenters, rate0, rate200, rate500] = makerate(eggs, trx, title_string, [0:.5:60], 'eggtime', 0, 1,single_choice,length(0:.5:60)-1);

%% PSD for rate functions
fs = 2;

if(eggs.first_substrate ==0)
    rate = rate0;
    y = rate(10:59,1);
    t = bincenters(10:59);
    figure; hold on; title(title_string); box on;
    plot(t,y,'r');
    title('y(t)')
    xlabel('Time (seconds)')
    ylabel({'y(t), Rate (Hz) of eggs on best substrate option after transition','line shows portion used for PSD'})
    h=fill([bincenters,fliplr(bincenters)],[rate(:,2);flipud(rate(:,3))],[1 0 0],'linestyle','none');
    set(h,'facealpha',.15);
end
if(eggs.first_substrate ==2)
    rate = rate200;
    y = rate(10:59,1);
    t = bincenters(10:59);
    figure; hold on; title(title_string); box on;
    plot(t,y,'g');
    title('y(t)')
    xlabel('Time (seconds)')
    ylabel({'y(t), Rate (Hz) of eggs on best substrate option after transition','line shows portion used for PSD'})
    h=fill([bincenters,fliplr(bincenters)],[rate(:,2);flipud(rate(:,3))],[0 1 0],'linestyle','none');
    set(h,'facealpha',.15);
end
if(eggs.first_substrate ==5)
    rate = rate500;
    y = rate(10:59,1);
    t = bincenters(10:59);
    figure; hold on; title(title_string); box on;
    plot(t,y,'b');
    title('y(t)')
    xlabel('Time (seconds)')
    ylabel({'y(t), Rate (Hz) of eggs on best substrate option after transition','line shows portion used for PSD'})
    h=fill([bincenters,fliplr(bincenters)],[rate(:,2);flipud(rate(:,3))],[0 0 1],'linestyle','none');
    set(h,'facealpha',.15);
end

%spectogram 1
ham_win = 20;
figure; hold on; title(title_string); box on;
[S,F,T,P] = spectrogram(y,rectwin(ham_win),ham_win-1,(length(y)),fs);
sf = surf(T+t(1),F,10*log10(abs(P)));
sf.EdgeColor = 'none';
axis tight
view(0,90)
xlabel({['Time (s) with rectwin window of ' num2str(ham_win/2) ' seconds'],'eggs laid on best substrate'})
ylabel('Frequency (Hz)')
zlabel('PSD');
colorbar; colormap('gray');

%spectogram 2
ham_win = 30;
figure; hold on; title(title_string); box on;
[S,F,T,P] = spectrogram(y,rectwin(ham_win),ham_win-1,(length(y)),fs);
sf = surf(T+t(1),F,10*log10(abs(P)));
sf.EdgeColor = 'none';
axis tight
view(0,90)
xlabel({['Time (s) with rectwin window of ' num2str(ham_win/2) ' seconds'],'eggs laid on best substrate'})
ylabel('Frequency (Hz)')
zlabel('PSD');
colorbar; colormap('gray');

%spectogram 3
ham_win = 40;
figure; hold on; title(title_string); box on;
[S,F,T,P] = spectrogram(y,rectwin(ham_win),ham_win-1,(length(y)),fs);
sf = surf(T+t(1),F,10*log10(abs(P)));
sf.EdgeColor = 'none';
axis tight
view(0,90)
xlabel({['Time (s) with rectwin window of ' num2str(ham_win/2) ' seconds'],'eggs laid on best substrate'})
ylabel('Frequency (Hz)')
zlabel('PSD');
colorbar;colormap('gray');

%spectogram 4
figure; hold on; box on;
[S,F,T,P] = spectrogram(y,rectwin(length(y)),1,(length(y)),fs);
plot(F,10*log10(abs(P)),'k');
ylabel('PSD')
xlabel({'Frequency (Hz)','eggs laid on best substrate'})


if(eggs.second_substrate ==0)
    rate = rate0;
    y = rate(10:59,1);
    t = bincenters(10:59);
    figure; hold on; title(title_string); box on;
    plot(t,y,'b');
    title('y(t)')
    xlabel('Time (seconds)')
    ylabel({'y(t), Rate (Hz) of eggs on second substrate option after transition','line shows portion used for PSD'})
    h=fill([bincenters,fliplr(bincenters)],[rate(:,2);flipud(rate(:,3))],[1 0 0],'linestyle','none');
    set(h,'facealpha',.15);
end
if(eggs.second_substrate ==2)
    rate = rate200;
    y = rate(10:59,1);
    t = bincenters(10:59);
    figure; hold on; title(title_string); box on;
    plot(t,y,'g');
    title('y(t)')
    xlabel('Time (seconds)')
    ylabel({'y(t), Rate (Hz) of eggs on second substrate option after transition','line shows portion used for PSD'})
    h=fill([bincenters,fliplr(bincenters)],[rate(:,2);flipud(rate(:,3))],[0 1 0],'linestyle','none');
    set(h,'facealpha',.15);
end
if(eggs.second_substrate ==5)
    rate = rate500;
    y = rate(10:59,1);
    t = bincenters(10:59);
    figure; hold on; title(title_string); box on;
    plot(t,y,'b');
    title('y(t)')
    xlabel('Time (seconds)')
    ylabel({'y(t), Rate (Hz) of eggs on second substrate option after transition','line shows portion used for PSD'})
    h=fill([bincenters,fliplr(bincenters)],[rate(:,2);flipud(rate(:,3))],[0 0 1],'linestyle','none');
    set(h,'facealpha',.15);
end

%spectogram 1
ham_win = 20;
figure; hold on; title(title_string); box on;
[S,F,T,P] = spectrogram(y,rectwin(ham_win),ham_win-1,(length(y)),fs);
sf = surf(T+t(1),F,10*log10(abs(P)));
sf.EdgeColor = 'none';
axis tight
view(0,90)
xlabel({['Time (s) with rectwin window of ' num2str(ham_win/2) ' seconds'],'eggs laid on second best substrate'})
ylabel('Frequency (Hz)')
zlabel('PSD');
colorbar; colormap('gray');

%spectogram 2
ham_win = 30;
figure; hold on; title(title_string); box on;
[S,F,T,P] = spectrogram(y,rectwin(ham_win),ham_win-1,(length(y)),fs);
sf = surf(T+t(1),F,10*log10(abs(P)));
sf.EdgeColor = 'none';
axis tight
view(0,90)
xlabel({['Time (s) with rectwin window of ' num2str(ham_win/2) ' seconds'],'eggs laid on second best substrate'})
ylabel('Frequency (Hz)')
zlabel('PSD');
colorbar; colormap('gray');

%spectogram 3
ham_win = 40;
figure; hold on; title(title_string); box on;
[S,F,T,P] = spectrogram(y,rectwin(ham_win),ham_win-1,(length(y)),fs);
sf = surf(T+t(1),F,10*log10(abs(P)));
sf.EdgeColor = 'none';
axis tight
view(0,90)
xlabel({['Time (s) with rectwin window of ' num2str(ham_win/2) ' seconds'],'eggs laid on second best substrate'})
ylabel('Frequency (Hz)')
zlabel('PSD');
colorbar;colormap('gray');

%spectogram 4
figure; hold on; title(title_string); box on;
[S,F,T,P] = spectrogram(y,rectwin(length(y)),1,(length(y)),fs);
plot(F,10*log10(abs(P)),'k');
ylabel('PSD')
xlabel({'Frequency (Hz)','eggs laid on second best substrate'})

%% DONE
out =1;
end
