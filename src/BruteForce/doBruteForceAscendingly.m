%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
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


function [Pw] = doBruteForceAscendingly (Iterations,Hash,Array,Opt)

for Increment=1:Iterations
    if strcmpi(Hash,DataHash(createString(Increment,Array),Opt))
        Pw= createString(Increment,Array);
        break
    end
    
%     if mod(Increment,1000) == 0
%         send(D,Increment);
%     end
end