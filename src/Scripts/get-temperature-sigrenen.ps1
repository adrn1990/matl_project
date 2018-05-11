
Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" | where-object {$_.InstanceName -eq "ACPI\ThermalZone\CPUZ_0"} | Select-object -Property CurrentTemperature

