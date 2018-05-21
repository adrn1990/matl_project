%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. H�rzeler
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
ClusterObj= parcluster(Cluster);
Slash= Obj.Slash;

%local variable to save the logical information if the brute force should
%be aborted.
Break= false;

%The number of iterations to find a password is now for 1 to 4 digits
Obj.Iterations = sum(NbrOfChars.^(1:MaxPwLength));
Iterations= Obj.Iterations;

%Options for function DataHash
Opt= Obj.HashStruct;

%prepare for UI-update
Increment= 0;
save(['Files',Slash,'Progress'],'Increment');

Obj.fWriteMessageBuffer(Obj.delemiter);
Obj.fWriteMessageBuffer(sprintf('Prepare BruteForcing on %s',datestr(now,'dd.mm.yyyy at HH:MM:SS')));
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
        
        c = parcluster(Cluster);
        Job = createJob(c);

        %with 2*n amount of tasks we will only be using even amount of
        %workers.
        NumWorkers= ClusterObj.NumWorkers;
        if mod(NumWorkers,2) == 1
            NumWorkers= NumWorkers-1;
        end
        
        %Divide Iterations for amount of workers
        IterationsPerWorker= ceil(2*Iterations/NumWorkers);
        
        %each task will be given the same amount of iterations depending on
        %the number of workers to do the bruteforcing the fastes way possible.             
        for Increment=1:NumWorkers/2
            %create only one task with the function which updates the UI
            %progress to avoid multiple access on file "Progress".
            if Increment == 1
                createTask(Job, @doBruteForceAscendinglyUIUpdate, 1, ...
                {(Increment-1)*IterationsPerWorker+1,Increment*IterationsPerWorker,Hash,Array,Opt,Slash},'CaptureDiary',true);
            else
                createTask(Job, @doBruteForceAscendingly, 1, ...
                {(Increment-1)*IterationsPerWorker+1,Increment*IterationsPerWorker,Hash,Array,Opt},'CaptureDiary',true);
            end
            createTask(Job, @doBruteForceRandomly, 1, ...
                {(Increment-1)*IterationsPerWorker+1,Increment*IterationsPerWorker,Hash,Array,Opt},'CaptureDiary',true);
        end
                
        %safe all task object into one property.
        Tasks= Job.Tasks;
        
        %preallocate some memory for faster for-loop operations.
        TaskState= cell(length(Tasks),1);
        
        %Stopcondition of the while loop
        StopCondition= false;
        
        %submit the job to the scheduler
        submit(Job)
        
        tic
        Obj.fWriteMessageBuffer(sprintf('Started BruteForcing on %s',datestr(now,'dd.mm.yyyy at HH:MM:SS')));

        %stay in the while loop until the brute forcing has been aborted or
        %the stop condition is set (which indicates a found password).
        while(~StopCondition && ~Break)
            %update progress of brute forcing on UI
            load(['Files',Slash,'Progress'],'Increment');
            X= 100*Increment/Iterations;
            Obj.fWriteStatus([sprintf('Your current progress in BruteForcing is: %0.4f',X),'%']);
            %get and plot the data from the cpu/gpu on the graphs
            if ispc
                displayData(Obj);
            else
                pause(2);%pause the while loop to get information from UI.
            end
            if Obj.Abort
                %Abort the BruteForce by cancelling the job and break the while
                %loop
                Break = true;
                Job.cancel;
                Obj.fWriteMessageBuffer(sprintf('The BruteForcing has after %0.4f seconds been aborted!',toc));
            end
            for Increment=1:length(Tasks)
                TaskState{Increment}= strcmp(Tasks(Increment).State,'finished');
            end
            LogicalTaskState= vertcat(TaskState{:});
            StopCondition= any(LogicalTaskState);
        end
        
        %get rid of each not finished task to fetch the output from the
        %job. (otherwise the fetchOutputs throws an exception).
        for Increment=1:length(Tasks)
            if ~LogicalTaskState(Increment)
                Tasks(Increment).delete
            end
        end

        %this part will only be done if the job hasn't been aborted.
        %it fetches the job output, hands the password over and saves the 
        %improvements 
        if ~Obj.Abort
            Pw = fetchOutputs(Job);
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
    Job.cancel;
end

%write the message buffer
if (~isempty(Obj.ResultOutput.Value{1}))%if a password has been found
    Obj.fWriteStatus('Your current progress in BruteForcing is: 100%');
    Obj.fWriteMessageBuffer('The BruteForcing was successfull!');
    Obj.fWriteMessageBuffer(sprintf('Your Password is: %s',Obj.ResultOutput.Value{1}));
    Obj.fWriteMessageBuffer(sprintf('Elapsed time is %0.4f seconds',toc));
    Obj.fWriteMessageBuffer(Obj.delemiter);
elseif Break %if the brute forcing has been aborted
    Obj.fWriteStatus('Your current progress in BruteForcing is: 0%');
    Obj.fWriteMessageBuffer(Obj.delemiter);
else
    Obj.fWriteStatus('Your current progress in BruteForcing is: 0%');
    Obj.fWriteMessageBuffer('The BruteForcing was unfortunately not successfull!');
    Obj.fWriteMessageBuffer('Please try again.');
    Obj.fWriteMessageBuffer(Obj.delemiter);
end