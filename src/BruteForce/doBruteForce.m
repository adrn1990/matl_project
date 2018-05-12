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
Improvements= Obj.Improvements;
[Length,~]= size(Improvements);
FoundByImprovement= false;
Method= Obj.HashStruct.Method;

RainbowStrat= strcmp(Obj.RainbowtableDropDown.Value,'Yes');

%To generate the following cell-array as specified us the commented part in
%the command window.
%Arr= {char(48:57),char(65:90),char(97:122)} %0-9, A-Z, a-z 48-57, 65-90, 97-122
%horzcat(Arr{:})

Array= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

%Options for function DataHash
Opt= Obj.HashStruct;




%FIXME: Update GUI out of Parallel
% D = parallel.pool.DataQueue;
% D.afterEach(@(x) Obj.fWriteMessageBuffer(sprintf('%d',x)));

%if there is the usage of rainbowtables, the following will be executed.
if RainbowStrat

%If there is NO usage of rainbowtables, the following will be executed.
%Bruteforce thru each possibility of the password while using a random
%generated index. Compare the hashes with the provided hash from the UI.
%If the comparsion of the hashes is true, throw an exception to exit the
%parfor-loop and assign the password to the result output to show it on the
%gui.
else
    Obj.fWriteMessageBuffer('BruteForcing in progress...');
    tic
    try
        %try allready used passwords and hashses first
        
        for Increment=1:Length
            if strcmp(Hash,Improvements{Increment,2}) && ...
                    strcmp(Method,Improvements{Increment,3})
                FoundByImprovement= true;
                msgID = '';
                msg = Improvements{Increment,1};
                baseException = MException(msgID,msg);
                throw(baseException);
            end
        end
        
        parfor Increment=1:NbrOfChars^3+NbrOfChars^2+NbrOfChars
            Inc= randi(NbrOfChars^3+NbrOfChars^2+NbrOfChars);
            if strcmp(Hash,DataHash(createString(Inc,Array),Opt))
                Pw= createString(Inc,Array);
                msgID = '';
                msg = Pw;
                baseException = MException(msgID,msg);
                throw(baseException);
            elseif strcmp(Hash,DataHash(createString(Increment,Array),Opt))
                Pw= createString(Increment,Array);
                msgID = '';
                msg = Pw;
                baseException = MException(msgID,msg);
                throw(baseException);                
             end
            %TODO: Update UI
            if mod(Increment,10000) == 0
                disp(Increment);
                %Obj.fWriteMessageBuffer(sprintf('The current index is: %d',Increment));
                %FIXME: Update GUI out of Parallel
                %send(D, Increment);
            end
        end
        
    catch ME
        Pw= ME.message;
        disp(Pw);
        if ~FoundByImprovement
            Improvements{end+1,1}= Pw;
            Improvements{end,2}= DataHash(Pw,Opt);
            Improvements{end,3}= Method;
            Obj.Improvements= Improvements;            
        end
        
        Obj.ResultOutput.Value= {Pw};
    end
    
    if (~isempty(Obj.ResultOutput.Value{1}))
        Obj.fWriteMessageBuffer('The BruteForcing was successfull!');
        Obj.fWriteMessageBuffer(sprintf('Your Password is: %s',Obj.ResultOutput.Value{1}));
        Obj.fWriteMessageBuffer(sprintf('Elapsed time is %f seconds',toc));
        Obj.fWriteMessageBuffer(Obj.delemiter);
    else
        Obj.fWriteMessageBuffer('The BruteForcing was unfortunately not successfull!');
        Obj.fWriteMessageBuffer('Please try again.');
        Obj.fWriteMessageBuffer(Obj.delemiter);
    end
    
end

return

end
