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
function doBruteForce(Obj)

%TODO: load Cluster

NbrOfChars= Obj.NbrOfChars;
MaxPwLength= Obj.MaxPwLength;

Obj.AmountOfCalls= 1;

Hash= Obj.Hash;
Improvements= Obj.Improvements;
[Length,~]= size(Improvements);
FoundByImprovement= false;
Method= Obj.HashStruct.Method;
Array= Obj.AllowedChars;

%The number of iterations to find a password is now for 1 to 3 digits
Obj.Iterations = NbrOfChars^3+NbrOfChars^2+NbrOfChars;
Iterations= Obj.Iterations;

%Options for function DataHash
Opt= Obj.HashStruct;




%Preparation for UI update
D = parallel.pool.DataQueue;
D.afterEach(@(x) updateParFor(x,Obj));


%Bruteforce thru each possibility of the password while using a random
%generated index. Compare the hashes with the provided hash from the UI.
%If the comparsion of the hashes is true, throw an exception to exit the
%parfor-loop and assign the password to the result output to show it on the
%gui.
Obj.fWriteMessageBuffer(Obj.delemiter);
Obj.fWriteMessageBuffer('BruteForcing in progress...');
Obj.fWriteMessageBuffer(sprintf('Started on %s',datestr(now,'dd.mm.yyyy at HH:MM:SS')));
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
    
    parfor Increment=1:Iterations
        Inc= randi(Iterations);
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
        %Update UI
        if mod(Increment,1000) == 0
            send(D, Increment);
        end
    end
    
catch ME
    Pw= ME.message;
    if ~FoundByImprovement
        Improvements{end+1,1}= Pw;
        Improvements{end,2}= DataHash(Pw,Opt);
        Improvements{end,3}= Method;
        Obj.Improvements= Improvements;
    end
    
    Obj.ResultOutput.Value= {Pw};
end

if (~isempty(Obj.ResultOutput.Value{1}))
    Obj.fWriteStatus('Your current progress in BruteForcing is: 100%');
    Obj.fWriteMessageBuffer('The BruteForcing was successfull!');
    Obj.fWriteMessageBuffer(sprintf('Your Password is: %s',Obj.ResultOutput.Value{1}));
    Obj.fWriteMessageBuffer(sprintf('Elapsed time is %f seconds',toc));
    Obj.fWriteMessageBuffer(Obj.delemiter);
else
    Obj.fWriteStatus('Your current progress in BruteForcing is: 0%');
    Obj.fWriteMessageBuffer('The BruteForcing was unfortunately not successfull!');
    Obj.fWriteMessageBuffer('Please try again.');
    Obj.fWriteMessageBuffer(Obj.delemiter);
end

end



%% local functions


function updateParFor(x,Obj)
X= 100*Obj.AmountOfCalls*1000/Obj.Iterations;
Obj.fWriteStatus([sprintf('Your current progress in BruteForcing is: %0.4f',X),'%']);
Obj.AmountOfCalls= Obj.AmountOfCalls+1;

displayData(Obj);

end
