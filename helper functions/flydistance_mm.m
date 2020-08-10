% fly is the fly number
% startt and endt are in frames
% you will need to take cumsum(dist) to get cumulative distance
function dist = flydistance_mm(trx,fly,startt,endt)
dist = [];
for i = (startt):1:(endt-1)
    X = trx(1,fly).x_mm(i);
    Y = trx(1,fly).y_mm(i);
    Xn = trx(1,fly).x_mm(i+1);
    Yn = trx(1,fly).y_mm(i+1);
    dist(i-startt+1) = pdist([X Y; Xn Yn],'euclidean');
end

