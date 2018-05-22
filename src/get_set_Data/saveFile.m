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
%==========================================================================
function  saveFile(Obj)
Buffer = Obj.messageBuffer;
TransBuffer = Buffer';
BufferSize = size(TransBuffer);
FileName = sprintf('BruteForce_Log_%s.txt',datestr(now,'yyyy-mm-dd_HHMMSS'));
CurrDir= pwd;
cd([CurrDir,Obj.Slash,'Log-files']);
fileID = fopen(FileName,'w');
cd(CurrDir);

for i=1:BufferSize(1)
    fprintf(fileID,'%s\n',TransBuffer{i,:});
end
fclose(fileID);
