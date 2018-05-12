%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
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
%==========================================================================

function [Obj] = initBruteForce(Obj)

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

%execute the function to do the brute force
Obj= doBruteForce(Obj);

return
end