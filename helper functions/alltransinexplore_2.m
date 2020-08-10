% this function goes with "makerate_2"
% it is specifically for looking at rates on 200 and 500 mM since 0 mM. 0
% mM rates are computed as usual.

% rem will remove transitions from the beginning
% set it to 0 unless you want to get rid of transitions

% distortime will give you distance or tiem durations as output
function [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransinexplore_2(trx, eggs, egg_num, rem, distortime)

if((eggs.explore_trans_sub(egg_num)-rem) > 0)
    a = find(trx(1,eggs.fly(egg_num)).transition_sub(1:eggs.egg_time(egg_num)),eggs.explore_trans_sub(egg_num)-rem,'last');
    a = sort(a,'descend');
    
    tmp = ones(1,(eggs.explore_trans_sub(egg_num)-rem));
    tmp(1:length(a)) = a;
    
       
    %% added
    %% making it the last time since seeing 0
    for i=1:1:length(tmp)
        tmp_0_index_tmp = find(trx(1,eggs.fly(egg_num)).sucrose(1:tmp(i))==0,1,'last');
        if(isempty(tmp_0_index_tmp))
            tmp_0_index(i) = tmp(i) - 1;
        else
            tmp_0_index(i) = tmp(i) - tmp_0_index_tmp;
        end
    end
    
    %%
    %%
    
    
    
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
                trans_dur_0 = [trans_dur_0, tmp_0_index(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)) == 2)
                trans_dur_200 = [trans_dur_200, tmp_0_index(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)) == 5)
                trans_dur_500 = [trans_dur_500, tmp_0_index(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)) == 5)
                trans_dur_500_from0 = [trans_dur_500_from0, tmp_0_index(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)) == 5)
                trans_dur_500_from200 = [trans_dur_500_from200, tmp_0_index(j)];
            end
            
        else
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 0)
                trans_dur_0 = [trans_dur_0, tmp_0_index(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 2)
                trans_dur_200 = [trans_dur_200, tmp_0_index(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 5)
                trans_dur_500 = [trans_dur_500, tmp_0_index(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 5 && lastsubstrate(trx, eggs.fly(egg_num),tran_list(j)-1) == 0)
                trans_dur_500_from0 = [trans_dur_500_from0, tmp_0_index(j)];
            end
            
            if(trx(1,eggs.fly(egg_num)).sucrose(tran_list(j)-1) == 5 && lastsubstrate(trx, eggs.fly(egg_num),tran_list(j)-1) == 2)
                trans_dur_500_from200 = [trans_dur_500_from200, tmp_0_index(j)];
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
