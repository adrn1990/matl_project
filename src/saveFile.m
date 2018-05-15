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
%==========================================================================
function  saveFile(Obj)
Obj.LogIndex = Obj.LogIndex + 1;
Buffer = Obj.messageBuffer;
TransBuffer = Buffer';
BufferSize = size(TransBuffer);
Date = sprintf('BruteForce_Log_%s_%s.txt',datestr(now,'yyyymmdd'), num2str(Obj.LogIndex));
filePh = fopen(Date,'w');

for i=1:BufferSize(1)
    fprintf(filePh,'%s\n',TransBuffer{i,:});
end
fclose(filePh);
