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
Obj.CpuLoadOutput.Value = CpuData.avgCpuLoad;
Obj.CpuTemperatureOutput.Value = CpuData.currCpuTemp;

%Get GPU data
GpuData = getGpuData;
Obj.GpuLoadOutput.Value = GpuData.avgGpuLoad;
Obj.GpuTemperatureOutput.Value = GpuData.currGpuTemp;

Obj.CpuValue(1) = str2double(CpuData.avgCpuLoad);
Obj.GpuValue(1) = str2double(GpuData.avgGpuLoad);
    
%Convert values into double and write in array
if Obj.SizeReached
    Obj.CpuValue = circshift(Obj.CpuValue,1);
    Obj.GpuValue = circshift(Obj.GpuValue,1);
end
   
%Write data in CPUaxis object
Obj.UIAxes_cpu.Children.YData = Obj.CpuValue;
Obj.UIAxes_cpu.Children.XData= Obj.time;

%Write data in GPUaxis object
Obj.UIAxes_gpu.Children.YData = Obj.GpuValue;
Obj.UIAxes_gpu.Children.XData= Obj.time;

%Prepare next index
Obj.time(end+1) = Obj.time(end)+1;
Obj.CpuValue = [0,Obj.CpuValue];
Obj.GpuValue = [0,Obj.GpuValue];
%Set Timer to first element
if Obj.time(end) == 61
    Obj.SizeReached = true;
    Obj.time(1) = 0; 
    %Obj.CpuValue(1) = 0;
end

end
