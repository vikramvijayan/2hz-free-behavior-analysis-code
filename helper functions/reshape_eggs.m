
function [egg] = reshape_eggs(eggs, a)


SNames = fieldnames(eggs);
for loopIndex = 1:numel(SNames)
    stuff = eggs.(SNames{loopIndex});
    if(strcmp(SNames{loopIndex},'total'))
        egg.(SNames{loopIndex}) = length(a);
    end
    if(strcmp(SNames{loopIndex},'first_substrate') || strcmp(SNames{loopIndex},'second_substrate')  || strcmp(SNames{loopIndex},'chamber_style') || strcmp(SNames{loopIndex},'all_substrates'))
        egg.(SNames{loopIndex}) = stuff;
    end
    if(~(strcmp(SNames{loopIndex},'total') || strcmp(SNames{loopIndex},'first_substrate') || strcmp(SNames{loopIndex},'second_substrate')  || strcmp(SNames{loopIndex},'chamber_style') || strcmp(SNames{loopIndex},'chamber_type')|| strcmp(SNames{loopIndex},'all_substrates')))
        
        egg.(SNames{loopIndex}) = stuff(a,:);
    end
end