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
[~,cpuTermalZones] = system('wmic /namespace:\\root\cimv2 PATH Win32_PerfFormattedData_Counters_ThermalZoneInformation get Temperature');
info = cpuTermalZones;
return 