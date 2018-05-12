%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              getGpuData
%
%Description:       TODO
%
%Input:             No input
%
%Output:            No output
%
%Example:           getGpuData();
%
%Copyright:
%
%**************************************************************************

%Version:           1.0

function info = getGpuData

%Define slash for operating system
if ispc
    Slash= '\';
else
    Slash= '/';
end

%define the path to the powershell scripts per each user
UserPath= [pwd,Slash,'Scripts',Slash];

%TODO: choose powershell scripts per GUI or dynamically
[~,gpuTermalZones] = system(sprintf('powershell -inputformat none -file %sget-gpu-temperature.ps1',UserPath));
gpuTermalZones = regexp(gpuTermalZones,'\d*','match');
gpuTempKelvin = str2double(horzcat(gpuTermalZones{:}));
dblTempCelsius = gpuTempKelvin - 273.15;
info.currGpuTemp = {num2str(dblTempCelsius)};

%FIXME: Path does not work
%[~,gpuAvgLoad] = system(sprintf('powershell -inputformat none -file %sget-gpu-load.ps1',UserPath));
% info.avgCpuLoad = regexp(cpuAvgLoad,'\d*','match');
return 