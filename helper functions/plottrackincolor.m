% whattoplot can be 'time', theta', or 'dtheta'

function out = plottrackincolor(trx,fly,eggs,time1,time2,whattoplot)



trx_flyxlim = max(trx(1,fly(1)).x_mm) - min(trx(1,fly(1)).x_mm);
trx_flyylim = max(trx(1,fly(1)).y_mm) - min(trx(1,fly(1)).y_mm);

figure; hold on; box on;

if(eggs.chamber_style == 2 && strcmp(eggs.chamber_type,'two circles'))
    barrier_size = 1;
end
if(eggs.chamber_style == 2 && strcmp(eggs.chamber_type,'standard'))
    barrier_size = 4;
end

if(eggs.chamber_style == 2)
    fill([0 trx_flyxlim trx_flyxlim 0], [trx(1,fly(1)).middle_lineA- min(trx(1,fly(1)).y_mm)-barrier_size/2, trx(1,fly(1)).middle_lineA- min(trx(1,fly(1)).y_mm)-barrier_size/2, trx(1,fly(1)).middle_lineA- min(trx(1,fly(1)).y_mm)+barrier_size/2, trx(1,fly(1)).middle_lineA- min(trx(1,fly(1)).y_mm)+barrier_size/2],[.8 .8 .8],'Linestyle','none');
else
    fill([0 trx_flyxlim trx_flyxlim 0], [trx(1,fly(1)).middle_lineA- min(trx(1,fly(1)).y_mm)-barrier_size/2, trx(1,fly(1)).middle_lineA- min(trx(1,fly(1)).y_mm)-barrier_size/2, trx(1,fly(1)).middle_lineA- min(trx(1,fly(1)).y_mm)+barrier_size/2, trx(1,fly(1)).middle_lineA- min(trx(1,fly(1)).y_mm)+barrier_size/2],[.8 .8 .8],'Linestyle','none');
    fill([0 trx_flyxlim trx_flyxlim 0], [trx(1,fly(1)).middle_lineB- min(trx(1,fly(1)).y_mm)-barrier_size/2, trx(1,fly(1)).middle_lineB- min(trx(1,fly(1)).y_mm)-barrier_size/2, trx(1,fly(1)).middle_lineB- min(trx(1,fly(1)).y_mm)+barrier_size/2, trx(1,fly(1)).middle_lineB- min(trx(1,fly(1)).y_mm)+barrier_size/2],[.8 .8 .8],'Linestyle','none');
end

for i = 1:1:length(time1)
    trx_flyx = trx(1,fly(i)).x_mm(time1(i):time2(i)) - min(trx(1,fly(i)).x_mm);
    trx_flyy = trx(1,fly(i)).y_mm(time1(i):time2(i)) - min(trx(1,fly(i)).y_mm);
    
    trx_fly_theta = trx(1,fly(i)).theta(time1(i):time2(i));
    trx_fly_dtheta = trx(1,fly(i)).dtheta(time1(i):time2(i));
    
    if(strcmp(whattoplot,'time'));
        surface([trx_flyx; trx_flyx],[trx_flyy; trx_flyy],[i.*ones(1,length(trx_flyx)); i.*ones(1,length(trx_flyx))],[(1:(1+time2(i)-time1(i)))./(60*2);(1:(1+time2(i)-time1(i)))./(60*2)],'facecol','no','edgecol','interp','linew',1);
    end
    
    if(strcmp(whattoplot,'theta'));
        surface([trx_flyx; trx_flyx],[trx_flyy; trx_flyy],[i.*ones(1,length(trx_flyx)); i.*ones(1,length(trx_flyx))],[trx_fly_theta;trx_fly_theta],'facecol','no','edgecol','interp','linew',1);
    end
    
    if(strcmp(whattoplot,'dtheta'));
        surface([trx_flyx; trx_flyx],[trx_flyy; trx_flyy],[i.*ones(1,length(trx_flyx)); i.*ones(1,length(trx_flyx))],[trx_fly_dtheta;trx_fly_dtheta],'facecol','no','edgecol','interp','linew',1);
    end
    
    [a , ~] = find(eggs.fly == fly(i) & eggs.egg_time <= time2(i) & eggs.egg_time >= time1(i));
    for j = 1:1:length(a)
        if (eggs.substrate(a(j)) == 0)
            %scatter3 (trx(1,fly(i)).x_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).x_mm),trx(1,fly(i)).y_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).y_mm),length(time1)+1,15,'r','s','fill','markeredgecolor','k');
            scatter3 (trx(1,fly(i)).x_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).x_mm),trx(1,fly(i)).y_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).y_mm),i,15,'r','o','fill');
        end
        if (eggs.substrate(a(j)) == 2)
            %scatter3 (trx(1,fly(i)).x_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).x_mm),trx(1,fly(i)).y_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).y_mm),length(time1)+1,15,'g','s','fill','markeredgecolor','k');
            scatter3 (trx(1,fly(i)).x_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).x_mm),trx(1,fly(i)).y_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).y_mm),i,15,'g','o','fill');
            
        end
        if (eggs.substrate(a(j)) == 5)
            %scatter3 (trx(1,fly(i)).x_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).x_mm),trx(1,fly(i)).y_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).y_mm),length(time1)+1,15,'b','s','fill','markeredgecolor','k');
            scatter3 (trx(1,fly(i)).x_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).x_mm),trx(1,fly(i)).y_mm(eggs.egg_time(a(j)))-min(trx(1,fly(i)).y_mm),i,15,'b','o','fill');
            
        end
    end
end

colorbar; colormap(jet);
set(gca,'xlim',[0,trx_flyxlim]);
set(gca,'ylim',[0,trx_flyylim]);
xlabel('X position in chamber (mm)');
ylabel({'Y position in chamber', 'Color is time from beginnning of trajectory (minutes)', 'Z position is in order of inputted arguments'});


out =1;
end