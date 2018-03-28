%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              encrypt
%
%Description:       This function encrypts a 1xn char-array with a random
%                   generated key. The function uses simple matrix
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


function [encrString] = encrypt (CharArray,m)
%{
Matlab uses the standard computer character code (the so-called ASCII code)
to assign a different number to each letter and punctuation mark. A space is
also regarded as one of the characters of the message.
To apply a matrix-algebra encryption scheme to this numerical form of the message, 
we begin by arranging the array of numbers into a 3 × # matrix. Matlab?s reshape 
function does exactly this:
%}


ArrayLength= length(CharArray);
Remainder= 0;

if (mod(ArrayLength,3) == 1)
    CharArray=[CharArray,'11']; %add two spaces
    ArrayLength= ArrayLength+2;
    Remainder= 2;
elseif (mod(ArrayLength,3) == 2)
    CharArray=[CharArray,'1']; %add one spaces
    ArrayLength= ArrayLength+1;
    Remainder= 1;
end

Row= ceil(ArrayLength/3);

nnumb = reshape (double(CharArray), 3, Row);
%{
We now arrive at the crucial step of the encryption, in which we transform
this matrix to another 3×n matrix. The transformation is effected by multiplying
our matrix on the left by a 3×3 matrix. Not any such matrix will do, however. 
To make decryption possible, we must multiply by a 3 × 3 matrix whose entries 
are all integers (whole numbers), and whose inverse has entries that are all integers. 
%}

%This assignment doesn't provides that the inverse matrix is with only
%integers.
%m = randi(100,3,3);

%{
We're now almost ready to multiply by m. But because the printable char- acters have ASCII
codes in the range 32 to 126, we must first adjust the 3 × 5 message matrix by subtracting 32
from every element
%}

%nnumb-32;

%{
Now the matrix must contain values in the range 0 to 94, and it is ready to be transformed 
by matrix multiplication:
%}

%m*(nnumb-32);

%{
This transformed matrix does not contain printable ASCII codes, but we can take care of that
via the following further adjustment:
%}

ncode = mod (m*(nnumb-32), 95) + 32;

%{
Here we have used the mod function to divide each element by 95 and keep only
the remainder, and then we have added 32 so that the values again range from 32 to 126.
All that remains to be done is to convert these numbers back to an array of characters.
We use Matlab's char function to convert the numbers to characters, and reshape again
to put them back into a 1 × n array:
%}

encrString = reshape (char(ncode), 1, ArrayLength);
encrString = encrString(1:end-Remainder);
end