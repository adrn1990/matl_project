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
%<Version 1.1> - 21.05.2018 - Folder get_set_Data added.
%<Version 1.2> - 24.05.2018 - Save the path into a property to use it in
%                             other functions without warnings.
%==========================================================================

function Obj = initApp(Obj)

%Specify the subfolder with functions here.
Obj.Folders= {'UI';
    'BruteForce';
    'Scripts';
    'Files';
    'Log-files';
    'get_set_Data';
    };

%Specify the slash for different operating systems
if ispc
    Obj.Slash= '\';
else
    Obj.Slash= '/';
end

%save the path of the application into a property.
Obj.ApplicationRoot= pwd;

%Add specified folders to the path
for Increment=1:length(Obj.Folders)
    addpath([pwd,Obj.Slash,Obj.Folders{Increment}]);
end

%load the file with the allready found passwords and hashes.
Obj.FileName= 'Improvements.mat';
cd([pwd,Obj.Slash,'Files']);
Obj.Improvements= importdata(Obj.FileName);
cd(Obj.ApplicationRoot);

end