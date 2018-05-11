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
    'Scripts';
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
    
    %check if MATLAB is running on admin rights.
    if ~isWindowsAdmin
        uiwait(msgbox(sprintf(['Your MATLAB is not executed as admin!','\n'...
            ,'Some functions may not work properly.']),...
            'MATLAB not on admin rights Warning','warn'));
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
userInterface_script;
%==========================================================================

clear Folders Increment Slash;

%TODO: Appkill function like rmpath

%% local function

%Local function to evaluate if the user is running MATLAB with admin rights
%returns logical true if it is running on admin rights.
function out = isWindowsAdmin()
wi = System.Security.Principal.WindowsIdentity.GetCurrent();
wp = System.Security.Principal.WindowsPrincipal(wi);
out = wp.IsInRole(System.Security.Principal.WindowsBuiltInRole.Administrator);
end

