%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              displayData
%
%Description:       TODO
%
%Input:             Object Obj of the class userInterface
%
%Output:            Object Obj of the class userInterface
%
%Example:           displayData;
%
%Copyright:
%
%**************************************************************************

%==========================================================================
%<Version 1.0> - 12.05.2018 - First version of the function.
%==========================================================================

function [Obj] = displayData(Obj)
time = 1 + Obj.PrevTime;
value = 0;

area(value, 'LineWidth', 1,...
    'FaceColor', 'red',...
    'FaceAlpha', 0.7,...
    'AlignVertexCenters', 'on');

value(end+1) = str2double(Obj.cpuData.avgCpuLoad);
time(end+1) = time(end)+1;
   
%Write data in axis object
Obj.UIAxes_cpu.Children.YData = value;
Obj.UIAxes_cpu.Children.XData= time;

%Set old value
Obj.PrevTime = time(end+1);

%Set Timer to first element
if time(end) == 61
    Obj.PrevTime = 0;
end

end
