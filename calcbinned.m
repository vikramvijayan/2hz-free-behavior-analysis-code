function [eb0, eb2, eb5, eb5f0, eb5f2] = calcbinned(eggs, trx, v)


% egg-laying times from last transition
% egg-laying times from last transition
[a , ~] =find(eggs.substrate == 0);
[a1 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,v);

[a , ~] =find(eggs.substrate == 2);
[a2 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,v);

[a , ~] =find(eggs.substrate == 5);
[a3 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,v);

[a , ~] =find(eggs.substrate == 5 & eggs.last0 > eggs.last200);
[a4 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,v);

%[a , ~] =find(eggs.substrate == 5  & eggs.last200 >= eggs.last0);

% changed on 10/05/2020
[a , ~] =find(eggs.substrate == 5  & eggs.last200 > eggs.last0);
[a5 , ~] = histcounts((eggs.egg_time(a)-eggs.etrans_time_sub(a,1))./2,v);

% egg-laying times from last transition and encounters of bin during
% exploration from last transition
tmp_0 = [];
tmp_200 = [];
tmp_500 = [];
tmp_500_0 = [];
tmp_500_200 = [];

for i = 1:1:eggs.total
    [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, ~] = alltransinexplore(trx, eggs, i, 0, 'time');
    tmp_0 = [tmp_0, trans_dur_0./2];
    tmp_200 = [tmp_200, trans_dur_200./2];
    tmp_500 = [tmp_500, trans_dur_500./2];
    tmp_500_0 = [tmp_500_0, trans_dur_500_from0./2];
    tmp_500_200 = [tmp_500_200, trans_dur_500_from200./2];
end


[a1X , ~] = histcounts(tmp_0,v);
[a2X , ~] = histcounts(tmp_200,v);
[a3X , ~] = histcounts(tmp_500,v);
[a4X , ~] = histcounts(tmp_500_0,v);
[a5X , ~] = histcounts(tmp_500_200,v);

a1Xc = [];
a2Xc = [];
a3Xc = [];
a4Xc = [];
a5Xc = [];

for i = 1:1:length(a1X)
    a1Xc(i) = sum(a1X(i:1:end));
    a2Xc(i) = sum(a2X(i:1:end));
    a3Xc(i) = sum(a3X(i:1:end));
    a4Xc(i) = sum(a4X(i:1:end));
    a5Xc(i) = sum(a5X(i:1:end));
end

a1Xc2 = zeros(1,length(a1Xc));
a2Xc2 = zeros(1,length(a2Xc));
a3Xc2 = zeros(1,length(a3Xc));
a4Xc2 = zeros(1,length(a4Xc));
a5Xc2 = zeros(1,length(a5Xc));

for i = 1:1:eggs.total
    [~, ~, ~, ~, ~, trans_list] = alltransinexplore(trx, eggs, i, 0, 'time');
    if(eggs.explore_start_substrate(i) == 0 && eggs.explore_trans_sub(i) == 0)
        tmp_ns = [(eggs.egg_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_ns2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_ns,v);
        [q3 , ~] = histcounts(tmp_ns2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a1Xc2(j) = a1Xc2(j) + 1;
        end
    end
    
    if(eggs.explore_start_substrate(i) == 2 && eggs.explore_trans_sub(i) == 0)
        tmp_s = [(eggs.egg_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_s2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_s,v);
        [q3 , ~] = histcounts(tmp_s2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a2Xc2(j) = a2Xc2(j) + 1;
        end
    end
    
    if(eggs.explore_start_substrate(i) == 5 && eggs.explore_trans_sub(i) == 0)
        tmp_s = [(eggs.egg_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_s2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_s,v);
        [q3 , ~] = histcounts(tmp_s2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a3Xc2(j) = a3Xc2(j) + 1;
        end
    end
    
    if(eggs.explore_start_substrate(i) == 5 && eggs.explore_trans_sub(i) == 0 && eggs.last0(i) > eggs.last200(i))
        tmp_s = [(eggs.egg_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_s2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_s,v);
        [q3 , ~] = histcounts(tmp_s2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a4Xc2(j) = a4Xc2(j) + 1;
        end
    end
    
    if(eggs.explore_start_substrate(i) == 5 && eggs.explore_trans_sub(i) == 0 && eggs.last200(i) >= eggs.last0(i))
        tmp_s = [(eggs.egg_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_s2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_s,v);
        [q3 , ~] = histcounts(tmp_s2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a5Xc2(j) = a5Xc2(j) + 1;
        end
    end
    
    if(eggs.explore_start_substrate(i) == 0 && eggs.explore_trans_sub(i) > 0)
        tmp_ns = [(min(trans_list)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_ns2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_ns,v);
        [q3 , ~] = histcounts(tmp_ns2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a1Xc2(j) = a1Xc2(j) + 1;
        end
    end

    
    if(eggs.explore_start_substrate(i) == 2 && eggs.explore_trans_sub(i) > 0)
        tmp_s = [(min(trans_list)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_s2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_s,v);
        [q3 , ~] = histcounts(tmp_s2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a2Xc2(j) = a2Xc2(j) + 1;
        end
    end
    
    
    if(eggs.explore_start_substrate(i) == 5 && eggs.explore_trans_sub(i) > 0)
        tmp_s = [(min(trans_list)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_s2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_s,v);
        [q3 , ~] = histcounts(tmp_s2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a3Xc2(j) = a3Xc2(j) + 1;
        end
    end
    
    if(eggs.explore_start_substrate(i) == 5 && eggs.explore_trans_sub(i) > 0 && eggs.last0(i) > eggs.last200(i))
        tmp_s = [(min(trans_list)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_s2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_s,v);
        [q3 , ~] = histcounts(tmp_s2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a4Xc2(j) = a4Xc2(j) + 1;
        end
    end
    
    if(eggs.explore_start_substrate(i) == 5 && eggs.explore_trans_sub(i) > 0 && eggs.last200(i) >= eggs.last0(i))
        tmp_s = [(min(trans_list)-eggs.estart_trans_time_sub(i,1))./2];
        tmp_s2 = [(eggs.explore_start_time(i)-eggs.estart_trans_time_sub(i,1))./2];
        
        [q1 , ~] = histcounts(tmp_s,v);
        [q3 , ~] = histcounts(tmp_s2,v);
        [~, q6] = find(q1 == 1);
        [~, q8] = find(q3 == 1);
        
        for j =q8:1:q6
            a5Xc2(j) = a5Xc2(j) + 1;
        end
    end
    
end

a1Xc = a1Xc + a1Xc2;
a2Xc = a2Xc + a2Xc2;
a3Xc = a3Xc + a3Xc2;
a4Xc = a4Xc + a4Xc2;
a5Xc = a5Xc + a5Xc2;

eb0 = [];
eb2 = [];
eb5 = [];
eb5f0 = [];
eb5f2 = [];

eb0B = [];
eb2B = [];
eb5B = [];
eb5f0B = [];
eb5f2B = [];

for i = 1:1:length(a1)
    [~,pci] = binofit(a1(i),a1Xc(i),.05);
    mean_ratio = a1(i)./a1Xc(i);
    if(isnan(mean_ratio))
        pci = NaN(1,2);
    end
    eb0(i,:) = [mean_ratio, pci(1), pci(2), a1Xc(i), a1(i)];
    
    [~,pci] = binofit(a2(i),a2Xc(i),.05);
    mean_ratio = a2(i)./a2Xc(i);
    if(isnan(mean_ratio))
        pci = NaN(1,2);
    end
    eb2(i,:) = [mean_ratio, pci(1), pci(2), a2Xc(i), a2(i)];
    
    [~,pci] = binofit(a3(i),a3Xc(i),.05);
    mean_ratio = a3(i)./a3Xc(i);
    if(isnan(mean_ratio))
        pci = NaN(1,2);
    end
    eb5(i,:) = [mean_ratio, pci(1), pci(2), a3Xc(i), a3(i)];
    
    [~,pci] = binofit(a4(i),a4Xc(i),.05);
    mean_ratio = a4(i)./a4Xc(i);
    if(isnan(mean_ratio))
        pci = NaN(1,2);
    end
    eb5f0(i,:) = [mean_ratio,pci(1), pci(2), a4Xc(i), a4(i)];
    
    [~,pci] = binofit(a5(i),a5Xc(i),.05);
    mean_ratio = a5(i)./a5Xc(i);
    if(isnan(mean_ratio))
        pci = NaN(1,2);
    end
    eb5f2(i,:) = [mean_ratio,pci(1), pci(2), a5Xc(i), a5(i)];
end

end