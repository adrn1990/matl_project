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
%Output:            A struct which includes the actual temperature and the
%                   average usage of the gpu device.
%
%Example:           info= getGpuData();
%
%Copyright:
%
%**************************************************************************

%==========================================================================
%<Version 1.0> - 12.05.2018 - First version of the function.
%<Version 1.1> - 23.05.2018 - Few descriptions added.
%<Version 1.2> - 24.05.2018 - Problem with path changing solved.
%==========================================================================

function info = getGpuData

%Define slash for operating system
if ispc
    Slash= '\';
else
    Slash= '/';
end

CurrDir= Obj.ApplicationRoot;

%define the path to the powershell scripts per each user
UserPath= [CurrDir,Slash,'Scripts',Slash];

%Execute the powershell script and extract the gpu temperature
[~,gpuTermalZones] = system(sprintf('powershell -inputformat none -file %sget-gpu-temperature.ps1',UserPath));
gpuTermalZones = regexp(gpuTermalZones,'\d*','match');
gpuTempKelvin = str2double(horzcat(gpuTermalZones{:}));
dblTempCelsius = gpuTempKelvin - 273.15;
info.currGpuTemp = {num2str(dblTempCelsius)};

%Execute the powershell script and extract the gpu usage
[~,gpuAvgLoad] = system(sprintf('powershell -inputformat none -file %sget-gpu-load.ps1',UserPath));
 info.avgGpuLoad = regexp(gpuAvgLoad,'\d*','match');
return 