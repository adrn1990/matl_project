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
function [Obj] = doBruteForce(Obj)

%TODO: load Cluster

NbrOfChars= Obj.NbrOfChars;
MaxPwLength= Obj.MaxPwLength;


Hash= Obj.Hash;

RainbowStrat= strcmp(Obj.RainbowtableDropDown.Value,'Yes');

%To generate the following cell-array as specified us the commented part in
%the command window.
%Arr= {char(48:57),char(65:90),char(97:122)} %0-9, A-Z, a-z 48-57, 65-90, 97-122
%horzcat(Arr{:})

Array= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

%Options for function DataHash
Opt= Obj.HashStruct;

%if there is the usage of rainbowtables, the following will be executed.
if RainbowStrat

%If there is NO usage of rainbowtables, the following will be executed.
%Bruteforce thru each possibility of the password while using a random
%generated index. Compare the hashes with the provided hash from the UI.
%If the comparsion of the hashes is true, throw an exception to exit the
%parfor-loop and assign the 
else
    Obj.fWriteMessageBuffer('BruteForcing initalized...');
    tic
    try
        parfor Increment=1:NbrOfChars^3+NbrOfChars^2+NbrOfChars
            Inc= randi(NbrOfChars^3+NbrOfChars^2+NbrOfChars);
            if strcmp(Hash,DataHash(createString(Inc,Array),Opt))
                Pw= createString(Inc,Array);
                msgID = '';
                msg = Pw;
                baseException = MException(msgID,msg);
                throw(baseException);
            end
            %TODO: Update UI
            if mod(Increment,10000) == 0
                disp(Increment);
                %Obj.fWriteMessageBuffer(sprintf('The current index is: %d',Increment));
            end
        end
        
    catch ME
        Pw= ME.message;
        disp(ME.message);
        
        Obj.ResultOutput.Value= {ME.message};
    end
    
    if (isempty(Obj.ResultOutput.Value))
        Obj.fWriteMessageBuffer('The BruteForcing was successfull!');
        Obj.fWriteMessageBuffer(sprintf('Your Password is: %s',Obj.ResultOutput.Value));
        Obj.fWriteMessageBuffer('Elapsed time is %f seconds',toc);
        Obj.fWriteMessageBuffer('---------------------------------------');
    else
        Obj.fWriteMessageBuffer('The BruteForcing was unfortunately not successfull!');
        Obj.fWriteMessageBuffer('Please try again.');
        Obj.fWriteMessageBuffer('---------------------------------------');
    end
    
end

return

end
