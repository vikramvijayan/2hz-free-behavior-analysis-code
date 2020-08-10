function [t0,t2,t5] = timeonsucrose(eggs, trx, times)
t5 = 0;
t2 = 0;
t0 = 0;
for j = 1:1:length(trx)
    [a b] = find(times(:,3) == j);
    
    for q = 1:1:length(a)
            [a1 b] = find(trx(1,j).sucrose(times(a(q),1):1:times(a(q),2)) == 0);
            [a2 b] = find(trx(1,j).sucrose(times(a(q),1):1:times(a(q),2)) == 2);
            [a5 b] = find(trx(1,j).sucrose(times(a(q),1):1:times(a(q),2)) == 5);
            t0 = t0+length(a1);
            t2 = t2+length(a2);
            t5 = t5+length(a5);
    end
end
    
