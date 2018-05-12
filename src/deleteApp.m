%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              deleteApp
%
%Description:       This function removes the path to the subfolders of the
%                   app and quits the running parallel pool.
%
%Input:             Object Obj of the class userInterface
%
%Output:            No Output
%
%Example:           deleteApp(Obj);
%
%Copyright:
%
%**************************************************************************

%==========================================================================
%<Version 1.0> - 12.05.2018 - First version of the function.
%==========================================================================

function [] = deleteApp(Obj)

%safe improvements
CurrPath= pwd;
cd([CurrPath,Obj.Slash,'Files']);
Improvements= Obj.Improvements;
save(sprintf('%s',Obj.FileName),'Improvements');
cd(CurrPath);
clear Improvements CurrPath

%delete specified folders from path
for Increment=1:length(Obj.Folders)
    rmpath([pwd,Obj.Slash,Obj.Folders{Increment}]);
end

%stop the current parallel session
delete(gcp('nocreate'));




end