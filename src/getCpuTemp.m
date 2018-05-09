%TODO: Actual Temp divide 10 and substract 0°K
%For PowerShell -> get Temperature zones: get-wmiobject MSAcpi_ThermalZoneTemperature -namespace "root/wmi"

function info =getCpuTemp
[status,termalZones] = system('wmic /namespace:\\root\cimv2 PATH Win32_PerfFormattedData_Counters_ThermalZoneInformation get Temperature');
info = termalZones;
return 