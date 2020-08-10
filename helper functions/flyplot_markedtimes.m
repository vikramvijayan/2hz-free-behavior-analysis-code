% this function will plot a fly and all its eggs. tiems indicates times
% that you want to shade in grey in the plot.

%xlimits is the limits you want on the x axis
function   out = flyplot_markedtimes(trx, eggs, fly, times, xlimits, title_string, dense_ticks_onx)

framerate = 2;

if(eggs.chamber_style == 2)
    c_size = 20;
    barrier_size = 4;
    
    if(strcmp(eggs.chamber_type,'large'))
        c_size = 68;
        barrier_size = 4;
    end
    
    if(strcmp(eggs.chamber_type,'two circles'))
        c_size = 61;
        barrier_size = 1;
    end
    
    figure; xlabel('Time (hours)'); ylabel('Y position (mm)'); title([title_string ' Fly ' num2str(fly)]); hold on;
    
    c = 'rggbbb';
    [~,b] = max(trx(1,fly).y_mm);
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineA+barrier_size/2, trx(1,fly).middle_lineA+barrier_size/2, c_size, c_size],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    [~,b] = min(trx(1,fly).y_mm);
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [0,0, trx(1,fly).middle_lineA-barrier_size/2, trx(1,fly).middle_lineA-barrier_size/2],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    
    
    fill([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineA-barrier_size/2, trx(1,fly).middle_lineA-barrier_size/2, trx(1,fly).middle_lineA+barrier_size/2, trx(1,fly).middle_lineA+barrier_size/2],[.8 .8 .8],'Linestyle','none');
    plot (1:1:length(trx(1,fly).y_mm), trx(1,fly).y_mm,'k');
    
    set(gca,'xtick',0:(60*60*framerate):length(trx(1,fly).y_mm)); set(gca,'xticklabel',[0:1:length(0:(60*60*framerate):length(trx(1,fly).y_mm))]); axis tight; box on;
    set(gca,'ylim',[0,c_size]);
    
    if(dense_ticks_onx)
        set(gca,'xtick',0:(60*framerate):length(trx(1,fly).y_mm));
        set(gca,'xticklabel',[0:1:length(0:(60*framerate):length(trx(1,fly).y_mm))]);
        axis tight;
        box on;
        xlabel('Time (min)')
    end
    
    [a , ~] = find(eggs.fly == fly);
    for j = 1:1:length(a)
        if (eggs.substrate(a(j)) == 0)
            scatter (eggs.egg_time(a(j)),trx(1,fly).y_mm(eggs.egg_time(a(j))),15,'r','o','fill');
        end
        if (eggs.substrate(a(j)) == 2)
            scatter (eggs.egg_time(a(j)),trx(1,fly).y_mm(eggs.egg_time(a(j))),15,'g','o','fill');
        end
        if (eggs.substrate(a(j)) == 5)
            scatter (eggs.egg_time(a(j)),trx(1,fly).y_mm(eggs.egg_time(a(j))),15,'b','o','fill');
        end
    end
end

if(eggs.chamber_style == 3)
    c_size = 32;
    figure; xlabel('Time (hours)'); ylabel('Y position (mm)'); title([title_string ' Fly ' num2str(fly)]); hold on;
    
    c = 'rggbbb';
    [~,b] = max(trx(1,fly).y_mm);
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineB+2, trx(1,fly).middle_lineB+2, c_size, c_size],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    [~,b] = find(trx(1,fly).y_mm < trx(1,fly).middle_lineB &  trx(1,fly).y_mm > trx(1,fly).middle_lineA,1,'first');
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineA+2, trx(1,fly).middle_lineA+2, trx(1,fly).middle_lineB-2, trx(1,fly).middle_lineB-2],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    [~,b] = min(trx(1,fly).y_mm);
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [0,0, trx(1,fly).middle_lineA-2, trx(1,fly).middle_lineA-2],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    
    fill([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineA-2, trx(1,fly).middle_lineA-2, trx(1,fly).middle_lineA+2, trx(1,fly).middle_lineA+2],[.8 .8 .8],'Linestyle','none');
    fill([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineB-2, trx(1,fly).middle_lineB-2, trx(1,fly).middle_lineB+2, trx(1,fly).middle_lineB+2],[.8 .8 .8],'Linestyle','none');
    plot (1:1:length(trx(1,fly).y_mm), trx(1,fly).y_mm,'k');
    
    set(gca,'xtick',0:(60*60*framerate):length(trx(1,fly).y_mm)); set(gca,'xticklabel',[0:1:length(0:(60*60*framerate):length(trx(1,fly).y_mm))]); axis tight; box on;
    set(gca,'ylim',[0,c_size]);
    
    if(dense_ticks_onx)
        set(gca,'xtick',0:(60*framerate):length(trx(1,fly).y_mm));
        set(gca,'xticklabel',[0:1:length(0:(60*framerate):length(trx(1,fly).y_mm))]);
        axis tight;
        box on;
        xlabel('Time (min)')
    end
    
    [a , ~] = find(eggs.fly == fly);
    for j = 1:1:length(a)
        if (eggs.substrate(a(j)) == 0)
            scatter (eggs.egg_time(a(j)),trx(1,fly).y_mm(eggs.egg_time(a(j))),15,'r','o','fill');
        end
        if (eggs.substrate(a(j)) == 2)
            scatter (eggs.egg_time(a(j)),trx(1,fly).y_mm(eggs.egg_time(a(j))),15,'g','o','fill');
        end
        if (eggs.substrate(a(j)) == 5)
            scatter (eggs.egg_time(a(j)),trx(1,fly).y_mm(eggs.egg_time(a(j))),15,'b','o','fill');
        end
    end
end

if(eggs.chamber_style == 5)
    c_size = 56;
    figure; xlabel('Time (hours)'); ylabel('Y position (mm)'); title([title_string ' Fly ' num2str(fly)]); hold on;
    
    c = 'rggbbb';
    [~,b] = max(trx(1,fly).y_mm);
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1],[trx(1,fly).middle_lineD+2, trx(1,fly).middle_lineD+2, c_size, c_size],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    
    [~,b] = find(trx(1,fly).y_mm < trx(1,fly).middle_lineD &  trx(1,fly).y_mm > trx(1,fly).middle_lineC,1,'first');
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineC+2, trx(1,fly).middle_lineC+2, trx(1,fly).middle_lineD-2, trx(1,fly).middle_lineD-2],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    
    [~,b] = find(trx(1,fly).y_mm < trx(1,fly).middle_lineC &  trx(1,fly).y_mm > trx(1,fly).middle_lineB,1,'first');
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineB+2, trx(1,fly).middle_lineB+2, trx(1,fly).middle_lineC-2, trx(1,fly).middle_lineC-2],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    
    [~,b] = find(trx(1,fly).y_mm < trx(1,fly).middle_lineB &  trx(1,fly).y_mm > trx(1,fly).middle_lineA,1,'first');
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineA+2, trx(1,fly).middle_lineA+2, trx(1,fly).middle_lineB-2, trx(1,fly).middle_lineB-2],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    
    [~,b] = min(trx(1,fly).y_mm);
    patch([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [0,0, trx(1,fly).middle_lineA-2, trx(1,fly).middle_lineA-2],c(trx(1,fly).sucrose(b)+1),'FaceAlpha',.15,'EdgeColor','none');
    
    fill([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineA-2, trx(1,fly).middle_lineA-2, trx(1,fly).middle_lineA+2, trx(1,fly).middle_lineA+2],[.8 .8 .8],'Linestyle','none');
    fill([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineB-2, trx(1,fly).middle_lineB-2, trx(1,fly).middle_lineB+2, trx(1,fly).middle_lineB+2],[.8 .8 .8],'Linestyle','none');
    fill([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineC-2, trx(1,fly).middle_lineC-2, trx(1,fly).middle_lineC+2, trx(1,fly).middle_lineC+2],[.8 .8 .8],'Linestyle','none');
    fill([1, length(trx(1,fly).y_mm), length(trx(1,fly).y_mm), 1], [trx(1,fly).middle_lineD-2, trx(1,fly).middle_lineD-2, trx(1,fly).middle_lineD+2, trx(1,fly).middle_lineD+2],[.8 .8 .8],'Linestyle','none');
    
    plot (1:1:length(trx(1,fly).y_mm), trx(1,fly).y_mm,'k');
    
    set(gca,'xtick',0:(60*60*framerate):length(trx(1,fly).y_mm)); set(gca,'xticklabel',[0:1:length(0:(60*60*framerate):length(trx(1,fly).y_mm))]); axis tight; box on;
    set(gca,'ylim',[0,c_size]);
    
    if(dense_ticks_onx)
        set(gca,'xtick',0:(60*framerate):length(trx(1,fly).y_mm));
        set(gca,'xticklabel',[0:1:length(0:(60*framerate):length(trx(1,fly).y_mm))]);
        axis tight;
        box on;
        xlabel('Time (min)')
    end
    
    [a , ~] = find(eggs.fly == fly);
    for j = 1:1:length(a)
        if (eggs.substrate(a(j)) == 0)
            scatter (eggs.egg_time(a(j)),trx(1,fly).y_mm(eggs.egg_time(a(j))),15,'r','o','fill');
        end
        if (eggs.substrate(a(j)) == 2)
            scatter (eggs.egg_time(a(j)),trx(1,fly).y_mm(eggs.egg_time(a(j))),15,'g','o','fill');
        end
        if (eggs.substrate(a(j)) == 5)
            scatter (eggs.egg_time(a(j)),trx(1,fly).y_mm(eggs.egg_time(a(j))),15,'b','o','fill');
        end
    end
end

[aa bb] = size(times);

for i = 1:1:aa
    patch([times(i,1),times(i,1),times(i,2),times(i,2)], [0, c_size, c_size, 0],[.5 .5 .5],'FaceAlpha',.5,'EdgeColor','none');
end
set(gca,'xlim',[xlimits]);

out = 1;
end

