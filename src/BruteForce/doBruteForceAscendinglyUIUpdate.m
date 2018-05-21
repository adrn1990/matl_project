%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. H�rzeler
%                   A. Gonzalez
%
%Name:              doBruteForceAscendignly
%
%Description:       TODO:
%
%Input:             TODO:
%
%
%Output:            TODO:
%
%Example:           TODO:
%
%Copyright:
%
%**************************************************************************


function [Pw] = doBruteForceAscendinglyUIUpdate (StartIndex,StopIndex,Hash,Array,Opt,Slash)

for Increment=StartIndex:StopIndex
    if strcmpi(Hash,DataHash(createString(Increment,Array),Opt))
        Pw= createString(Increment,Array);
        break
    end
    
    if mod(Increment,1000) == 0
        save(['Files',Slash,'Progress'],'Increment');
    end
end