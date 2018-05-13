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

%Get CPU data
CpuData = getCpuData;
% Obj.CpuLoadOutput.Value = Obj.CpuData.avgCpuLoad;
% Obj.CpuTemperatureOutput.Value = Obj.CpuData.currCpuTemp;

%Get GPU data
% GpuData = getGpuData;
% Obj.GpuLoadOutput.Value = Obj.GpuData.avgGpuLoad;
% Obj.GpuTemperatureOutput.Value = Obj.GpuData.currGpuTemp;

%FIXME: area() function does not work
% area(Obj.UIAxes_cpu.Children.YData, 'LineWidth', 1,...
%     'FaceColor', 'red',...
%     'FaceAlpha', 0.7,...
%     'AlignVertexCenters', 'on');

%Convert values into double and write in array
Obj.CpuValue(end) = str2double(CpuData.avgCpuLoad);
% Obj.GpuValue(end+1) = str2double(GpuData.avgGpuLoad);

   
%Write data in CPUaxis object
Obj.UIAxes_cpu.Children.YData = Obj.CpuValue;
Obj.UIAxes_cpu.Children.XData= Obj.time;

%Write data in GPUaxis object
% Obj.UIAxes_gpu.Children.YData = Obj.GpuValue;
% Obj.UIAxes_gpu.Children.XData= Obj.time;

%Prepare next index
Obj.time(end+1) = Obj.time(end)+1;
Obj.CpuValue(end+1) = 0;
%Set Timer to first element
if Obj.time(end) == 61
    Obj.time(1) = 0; %FIXME: correct statement
    Obj.CpuValue(1) = 0;
end

end
