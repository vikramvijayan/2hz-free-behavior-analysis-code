%% if search_dur is 0, you will use the traditional computationally determiend search. Otherwise it is the search duration in seconds

%% min search is the minimum search duration in seconds
function [eggs, trx] = assemble_data_global(trx, egg, substrate, search_dur, chamber_type, min_search, max_search)

% substrate is coded as a matrix. Each column is a new chamber,
% each row is top, middle, and bottom. Options are 0, 2, and 5.

% frames per second in trx
framerate = 2;

% number of flies
y = length(substrate);

% reorder egg to make sure all eggs are in ascending order. all new data
% files should already be in ascending order, but some of the old ones are
% not always in ascending order. this is a new addition to the code on
% 1/5/2015

for i = 1:1:y
    [a, ~] = find(egg(:,i) > 0);
    egg(1:1:length(a),i) = sort(egg(1:1:length(a),i),'ascend');
end

% calculate the maximum number of frames for any fly in the data set in
% max_frames

z = [];
for i = 1:1:length(trx)
    z(i) = length(trx(1,i).y);
end
max_frames = max(z);

% ------------------------------------------------------------------------
% PART 1: THIS PART OF THE CODE ADDS SOME DATA TO TRX STRUCTURE

% create an array in trx that tells the substrate that the fly is on

trx_binary = zeros(max_frames,y);
trx_binary_invert = zeros(max_frames,y);
trx_binary_tmp = zeros(max_frames,y);
trx_binary_tmp2 = zeros(max_frames,y);
trx_binary_tmp3 = zeros(max_frames,y);

trx_sucrose = zeros(max_frames,y);

[rows_s, ~] = size(substrate);

% modified on 01/25/16 to get more precise boundary
% If there are 5 rows in substrate and chamber_typwe is standard, we are 
% dealing with a normal 5 choice chamber
if(rows_s == 5 && strcmp(chamber_type,'standard'))
    for i=1:y
        
        % correcting for the 1mm on edges that centroids are not present
        max_column = max(trx(1,i).y) + (max(trx(1,i).y) - min(trx(1,i).y))/54;
        min_column = min(trx(1,i).y) - (max(trx(1,i).y) - min(trx(1,i).y))/54;
        
        % finding the middle of all the plastic barriers
        middle_lineA(i) = 10*(max_column-min_column)/56 + min_column;
        middle_lineB(i) = 22*(max_column-min_column)/56 + min_column;
        middle_lineC(i) = 34*(max_column-min_column)/56 + min_column;
        middle_lineD(i) = 46*(max_column-min_column)/56 + min_column;
        
        % which part of the chamber is the fly on
        trx_binary(1:1:length(trx(1,i).y),i) = (trx(1,i).y > middle_lineA(i));
        trx_binary_tmp(1:1:length(trx(1,i).y),i) = (trx(1,i).y > middle_lineB(i));
        trx_binary_tmp2(1:1:length(trx(1,i).y),i) = (trx(1,i).y > middle_lineC(i));
        trx_binary_tmp3(1:1:length(trx(1,i).y),i) = (trx(1,i).y > middle_lineD(i));
        trx_binary(1:1:length(trx(1,i).y),i) = trx_binary(1:1:length(trx(1,i).y),i) + trx_binary_tmp(1:1:length(trx(1,i).y),i) + trx_binary_tmp2(1:1:length(trx(1,i).y),i) + trx_binary_tmp3(1:1:length(trx(1,i).y),i);
           
        % adjust the x and y coordinate (x_mm) and (y_mm) to be between 0
        % and limits of chamber       
        trx(1,i).y_mm = trx(1,i).y_mm - min(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/54;
        trx(1,i).x_mm = trx(1,i).x_mm - min(trx(1,i).x_mm) + (max(trx(1,i).x_mm) - min(trx(1,i).x_mm))/18;
    
        % finding the middle of all the plastic barriers in mm
        max_column_mm = max(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/54; 
        min_column_mm = min(trx(1,i).y_mm) - (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/54;
        trx(1,i).middle_lineA =  10*(max_column_mm-min_column_mm)/56 + min_column_mm;
        trx(1,i).middle_lineB =  22*(max_column_mm-min_column_mm)/56 + min_column_mm;
        trx(1,i).middle_lineC =  34*(max_column_mm-min_column_mm)/56 + min_column_mm;
        trx(1,i).middle_lineD =  46*(max_column_mm-min_column_mm)/56 + min_column_mm;
        
        for j = 1:1:max_frames
            if(trx_binary(j,i) == 0)
                trx_sucrose(j,i) = substrate(5,i);
            end
            
            if(trx_binary(j,i) == 1)
                trx_sucrose(j,i) = substrate(4,i);
            end
            
            if(trx_binary(j,i) == 2)
                trx_sucrose(j,i) = substrate(3,i);
            end
            
            if(trx_binary(j,i) == 3)
                trx_sucrose(j,i) = substrate(2,i);
            end
            
            if(trx_binary(j,i) == 4)
                trx_sucrose(j,i) = substrate(1,i);
            end
        end
        trx(1,i).sucrose = trx_sucrose(1:length(trx(1,i).x),i);
        trx(1,i).binary = trx_binary(1:length(trx(1,i).x),i);
        
        trx(1,i).sucrose = trx(1,i).sucrose';
        trx(1,i).binary = trx(1,i).binary';
    end
end

% modified on 01/25/16 to get more precise boundary
% If there are 3 rows in substrate and chamber_typwe is standard, we are 
% dealing with a normal 3 choice chamber
if(rows_s == 3 && strcmp(chamber_type,'standard'))
    for i=1:y
        
        % correcting for the 1mm on edges that centroids are not present
        max_column = max(trx(1,i).y) + (max(trx(1,i).y) - min(trx(1,i).y))/30;
        min_column = min(trx(1,i).y) - (max(trx(1,i).y) - min(trx(1,i).y))/30;
        
        % finding the middle of all the plastic barriers
        middle_lineA(i) = 10*(max_column -min_column)/32 + min_column;
        middle_lineB(i) = 22*(max_column -min_column)/32 + min_column;


        % which part of the chamber is the fly on
        trx_binary(1:1:length(trx(1,i).y),i) = (trx(1,i).y > middle_lineA(i));
        trx_binary_tmp(1:1:length(trx(1,i).y),i) = (trx(1,i).y > middle_lineB(i));
        trx_binary(1:1:length(trx(1,i).y),i) = trx_binary(1:1:length(trx(1,i).y),i) + trx_binary_tmp(1:1:length(trx(1,i).y),i);
        
        % adjust the x and y coordinate (x_mm) and (y_mm) to be between 0
        % and limits of chamber       
        trx(1,i).y_mm = trx(1,i).y_mm - min(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/30;
        trx(1,i).x_mm = trx(1,i).x_mm - min(trx(1,i).x_mm) + (max(trx(1,i).x_mm) - min(trx(1,i).x_mm))/18;
        
        % finding the middle of all the plastic barriers in mm
        max_column_mm = max(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/30; 
        min_column_mm = min(trx(1,i).y_mm) - (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/30; 
        trx(1,i).middle_lineA =  10*(max_column_mm-min_column_mm)/32 + min_column_mm;
        trx(1,i).middle_lineB =  22*(max_column_mm-min_column_mm)/32 + min_column_mm;
        trx(1,i).middle_lineC =  0;
        trx(1,i).middle_lineD =  0;
        
        for j = 1:1:max_frames
            if(trx_binary(j,i) == 0)
                trx_sucrose(j,i) = substrate(3,i);
            end
            
            if(trx_binary(j,i) == 1)
                trx_sucrose(j,i) = substrate(2,i);
            end
            
            if(trx_binary(j,i) == 2)
                trx_sucrose(j,i) = substrate(1,i);
            end
        end
        trx(1,i).sucrose = trx_sucrose(1:length(trx(1,i).x),i);
        trx(1,i).binary = trx_binary(1:length(trx(1,i).x),i);
        
        trx(1,i).sucrose = trx(1,i).sucrose';
        trx(1,i).binary = trx(1,i).binary';
    end
end

% modified on 01/25/16 to get more precise boundary
% If there are 2 rows in substrate and chamber_typwe is standard, we are 
% dealing with a normal 2 choice chamber
if(rows_s == 2 && strcmp(chamber_type,'standard'))
    for i=1:y
        
        % this is code that inverts the x and y and allows anaysis with a
        % fake vertical boudary.
        % make sure it is commented during regualt operation of the code!
%         disp('you know you are inverting the boudary, right?')
%         tmp_y_pos = trx(1,i).y;
%         trx(1,i).y = trx(1,i).x;
%         trx(1,i).x = tmp_y_pos;
        
        % correcting for the 1mm on edges that centroids are not present
        max_column = max(trx(1,i).y) + (max(trx(1,i).y) - min(trx(1,i).y))/18; 
        min_column = min(trx(1,i).y) - (max(trx(1,i).y) - min(trx(1,i).y))/18; 
      
        % finding the middle of all the plastic barriers
        middle_line(i) = 10*(max_column -min_column)/20 + min_column;
        
        % which part of the chamber is the fly on
        trx_binary(1:1:length(trx(1,i).y),i) = (trx(1,i).y > middle_line(i));
        
        % adjust the x and y coordinate (x_mm) and (y_mm) to be between 0
        % and limits of chamber       
        trx(1,i).y_mm = trx(1,i).y_mm - min(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/18;
        trx(1,i).x_mm = trx(1,i).x_mm - min(trx(1,i).x_mm) + (max(trx(1,i).x_mm) - min(trx(1,i).x_mm))/18;
        
        % finding the middle of all the plastic barriers in mm
        max_column_mm = max(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/18; 
        min_column_mm = min(trx(1,i).y_mm) - (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/18; 
        trx(1,i).middle_lineA =  10*(max_column_mm-min_column_mm)/20 + min_column_mm;        
        trx(1,i).middle_lineB =  0;
        trx(1,i).middle_lineC =  0;
        trx(1,i).middle_lineD =  0;
        
        for j = 1:1:max_frames
            if(trx_binary(j,i) == 0)
                trx_sucrose(j,i) = substrate(2,i);
            end
            
            if(trx_binary(j,i) == 1)
                trx_sucrose(j,i) = substrate(1,i);
            end
            
        end
        trx(1,i).sucrose = trx_sucrose(1:length(trx(1,i).x),i);
        trx(1,i).binary = trx_binary(1:length(trx(1,i).x),i);
        
        trx(1,i).sucrose = trx(1,i).sucrose';
        trx(1,i).binary = trx(1,i).binary';
    end
end


% modified on 01/31/16
% chamber has 2 30 mm diameter circles and 1 mm barrier inbetween the circ;les
% giving total y of 61 mm
if(rows_s == 2 && strcmp(chamber_type,'two circles'))
    for i=1:y
        
        % correcting for the 1mm on edges that centroids are not present
        max_column = max(trx(1,i).y) + (max(trx(1,i).y) - min(trx(1,i).y))/59; 
        min_column = min(trx(1,i).y) - (max(trx(1,i).y) - min(trx(1,i).y))/59; 
      
        % finding the middle of all the plastic barriers
        middle_line(i) = 30.5*(max_column -min_column)/61 + min_column;
        
        % which part of the chamber is the fly on
        trx_binary(1:1:length(trx(1,i).y),i) = (trx(1,i).y > middle_line(i));
        
        % adjust the x and y coordinate (x_mm) and (y_mm) to be between 0
        % and limits of chamber       
        trx(1,i).y_mm = trx(1,i).y_mm - min(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/59;
        trx(1,i).x_mm = trx(1,i).x_mm - min(trx(1,i).x_mm) + (max(trx(1,i).x_mm) - min(trx(1,i).x_mm))/28;
        
        % finding the middle of all the plastic barriers in mm
        max_column_mm = max(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/59; 
        min_column_mm = min(trx(1,i).y_mm) - (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/59; 
        trx(1,i).middle_lineA =  30.5*(max_column_mm-min_column_mm)/61 + min_column_mm;        
            trx(1,i).middle_lineB =  0;
        trx(1,i).middle_lineC =  0;
        trx(1,i).middle_lineD =  0;
        for j = 1:1:max_frames
            if(trx_binary(j,i) == 0)
                trx_sucrose(j,i) = substrate(2,i);
            end
            
            if(trx_binary(j,i) == 1)
                trx_sucrose(j,i) = substrate(1,i);
            end
            
        end
        trx(1,i).sucrose = trx_sucrose(1:length(trx(1,i).x),i);
        trx(1,i).binary = trx_binary(1:length(trx(1,i).x),i);
        
        trx(1,i).sucrose = trx(1,i).sucrose';
        trx(1,i).binary = trx(1,i).binary';
    end
end


% modified on 01/25/16 to get more precise boundary
% If there are 2 rows in substrate and chamber_type is large, we are 
% dealing with a the large ( 2 choice chamber
if(rows_s == 2 && strcmp(chamber_type,'large'))
    for i=1:y
        
        % correcting for the 1mm on edges that centroids are not present
        max_column = max(trx(1,i).y) + (max(trx(1,i).y) - min(trx(1,i).y))/66;
        min_column = min(trx(1,i).y) - (max(trx(1,i).y) - min(trx(1,i).y))/66;
        
        % finding the middle of all the plastic barriers
        middle_line(i) = 34*(max_column -min_column)/68 + min_column;
        
        % which part of the chamber is the fly on
        trx_binary(1:1:length(trx(1,i).y),i) = (trx(1,i).y > middle_line(i));
        
        % adjust the x and y coordinate (x_mm) and (y_mm) to be between 0
        % and limits of chamber
        trx(1,i).y_mm = trx(1,i).y_mm - min(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/66;
        trx(1,i).x_mm = trx(1,i).x_mm - min(trx(1,i).x_mm) + (max(trx(1,i).x_mm) - min(trx(1,i).x_mm))/43;
        
        % finding the middle of all the plastic barriers in mm
        max_column_mm = max(trx(1,i).y_mm) + (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/66;
        min_column_mm = min(trx(1,i).y_mm) - (max(trx(1,i).y_mm) - min(trx(1,i).y_mm))/66;
        trx(1,i).middle_lineA =  34*(max_column_mm-min_column_mm)/68 + min_column_mm;
            trx(1,i).middle_lineB =  0;
        trx(1,i).middle_lineC =  0;
        trx(1,i).middle_lineD =  0;
        
        for j = 1:1:max_frames
            if(trx_binary(j,i) == 0)
                trx_sucrose(j,i) = substrate(2,i);
            end
            
            if(trx_binary(j,i) == 1)
                trx_sucrose(j,i) = substrate(1,i);
            end
            
        end
        trx(1,i).sucrose = trx_sucrose(1:length(trx(1,i).x),i);
        trx(1,i).binary = trx_binary(1:length(trx(1,i).x),i);
        
        trx(1,i).sucrose = trx(1,i).sucrose';
        trx(1,i).binary = trx(1,i).binary';
    end
end

% create the transition array for a fake midline down the x coordinate of
% the chamber
for i=1:y
    max_column = max(trx(1,i).x);
    min_column = min(trx(1,i).x);
    middle_line_invert(i) = (max_column+min_column)/2;
    
    max_column_mm = max(trx(1,i).x_mm);
    min_column_mm = min(trx(1,i).x_mm);
    trx(1,i).middle_line_invert = (max_column_mm+min_column_mm)/2;
    
    
    trx_binary_invert(1:1:length(trx(1,i).x),i) = (trx(1,i).x > middle_line_invert(i));
    
    trx(1,i).binary_invert = trx_binary_invert(1:length(trx(1,i).x),i);
    trx(1,i).binary_invert = trx(1,i).binary_invert';
   
end


% create an array in trx that tells when the fly transitions (-1 is transitioning
% down the chamber, +1 is up the chamber) and 0 means the fly did not transtion in
% that interval

for i = 1:y
    trx(1,i).transition = [1, diff(trx(1,i).binary)];
end

% create an array in trx that tells when the fly transitions across the
% fake inverted midline

for i = 1:y
    trx(1,i).transition_invert = [1, diff(trx(1,i).binary_invert)];
end

% create an array in trx that tells when the fly transitions substrates

for i = 1:y
    trx(1,i).transition_sub = [1, diff(trx(1,i).sucrose)];
end


% create an array in trx that tells the net distance (in mm) and speed (in
% mm/sec) that the fly is traveling at
for i = 1:y
    trx(1,i).distance = cumsum(flydistance_mm(trx,i,1,length(trx(1,i).x_mm)));
    trx(1,i).distancex = cumsum(flydistance_xmm(trx,i,1,length(trx(1,i).x_mm)));
    trx(1,i).distancey = cumsum(flydistance_ymm(trx,i,1,length(trx(1,i).x_mm)));
    trx(1,i).distance = [0 trx(1,i).distance];
    trx(1,i).distancex = [0 trx(1,i).distancex];
    trx(1,i).distancey = [0 trx(1,i).distancey];
    trx(1,i).speed = [0 2.*diff(trx(1,i).distance)];
end

% convert theta from radians to degrees
for j = 1:1:y
    trx(1,j).theta = (trx(1,j).theta + pi) / (2*pi) * 360;
end

% create an array that tells frame to frame changes in heading in degrees
% (dtheta)
for j = 1:1:y
    q = [];
    for i = 1:1:length(trx(1,j).theta)-1
        q(i) = (trx(1,j).theta(i+1) - trx(1,j).theta(i));
        if((trx(1,j).theta(i+1) - trx(1,j).theta(i)) > 180)
            q(i) = (trx(1,j).theta(i+1) - trx(1,j).theta(i))-360;
        end
        if((trx(1,j).theta(i+1) - trx(1,j).theta(i)) < -180)
            q(i) = 360 + (trx(1,j).theta(i+1) - trx(1,j).theta(i));
        end
    end
    trx(1,j).dtheta = [0 q];
end

% create an array for 0, 200, 500 mM
for j = 1:1:y
    
    trx(1,j).on0 = zeros(1,length(trx(1,j).x));
    trx(1,j).on2 = zeros(1,length(trx(1,j).x));
    trx(1,j).on5 = zeros(1,length(trx(1,j).x));
    
    [~, b] = find(trx(1,j).sucrose == 0);
    trx(1,j).on0(b) = 1;
    
    [~, b] = find(trx(1,j).sucrose == 2);
    trx(1,j).on2(b) = 1;
    
    [~, b] = find(trx(1,j).sucrose == 5);
    trx(1,j).on5(b) = 1;
end



% ------------------------------------------------------------------------
% PART 2: THIS PART OF THE CODE CREATES EGGS STRUCTURE. THIS IS DIFFERENT
% FROM THE EGG VARIABLE THAT YOU INITIALIZE.

eggs = struct;

options = unique(substrate);
options = sort(options,'ascend');
eggs.all_substrates = options;
eggs.first_substrate = options(1);
if(length(options) > 1)
    eggs.second_substrate = options(2);
else
    eggs.second_substrate = options(1);
end

eggs.chamber_style = rows_s;
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
        eggs.explore_start_time(i) = min(findbouts(trx(1,eggs.fly(i)).speed(1:eggs.egg_time(i))), eggs.egg_time(i)-min_search*2);
        eggs.explore_start_time(i) = max(eggs.explore_start_time(i), 1);
        eggs.explore_start_time(i) = max(eggs.explore_start_time(i), eggs.egg_time(i)-max_search*2);
    end
    
    eggs.run_end_time(i) = 1+length(trx(1,eggs.fly(i)).speed)- findruns(fliplr(trx(1,eggs.fly(i)).speed((1+eggs.egg_time(i)):end)));
    %eggs.egg_time(i)
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
    [a, b] = find(trx(1,eggs.fly(i)).transition(eggs.explore_start_time(i):eggs.egg_time(i)));
    eggs.explore_trans(i) = length(b);
    [a, b] = find(trx(1,eggs.fly(i)).transition(eggs.egg_time(i):eggs.run_end_time(i)));
    eggs.run_trans(i) = length(b);
    [a, b] = find(trx(1,eggs.fly(i)).transition_invert(eggs.explore_start_time(i):eggs.egg_time(i)));
    eggs.explore_trans_invert(i) = length(b);
end
eggs.explore_trans = transpose(eggs.explore_trans);
eggs.run_trans = transpose(eggs.run_trans);
eggs.explore_trans_invert = transpose(eggs.explore_trans_invert);

% number of actual substrate transitions in exploration/run
for i = 1:1:eggs.total
    [a, b] = find(trx(1,eggs.fly(i)).transition_sub(eggs.explore_start_time(i):eggs.egg_time(i)));
    eggs.explore_trans_sub(i) = length(b);
    [a, b] = find(trx(1,eggs.fly(i)).transition_sub(eggs.egg_time(i):eggs.run_end_time(i)));
    eggs.run_trans_sub(i) = length(b);
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


