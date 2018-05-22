%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              doBruteForceAscendignly
%
%Description:       This function iterates thru a scope, given by the
%                   input arguments 'StartIndex' and 'StopIndex'. It
%                   compares the provided hash with the hash created in
%                   each loop with the for-loop increment.
%                   If the comparsion is true, the loop breakes
%                   and returns the value. This function is designed to be 
%                   executed by a worker from a parallel cluster.
%
%Input:             StartIndex:
%                       This variable provides the start index of the 
%                       for-loop. Work may be divided while brute forcing,
%                       therefore the start index may not be 1.
%
%                   StopIndex:
%                       This variable provides the stop index of the 
%                       for-loop. Work may be divided while brute forcing,
%                       therefore the stop index may not be the maximum of 
%                       iterations.
%
%                   Hash:
%                       This variable provides the hash of the password,
%                       which will be tried to find.
%
%                   Array:
%                       This "Array" contains all chars which are allowed
%                       for a password.
%                   Opt: 
%                       This struct "Opt" is used by the function DataHash.
%                       For further information see type 'help DataHash'.
%
%Output:            Pw:
%                       This output argument saves the password.
%
%Example:           Hash= '7110eda4d09e062aa5e4a390b0a572ac0d2c0220';
%                   Opt= ...
%                     struct('Method','SHA-1','Format','HEX','Input','ascii');
%                   Array= '0123456789';
%                   Pw= doBruteForceAscendingly (1,11010,Hash,Array,Opt)
%
%Copyright:
%
%**************************************************************************

%==========================================================================
%<Version 1.0> - 16.05.2018 - First version of the function.
%<Version 1.1> - 22.05.2018 - Bugfix: return value is now also assigned if
%                             no password was found. 
%==========================================================================

function [Pw] = doBruteForceAscendingly (StartIndex,StopIndex,Hash,Array,Opt)

%iterate thru a specific part. Compare then the given hash with the hash
%which is created in each for-loop operation. 
for Increment=StartIndex:StopIndex
    if strcmpi(Hash,DataHash(createString(Increment,Array),Opt))
        Pw= createString(Increment,Array);
        return
    end
end

%assign an empty char to the return value to avoid exceptions if the
%password couldn't be found.
Pw= '';