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

%TODO: Update status bar
% %Preparation for UI update
% D = parallel.pool.DataQueue;
% D.afterEach(@disp);

for Increment=1:Length
    if strcmp(Hash,Improvements{Increment,2}) && ...
            strcmp(Method,Improvements{Increment,3})
        FoundByImprovement= true;
    end
end


%The parallel job will only be created if the password couldn't be found by
%improvements.
if ~FoundByImprovement
    
    %TODO choose cluster
    c = parcluster;
    Job = createJob(c);
    
    %TODO: divide the task to more than two workers (if there are any)
    Task1= createTask(Job, @doBruteForceAscendingly, 1, {Iterations,Hash,Array,Opt},'CaptureDiary',true);
    Task2= createTask(Job, @doBruteForceRandomly, 1, {Iterations,Hash,Array,Opt},'CaptureDiary',true);
    
    %submit the job to the scheduler
    submit(Job)
    
    Break= false;
    
    while(~strcmp(Task1.State,'finished') && ~strcmp(Task2.State,'finished') && ~Break)
        %TODO: displayData
        pause(3);
        if Obj.Abort
            %Abort the BruteForce by cancelling the job and break the while
            %loop
            Break = true;
            Job.cancel;
        end
    end
    
    %cancel the task which is not finished yet
    if strcmp(Task1.State,'finished')
        Task2.delete
    elseif strcmp(Task2.State,'finished')
        Task1.delete
    end
    
    results = fetchOutputs(Job);
    
end

%Handover Password
end

