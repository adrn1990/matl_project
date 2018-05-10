$computer = $env:COMPUTERNAME
$namespace = "ROOT\cimv2\NV"
$gpuclass = "Gpu"
$tempclass = "ThermalProbe"

$GPU_Meters=Get-WmiObject -Class $gpuclass -ComputerName $computer -Namespace $namespace | Select-Object *
$TEMP_Meters=Get-WmiObject -Class $tempclass -ComputerName $computer -Namespace $namespace | Select-Object *
$nvidia_model=$GPU_Meters.productName
$gpu_usage=$GPU_Meters.percentGpuUsage
$mem_usage=$GPU_Meters.percentGpuMemoryUsage
$temperature=$TEMP_Meters.temperature

$output = "Nvidia $nvidia_model Memory:$mem_usage% GPU:$gpu_usage% Temp:$Temperature°C | Memory=$mem_usage;;;0; GPU=$gpu_usage;;;0; TEMP=$temperature;;;0;"

Write-Output $Output

exit 0
