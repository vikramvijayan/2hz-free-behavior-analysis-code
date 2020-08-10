
function [egg] = reshape_eggs_plastic(eggs)

egg = eggs;
egg.etrans_time_sub = egg.etrans_time;
egg.etrans_dist_sub = egg.etrans_dist;
egg.rtrans_time_sub = egg.rtrans_time;
egg.rtrans_dist_sub = egg.rtrans_dist;
egg.estart_trans_time_sub = egg.estart_trans_time;
egg.explore_trans_sub = egg.explore_trans;
egg.run_trans_sub = egg.run_trans;


end