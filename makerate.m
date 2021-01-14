%% sample call
%[bincenters, rate0, rate200, rate500, eb0, eb2, eb5] =   makerate(eggs, trx, title_string, [0:5:30, 45, 60, 90, 120, 240, 360, 600, 1200, 7200], 'eggtime', 0, 1,0,length([0:5:30, 45, 60, 90, 120, 240, 360, 600, 1200, 7200])-1);


% Chance of laying an egg in bin versus total occurances of the same bin
% during exploration
% The x-axis is time from transition (which does ot have to be in
% exploration) to a time that was encounted in exploration (which has to be in exploration)

% plotasgraph is the number of plots to plot as graph (the rest are plotted
% as points with errorbar)
function [bincenters, rate0, rate200, rate500, eb0, eb2, eb5] =  makerate(egg, trx, title_string, binning, gate, gate_num, greater, single_choice, plotasgraph)


% v must be of uniform spacing, this is the underlying sampling of the data
% before any binning is applied
mJ = [];
for i =1:1:length(trx)
    J = find(diff(trx(1,i).transition_sub));
    J = [1 J];
    mJ(i) = max(abs(diff(J)));
end

v = 0:.5:(max(mJ)+10);
%v = 0:.5:6000;
diffv = mean(diff(v));

if(strcmp(gate,'eggnum') && greater == 1)
    [a , ~] = find(egg.num >= gate_num);
end

if(strcmp(gate,'eggnum') && greater == 0)
    [a , ~] = find(egg.num < gate_num);
end

if(strcmp(gate,'eggtime') && greater == 1)
    [a , ~] = find(egg.egg_time >= gate_num*7200);
end

if(strcmp(gate,'eggtime') && greater == 0)
    [a , ~] = find(egg.egg_time < gate_num*7200);
end

eggs = reshape_eggs(egg,a);

[eb0, eb2, eb5, eb5f0, eb5f2] = calcbinned(eggs,trx,v);
[eb0B, eb2B, eb5B, eb5f0B, eb5f2B] = calcbinned(eggs,trx,binning);

for i = 1:1:(length(binning)-1)
    vx(i) = (binning(i)+binning(i+1))/2;
end

for i = 1:1:(length(v)-1)
    vx2(i) = (v(i)+v(i+1))/2;
end


[a , ~] = histcounts(v,binning);
a(end) = a(end)-1;
c = 1;

for i = 1:1:length(a)
    eb0B(i,2) = 60*(eb0B(i,2)*eb0B(i,4)) * (1/diffv) / sum(eb0(c:(c+a(i)-1),4));
    eb0B(i,3) = 60*(eb0B(i,3)*eb0B(i,4)) * (1/diffv) / sum(eb0(c:(c+a(i)-1),4));
    eb0B(i,1) = 60*(1/diffv) * sum(eb0(c:(c+a(i)-1),5)) / sum(eb0(c:(c+a(i)-1),4));
    
    eb2B(i,2) = 60*(eb2B(i,2)*eb2B(i,4)) * (1/diffv) / sum(eb2(c:(c+a(i)-1),4));
    eb2B(i,3) = 60*(eb2B(i,3)*eb2B(i,4)) * (1/diffv) / sum(eb2(c:(c+a(i)-1),4));
    eb2B(i,1) = 60*(1/diffv) * sum(eb2(c:(c+a(i)-1),5)) / sum(eb2(c:(c+a(i)-1),4));
    
    eb5B(i,2) = 60*(eb5B(i,2)*eb5B(i,4)) * (1/diffv) / sum(eb5(c:(c+a(i)-1),4));
    eb5B(i,3) = 60*(eb5B(i,3)*eb5B(i,4)) * (1/diffv) / sum(eb5(c:(c+a(i)-1),4));
    eb5B(i,1) = 60*(1/diffv) * sum(eb5(c:(c+a(i)-1),5)) / sum(eb5(c:(c+a(i)-1),4));
    
    eb5f0B(i,2) = 60*(eb5f0B(i,2)*eb5f0B(i,4)) * (1/diffv) / sum(eb5f0(c:(c+a(i)-1),4));
    eb5f0B(i,3) = 60*(eb5f0B(i,3)*eb5f0B(i,4)) * (1/diffv) / sum(eb5f0(c:(c+a(i)-1),4));
    eb5f0B(i,1) = 60*(1/diffv) * sum(eb5f0(c:(c+a(i)-1),5)) / sum(eb5f0(c:(c+a(i)-1),4));
    
    eb5f2B(i,2) = 60*(eb5f2B(i,2)*eb5f2B(i,4)) * (1/diffv) / sum(eb5f2(c:(c+a(i)-1),4));
    eb5f2B(i,3) = 60*(eb5f2B(i,3)*eb5f2B(i,4)) * (1/diffv) / sum(eb5f2(c:(c+a(i)-1),4));
    eb5f2B(i,1) = 60*(1/diffv) * sum(eb5f2(c:(c+a(i)-1),5)) / sum(eb5f2(c:(c+a(i)-1),4));
    
    c = c+a(i);
end

if(greater == 0)
    title_great = ' less than ';
else
    title_great = ' greater than ';
end

figure; hold on; title([title_string ' for eggs with ' gate title_great num2str(gate_num) ]); box on;

% eb0B = eb5f0B;
% eb2B = eb5f2B;

if(any(eggs.all_substrates == 0))
    h = fill([vx(1:plotasgraph),fliplr(vx(1:plotasgraph))],[eb0B((1:plotasgraph),2);flipud(eb0B((1:plotasgraph),3))],[158,202,225]./255,'linestyle','none');
    set(h,'facealpha',.4);    
    %errorbar((2.*rand(1,1)-1)+binning(plotasgraph+1) + 2.5+ 5.* (0:1:(length(vx)-plotasgraph-1)), eb0B((1+plotasgraph):1:length(vx),1), eb0B((1+plotasgraph):1:length(vx),1)-eb0B((1+plotasgraph):1:length(vx),2), eb0B((1+plotasgraph):1:length(vx),3)-eb0B((1+plotasgraph):1:length(vx),1),'or','Linewidth',1,'MarkerSize',4,'MarkerFaceColor','r');
    errorbar((1.5)+binning(plotasgraph+1) + 2.5+ 5.* (0:1:(length(vx)-plotasgraph-1)), eb0B((1+plotasgraph):1:length(vx),1), eb0B((1+plotasgraph):1:length(vx),1)-eb0B((1+plotasgraph):1:length(vx),2), eb0B((1+plotasgraph):1:length(vx),3)-eb0B((1+plotasgraph):1:length(vx),1),'or','Linewidth',1,'MarkerSize',4,'MarkerFaceColor',[158,202,225]./255);
end

if(any(eggs.all_substrates == 2))
    h = fill([vx(1:plotasgraph),fliplr(vx(1:plotasgraph))],[eb2B((1:plotasgraph),2);flipud(eb2B((1:plotasgraph),3))],[33,113,181]./255,'linestyle','none');
    set(h,'facealpha',.4);
    %errorbar((2.*rand(1,1)-1)+binning(plotasgraph+1) + 2.5+5.* (0:1:(length(vx)-plotasgraph-1)), eb2B((1+plotasgraph):1:length(vx),1),  eb2B((1+plotasgraph):1:length(vx),1)-eb2B((1+plotasgraph):1:length(vx),2), eb2B((1+plotasgraph):1:length(vx),3)- eb2B((1+plotasgraph):1:length(vx),1),'og','Linewidth',1,'MarkerSize',4,'MarkerFaceColor','g');
    errorbar((0)+binning(plotasgraph+1) + 2.5+5.* (0:1:(length(vx)-plotasgraph-1)), eb2B((1+plotasgraph):1:length(vx),1),  eb2B((1+plotasgraph):1:length(vx),1)-eb2B((1+plotasgraph):1:length(vx),2), eb2B((1+plotasgraph):1:length(vx),3)- eb2B((1+plotasgraph):1:length(vx),1),'og','Linewidth',1,'MarkerSize',4,'MarkerFaceColor',[33,113,181]./255);


end

if(any(eggs.all_substrates == 5))
    h = fill([vx(1:plotasgraph),fliplr(vx(1:plotasgraph))],[eb5B((1:plotasgraph),2);flipud(eb5B((1:plotasgraph),3))],[8,48,107]./255,'linestyle','none');
    set(h,'facealpha',.4);
    %errorbar((2.*rand(1,1)-1)+binning(plotasgraph+1) + 2.5+5.* (0:1:(length(vx)-plotasgraph-1)), eb5B((1+plotasgraph):1:length(vx),1), eb5B((1+plotasgraph):1:length(vx),1)-eb5B((1+plotasgraph):1:length(vx),2), eb5B((1+plotasgraph):1:length(vx),3)-eb5B((1+plotasgraph):1:length(vx),1),'ob','Linewidth',1,'MarkerSize',4,'MarkerFaceColor','b');
    errorbar((1.5)+binning(plotasgraph+1) + 2.5+5.* (0:1:(length(vx)-plotasgraph-1)), eb5B((1+plotasgraph):1:length(vx),1), eb5B((1+plotasgraph):1:length(vx),1)-eb5B((1+plotasgraph):1:length(vx),2), eb5B((1+plotasgraph):1:length(vx),3)-eb5B((1+plotasgraph):1:length(vx),1),'ob','Linewidth',1,'MarkerSize',4,'MarkerFaceColor',[8,48,107]./255);
end


if(any(eggs.all_substrates == 0))
    plot(vx(1:plotasgraph),eb0B((1:plotasgraph),1),'-o','Color',[158,202,225]./255, 'Markerfacecolor',[158,202,225]./255,'MarkerSize',4,'Linewidth',1);
end
if(any(eggs.all_substrates == 2))
    plot(vx(1:plotasgraph),eb2B((1:plotasgraph),1),'-o','Color',[33,113,181]./255,'Markerfacecolor',[33,113,181]./255,'MarkerSize',4,'Linewidth',1);
end
if(any(eggs.all_substrates == 5))
    plot(vx(1:plotasgraph),eb5B((1:plotasgraph),1),'-o','Color',[8,48,107]./255,'Markerfacecolor',[8,48,107]./255,'MarkerSize',4,'Linewidth',1);
end

xlabel('Time since last substrate transition (seconds)');
ylabel('Rate (eggs/min) in exploration');
set(gca, 'xtick',[binning(1:(plotasgraph+1)), binning(plotasgraph+1) + 5.* (1:1:length(vx)-plotasgraph)]);
set(gca,'XTickLabel',[binning]);
set(gca, 'xlim',[0, binning(plotasgraph+1) + 5.* (length(vx)-plotasgraph)]);
set(gca, 'ylim',[0 5]);
set(gca, 'TickDir', 'out');
box off


%%%another type of fig

figure; hold on; box on;
vx2 = (2.5:5:(2.5+5*(length(vx)-1)));

if(any(eggs.all_substrates == 0))
    h = fill([vx2(1:end),fliplr(vx2(1:end))],[eb0B((1:end),2);flipud(eb0B((1:end),3))],[158,202,225]./255,'linestyle','none');
    set(h,'facealpha',.4);    
    %errorbar((1.5)+binning(plotasgraph+1) + 2.5+ 5.* (0:1:(length(vx)-plotasgraph-1)), eb0B((1+plotasgraph):1:length(vx),1), eb0B((1+plotasgraph):1:length(vx),1)-eb0B((1+plotasgraph):1:length(vx),2), eb0B((1+plotasgraph):1:length(vx),3)-eb0B((1+plotasgraph):1:length(vx),1),'or','Linewidth',1,'MarkerSize',4,'MarkerFaceColor','r');
end

if(any(eggs.all_substrates == 2))
    h = fill([vx2(1:end),fliplr(vx2(1:end))],[eb2B((1:end),2);flipud(eb2B((1:end),3))],[33,113,181]./255,'linestyle','none');
    set(h,'facealpha',.4);
    %errorbar((0)+binning(plotasgraph+1) + 2.5+5.* (0:1:(length(vx)-plotasgraph-1)), eb2B((1+plotasgraph):1:length(vx),1),  eb2B((1+plotasgraph):1:length(vx),1)-eb2B((1+plotasgraph):1:length(vx),2), eb2B((1+plotasgraph):1:length(vx),3)- eb2B((1+plotasgraph):1:length(vx),1),'og','Linewidth',1,'MarkerSize',4,'MarkerFaceColor','g');
end

if(any(eggs.all_substrates == 5))
    h = fill([vx2(1:end),fliplr(vx2(1:end))],[eb5B((1:end),2);flipud(eb5B((1:end),3))],[8,48,107]./255,'linestyle','none');
    set(h,'facealpha',.4);
    %errorbar((1.5)+binning(plotasgraph+1) + 2.5+5.* (0:1:(length(vx)-plotasgraph-1)), eb5B((1+plotasgraph):1:length(vx),1), eb5B((1+plotasgraph):1:length(vx),1)-eb5B((1+plotasgraph):1:length(vx),2), eb5B((1+plotasgraph):1:length(vx),3)-eb5B((1+plotasgraph):1:length(vx),1),'ob','Linewidth',1,'MarkerSize',4,'MarkerFaceColor','b');
end



if(any(eggs.all_substrates == 0))
    plot(vx2(1:end),eb0B((1:end),1),'-o','Color', [158,202,225]./255,'Markerfacecolor',[158,202,225]./255,'MarkerSize',4,'Linewidth',1);
end
if(any(eggs.all_substrates == 2))
    plot(vx2(1:end),eb2B((1:end),1),'-o','Color',[33,113,181]./255,'Markerfacecolor',[33,113,181]./255,'MarkerSize',4,'Linewidth',1);
end
if(any(eggs.all_substrates == 5))
    plot(vx2(1:end),eb5B((1:end),1),'-o','Color',[8,48,107]./255,'Markerfacecolor',[8,48,107]./255,'MarkerSize',4,'Linewidth',1);
end

line([61,61],[0 10],'linewidth',4, 'color','w');
set(gca, 'xtick',[vx2-2.5, vx2(end)+2.5]);
%set(gca,'XTickLabel',[]);
set(gca,'XTickLabel',[binning]);
%set(gca, 'xlim',[0, binning(plotasgraph+1) + 5.* (length(vx)-plotasgraph)]);
set(gca, 'xlim',[0,  5.* (length(vx2)+1)]);
set(gca, 'ylim',[0 5]);
a = gca;
% set box property to off and remove background color
set(a,'box','off','color','none')
% create new, empty axes with box but without ticks
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[]);
% set original axes as active
axes(a)
set(gca, 'TickDir', 'out');
box off
% link axes in case of zooming
linkaxes([a b])


%%%%%%%%

% figure; hold on; title([title_string ' for eggs with ' gate title_great num2str(gate_num) ]); box on;
% 
% xaxis_forplot = [vx(1:plotasgraph),binning(plotasgraph+1) + 2.5+ 5.* (0:1:(length(vx)-plotasgraph-1))];
% 
% xlabel('Time since last substrate transition (seconds)');
% ylabel('Total occurances of bin in exploration');
% plot(xaxis_forplot, eb0B(:,4), '-or','MarkerSize',2);
% plot(xaxis_forplot, eb2B(:,4),'-og','MarkerSize',2);
% plot(xaxis_forplot, eb5B(:,4),'-ob','MarkerSize',2);
% set(gca, 'xtick',[binning(1:(plotasgraph+1)), binning(plotasgraph+1) + 5.* (1:1:length(vx)-plotasgraph)]);
% set(gca,'XTickLabel',[binning]);
% set(gca, 'xlim',[0, binning(plotasgraph+1) + 5.* (length(vx)-plotasgraph)]);
% 
% 
% figure; hold on; title([title_string ' for eggs with ' gate title_great num2str(gate_num) ]); box on;
% 
% xlabel('Time since last substrate transition (seconds)');
% ylabel('Eggs laid in bin');
% plot(xaxis_forplot, eb0B(:,5), '-sr','MarkerSize',2);
% plot(xaxis_forplot, eb2B(:,5), '-sg','MarkerSize',2);
% plot(xaxis_forplot, eb5B(:,5), '-sb','MarkerSize',2);
% set(gca, 'xtick',[binning(1:(plotasgraph+1)), binning(plotasgraph+1) + 5.* (1:1:length(vx)-plotasgraph)]);
% set(gca,'XTickLabel',[binning]);
% set(gca, 'xlim',[0, binning(plotasgraph+1) + 5.* (length(vx)-plotasgraph)]);

bincenters = vx;
rate0 = eb0B;
rate200 = eb2B;
rate500 = eb5B;

end
