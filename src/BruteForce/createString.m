function [Str] = createString(Inc,Array)

Chars= length(Array);

%Pw as cell
Pw= cell(1,8);

%
persistent Index;

%Inc= uint64(Inc);

I1= Inc;
I2= floor(Inc/(Chars^1));
I3= floor(Inc/(Chars^2));
I4= floor(Inc/(Chars^3));
I5= floor(Inc/(Chars^4));
I6= floor(Inc/(Chars^5));
I7= floor(Inc/(Chars^6));
I8= floor(Inc/(Chars^7));




%digit 1
if Inc > 0
    if I1 > Chars && mod(I1,Chars^1) ~= 0
        Index= mod(I1,Chars^1);
    elseif I1 > Chars && mod(I1,Chars^1) == 0
        Index= Chars;
    else
        Index= I1;
    end
    Pw{1}= Array(Index);
end

%digit 2
%check if the digit 2 should be used
if Inc > Chars^1
    if I2 > Chars && mod(I2,Chars^1) ~= 0
        Index= mod(I2,Chars^1);
    elseif I2 > Chars && mod(I2,Chars^1) == 0
        Index= Chars;
    else
        Index= I2;
    end
    Pw{2}= Array(Index);
end

%digit 3
%check if the digit 3 should be used
if Inc > Chars^2
    if I3 > Chars && mod(I3,Chars^1) ~= 0
        Index= mod(I3,Chars^1);
    elseif I3 > Chars && mod(I3,Chars^1) == 0
        Index= Chars;
    else
        Index= I3;
    end
    Pw{3}= Array(Index);
end

Str= horzcat(Pw{:});

end