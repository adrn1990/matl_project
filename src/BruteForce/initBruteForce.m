%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              initBruteForce
%
%Description:       TODO:
%
%Input:             Object Obj of the Class userInterface
%
%                   Struct S with fields:
%
%                   S.Type
%                       char array.
%                   S.Entry
%                   S.EncrytAlgo
%                       char array.
%                   S.RainbowStrat
%                   S.Cluster
%
%Output:            TODO:
%
%Example:           Struct= struct('Type','Password','Entry','myPassword',...
%                       'EncryptAlgo','SHA1','RainbowStrat',false,'Cluster','Default')
%
%Copyright:
%
%**************************************************************************

function [CrackedPw] = initBruteForce(Obj,Struct)


if(strcmp(Struct.Type,'Password'))
    Opt= struct('Method',Struct.EncryptAlgo,'Format','HEX','Input','ascii');
    Data= Struct.Entry;
    Hash = DataHash(Data, Opt);
else
    Hash= Struct.Entry;
end

CrackedPw= doBruteForce(Obj,Hash,Struct.RainbowStrat,Struct.Cluster);
end