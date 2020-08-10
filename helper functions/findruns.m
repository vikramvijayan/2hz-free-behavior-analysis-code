
% you provide the array of velocities before the egg laying event
function bouts = findruns(veldata)

swin = 37;
swinhalf = 18;
bouts = 1;

veldata_smooth = smooth(veldata,swin);
[a b] = find(veldata_smooth(1:1:end-swinhalf) < .13, 1, 'last');
bouts = a;
if(isempty(bouts))
    bouts = 1;
end
end
