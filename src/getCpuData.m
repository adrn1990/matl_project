%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
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

%
%TODO: Actual Temp divide 10 and substract 0°K
%For PowerShell -> get Temperature zones: get-wmiobject MSAcpi_ThermalZoneTemperature -namespace "root/wmi"

function info = getCpuData
[~,cpuTermalZones] = system('powershell -inputformat none -file C:\Users\bruno\Documents\WindowsPowerShell\modules\get-temperature\get-temperature-TZ0.ps1');
cpuTermalZones = regexp(cpuTermalZones,'\d*','match');
cpuTempKelvin = str2double(horzcat(cpuTermalZones{:}));
info.currCpuTemp = (cpuTempKelvin / 10) - 273.15;

[~,cpuAvgLoad] = system('powershell -inputformat none -file C:\Users\bruno\Documents\WindowsPowerShell\modules\get-temperature\get-cpu-load.ps1');
cpuAvgLoad = regexp(cpuAvgLoad,'\d*','match');
info.avgCpuLoad = str2double(horzcat(cpuAvgLoad{:}));
return 