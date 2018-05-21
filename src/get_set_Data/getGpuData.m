%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Huerzeler
%                   A. Gonzalez
%
%Name:              getGpuData
%
%Description:       This function get the gpu data (Temperature & Usage).
%                   The data is determined by Windows Powershell scripts
%                   and converted into known units (°C)
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

[~,gpuTermalZones] = system(sprintf('powershell -inputformat none -file %sget-gpu-temperature.ps1',UserPath));
gpuTermalZones = regexp(gpuTermalZones,'\d*','match');
gpuTempKelvin = str2double(horzcat(gpuTermalZones{:}));
dblTempCelsius = gpuTempKelvin - 273.15;
info.currGpuTemp = {num2str(dblTempCelsius)};

[~,gpuAvgLoad] = system(sprintf('powershell -inputformat none -file %sget-gpu-load.ps1',UserPath));
 info.avgGpuLoad = regexp(gpuAvgLoad,'\d*','match');
return 