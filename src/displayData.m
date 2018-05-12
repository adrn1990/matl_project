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
uiaxes(Obj.UIAxes_cpu);

area(value, 'LineWidth', 1,...
    'FaceColor', 'red',...
    'FaceAlpha', 0.7,...
    'AlignVertexCenters', 'on');

value(end+1) = str2double(Obj.cpuData.avgCpuLoad);
time(end+1) = time(end)+1;
   
%Write data in axis object
Obj.UIAxes_cpu.YAxis = value;
Obj.UIAxes_cpu.XAxis= time;

%Set old value
Obj.PrevTime = time(end+1);

%Set Timer to first element
if time(end) == 61
    Obj.PrevTime = 0;
end


% fig.Children.YAxis.Limits = [0 100];
% fig.Children.XAxis.Limits = [0 60];
% fig.Children.YAxis.LimitsMode = 'manual';
% fig.Children.XAxis.Direction = 'reverse';

% for index = 1:60
%     value(end+1) = index^1.5;
%     time(end+1) = time(end)+1;
%     fig.Children.Children.YData= value;
%     fig.Children.Children.XData= time;
%     pause(0.5)
% end



end
