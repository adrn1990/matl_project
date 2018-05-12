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
%FIXME: prevTime should be declarated in public in app object
prevTime = 0;
time = 1 + prevTime;
value = 0;


% fig= figure;
% plot(time ,value,'LineWidth',1.5,'Color','red');

area(value, 'LineWidth', 1,...
    'FaceColor', 'red',...
    'FaceAlpha', 0.7,...
    'AlignVertexCenters', 'on');

value(end+1) = Obj.cpuData.avgCpuLoad;
time(end+1) = time(end)+1;
   
%Write data in axis object
Obj.UIAxes_cpu.YData = value;
Obj.UIAxes_cpu.XData = time;

%Set old value
prevTime = time(end+1);

%Set Timer to first element
if time(end) == 61
    prevTimer = 0;
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
