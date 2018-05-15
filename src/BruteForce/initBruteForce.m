%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. H�rzeler
%                   A. Gonzalez
%
%Name:              initBruteForce
%
%Description:       This function initialize the Bruteforceing by hashing
%                   the password of the user (if necessary).
%
%Input:             Object Obj of the Class userInterface
%
%Output:            Object Obj of the Class userInterface
%
%Example:           Obj = initBruteForce(Obj);
%
%Copyright:
%
%**************************************************************************

%==========================================================================
%<Version 1.0> - 12.05.2018 - First version of the function.
%<Version 1.1> - 15.05.2018 - The function no longer calls the doBruteForce
%                             function.
%                           - The return value has been changed to nothing.
%==========================================================================

function initBruteForce(Obj)

%Struct for DataHash function
Opt= Obj.HashStruct;

%ToDecrypt contains the information if its a password or a hash to force.
ToDecrypt= Obj.ModeDropDown.Value;

%If ToDecrypt is 'Password', hash the field containing the char array with 
%the password. 
if(strcmp(ToDecrypt,'Password'))
    Data= Obj.InputEditField.Value;
    Hash = DataHash(Data, Opt);
else
    Hash= Obj.ModeDropDown.Value;
end

%Handover the hash to the object.
Obj.Hash= Hash;

end