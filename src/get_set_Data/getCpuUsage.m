%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Huerzeler
%                   A. Gonzalez
%
%Name:              getCpuUsage
%
%Description:       This function get the gpu data (Temperature & Usage).
%                   The data is determined by Windows Powershell scripts
%                   and converted into known units (°C)
%
%Input:             No input
%
%Output:            TODO:
%
%Example:           h = getCpuUsage();
%
%Copyright:         TODO:
%
%**************************************************************************

%==========================================================================
%<Version 1.0> - 12.05.2018 - First version of the function.
%==========================================================================

function h = getCpuUsage

h = create_gui ;

end

function mon = createMonitor

   cpuIdleProcess = 'Idle' ;
   mon.NumOfCPU = double(System.Environment.ProcessorCount);
  
   mon.ProcPerfCounter.cpuIdle = System.Diagnostics.PerformanceCounter('Process', '% Processor Time', cpuIdleProcess );
end

function updateMeasure(obj,evt,hfig)
   h = guidata(hfig) ;
   %// Calculate the cpu usage
   cpu.total = 100 - h.mon.ProcPerfCounter.cpuIdle.NextValue / h.mon.NumOfCPU ;
   cpu.matlab = h.mon.ProcPerfCounter.Matlab.NextValue / h.mon.NumOfCPU ;
   %// update the display
   set(h.txtTotalCPU,'String',num2str(cpu.total,'%5.2f %%') )
   set(h.txtMatlabCPU,'String',num2str(cpu.matlab,'%5.2f %%') )
end

function StartMonitor(obj,evt)
   h = guidata(obj) ;
   start(h.t)
end
function StopMonitor(obj,evt)
   h = guidata(obj) ;
   stop(h.t)
end

function h = create_gui %// The boring part

   h.fig = figure('Unit','Pixels','Position',[200 800 240 120],'MenuBar','none','Name','CPU usage %','NumberTitle','off') ;

   h.btnStart = uicontrol('Callback',@StartMonitor,'Position',[10 80 100 30],'String', 'START' );
   h.btnStart = uicontrol('Callback',@StopMonitor,'Position',[130 80 100 30 ],'String', 'STOP' );

   h.lbl1 = uicontrol('HorizontalAlignment','right','Position',[10 50 100 20],'String','TOTAL :','Style','text' );
   h.txtTotalCPU = uicontrol('Position',[130 50 100 20],'String','0','Style','text' ) ;

   h.lbl2 = uicontrol('HorizontalAlignment','right','Position',[10 10 100 20],'String','Matlab :','Style','text' );
   h.txtMatlabCPU = uicontrol('Position',[130 10 100 20],'String','0','Style','text' ) ;

   movegui(h.fig,'center')

   %// create the monitor
   h.mon = createMonitor ;

   %// Create the timer
   h.t = timer;
   h.t.Period = 1;
   h.t.ExecutionMode = 'fixedRate';
   h.t.TimerFcn = {@updateMeasure,h.fig} ;
   h.t.TasksToExecute = Inf;

   %// store the handle collection
   guidata(h.fig,h)

end