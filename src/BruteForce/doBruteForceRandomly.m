%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              doBruteForceRandomly
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

function [Pw] = doBruteForceRandomly (Iterations,Hash,Array,Opt)


for Increment=1:Iterations
    Inc= randi(Iterations);
    if strcmp(Hash,DataHash(createString(Inc,Array),Opt))
        Pw= createString(Inc,Array);
        break
    end
end

end