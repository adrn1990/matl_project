%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              runApp
%
%Description:       This script runs the applikation, adds the necessary 
%                   paths and provides information to the user if the 
%                   computer is not a pc and doesn't run the operating
%                   system "Windows 10".
%
%Input:             No input
%
%Output:            No output
%
%Example:           runApp();
%
%Copyright:
%
%**************************************************************************

%Specify the subfolder with functions here.
Folders= {'UI';
    };

%Check if the user's computer is a pc or mac/linux
if ispc
    %TODO: get Windows version and prompt a warning if its not Windows 10.
    system_dependent('getwinsys');
    Slash= '\';
elseif isunix
    %UI to inform about not supported operating systems.
    uiwait(msgbox(['This application may not work properly because your ',...
        'operating system is not "Windows".'],'Operating System Warning','warn'));
    Slash= '/';
end

%Check if the user is a student and prompt a warning if not.
if ~isstudent
    uiwait(msgbox('This application should only be used for education!',...
        'Operating System Warning','warn'));
end

%Add specified folders to the path
for Increment=1:length(Folders)
    addpath([pwd,Slash,Folders{Increment}]);
end

%==============================Calling the GUI=============================
App= userInterface_script;
%==========================================================================
