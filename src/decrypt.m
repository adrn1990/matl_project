%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              decrypt
%
%Description:       This function decrypts a 1xn char-array with the matrix
%                   m, which has been generated with the function
%                   createKey. The function uses simple matrix
%                   multiplications while providing that each char is an
%                   ascii-char.
%
%Preconditions:     
%
%Postconditions:
%
%Copyright:         for further information visit: 
%                   http://www.4er.org/LinearAlgebra/CASES/3.%20ea1code.pdf
%
%**************************************************************************

function [decString] = decrypt (encString,m)

    ArrayLength= length(encString);
    Remainder= 0;
    A= ones(1,length(encString)+1);
    %TODO: find the problem with the last chars of the password.
    HelpChar= encrypt([A,'11'],m);
    Row= ceil(ArrayLength/3);
    
if (mod(ArrayLength,3) == 1)
    encString=[encString,HelpChar(end-1),HelpChar(end)]; %add two encrypted spaces
    ArrayLength= ArrayLength+2;
    Remainder= 2;
elseif (mod(ArrayLength,3) == 2)
    encString=[encString,HelpChar(end)]; %add one encrypted spaces
    ArrayLength= ArrayLength+1;
    Remainder= 1;
end
    nnumb = reshape (double(encString), 3, Row);
    
    ncode = mod (m\(nnumb-32), 95) + 32;
    decString = reshape (char(ncode), 1, ArrayLength);
    decString = decString(1:end-Remainder);
end