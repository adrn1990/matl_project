%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. H�rzeler
%                   A. Gonzalez
%
%Name:              createString
%
%Description:       This function creates a string with the length of 8 chars
%                   for a given integer. The chars which should be used to 
%                   create the string can be defined in the array 'Array'.
%                   This function is designed to be used in a for-loop.
%
%Input:             Inc:
%                       The increment is an integer with the minimum of 1
%                       and the maximum of m^n + m^n-1 + ... + m^1 where m=
%                       length(Array) and n=8.
%                    
%                   Array:
%                       The array is a char array which contains all chars
%                       to be used in the output string.
%
%Output:            Str: 
%                       char array with the minimum length of 1 and the
%                       maxiumum length of 8.
%
%Example:           Array= '0123456789';
%                   Password= createString(156,Array)
%
%Copyright:
%
%**************************************************************************

%==========================================================================
%<Version 1.0> - 09.05.2018 - First version of the function.
%<Version 2.0> - 22.05.2018 - The function now operates with the function
%                             "sum" for better readability
%==========================================================================

function [Str] = createString(Inc,Array)

%save the length of the allowed chars into a variable
Chars= length(Array);

%preallocation Pw as cell
Pw= cell(1,8);

%digit 1
Index=  mod(Inc-1,Chars^1)+1;
Pw{1}= Array(Index);

%digit 2
if Inc > Chars^1
    
    Index= floor(mod(Inc-Chars^1-1,Chars^2)/Chars^1)+1;
    
    %The 2. digit of the cell-array Pw is the char of the array 'Array' with
    %the index 'Index'
    Pw{2}= Array(Index);
end


%digit 3
if Inc > sum(Chars.^(1:2))
    
    Index= floor(mod(Inc+sum(-Chars.^(1:2))-1,Chars^3)/Chars^2)+1;
    Pw{3}= Array(Index);
end

%digit 4
if Inc > sum(Chars.^(1:3))
    
    Index= floor(mod(Inc+sum(-Chars.^(1:3))-1,Chars^4)/Chars^3)+1;
    Pw{4}= Array(Index);
end

%digit 5
if Inc > sum(Chars.^(1:4))
    
    Index= floor(mod(Inc+sum(-Chars.^(1:4))-1,Chars^5)/Chars^4)+1;
    Pw{5}= Array(Index);
end

%digit 6
if Inc > sum(Chars.^(1:5))
    
    Index= floor(mod(Inc+sum(-Chars.^(1:5))-1,Chars^6)/Chars^5)+1;
    Pw{6}= Array(Index);
end

%digit 7
if Inc > sum(Chars.^(1:6))
    
    Index= floor(mod(Inc+sum(-Chars.^(1:6))-1,Chars^7)/Chars^6)+1;
    Pw{7}= Array(Index);
end

%digit 8
if Inc > sum(Chars.^(1:7))
    
    Index= floor(mod(Inc+sum(-Chars.^(1:7))-1,Chars^8)/Chars^7)+1;
    Pw{8}= Array(Index);
end

%concat the cell-array and get rid of empty cells
Str= horzcat(Pw{:});

end