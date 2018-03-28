%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              createKey
%
%Description:       Our encryption system requires an integer matrix m
%                   whose inverse matrix m is also an integer matrix. In
%                   general, there is no easy way to identify matrices with
%                   this property. An option to solve this problem is to
%                   multiplicate lower and upper triangular parts of the
%                   random matrix m and check if the inverse matrix
%                   contains only integers as well. This procedure will be
%                   repeated until a matrix with this conditions is found.
%
%Preconditions:     Nan
%
%Postconditions:    
%
%Copyright:         for further algorythmic information visit: 
%                   http://www.4er.org/LinearAlgebra/CASES/3.%20ea1code.pdf
%
%************************************************************************** 
function [keyM] = createKey()

flag=0;

while (flag==0)
    
    %create a random 3x3 matrix m
    m = randi(10,3,3);
    
    %create a new 3x3 matrix as multiplication of the lower and upper triangular part
    %of the matrix m which is hard to "crack".
    d= diag([1 1 1],0);
    mul= tril(m,-1)+d;
    mup= triu(m,1)+d; 
    m= mul*mup;
    
    LogM= mod(inv(m),1)==0;
    
    if all(all(LogM == true))
        flag=1;
        keyM= m;
    end
end
end