cd 'C:\Program Files\NVIDIA Corporation\NVSMI\'
.\nvidia-smi -i 0 --query-gpu=utilization.gpu --format=csv,noheader
