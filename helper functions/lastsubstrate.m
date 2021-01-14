function [lastsub] = lastsubstrate(trx, fly, time)


    [a1 b1] = find(trx(1,fly).sucrose(1:time) ~= trx(1,fly).sucrose(time), 1, 'last');

    if(isempty(b1))
        a1 = 1;
        b1 = time;

    end
    
    lastsub = trx(1,fly).sucrose(b1);
    
end
