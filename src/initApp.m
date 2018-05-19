%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              initApp
%
%Description:       This function adds the subfolders of the app to the
%                   path and loads the allready found passwords and hashes.
%
%Input:             Object Obj of the class userInterface
%
%Output:            Object Obj of the class userInterface
%
%Example:           initApp();
%
%Copyright:
%
%**************************************************************************

%==========================================================================
%<Version 1.0> - 12.05.2018 - First version of the function.
%==========================================================================

function Obj = initApp(Obj)

%Specify the subfolder with functions here.
Obj.Folders= {'UI';
    'BruteForce';
    'Scripts';
    'Files';
    'Log-files';
    };

%Specify the slash for different operating systems
if ispc
    Obj.Slash= '\';
else
    Obj.Slash= '/';
end

%Add specified folders to the path
for Increment=1:length(Obj.Folders)
    addpath([pwd,Obj.Slash,Obj.Folders{Increment}]);
end

%load the file with the allready found passwords and hashes.
Obj.FileName= 'Improvements.mat';
CurrPath= pwd;
cd([CurrPath,Obj.Slash,'Files']);
Obj.Improvements= importdata(Obj.FileName);
cd(CurrPath);
clear CurrPath

end