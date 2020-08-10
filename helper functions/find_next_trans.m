% transition array can be trans or trans_sub
function out = find_next_trans(transition_array, currenttime)
    out = find(transition_array(currenttime:end) ~= 0,1,'first')+currenttime-1;
    if(isempty(out))
        out = length(transition_array);
    end
end
