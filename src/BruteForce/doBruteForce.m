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
MaxPwLength= 8; %App.get

%To generate the following cell-array as specified us the commented part in 
%the command window.
%Arr= {char(48:57),char(65:90),char(97:122)} %0-9, A-Z, a-z 48-57, 65-90, 97-122
%horzcat(Arr{:})

Array= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

%Options for function DataHash
Opt= struct('Method',Struct.EncryptAlgo,'Format','HEX','Input','ascii');

if RainbowStrat
    
else %No usage of rainbowtables
    
    parfor Increment=1:NbrOfChars^PwLength
        if strcmp(Hash,DataHash(createString(Increment),Opt))
            
        end
        %TODO: Update UI
    end
    
end


end

%% local functions
function [Pw] = runBruteForce()

end

function [Str] = createString(Inc)
persistent I1 I2 I3 I5 I6 I7 I8;

if mod(Inc,NbrOfChars^1) == 0
elseif mod(Inc,NbrOfChars^2) == 0
elseif mod(Inc,NbrOfChars^3) == 0
elseif mod(Inc,NbrOfChars^4) == 0
end

end