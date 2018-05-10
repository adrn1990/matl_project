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

%Version:           1.0

function info = getCpuData
[~,cpuTermalZones] = system('powershell -inputformat none -file C:\Users\bruno\Documents\WindowsPowerShell\modules\get-temperature\get-temperature-TZ0.ps1');
cpuTermalZones = regexp(cpuTermalZones,'\d*','match');
cpuTempKelvin = str2double(horzcat(cpuTermalZones{:}));
dblTempCelsius = (cpuTempKelvin / 10) - 273.15;
info.currCpuTemp = {num2str(dblTempCelsius)};

[~,cpuAvgLoad] = system('powershell -inputformat none -file C:\Users\bruno\Documents\WindowsPowerShell\modules\get-temperature\get-cpu-load.ps1');
info.avgCpuLoad = regexp(cpuAvgLoad,'\d*','match');
return 