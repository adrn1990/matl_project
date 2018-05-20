%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              doBruteForceRandomly
%
%Description:       This function is doing the bruteforcing with a random
%                   number for the createString function.
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



function [Pw] = doBruteForceRandomly (StartIndex,StopIndex,Hash,Array,Opt)


for Increment=StartIndex:StopIndex
    Inc= randi([StartIndex StopIndex]);
    if strcmpi(Hash,DataHash(createString(Inc,Array),Opt))
        Pw= createString(Inc,Array);
        break
    end
end

end