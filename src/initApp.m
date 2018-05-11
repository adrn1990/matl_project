%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              initApp
%
%Description:       TODO:
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

function Obj = initApp(Obj)

%Specify the subfolder with functions here.
Obj.Folders= {'UI';
    'BruteForce';
    'Scripts';
    'Files';
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

CurrPath= pwd;
cd([CurrPath,Obj.Slash,'Files']);
Obj.FoundHash= importdata('FoundHashes.mat');
cd(CurrPath);

end