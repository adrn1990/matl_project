%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              doBruteForceAscendignlyGpu
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


function [Pw] = doBruteForceAscendinglyGpu (Iterations,Hash,Array,Opt)

for Increment=1:length(Iterations)
    if strcmp(Hash,DataHash(createString(Iterations(Increment),Array),Opt))
        Pw= createString(Iterations(Increment),Array);
        break
    end
    
%     if mod(Increment,1000) == 0
%         send(D, Increment);
%     end
end