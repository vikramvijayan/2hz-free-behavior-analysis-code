%% if search_dur is 0, you will use the traditional computationally determiend search. Otherwise it is the search duration in seconds

function [eggs, trx] = assemble_data_global_posttrx(trx, egg, substrate, search_dur, chamber_type, min_search)

% frames per second in trx
framerate = 2;

% number of flies
y = length(trx);

for i = 1:1:y
    [a, ~] = find(egg(:,i) > 0);
    egg(1:1:length(a),i) = sort(egg(1:1:length(a),i),'ascend');
end

% ------------------------------------------------------------------------
% PART 2: THIS PART OF THE CODE CREATES EGGS STRUCTURE. THIS IS DIFFERENT
% FROM THE EGG VARIABLE THAT YOU INITIALIZE.

eggs = struct;

tmp_trx = [];
for i = 1:1:y
    tmp_trx = [tmp_trx, trx(1,i).sucrose];
end
options = unique(tmp_trx);
options = sort(options,'ascend');
eggs.all_substrates = options;
eggs.first_substrate = options(1);
if(length(options) > 1)
    eggs.second_substrate = options(2);
else
    eggs.second_substrate = options(1);
end

eggs.chamber_style = 'mixed';
eggs.chamber_type = chamber_type;


% which fly did the egg come from (same order as trx) and what substrate is
% it on
eggs.fly = [];
eggs.num = [];

for i =1:y
    [a, ~] = find(egg(:,i) > 0);
    eggs.fly = [eggs.fly, i.*ones(1,length(a))];
    eggs.num = [eggs.num, 1:1:length(a)];
end
eggs.fly = transpose(eggs.fly);
eggs.num = transpose(eggs.num);

% total eggs
eggs.total = length(eggs.fly);

% time that egg was laid (comes from egg)
[tmp1 , ~] = find(egg(:)>0);
tmp2 = egg(:);
eggs.egg_time = tmp2(tmp1);

% substrate that egg is laid on (options are 0, 2, and 5 for different sucrose concentrations)
for i = 1:1:eggs.total
    eggs.substrate(i) = trx(1,eggs.fly(i)).sucrose(eggs.egg_time(i));
end
eggs.substrate = transpose(eggs.substrate);

% transitions times/distances prior to egg laying (1 is most proximal) of
% plastic barrier transitions
for i = 1:1:eggs.total
    a = find(trx(1,eggs.fly(i)).transition(1:eggs.egg_time(i)),10,'last');
    a = sort(a,'descend');
    tmp = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
    tmp(1:length(a)) = a;
    eggs.etrans_time(i,:) = tmp;
    eggs.etrans_dist(i,:) = trx(1,eggs.fly(i)).distance(eggs.egg_time(i)) - trx(1,eggs.fly(i)).distance(eggs.etrans_time(i,:));
end

% transitions times/distances prior to egg laying (1 is most proximal) of
% actual substrate transitions
for i = 1:1:eggs.total
    a = find(trx(1,eggs.fly(i)).transition_sub(1:eggs.egg_time(i)),10,'last');
    a = sort(a,'descend');
    tmp = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
    tmp(1:length(a)) = a;
    eggs.etrans_time_sub(i,:) = tmp;
    eggs.etrans_dist_sub(i,:) = trx(1,eggs.fly(i)).distance(eggs.egg_time(i)) - trx(1,eggs.fly(i)).distance(eggs.etrans_time_sub(i,:));
end

% transitions times post to egg laying (1 is most proximal) of
% plastic barrier transitions
for i = 1:1:eggs.total
    a = eggs.egg_time(i) + find(trx(1,eggs.fly(i)).transition((1+eggs.egg_time(i)):length(trx(1,eggs.fly(i)).x)),5,'first');
    a = sort(a,'ascend');
    tmp = length(trx(1,eggs.fly(i)).x).*[1; 1; 1; 1; 1];
    tmp(1:length(a)) = a;
    eggs.rtrans_time(i,:) = tmp;
    eggs.rtrans_dist(i,:) = trx(1,eggs.fly(i)).distance(eggs.rtrans_time(i,:)) - trx(1,eggs.fly(i)).distance(eggs.egg_time(i));
end

% transitions times post to egg laying (1 is most proximal) of
% actual substrate transitions
for i = 1:1:eggs.total
    a = eggs.egg_time(i) + find(trx(1,eggs.fly(i)).transition_sub((1+eggs.egg_time(i)):length(trx(1,eggs.fly(i)).x)),5,'first');
    a = sort(a,'ascend');
    tmp = length(trx(1,eggs.fly(i)).x).*[1; 1; 1; 1; 1];
    tmp(1:length(a)) = a;
    eggs.rtrans_time_sub(i,:) = tmp;
    eggs.rtrans_dist_sub(i,:) = trx(1,eggs.fly(i)).distance(eggs.rtrans_time_sub(i,:)) - trx(1,eggs.fly(i)).distance(eggs.egg_time(i));
end

% time at which exploration or run started/finished
for i = 1:1:eggs.total
    
    if(search_dur ~=0)
        if(i > 1 && (eggs.fly(i) == eggs.fly(i-1)))
            eggs.explore_start_time(i) = max([1, eggs.egg_time(i-1), eggs.egg_time(i)-search_dur*2]);
        else
            eggs.explore_start_time(i) = max([1, eggs.egg_time(i)-search_dur*2]);
        end
    end
    
    if(search_dur == 0)
        eggs.explore_start_time(i) =  min(findbouts(trx(1,eggs.fly(i)).speed(1:eggs.egg_time(i))), eggs.egg_time(i)-min_search*2);
    end
    
    eggs.run_end_time(i) = 1+length(trx(1,eggs.fly(i)).speed)- findruns(fliplr(trx(1,eggs.fly(i)).speed((1+eggs.egg_time(i)):end)));
    eggs.explore_start_substrate(i) = trx(1,eggs.fly(i)).sucrose(eggs.explore_start_time(i));
end
eggs.explore_start_time = transpose( eggs.explore_start_time);
eggs.run_end_time = transpose(eggs.run_end_time);
eggs.explore_start_substrate = transpose(eggs.explore_start_substrate);

% plastic transitions times prior to egg laying EXPLORATION (1 is most proximal)
% this was added on 1/13/15
for i = 1:1:eggs.total
    a = find(trx(1,eggs.fly(i)).transition(1:eggs.explore_start_time(i)),5,'last');
    a = sort(a,'descend');
    tmp = [1; 1; 1; 1; 1];
    tmp(1:length(a)) = a;
    eggs.estart_trans_time(i,:) = tmp;
end

% actual substrate transitions times prior to egg laying EXPLORATION (1 is most proximal)
% this was added on 1/13/15
for i = 1:1:eggs.total
    a = find(trx(1,eggs.fly(i)).transition_sub(1:eggs.explore_start_time(i)),5,'last');
    a = sort(a,'descend');
    tmp = [1; 1; 1; 1; 1];
    tmp(1:length(a)) = a;
    eggs.estart_trans_time_sub(i,:) = tmp;
end

% distance of exploration or run
for i = 1:1:eggs.total
    eggs.explore_dist(i) = trx(1,eggs.fly(i)).distance(eggs.egg_time(i)) - trx(1,eggs.fly(i)).distance(eggs.explore_start_time(i));
    eggs.run_dist(i) = trx(1,eggs.fly(i)).distance(eggs.run_end_time(i)) - trx(1,eggs.fly(i)).distance(eggs.egg_time(i));
    eggs.explore_distx(i) = trx(1,eggs.fly(i)).distancex(eggs.egg_time(i)) - trx(1,eggs.fly(i)).distancex(eggs.explore_start_time(i));
    eggs.explore_disty(i) = trx(1,eggs.fly(i)).distancey(eggs.egg_time(i)) - trx(1,eggs.fly(i)).distancey(eggs.explore_start_time(i));
    
end
eggs.explore_dist = transpose( eggs.explore_dist);
eggs.explore_distx = transpose( eggs.explore_distx);
eggs.explore_disty = transpose( eggs.explore_disty);
eggs.run_dist = transpose(eggs.run_dist);

% number of plastic transitions in exploration/run
for i = 1:1:eggs.total
    [a, ~] = find(trx(1,eggs.fly(i)).transition(eggs.explore_start_time(i):eggs.egg_time(i)));
    eggs.explore_trans(i) = length(a);
    [a, ~] = find(trx(1,eggs.fly(i)).transition(eggs.egg_time(i):eggs.run_end_time(i)));
    eggs.run_trans(i) = length(a);
    [a, ~] = find(trx(1,eggs.fly(i)).transition_invert(eggs.explore_start_time(i):eggs.egg_time(i)));
    eggs.explore_trans_invert(i) = length(a);
end
eggs.explore_trans = transpose(eggs.explore_trans);
eggs.run_trans = transpose(eggs.run_trans);
eggs.explore_trans_invert = transpose(eggs.explore_trans_invert);

% number of actual substrate transitions in exploration/run
for i = 1:1:eggs.total
    [a, ~] = find(trx(1,eggs.fly(i)).transition_sub(eggs.explore_start_time(i):eggs.egg_time(i)));
    eggs.explore_trans_sub(i) = length(a);
    [a, ~] = find(trx(1,eggs.fly(i)).transition_sub(eggs.egg_time(i):eggs.run_end_time(i)));
    eggs.run_trans_sub(i) = length(a);
end
eggs.explore_trans_sub = transpose(eggs.explore_trans_sub);
eggs.run_trans_sub = transpose(eggs.run_trans_sub);

% time of last visit to a particular substrate before egg-laying
for i = 1:1:eggs.total
    [~, a1] = find(trx(1,eggs.fly(i)).sucrose(1:eggs.egg_time(i)) == 0, 1, 'last');
    [~, a2] = find(trx(1,eggs.fly(i)).sucrose(1:eggs.egg_time(i)) == 2, 1, 'last');
    [~, a3] = find(trx(1,eggs.fly(i)).sucrose(1:eggs.egg_time(i)) == 5, 1, 'last');
    
    if(isempty(a1))
        a1 = 1;
    end
    
    if(isempty(a2))
        a2 = 1;
    end
    
    if(isempty(a3))
        a3 = 1;
    end
    eggs.last0(i) = a1;
    eggs.last200(i) = a2;
    eggs.last500(i) = a3;
end

eggs.last0 = transpose(eggs.last0);
eggs.last200 = transpose(eggs.last200);
eggs.last500 = transpose(eggs.last500);

if(eggs.first_substrate == 0)
    eggs.last_first = eggs.last0;
end
if(eggs.first_substrate == 2)
    eggs.last_first = eggs.last200;
end
if(eggs.first_substrate == 5)
    eggs.last_first = eggs.last500;
end
if(eggs.second_substrate == 0)
    eggs.last_second = eggs.last0;
end
if(eggs.second_substrate == 2)
    eggs.last_second = eggs.last200;
end
if(eggs.second_substrate == 5)
    eggs.last_second = eggs.last500;
end

% ------------------------------------------------------------------------
% PART 3: THIS PART OF THE CODE ADDS A FEW MORE THINGS TO TRX

for j = 1:1:y
    [a b] = find(eggs.fly == j);
    trx(1,j).eggs = zeros(1,length(trx(1,j).x));
    trx(1,j).eggs(eggs.egg_time(a)) = 1;
end


for j = 1:1:y
    [a b] = find(eggs.fly == j);
    trx(1,j).eggs = zeros(1,length(trx(1,j).x));
    trx(1,j).eggs(eggs.egg_time(a)) = 1;
end

for j = 1:1:y
    [a b] = find(eggs.fly == j);
    trx(1,j).search = zeros(1,length(trx(1,j).x));
    
    for q =1:1:length(a)
        trx(1,j).search(eggs.explore_start_time(a(q)):eggs.egg_time(a(q))) = 1;
    end
end

% ------------------------------------------------------------------------
% PART 4

% very important, this will set the substrate transitions to the real
% plastic transition for single choice chambers
if(length(eggs.all_substrates) == 1)
    eggs = reshape_eggs_plastic(eggs);
    trx = reshape_trx_plastic(trx);
end


