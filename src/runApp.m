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
    'BruteForce';
    };

%Check if the user's computer is a pc
if ispc
    
    %get the current Windows-version, extract the version from the string
    %and typecast it to double for comparsion
    Version= char(system_dependent('getwinsys'));
    Version= char(regexp(Version,'Version 1\d.\d*','match'));
    Version= str2double(char(regexp(Version,'\d\d.\d','match')));
    
    %Compare if the version of Windows is before 10.0 and prompt a warning
    %if its before 10.0
    if Version < 10.0
        uiwait(msgbox(sprintf(['Your operating system is not "Windows 10"'...
            ,'or higher.','\n','This application may not work properly.']),...
            'Operating System Version Warning','warn'));
    end
    Slash= '\';
    
else %isunix or unknown
    %UI to inform about not supported operating systems.
    uiwait(msgbox(['This application may not work properly because your ',...
        'operating system is not "Windows".'],'Operating System Warning','warn'));
    Slash= '/';
end

%Check if the user is a student and prompt a warning if not.
if ~isstudent
    uiwait(msgbox('This application should be used for education only!',...
        'Operating System Warning','warn'));
end

%Add specified folders to the path
for Increment=1:length(Folders)
    addpath([pwd,Slash,Folders{Increment}]);
end

%==============================Calling the GUI=============================
App= userInterface_script;
%==========================================================================

%TODO: Appkill function like rmpath and rm Vars
