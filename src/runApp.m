%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              runApp
%
%Description:       This function should be executed to run the
%                   BruteForce-Application. This function checks if MATLAB
%                   is running as admin, if Windows is running on Win 10 or
%                   higher, it the current pc is running a Mac-OS or Linux
%                   and if MATLAB is using a student licence.
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

%==========================================================================
%<Version 1.0> - 13.05.2018 - First version of the script.
%<Version 1.1> - 14.05.2018 - License check for Parallel Computing Toolbox.
%<Version 1.2> - 16.05.2018 - Remove of variables added.
%==========================================================================

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
    
    clear Version
    
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

%Check if the paralleling toolbox is installed and licensed. Throw an
%exception if not.
Struct= ver('distcomp');
IsInstalled= strcmp(Struct.Name,'Parallel Computing Toolbox');

IsLicensed= license('test','Distrib_Computing_Toolbox');

if ~IsInstalled || ~IsLicensed
    msg = 'The Parallel Computing Toolbox has to be installed and licensed to use this software!';
    uiwait(msgbox(msg,'Parallel Computing Toolbox','error'));
    VerException = MException('',msg);
    throw(VerException);
end

addpath([pwd,Slash,'UI']);
clear Slash msg VerException IsInstalled IsLicensed Struct

%==============================Calling the GUI=============================
userInterface_script;
%==========================================================================

%% local function

%Local function to evaluate if the user is running MATLAB with admin rights
%returns logical true if it is running on admin rights.
function out = isWindowsAdmin()
wi = System.Security.Principal.WindowsIdentity.GetCurrent();
wp = System.Security.Principal.WindowsPrincipal(wi);
out = wp.IsInRole(System.Security.Principal.WindowsBuiltInRole.Administrator);
end

