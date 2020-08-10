
function [trx2] = reshape_trx_plastic(trx)

trx2 = trx;
for i = 1:1:length(trx)
    trx2(1,i).transition_sub = trx2(1,i).transition;
end

end