%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              deleteApp
%
%Description:       This function removes the path to the subfolders of the
%                   app and saves all improvements into a file.
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
%<Version 1.1> - 22.05.2018 - Part of closing the parallel pool deleted.
%<Version 1.2> - 24.05.2018 - Get the path now from the object to avoid
%                             warnings in case the current path has been
%                             changed while the app was open.
%==========================================================================

function [] = deleteApp(Obj)

AppPath= Obj.ApplicationRoot;

%save all improvements into a file called Improvement
cd([AppPath,Obj.Slash,'Files']);
Improvements= Obj.Improvements;
save(sprintf('%s',Obj.FileName),'Improvements');
cd(AppPath);

%delete specified folders from path
for Increment=1:length(Obj.Folders)
    rmpath([AppPath,Obj.Slash,Obj.Folders{Increment}]);
end

end