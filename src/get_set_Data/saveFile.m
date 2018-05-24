%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Huerzeler
%                   A. Gonzalez
%
%Name:              saveFile
%
%Description:       This function saves the whole data from Log monitor
%                   into a .txt file.
%
%Input:             Object Obj of the class userInterface
%
%Output:            none
%
%Example:           saveFile(Obj);
%
%Copyright:
%
%**************************************************************************

%==========================================================================
%<Version 1.0> - 15.05.2018 - First version of the function.
%<Version 1.1> - 17.05.2018 - Change index into time in filename
%<Version 2.0> - 17.05.2018 - Save file into Log-file directory
%<Version 2.1> - 23.05.2018 - Few descriptions added
%<Version 2.2> - 24.05.2018 - Problem with path changing fixed.
%==========================================================================
function  saveFile(Obj)

%Read in the messageBuffer from the UI
Buffer = Obj.messageBuffer;

%Transpose the buffer
TransBuffer = Buffer';

%Determine the buffer size
BufferSize = size(TransBuffer);

%Generate the unique filename
FileName = sprintf('BruteForce_Log_%s.txt',datestr(now,'yyyy-mm-dd_HHMMSS'));
CurrDir= Obj.ApplicationRoot;

%Change directory to Log-files
cd([CurrDir,Obj.Slash,'Log-files']);

%Open a new text file
fileID = fopen(FileName,'w');
cd(CurrDir);

%Write each line into the .txt file
for i=1:BufferSize(1)
    fprintf(fileID,'%s\n',TransBuffer{i,:});
end
fclose(fileID);
