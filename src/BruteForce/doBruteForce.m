%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              doBruteForce
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
function [CrackedPw] = doBruteForce(Obj,Hash,RainbowStrat,Cluster)

%TODO: load Cluster

%TODO: edit the maximum with fields of the object.
NbrOfChars= 64; %App.get
PwLength= 8; %App.get

%To generate the following cell-array as specified us the commented part in 
%the command window.
%{char(48:57),char(65:90),char(97:122)} %0-9, A-Z, a-z 48-57, 65-90, 97-122
%horzcat(A{:})

Array= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

%Options for function DataHash
Opt= struct('Method',Struct.EncryptAlgo,'Format','HEX','Input','ascii');

if RainbowStrat
    
else %No usage of rainbowtables
    
    parfor Increment=1:NbrOfChars^PwLength
        if strcmp(Hash,DataHash(incrementToChar(Array,PwLength,Increment),Opt))
            
        end
        %TODO: Update UI
    end
    
end


end

%% local functions
function [Char] = incrementToChar(Array,PwLength,Increment)



end
