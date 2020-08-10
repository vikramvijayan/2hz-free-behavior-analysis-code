function heatmat = positionheatmap_specifictimes(trx, substrate, times, choice, binzx, binzy)

if(choice == 2)
    heatmat = zeros(binzy,binzx);
    
    for j = 1:1:length(trx)
        x = ((trx(1,j).x - min(trx(1,j).x)));
        x = x./max(x).*binzx;
        y = ((trx(1,j).y - min(trx(1,j).y)));
        y = y./max(y).*binzy;
        
        x = ceil(x);
        [a b] = find(x==0);
        x(b) = 1;
        
        y = ceil(y);
        [a b] = find(y==0);
        y(b) = 1;
        
        if(substrate(1,j) ~= min(min(substrate)))
            y = binzy+1 - y;
        end
        
        [a b] = find(times(:,3) == j);
        
        for q = 1:1:length(a)
            for i = times(a(q),1):1:times(a(q),2)
                heatmat(y(i),x(i)) = heatmat(y(i),x(i)) + 1;
            end
        end
    end
end

if(choice == 3)   
    heatmat = zeros(binzy,binzx);
    
    for j = 1:1:length(trx)
        x = ((trx(1,j).x - min(trx(1,j).x)));
        x = x./max(x).*binzx;
        y = ((trx(1,j).y - min(trx(1,j).y)));
        y = y./max(y).*binzy;
        
        x = ceil(x);
        [a b] = find(x==0);
        x(b) = 1;
        
        y = ceil(y);
        [a b] = find(y==0);
        y(b) = 1;
        
        if(substrate(1,j) ~= min(min(substrate(1,:)),min(substrate(3,:))))
            y = binzy+1 - y;
        end
        
        [a b] = find(times(:,3) == j);
        
        for q = 1:1:length(a)
            for i = times(a(q),1):1:times(a(q),2)
                heatmat(y(i),x(i)) = heatmat(y(i),x(i)) + 1;
            end
        end
    end
end

if(choice == 5)
    heatmat = zeros(binzy,binzx);
    
    for j = 1:1:length(trx)
        x = ((trx(1,j).x - min(trx(1,j).x)));
        x = x./max(x).*binzx;
        y = ((trx(1,j).y - min(trx(1,j).y)));
        y = y./max(y).*binzy;
        
        x = ceil(x);
        [a b] = find(x==0);
        x(b) = 1;
        
        y = ceil(y);
        [a b] = find(y==0);
        y(b) = 1;
        
        if(substrate(1,j) ~= min(min(substrate(1,:)),min(substrate(5,:))))
            y = binzy+1 - y;
        end
        
        [a b] = find(times(:,3) == j);
        
        for q = 1:1:length(a)
            for i = times(a(q),1):1:times(a(q),2)
                heatmat(y(i),x(i)) = heatmat(y(i),x(i)) + 1;
            end
        end
    end
end

return