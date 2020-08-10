function [eggs, trx] = combine_experiments(celloffiles)

new_egg = [];
new_trx = struct;

for i = 1:1:length(celloffiles)
    currentfile = celloffiles{i};
    load(['F:\OneDrive\Postdoc\most current data analysis folders\01.22.16 matlab analysis\tracking data files\' currentfile]);
    
    trx_in = struct;
    
    for j = 1:1:length(trx)
        trx_in(1,j).x = trx(1,j).x;
        trx_in(1,j).y = trx(1,j).y;
        trx_in(1,j).theta = trx(1,j).theta;
        trx_in(1,j).x_mm = trx(1,j).x_mm;
        trx_in(1,j).y_mm = trx(1,j).y_mm;
    end
        
    [eggs, trx] = assemble_data_global(trx_in, egg, substrate, 0, chamber_type, 0);
        
    [regg, cegg] = size(egg);
    egg_temp = zeros(200, cegg);
    egg_temp(1:regg,1:cegg) = egg;
    
    new_egg = [new_egg, egg_temp];
    

    if(i==1)
        new_trx = trx;
    else
        new_trx = [new_trx, trx];
    end
   
end

[eggs, trx] = assemble_data_global_posttrx(new_trx, new_egg, [], 0, 'mixed', 0);

end