function [Str] = createString(Inc,Array)

Chars= length(Array);

%Pw as cell
Pw= cell(1,8);

%
persistent Index;

Inc= uint64(Inc);

if double(Inc/(Chars^0)) > 0
    Index= mod(double(Inc),Chars^1)+1;
    Pw{1}= Array(Index);
end

if double(Inc/(Chars^1)) > 0
    Index= mod(double(Inc),Chars^1)+1;
    Pw{2}= Array(Index);
end

if double(Inc/(Chars^2)) > 0
    Index= mod(double(Inc),Chars^2)+1;
    Pw{3}= Array(Index);
end

if double(Inc/(Chars^3)) > 0
    Index= mod(double(Inc),Chars^3)+1;
    Pw{4}= Array(Index);
end

if double(Inc/(Chars^4)) > 0
    Index= mod(double(Inc),Chars^4)+1;
    Pw{5}= Array(Index);
end

if double(Inc/(Chars^5)) > 0
    Index= mod(double(Inc),Chars^5)+1;
    Pw{6}= Array(Index);
end

if double(Inc/(Chars^6)) > 0
    Index= mod(double(Inc),Chars^6)+1;
    Pw{7}= Array(Index);
end

if double(Inc/(Chars^7)) > 0
    Index= mod(double(Inc),Chars^7)+1;
    Pw{8}= Array(Index);
end

Str= horzcat(Pw{:});

end