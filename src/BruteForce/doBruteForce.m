%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. H�rzeler
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
function [Obj] = doBruteForce(Obj)

%TODO: load Cluster

NbrOfChars= Obj.NbrOfChars;
MaxPwLength= Obj.MaxPwLength;


RainbowStrat= strcmp(Obj.RainbowtableDropDown.Value,'Yes');

%To generate the following cell-array as specified us the commented part in 
%the command window.
%Arr= {char(48:57),char(65:90),char(97:122)} %0-9, A-Z, a-z 48-57, 65-90, 97-122
%horzcat(Arr{:})

Array= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

%Options for function DataHash
Opt= Obj.HashStruct;

if RainbowStrat
    
else %No usage of rainbowtables
    
%     parfor Increment=1:NbrOfChars^MaxPwLength
%         if strcmp(Hash,DataHash(createString(Increment),Opt))
%             
%         end
%         %TODO: Update UI
%     end
    
end

return

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