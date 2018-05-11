%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. H�rzeler
%                   A. Gonzalez
%
%Name:              getCpuData
%
%Description:       TODO
%
%Input:             No input
%
%Output:            No output
%
%Example:           getCpuData();
%
%Copyright:
%
%**************************************************************************

%Version:           1.0

function info = getCpuData

%Define slash for operating system
if ispc
    Slash= '\';
else
    Slash= '/';
end

%define the path to the powershell scripts per each user
UserPath= [pwd,Slash,'Scripts',Slash];

%TODO: choose powershell scripts per GUI or dynamically
[~,cpuTermalZones] = system(sprintf('powershell -inputformat none -file %sget-temperature-TZ0.ps1',UserPath));
cpuTermalZones = regexp(cpuTermalZones,'\d*','match');
cpuTempKelvin = str2double(horzcat(cpuTermalZones{:}));
dblTempCelsius = (cpuTempKelvin / 10) - 273.15;
info.currCpuTemp = {num2str(dblTempCelsius)};

[~,cpuAvgLoad] = system(sprintf('powershell -inputformat none -file %sget-cpu-load.ps1',UserPath));
info.avgCpuLoad = regexp(cpuAvgLoad,'\d*','match');
return 