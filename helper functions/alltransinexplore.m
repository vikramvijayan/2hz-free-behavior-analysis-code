% rem will remove transitions from the beginning
% set it to 0 unless you want to get rid of transitions

% distortime will give you distance or tiem durations as output
function [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore(trx, eggs, egg_num, rem, distortime)

if((eggs.explore_trans_sub(egg_num)-rem) > 0)
    a = find(trx(1,eggs.fly(egg_num)).transition_sub(1:eggs.egg_time(egg_num)),eggs.explore_trans_sub(egg_num)-rem,'last');
    a = sort(a,'descend');
    tmp = ones(1,(eggs.explore_trans_sub(egg_num)-rem));
    tmp(1:length(a)) = a;
    tran_list = [eggs.egg_time(egg_num), tmp];
    
    if(strcmp(distortime,'dist'))
        trans_dur = -1.*diff(trx(1,eggs.fly(egg_num)).distance(tran_list));
    end
    
    if(strcmp(distortime,'distx'))
        trans_dur = -1.*diff(trx(1,eggs.fly(egg_num)).distancex(tran_list));
    end
    
    if(strcmp(distortime,'disty'))
        trans_dur = -1.*diff(trx(1,eggs.fly(egg_num)).distancey(tran_list));
    end
    
    if(strcmp(distortime,'time'))
        trans_dur = -1.*diff(tran_list);
    end
    
    trans_list = tmp;
    
    trans_dur_0   = [];
    trans_dur_200 = [];
    trans_dur_500 = [];
    trans_dur_500_from0 = [];
    trans_dur_500_from200 = [];
    
    for j = 1:1:(length(tran_list)-1)
        
        if(tran_list(j) == 1)
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)) == 0)
                trans_dur_0 = [trans_dur_0, trans_dur(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)) == 2)
                trans_dur_200 = [trans_dur_200, trans_dur(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)) == 5)
                trans_dur_500 = [trans_dur_500, trans_dur(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)) == 5)
                trans_dur_500_from0 = [trans_dur_500_from0, trans_dur(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)) == 5)
                trans_dur_500_from200 = [trans_dur_500_from200, trans_dur(j)];
            end
            
        else
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 0)
                trans_dur_0 = [trans_dur_0, trans_dur(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 2)
                trans_dur_200 = [trans_dur_200, trans_dur(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 5)
                trans_dur_500 = [trans_dur_500, trans_dur(j)];
            end
       
            if((trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 5) && (lastsubstrate(trx, eggs.fly(egg_num),tran_list(j)-1) == 0))
                trans_dur_500_from0 = [trans_dur_500_from0, trans_dur(j)];
            end
            
            if((trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 5) && (lastsubstrate(trx, eggs.fly(egg_num),tran_list(j)-1) == 2))
                trans_dur_500_from200 = [trans_dur_500_from200, trans_dur(j)];
            end
            
        end
    end
    
else
    trans_dur_0   = [];
    trans_dur_200 = [];
    trans_dur_500 = [];
    trans_dur_500_from0 = [];
    trans_dur_500_from200 = [];
    trans_list = [];
end

end
