function Get-Temperature {
$t = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" | where -Property instancename -EQ "ACPI\ThermalZone\TZ04_0"
$currentTempKelvin = $t.CurrentTemperature / 10
$currentTempCelsius = $currentTempKelvin - 273.15



return $currentTempCelsius
}