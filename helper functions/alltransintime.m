function [trans_dur_0, trans_dur_200, trans_dur_500, trans_dur_500_from0, trans_dur_500_from200, trans_list] = alltransintime(trx, times)

trans_dur_0   = [];
trans_dur_200 = [];
trans_dur_500 = [];
trans_dur_500_from0 = [];
trans_dur_500_from200 = [];

for i = 1:1:size(times,1)
    a = find(trx(1,times(i,3)).transition_sub(times(i,1):times(i,2)));
    a = a+times(i,1)-1;
    a = sort(a,'descend');
    tran_list = [times(i,2); a];
    trans_dur = -1.*diff(tran_list);
    trans_list = a;
    
    
    
    for j = 1:1:(length(tran_list)-1)
        
        if(tran_list(j) == 1)
            if(trx(1,(times(i,3))).sucrose(tran_list(j)) == 0)
                trans_dur_0 = [trans_dur_0, trans_dur(j)];
            end
            
            if(trx(1,(times(i,3))).sucrose(tran_list(j)) == 2)
                trans_dur_200 = [trans_dur_200, trans_dur(j)];
            end
            
            if(trx(1,(times(i,3))).sucrose(tran_list(j)) == 5)
                trans_dur_500 = [trans_dur_500, trans_dur(j)];
            end
            
            if(trx(1,(times(i,3))).sucrose(tran_list(j)) == 5)
                trans_dur_500_from0 = [trans_dur_500_from0, trans_dur(j)];
            end
            
            if(trx(1,(times(i,3))).sucrose(tran_list(j)) == 5)
                trans_dur_500_from200 = [trans_dur_500_from200, trans_dur(j)];
            end
            
        else
            if(trx(1,(times(i,3))).sucrose(tran_list(j)-1) == 0)
                trans_dur_0 = [trans_dur_0, trans_dur(j)];
            end
            
            if(trx(1,(times(i,3))).sucrose(tran_list(j)-1) == 2)
                trans_dur_200 = [trans_dur_200, trans_dur(j)];
            end
            
            if(trx(1,(times(i,3))).sucrose(tran_list(j)-1) == 5)
                trans_dur_500 = [trans_dur_500, trans_dur(j)];
            end
            
            if(trx(1,(times(i,3))).sucrose(tran_list(j)-1) == 5 && lastsubstrate(trx, (times(i,3)),tran_list(j)-1) == 0)
                trans_dur_500_from0 = [trans_dur_500_from0, trans_dur(j)];
            end
            
            if(trx(1,(times(i,3))).sucrose(tran_list(j)-1) == 5 && lastsubstrate(trx, (times(i,3)),tran_list(j)-1) == 2)
                trans_dur_500_from200 = [trans_dur_500_from200, trans_dur(j)];
            end
            
        end
    end
    
    
end

end
