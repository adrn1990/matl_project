%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              doBruteForce2
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
function [] = doBruteForce2 (Obj)

%local variable for the numbers of chars
NbrOfChars= Obj.NbrOfChars;

%local variable for the number of digits the password can have
MaxPwLength= Obj.MaxPwLength;

Obj.AmountOfCalls= 1;

Hash= Obj.Hash;
Improvements= Obj.Improvements;
[Length,~]= size(Improvements);
FoundByImprovement= false;
Method= Obj.HashStruct.Method;
Array= Obj.AllowedChars;
Cluster= Obj.ClusterDropDown.Value;

%local variable to save the logical information if the brute force should
%be aborted.
Break= false;

%The number of iterations to find a password is now for 1 to 4 digits
Obj.Iterations = sum(NbrOfChars.^(1:MaxPwLength));
Iterations= Obj.Iterations;

%Options for function DataHash
Opt= Obj.HashStruct;

%TODO: Update status bar
% %Preparation for UI update
% D = parallel.FevalQueue;
% D.afterEach(@disp);

Obj.fWriteMessageBuffer(Obj.delemiter);
Obj.fWriteMessageBuffer('BruteForcing in progress...');
Obj.fWriteMessageBuffer(sprintf('Started on %s',datestr(now,'dd.mm.yyyy at HH:MM:SS')));
tic
try
    %go first thru the improvements
    %the increment starts at 2 because of the title in each column of the
    %improvements cell.
    for Increment=2:Length
        if strcmp(Hash,Improvements{Increment,2}) && ...
                strcmp(Method,Improvements{Increment,3})
            FoundByImprovement= true;
            Obj.ResultOutput.Value(1)= {Improvements{Increment,1}};
            break
        end
    end
    
    %The parallel job will only be created if the password couldn't be found by
    %improvements.
    if ~FoundByImprovement
        
        %TODO: Divide Iterations for amount of workers and gpus
               
        
        %TODO choose cluster from UI
        c = parcluster(Cluster);
        Job = createJob(c);
        
        %TODO: divide the task to more than two workers (if there are any)
        Task1= createTask(Job, @doBruteForceAscendingly, 1, {Iterations,Hash,Array,Opt},'CaptureDiary',true);
        Task2= createTask(Job, @doBruteForceRandomly, 1, {Iterations,Hash,Array,Opt},'CaptureDiary',true);
        
        %submit the job to the scheduler
        submit(Job)       
        
        while(~strcmp(Task1.State,'finished') && ~strcmp(Task2.State,'finished') && ~Break)
            %TODO: displaydata throws an exception
            %displayData(Obj)
             pause(3);
            if Obj.Abort
                %Abort the BruteForce by cancelling the job and break the while
                %loop
                Break = true;
                Job.cancel;
                Obj.fWriteMessageBuffer(sprintf('The BruteForcing has after %0.4f seconds been aborted!',toc));
            end
        end
        
        %TODO append this part for multiple workers / tasks
        %cancel the task which is not finished yet
        if strcmp(Task1.State,'finished')
            Task2.delete
        elseif strcmp(Task2.State,'finished')
            Task1.delete
        end
        
        if ~Obj.Abort
            Pw = fetchOutputs(Job);
            Pw{1};
            Obj.ResultOutput.Value= Pw;
            
            %if the password was not found by improvement, save it into the
            %variable imrovements.
            Improvements{end+1,1}= Pw{1};
            Improvements{end,2}= DataHash(Pw{1},Opt);
            Improvements{end,3}= Method;
            Obj.Improvements= Improvements;
        end
    end
    
    
%catch any exception that may occur while brute forcing.    
catch ME
    Obj.fWriteMessageBuffer('An error with the following message occured:');
    Obj.fWriteMessageBuffer(ME.message);
end

%write the message buffer
if (~isempty(Obj.ResultOutput.Value{1}))%if a password has been found
    Obj.fWriteStatus('Your current progress in BruteForcing is: 100%');
    Obj.fWriteMessageBuffer('The BruteForcing was successfull!');
    Obj.fWriteMessageBuffer(sprintf('Your Password is: %s',Obj.ResultOutput.Value{1}));
    Obj.fWriteMessageBuffer(sprintf('Elapsed time is %0.4f seconds',toc));
    Obj.fWriteMessageBuffer(Obj.delemiter);
elseif Break %if the brute forcing has been aborted
    Obj.fWriteMessageBuffer(Obj.delemiter);
else
    Obj.fWriteStatus('Your current progress in BruteForcing is: 0%');
    Obj.fWriteMessageBuffer('The BruteForcing was unfortunately not successfull!');
    Obj.fWriteMessageBuffer('Please try again.');
    Obj.fWriteMessageBuffer(Obj.delemiter);
end