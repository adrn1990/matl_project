%**************************************************************************
%Project:           Brute-Force Tool
%
%Authors:           B. Hürzeler
%                   A. Gonzalez
%
%Name:              userInterface
%
%Description:       TODO
%
%Input:             No input
%
%Output:            Object of the class userInterface
%
%Example:           app = userInterface_script();
%
%Copyright:
%
%**************************************************************************

%=============================Version- Overview============================
%{
%==========================================================================
%<Version 1.0> - 28.04.2018 - First draft of the class and its UI.
%
%<Version 2.0> - 11.05.2018 - Second draft of the class and its UI.
%                           - Integration of bruteforcing with parfor-loop 
%                             up to three characters.
%                           - Implementation of improvement procedure.
%                           - Call of initialization and delete functions.
%                           - Integration of powershell scripts.
%                           - Implementation of runApp script to create an
%                             object and check different things of system.
%
%<Version 3.0> - 14.05.2018 - New strategy of providing the load to the
%                             workers of the parallel computing toolbox.
%                           - Graphs changed and displaying of data
%                             implemented.
%
%<Version 4.0> - 18.05.2018 - New functionalities around the GPU and its
%                             graphs.
%                           - Hashes and passwords can now be forced.
%                           - Dynamic warning depending on the
%                             configuration of the components.
%                           - Password length changed to 4 chars.
%                           - CreateAHash button with callback added
%
%<Version 4.0.1> - 23.05.2018 - Missing descriptions added.
%==========================================================================
%}

classdef userInterface_script < matlab.apps.AppBase

%==========================================================================
%=============================class properties=============================
%==========================================================================
    properties (Access = public)
        BruteForceToolUIFigure   matlab.ui.Figure
        FileMenu                 matlab.ui.container.Menu
        NewrunMenu               matlab.ui.container.Menu
        SaveMenu                 matlab.ui.container.Menu
        ExitMenu                 matlab.ui.container.Menu
        InfoMenu                 matlab.ui.container.Menu
        AboutMenu                matlab.ui.container.Menu
        BruteforceToolLabel      matlab.ui.control.Label
        InputPasswordHashLabel   matlab.ui.control.Label
        InputEditField           matlab.ui.control.EditField
        StartButton              matlab.ui.control.Button
        LogMonitorTextAreaLabel  matlab.ui.control.Label
        LogMonitorOutput         matlab.ui.control.TextArea
        ModeTodecryptLabel       matlab.ui.control.Label
        ModeDropDown             matlab.ui.control.DropDown
        EncryptionAlgorithmDropDownLabel  matlab.ui.control.Label
        EncryptionDropDown       matlab.ui.control.DropDown
        CPUTempCLabel            matlab.ui.control.Label
        CpuTemperatureOutput     matlab.ui.control.TextArea
        CPULoadLabel             matlab.ui.control.Label
        CpuLoadOutput            matlab.ui.control.TextArea
        ResultTextAreaLabel      matlab.ui.control.Label
        ResultOutput             matlab.ui.control.TextArea
        AdvancedsettingsLabel    matlab.ui.control.Label
        EvaluateButton           matlab.ui.control.Button
        StatusTextAreaLabel      matlab.ui.control.Label
        StatusOutput             matlab.ui.control.TextArea
        WarningBox               matlab.ui.control.TextArea
        UIAxes_cpu               matlab.ui.control.UIAxes
        UIAxes_gpu               matlab.ui.control.UIAxes
        GPULoadLabel             matlab.ui.control.Label
        GpuLoadOutput            matlab.ui.control.TextArea
        GPUTempCLabel            matlab.ui.control.Label
        GpuTemperatureOutput     matlab.ui.control.TextArea
        ClusterDropDownLabel     matlab.ui.control.Label
        ClusterDropDown          matlab.ui.control.DropDown
        AbortButton              matlab.ui.control.Button
        GPUSwitchLabel           matlab.ui.control.Label
        GPUSwitch                matlab.ui.control.Switch
        CreateahashButton        matlab.ui.control.Button
%manual properties---

        %This property indicates a flag for aborting the Brute force
        %process.
        Abort= false;

        %The following property saves the allowed chars for the password.
        AllowedChars= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

        %This property saves the path of the application.
        ApplicationRoot;
        
        %This property saves the information if a cluster is valid or not.
        ClusterIsValid= false;
        
        %This property includes all data about the cpu.
        cpuData;

        %This property includes all information about the cpu as struct.
        cpuInfo;

        %This property is required for displaying the cpu values.
        CpuValue = 0;

        %This property is needed for grouping log messages.
        delemiter = '---------------------------------------------------------------------------------------------------------------';

        %This property is needed for important log messages for the user.
        delemiter2 = '===============================================================';

        %This property indicates a flag if an evaluation has processed.
        evaluateDone = false;

        %This property safes the name of the file with the allready found 
        %passwords and hashes.
        FileName;

        %This property safes all folders of the path.
        Folders;
                
        %This property indicates a flag for an available gpu device.
        GpuAvailable= false;
        
        %This property includes all information about the gpu.
        gpuInfo;

        %This property includes all data about the gpu.
        gpuData;

        %This property indicates a flag for an enabled gpu device.
        GpuEnabled = false;

        %This property indicates a flag if an gpu evaluation has processed.
        gpuEvaluationDone = false;

        %This property is required for displaying the gpu values.
        GpuValue = 0;

        %This property saves the hash of the given data.
        Hash;
        
        %This property saves the lenght of the hash (Default is SHA-1).    
        HashLength= 40;
        
        %This struct safes the properties for the function DataHash
        HashStruct= struct('Method','','Format','HEX','Input','ascii');

        %This property safes the allready found passwords and hashes.
        Improvements;

        %This property saves the amount of iterations the parfor loop has
        %to do.
        Iterations;
        
        %This property saves the information, if the log monitor has been
        %saved to a file.
        LogSaved= false;
                
        %The maximum of the password length is set to 4.
        MaxPwLength= 4;
        
        %This property is required to write the log messages.
        messageBuffer = {''};
        
        %This property safes the number of chars for the password
        %0-9, A-Z, a-z
        NbrOfChars= 62;

        %This property is required for displaying the values on axes.
        SizeReached = false;
        
        %This property safes the char slash/backslash dependency on the
        %operating system of the user.
        Slash;
        
        %This property indicates the x-axis values in graphs.
        time = 0;
        

    end % end of class properties
%==========================================================================    



%==========================================================================
%===========================class private methods==========================
%==========================================================================
    methods (Access = private)
         % Button pushed function: AbortButton
        function AbortButtonPushed(app, event)
            app.Abort = true;
        end
               
        % Menu selected function: AboutMenu
        function AboutMenuSelected(app, event)
            msgbox({'Name: Brute-Force Tool' 'Version: 0.0.0' 'Designer: A.Gonzalez / B. Huerzeler'}, 'About...');
        end
        
        % Close request function: BruteForceToolUIFigure
        function CloseRequest(app, event)
            
            %call function for delete procedure
            deleteApp(app);
            
            delete(app);
            
        end

        % Value changed function: ClusterDropDown
        function ClusterDropDownValueChanged(app, event)
            app.ClusterIsValid= false;
            app.evalStartBF();
            Value= app.ClusterDropDown.Value;
            clusterValidity(app,Value);
        end        

        %check if the chosen cluster is valid.
        function clusterValidity(app,Value)
            app.fWriteMessageBuffer('Checking cluster validity...')
            try
                Cluster= parcluster(Value);
                if Cluster.isvalid
                    app.ClusterIsValid= true;
                    app.fWriteMessageBuffer(sprintf(...
                        'The chosen cluster ''%s'' is valid.',Value));
                    app.fWriteMessageBuffer(app.delemiter);
                else
                    app.ClusterIsValid= false;
                    app.fWriteMessageBuffer(sprintf(...
                        'The chosen cluster ''%s'' is not valid. Please choose another one.',Value));
                    app.fWriteMessageBuffer(app.delemiter);
                end
            catch ME
                Msg= ME.message;
                app.fWriteMessageBuffer(Msg);
                app.fWriteMessageBuffer(app.delemiter);
                app.ClusterIsValid= false;
            end
            
            evalStartBF(app);
        end
        
        %this function sets the components properties to the state after the system is evaluated
        function compAfterEval(app)
            app.EvaluateButton.Enable = 'off';
            app.StartButton.Enable = 'off';
            app.NewrunMenu.Enable = 'on';
            app.SaveMenu.Enable = 'on';
            app.ExitMenu.Enable = 'on';
            app.AbortButton.Enable = 'off';
            app.ModeDropDown.Enable = 'on';
            app.InputEditField.Enable = 'on';
            app.EncryptionDropDown.Enable = 'on';
            app.ClusterDropDown.Enable = 'on';
            app.Abort = false;
            app.CreateahashButton.Enable = 'on';

            if app.GpuAvailable
                app.GPUSwitch.Enable = 'on';
            end
        end

        %this function sets the components properties to the state before 
        %the system is evaluated
        function compBeforeEval(app,varargin)
            %check if varargin is used
            if ~isempty(varargin)
                value = varargin{1};
            end
            
            
            app.EvaluateButton.Enable = 'on';
            app.WarningBox.Visible = 'off';
            app.StartButton.Enable = 'off';
            app.NewrunMenu.Enable = 'off';
            app.SaveMenu.Enable = 'off';
            app.ExitMenu.Enable = 'on';
            app.AbortButton.Enable = 'off';
            app.ModeDropDown.Enable = 'off';
            app.InputEditField.Enable = 'off';
            app.EncryptionDropDown.Enable = 'off';
            app.ClusterDropDown.Enable = 'off';
            app.CreateahashButton.Enable = 'off';

            
            if strcmp(value,'full')
                app.messageBuffer = {''};
                app.LogMonitorOutput.Value = '';
                app.InputEditField.Value = '';
                app.StatusOutput.Value = '';
                app.ResultOutput.Value = '';
                app.evaluateDone= false;
                app.gpuEvaluationDone= false;
                app.GPUSwitch.Enable = 'off';
                app.InputEditField.Value= '';
                
                
            end

            setAxisProps(app);                      
            
        end
                
        %this function sets the component properties to the state while the
        %brute forcing is in progress
        function compWhileBruteForce(app)
            app.EvaluateButton.Enable = 'off';
            app.StartButton.Enable = 'off';
            app.NewrunMenu.Enable = 'off';
            app.SaveMenu.Enable = 'off';
            app.ExitMenu.Enable = 'off';
            app.AbortButton.Enable = 'on';
            app.ModeDropDown.Enable = 'off';
            app.InputEditField.Enable = 'off';
            app.EncryptionDropDown.Enable = 'off';
            app.ClusterDropDown.Enable = 'off';
            app.GPUSwitch.Enable = 'off';
            app.ExitMenu.Enable = 'off';
            app.CreateahashButton.Enable = 'off';
            
        end
        
        %this function sets the components properties to the state while 
        %the system gets evaluated
        function compWhileEvaluate(app)
            app.EvaluateButton.Enable = 'off';
            app.WarningBox.Visible = 'off';
            app.StartButton.Enable = 'off';
            app.NewrunMenu.Enable = 'off';
            app.SaveMenu.Enable = 'off';
            app.ExitMenu.Enable = 'off';
            app.AbortButton.Enable = 'off';
            app.ModeDropDown.Enable = 'off';
            app.InputEditField.Enable = 'off';
            app.EncryptionDropDown.Enable = 'off';
            app.ClusterDropDown.Enable = 'off';
            app.GPUSwitch.Enable = 'off';
            app.CreateahashButton.Enable = 'off';
        end

        % Create UIFigure and components
        function createComponents(app)

            % Create BruteForceToolUIFigure
            app.BruteForceToolUIFigure = uifigure;
            app.BruteForceToolUIFigure.Color = [0.3137 0.3137 0.3137];
            app.BruteForceToolUIFigure.Position = [100 100 1284 974];
            app.BruteForceToolUIFigure.Name = 'Brute-Force Tool';
            app.BruteForceToolUIFigure.CloseRequestFcn = createCallbackFcn(app, @CloseRequest, true);

            % Create FileMenu
            app.FileMenu = uimenu(app.BruteForceToolUIFigure);
            app.FileMenu.Text = 'File';

            % Create NewrunMenu
            app.NewrunMenu = uimenu(app.FileMenu);
            app.NewrunMenu.MenuSelectedFcn = createCallbackFcn(app, @NewrunMenuSelected, true);
            app.NewrunMenu.Accelerator = 'N';
            app.NewrunMenu.Text = 'New run...';

            % Create SaveMenu
            app.SaveMenu = uimenu(app.FileMenu);
            app.SaveMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveMenuSelected, true);
            app.SaveMenu.Accelerator = 'S';
            app.SaveMenu.Text = 'Save';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.FileMenu);
            app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            app.ExitMenu.Text = 'Exit';

            % Create InfoMenu
            app.InfoMenu = uimenu(app.BruteForceToolUIFigure);
            app.InfoMenu.Text = '?';

            % Create AboutMenu
            app.AboutMenu = uimenu(app.InfoMenu);
            app.AboutMenu.MenuSelectedFcn = createCallbackFcn(app, @AboutMenuSelected, true);
            app.AboutMenu.Text = 'About...';

            % Create BruteforceToolLabel
            app.BruteforceToolLabel = uilabel(app.BruteForceToolUIFigure);
            app.BruteforceToolLabel.FontName = 'Digital-7 Mono';
            app.BruteforceToolLabel.FontSize = 26;
            app.BruteforceToolLabel.FontWeight = 'bold';
            app.BruteforceToolLabel.FontColor = [0.9412 0.9412 0.9412];
            app.BruteforceToolLabel.Position = [44 914 203 32];
            app.BruteforceToolLabel.Text = 'Brute force Tool';

            % Create InputPasswordHashLabel
            app.InputPasswordHashLabel = uilabel(app.BruteForceToolUIFigure);
            app.InputPasswordHashLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.InputPasswordHashLabel.HorizontalAlignment = 'right';
            app.InputPasswordHashLabel.FontColor = [1 1 1];
            app.InputPasswordHashLabel.Position = [66 707 133 15];
            app.InputPasswordHashLabel.Text = 'Input [Password / Hash]';

            % Create InputEditField
            app.InputEditField = uieditfield(app.BruteForceToolUIFigure, 'text');
            app.InputEditField.ValueChangingFcn = createCallbackFcn(app, @InputEditFieldValueChanging, true);
            app.InputEditField.FontColor = [1 1 1];
            app.InputEditField.BackgroundColor = [0.3137 0.3137 0.3137];
            app.InputEditField.Position = [332 703 164 22];           

            % Create StartButton
            app.StartButton = uibutton(app.BruteForceToolUIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.BackgroundColor = [0.4 0.8 0.9294];
            app.StartButton.FontName = 'Arial';
            app.StartButton.FontSize = 20;
            app.StartButton.FontWeight = 'bold';
            app.StartButton.FontColor = [1 1 1];
            app.StartButton.Position = [66 411 430 54];
            app.StartButton.Text = 'START Brute force';

            % Create LogMonitorTextAreaLabel
            app.LogMonitorTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.LogMonitorTextAreaLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.LogMonitorTextAreaLabel.FontColor = [1 1 1];
            app.LogMonitorTextAreaLabel.Position = [34 263 70 15];
            app.LogMonitorTextAreaLabel.Text = 'Log-Monitor';

            % Create LogMonitorOutput
            app.LogMonitorOutput = uitextarea(app.BruteForceToolUIFigure);
            app.LogMonitorOutput.Editable = 'off';
            app.LogMonitorOutput.FontColor = [1 1 1];
            app.LogMonitorOutput.BackgroundColor = [0.3137 0.3137 0.3137];
            app.LogMonitorOutput.Position = [31 34 570 224];

            % Create ModeTodecryptLabel
            app.ModeTodecryptLabel = uilabel(app.BruteForceToolUIFigure);
            app.ModeTodecryptLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.ModeTodecryptLabel.HorizontalAlignment = 'right';
            app.ModeTodecryptLabel.FontColor = [1 1 1];
            app.ModeTodecryptLabel.Position = [66 747 101 15];
            app.ModeTodecryptLabel.Text = 'Mode [To decrypt]';

            % Create ModeDropDown
            app.ModeDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.ModeDropDown.Items = {'Select...', 'Password', 'Hash'};
            app.ModeDropDown.ValueChangedFcn = createCallbackFcn(app, @ModeDropDownValueChanged, true);
            app.ModeDropDown.FontColor = [1 1 1];
            app.ModeDropDown.BackgroundColor = [0.3137 0.3137 0.3137];
            app.ModeDropDown.Position = [332 743 164 22];
            app.ModeDropDown.Value = 'Select...';

            % Create EncryptionAlgorithmDropDownLabel
            app.EncryptionAlgorithmDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.EncryptionAlgorithmDropDownLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.EncryptionAlgorithmDropDownLabel.HorizontalAlignment = 'right';
            app.EncryptionAlgorithmDropDownLabel.FontColor = [1 1 1];
            app.EncryptionAlgorithmDropDownLabel.Position = [66 578 123 15];
            app.EncryptionAlgorithmDropDownLabel.Text = 'Encryption [Algorithm]';

            % Create EncryptionDropDown
            app.EncryptionDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.EncryptionDropDown.Items = {'Select...', 'SHA-1', 'SHA-256', 'SHA-512', 'MD5'};
            app.EncryptionDropDown.ValueChangedFcn = createCallbackFcn(app, @EncryptionDropDownValueChanged, true);
            app.EncryptionDropDown.FontColor = [1 1 1];
            app.EncryptionDropDown.BackgroundColor = [0.3137 0.3137 0.3137];
            app.EncryptionDropDown.Position = [332 574 164 22];
            app.EncryptionDropDown.Value = 'Select...';

            % Create CPUTempCLabel
            app.CPUTempCLabel = uilabel(app.BruteForceToolUIFigure);
            app.CPUTempCLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.CPUTempCLabel.HorizontalAlignment = 'right';
            app.CPUTempCLabel.FontColor = [1 1 1];
            app.CPUTempCLabel.Position = [999 345 90 15];
            app.CPUTempCLabel.Text = 'CPU Temp. [°C]';

            % Create CpuTemperatureOutput
            app.CpuTemperatureOutput = uitextarea(app.BruteForceToolUIFigure);
            app.CpuTemperatureOutput.Editable = 'off';
            app.CpuTemperatureOutput.HorizontalAlignment = 'center';
            app.CpuTemperatureOutput.FontSize = 14;
            app.CpuTemperatureOutput.FontColor = [1 1 1];
            app.CpuTemperatureOutput.BackgroundColor = [0.3137 0.3137 0.3137];
            app.CpuTemperatureOutput.Position = [1127 338 92 28];

            % Create CPULoadLabel
            app.CPULoadLabel = uilabel(app.BruteForceToolUIFigure);
            app.CPULoadLabel.HorizontalAlignment = 'right';
            app.CPULoadLabel.FontColor = [1 1 1];
            app.CPULoadLabel.Position = [661 345 82 15];
            app.CPULoadLabel.Text = 'CPU Load [%]';

            % Create CpuLoadOutput
            app.CpuLoadOutput = uitextarea(app.BruteForceToolUIFigure);
            app.CpuLoadOutput.Editable = 'off';
            app.CpuLoadOutput.HorizontalAlignment = 'center';
            app.CpuLoadOutput.FontSize = 14;
            app.CpuLoadOutput.FontColor = [1 1 1];
            app.CpuLoadOutput.BackgroundColor = [0.3137 0.3137 0.3137];
            app.CpuLoadOutput.Position = [789 338 92 28];

            % Create ResultTextAreaLabel
            app.ResultTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.ResultTextAreaLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.ResultTextAreaLabel.HorizontalAlignment = 'right';
            app.ResultTextAreaLabel.FontColor = [1 1 1];
            app.ResultTextAreaLabel.Position = [645 250 40 15];
            app.ResultTextAreaLabel.Text = 'Result';

            % Create ResultOutput
            app.ResultOutput = uitextarea(app.BruteForceToolUIFigure);
            app.ResultOutput.Editable = 'off';
            app.ResultOutput.HorizontalAlignment = 'center';
            app.ResultOutput.FontSize = 48;
            app.ResultOutput.FontWeight = 'bold';
            app.ResultOutput.FontColor = [0.6784 1 0.1843];
            app.ResultOutput.BackgroundColor = [0.3137 0.3137 0.3137];
            app.ResultOutput.Position = [650 185 583 60];

            % Create AdvancedsettingsLabel
            app.AdvancedsettingsLabel = uilabel(app.BruteForceToolUIFigure);
            app.AdvancedsettingsLabel.VerticalAlignment = 'center';
            app.AdvancedsettingsLabel.FontSize = 16;
            app.AdvancedsettingsLabel.FontAngle = 'italic';
            app.AdvancedsettingsLabel.FontColor = [1 1 1];
            app.AdvancedsettingsLabel.Position = [65 631 338 20];
            app.AdvancedsettingsLabel.Text = 'Advanced settings';

            % Create EvaluateButton
            app.EvaluateButton = uibutton(app.BruteForceToolUIFigure, 'push');
            app.EvaluateButton.ButtonPushedFcn = createCallbackFcn(app, @EvaluateButtonPushed, true);
            app.EvaluateButton.BackgroundColor = [1 0.9255 0.5451];
            app.EvaluateButton.FontSize = 14;
            app.EvaluateButton.FontWeight = 'bold';
            app.EvaluateButton.Position = [73 816 423 45];
            app.EvaluateButton.Text = 'Evaluate System';

            % Create StatusTextAreaLabel
            app.StatusTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.StatusTextAreaLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.StatusTextAreaLabel.FontColor = [1 1 1];
            app.StatusTextAreaLabel.Position = [34 323 40 15];
            app.StatusTextAreaLabel.Text = 'Status';

            % Create StatusOutput
            app.StatusOutput = uitextarea(app.BruteForceToolUIFigure);
            app.StatusOutput.Editable = 'off';
            app.StatusOutput.FontColor = [1 1 1];
            app.StatusOutput.BackgroundColor = [0.3137 0.3137 0.3137];
            app.StatusOutput.Position = [31 289 570 29];

            % Create WarningBox
            app.WarningBox = uitextarea(app.BruteForceToolUIFigure);
            app.WarningBox.Editable = 'off';
            app.WarningBox.FontSize = 9;
            app.WarningBox.FontColor = [1 0.27 0];
            app.WarningBox.BackgroundColor = [0.3137 0.3137 0.3137];
            app.WarningBox.Position = [332 669 164 35];

            % Create UIAxes_cpu
            app.UIAxes_cpu = uiaxes(app.BruteForceToolUIFigure);
            title(app.UIAxes_cpu, 'CPU Average Load','Color','white')
            ylabel(app.UIAxes_cpu, '%')
            app.UIAxes_cpu.XLim = [0 60];
            app.UIAxes_cpu.YLim = [0 100];
            app.UIAxes_cpu.XDir = 'reverse';
            app.UIAxes_cpu.GridColor = [0.902 0.902 0.902];
            app.UIAxes_cpu.MinorGridColor = [0.149 0.149 0.149];
            app.UIAxes_cpu.Box = 'on';
            app.UIAxes_cpu.XColor = [0.9412 0.9412 0.9412];
            app.UIAxes_cpu.XTick = [0 20 40 60];
            app.UIAxes_cpu.YColor = [0.9412 0.9412 0.9412];
            app.UIAxes_cpu.YTick = [0 25 50 75 100];
            app.UIAxes_cpu.ZColor = [0.9412 0.9412 0.9412];
            app.UIAxes_cpu.Color = [0.3137 0.3137 0.3137];
            app.UIAxes_cpu.XGrid = 'on';
            app.UIAxes_cpu.YGrid = 'on';
            app.UIAxes_cpu.BackgroundColor = [0.3137 0.3137 0.3137];
            app.UIAxes_cpu.Position = [600 631 639 228];

            % Create UIAxes_gpu
            app.UIAxes_gpu = uiaxes(app.BruteForceToolUIFigure);
            title(app.UIAxes_gpu, 'GPU Average Load', 'Color','white')
            ylabel(app.UIAxes_gpu, '%')
            app.UIAxes_gpu.XLim = [0 60];
            app.UIAxes_gpu.YLim = [0 100];
            app.UIAxes_gpu.XDir = 'reverse';
            app.UIAxes_gpu.GridColor = [0.902 0.902 0.902];
            app.UIAxes_gpu.MinorGridColor = [0.902 0.902 0.902];
            app.UIAxes_gpu.Box = 'on';
            app.UIAxes_gpu.BoxStyle = 'full';
            app.UIAxes_gpu.XColor = [0.9412 0.9412 0.9412];
            app.UIAxes_gpu.XTick = [0 20 40 60];
            app.UIAxes_gpu.YColor = [0.9412 0.9412 0.9412];
            app.UIAxes_gpu.YTick = [0 25 50 75 100];
            app.UIAxes_gpu.Color = [0.3137 0.3137 0.3137];
            app.UIAxes_gpu.XGrid = 'on';
            app.UIAxes_gpu.YGrid = 'on';
            app.UIAxes_gpu.BackgroundColor = [0.3137 0.3137 0.3137];
            app.UIAxes_gpu.Position = [599 405 642 215];

            % Create GPULoadLabel
            app.GPULoadLabel = uilabel(app.BruteForceToolUIFigure);
            app.GPULoadLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.GPULoadLabel.HorizontalAlignment = 'right';
            app.GPULoadLabel.FontColor = [1 1 1];
            app.GPULoadLabel.Position = [661 304 82 15];
            app.GPULoadLabel.Text = 'GPU Load [%]';

            % Create GpuLoadOutput
            app.GpuLoadOutput = uitextarea(app.BruteForceToolUIFigure);
            app.GpuLoadOutput.Editable = 'off';
            app.GpuLoadOutput.HorizontalAlignment = 'center';
            app.GpuLoadOutput.FontSize = 14;
            app.GpuLoadOutput.FontColor = [1 1 1];
            app.GpuLoadOutput.BackgroundColor = [0.3137 0.3137 0.3137];
            app.GpuLoadOutput.Position = [789 297 92 28];

            % Create GPUTempCLabel
            app.GPUTempCLabel = uilabel(app.BruteForceToolUIFigure);
            app.GPUTempCLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.GPUTempCLabel.HorizontalAlignment = 'right';
            app.GPUTempCLabel.FontColor = [1 1 1];
            app.GPUTempCLabel.Position = [998 304 91 15];
            app.GPUTempCLabel.Text = 'GPU Temp. [°C]';

            % Create GpuTemperatureOutput
            app.GpuTemperatureOutput = uitextarea(app.BruteForceToolUIFigure);
            app.GpuTemperatureOutput.Editable = 'off';
            app.GpuTemperatureOutput.HorizontalAlignment = 'center';
            app.GpuTemperatureOutput.FontSize = 14;
            app.GpuTemperatureOutput.FontColor = [1 1 1];
            app.GpuTemperatureOutput.BackgroundColor = [0.3137 0.3137 0.3137];
            app.GpuTemperatureOutput.Position = [1127 297 92 28];

            % Create ClusterDropDownLabel
            app.ClusterDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.ClusterDropDownLabel.BackgroundColor = [0.3137 0.3137 0.3137];
            app.ClusterDropDownLabel.FontColor = [1 1 1];
            app.ClusterDropDownLabel.Position = [73 529 55 15];
            app.ClusterDropDownLabel.Text = 'Cluster';

            % Create ClusterDropDown
            app.ClusterDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.ClusterDropDown.Items = {'Select...'};
            app.ClusterDropDown.ValueChangedFcn = createCallbackFcn(app, @ClusterDropDownValueChanged, true);
            app.ClusterDropDown.FontColor = [1 1 1];
            app.ClusterDropDown.BackgroundColor = [0.3137 0.3137 0.3137];
            app.ClusterDropDown.Position = [332 525 164 22];
            app.ClusterDropDown.Value = 'Select...';

            % Create AbortButton
            app.AbortButton = uibutton(app.BruteForceToolUIFigure, 'push');
            app.AbortButton.ButtonPushedFcn = createCallbackFcn(app, @AbortButtonPushed, true);
            app.AbortButton.BackgroundColor = [1 0.302 0];
            app.AbortButton.FontName = 'Arial';
            app.AbortButton.FontSize = 20;
            app.AbortButton.FontWeight = 'bold';
            app.AbortButton.FontColor = [1 1 1];
            app.AbortButton.Position = [66 345 430 54];
            app.AbortButton.Text = 'ABORT';

            % Create GPUSwitchLabel
            app.GPUSwitchLabel = uilabel(app.BruteForceToolUIFigure);
            app.GPUSwitchLabel.FontColor = [1 1 1];
            app.GPUSwitchLabel.Position = [73 489 32 15];
            app.GPUSwitchLabel.Text = 'GPU';

            % Create GPUSwitch
            app.GPUSwitch = uiswitch(app.BruteForceToolUIFigure, 'slider');
            app.GPUSwitch.Items = {'Disabled', 'Enabled'};
            app.GPUSwitch.ValueChangedFcn = createCallbackFcn(app, @GPUSwitchValueChanged, true);
            app.GPUSwitch.FontColor = [1 1 1];
            app.GPUSwitch.Position = [391 484 54 24];
            app.GPUSwitch.Value = 'Disabled';
            
            % Create CreateahashButton
            app.CreateahashButton = uibutton(app.BruteForceToolUIFigure, 'push');
            app.CreateahashButton.ButtonPushedFcn = createCallbackFcn(app, @CreateahashButtonPushed, true);
            app.CreateahashButton.BackgroundColor = [0.5765 0.4392 0.8588];
            app.CreateahashButton.FontSize = 15;
            app.CreateahashButton.FontWeight = 'bold';
            app.CreateahashButton.FontColor = [1 0.902 0];
            app.CreateahashButton.Position = [1088 34 145 28];
            app.CreateahashButton.Text = 'CREATE A HASH';
        end
        
        % Button pushed function: CreateahashButton
        function CreateahashButtonPushed(app, event)
            % Create a dynamic string for warnbox
            warnStr = sprintf('Please keep the maximal character length of %s for password!', ...
                num2str(app.MaxPwLength));
            % Wait until user click the box away
            uiwait(msgbox({'You will be redirected to a website!';...
                warnStr}, 'Warning','warn'));
            % Open the website
            web('https://hashgenerator.de/'); 
            
        end
        
        % Value changed function: EncryptionDropDown
        function EncryptionDropDownValueChanged(app, event)
            value = app.EncryptionDropDown.Value;
            
            %Set items for Dropdown menu without select...
            app.EncryptionDropDown.Items = {'SHA-1', 'SHA-256', 'SHA-512', 'MD5'};
            
            switch value
                case 'SHA-1'
                    app.HashStruct.Method= 'SHA-1';
                case 'SHA-256'
                    app.HashStruct.Method= 'SHA-256';
                case 'SHA-512'
                    app.HashStruct.Method= 'SHA-512';
                case 'MD5'
                    app.HashStruct.Method= 'MD5';
            end
            
            app.HashLength= getHashLength(app);

            evalInputFieldWarningMsg(app);
            evalInputFieldWarningVisibility(app);
            evalStartBF(app);
        end
                
        %this function evaluates the used chars for the password or hash
        %and returns true if they are valid
        function [IsValid] = evalChars(app,Char)
            IsValid= isempty(regexp(Char,sprintf('[^%s]',app.AllowedChars), 'once'));
        end

        %evaluate the cpu and write it to the log monitor
        function evalCPU(app)
                            %Start system evaluation
                fWriteMessageBuffer(app, 'System evaluation started...');
                
                %Get CPU information
                fWriteMessageBuffer(app, 'Get CPU information: ');
                fWriteMessageBuffer(app, app.delemiter);
                
                app.cpuInfo = cpuinfo();
                
                cpuMessage = sprintf('Name: \t \t \t %s' , app.cpuInfo.Name);
                fWriteMessageBuffer(app, cpuMessage);
                
                cpuCores = num2str(app.cpuInfo.NumProcessors);
                cpuMessage = sprintf('Number of cores: \t %s', cpuCores);
                fWriteMessageBuffer(app, cpuMessage);
                
                cpuMessage = sprintf('Clock: \t \t \t %s', app.cpuInfo.Clock);
                fWriteMessageBuffer(app, cpuMessage);
                
                cpuMessage = sprintf('OS Type: \t \t %s (%s)', app.cpuInfo.OSType, app.cpuInfo.OSVersion);
                fWriteMessageBuffer(app, cpuMessage);
                fWriteMessageBuffer(app, 'Getting CPU information done...');
                fWriteMessageBuffer(app, app.delemiter);
        end

        %evaluate the cpu data
        function evalCPUData(app)
            fWriteMessageBuffer(app, 'Getting CPU data...');
            app.cpuData = getCpuData;
            app.CpuLoadOutput.Value = app.cpuData.avgCpuLoad;
            app.CpuTemperatureOutput.Value = app.cpuData.currCpuTemp;
            fWriteMessageBuffer(app, 'CPU data recieved');
            fWriteMessageBuffer(app, app.delemiter);
        end
        
        %evaluate the gpu and write it to the log monitor
        function evalGPU(app)
            app.gpuInfo = gpuDevice;
            
            fWriteMessageBuffer(app, 'Compatible GPU detected...');
            
            % Get GPU information
            fWriteMessageBuffer(app, 'Get GPUinformation: ');
            fWriteMessageBuffer(app, app.delemiter);
            
            gpuMessage = sprintf('Name: \t \t \t \t %s' , app.gpuInfo.Name);
            fWriteMessageBuffer(app, gpuMessage);
            
            gpuMessage = sprintf('Compute Capability: \t %s', app.gpuInfo.ComputeCapability);
            fWriteMessageBuffer(app, gpuMessage);
            
            gpuThreads = num2str(app.gpuInfo.MaxThreadsPerBlock);
            gpuMessage = sprintf('Max Threads per block: \t %s', gpuThreads);
            fWriteMessageBuffer(app, gpuMessage);
            
            gpuClock = num2str(app.gpuInfo.ClockRateKHz);
            gpuMessage = sprintf('Clock rate [kHz]: \t \t %s', gpuClock);
            fWriteMessageBuffer(app, gpuMessage);
            
            fWriteMessageBuffer(app, 'Getting GPU information done...');
            fWriteMessageBuffer(app, app.delemiter);
            
        end
        
        %evaluate the gpu data
        function evalGPUData(app)
            fWriteMessageBuffer(app, 'Getting GPU data...');
            app.gpuData = getGpuData;
            app.GpuLoadOutput.Value = app.gpuData.avgGpuLoad;
            app.GpuTemperatureOutput.Value = app.gpuData.currGpuTemp;
            fWriteMessageBuffer(app, 'GPU data recieved');
            fWriteMessageBuffer(app, app.delemiter);
            app.gpuEvaluationDone = true;
        end
        
        %evaluate which warning message should be showed. This is a dynamic
        %problem because the length of each hash method is different.
        function evalInputFieldWarningMsg(app)
            if strcmp(app.ModeDropDown.Value,app.ModeDropDown.Items{1})
                app.WarningBox.Value = {sprintf([...
                    'Password length is limited to %d and chars ''0-9'', ',...
                    '''A-Z'', ''a-z'' are allowed.'],app.MaxPwLength)};
            elseif ~strcmp(app.ModeDropDown.Value,app.ModeDropDown.Items{1})
                app.WarningBox.Value = {sprintf([...
                    'Hash length has to be %d and chars ''0-9'', ''A-Z'',',...
                    '''a-z'' are allowed.'],app.HashLength)};
            end
        end
        
        %this function evaluates if the warning of the input field should
        %be visible or not. It depends on different options like the mode,
        %the length of the input and used chars.
        function evalInputFieldWarningVisibility(app,varargin)
            
            %check if varargin is used
            if isempty(varargin)
                valLength = length(app.InputEditField.Value);
                value= app.InputEditField.Value;
            else
                valLength= varargin{1};
                value= varargin{2};
            end
            
            %set the backgroundcolor.
            Color1= [1 0.302 0];
            Color2= [0.3137 0.3137 0.3137];
            
            %check which mode is used
            if strcmp(app.ModeDropDown.Value,'Password')%PWmode
                if valLength > app.MaxPwLength || ~evalChars(app,value)
                    app.WarningBox.Visible = 'on';
                    app.InputEditField.BackgroundColor= Color1;
                else
                    app.WarningBox.Visible = 'off';
                    app.InputEditField.BackgroundColor= Color2;
                end
            elseif strcmp(app.ModeDropDown.Value,'Hash') %hashmode
                if ~(app.HashLength == valLength) || ~evalChars(app,value)
                    app.WarningBox.Visible = 'on';
                    app.InputEditField.BackgroundColor= Color1;
                else
                    app.WarningBox.Visible = 'off';
                    app.InputEditField.BackgroundColor= Color2;
                end
            end
        end
        
        %evaluate the parallel computing toolbox
        function evalPCT(app,varargin)
            
            %check if varargin is used
            if isempty(varargin)
                Input = '';
            else
                Input= varargin{1};
            end
            
            if ~strcmp(Input,'part')
                fWriteMessageBuffer(app, 'Starting up parallel processing...');
                fWriteMessageBuffer(app, 'Getting Clusters:');
                fWriteMessageBuffer(app, ' ');
                
                %get available clusters and plot it to the buffer
                Clusters = parallel.clusterProfiles;
                for Increment=1:length(Clusters)
                    fWriteMessageBuffer(app, ['- "',Clusters{Increment},'"']);
                end
                
            end
            
            %close the current pool if there is one running
            p = gcp('nocreate'); % If no pool, do not create new one.
            if ~isempty(p)
                fWriteMessageBuffer(app, ' ');
                fWriteMessageBuffer(app, 'The running pool has to be closed!');
                delete(gcp('nocreate'));
                fWriteMessageBuffer(app, 'The pool is closed.');
            end
            
            if ~strcmp(Input,'part')
                app.ClusterDropDown.Items= Clusters;
                fWriteMessageBuffer(app, ' ');
                fWriteMessageBuffer(app, 'Parallel processing ready.');
                fWriteMessageBuffer(app, app.delemiter);
                
                clusterValidity(app,Clusters{1});
            end
        end
                
        % Button pushed function: EvaluateButton
        function EvaluateButtonPushed(app, event)
            
            %set the components to the visibility before evaluating (to
            %clear graphics and other components)
            compBeforeEval(app,'full');
            %set the components to the visibility while evaluating
            compWhileEvaluate(app);
            
            %set the property to true if a gpu is available
            if gpuDeviceCount > 0
                app.GpuAvailable= true;
            else
                app.StatusOutput.Value = 'Existing GPU is not compatible!';
            end
            
            
            if ~app.evaluateDone
                try
                    %evaluate the cpu
                    evalCPU(app);
                    
                    if app.GpuAvailable
                        
                        %evaluate the gpu
                        evalGPU(app);
                    else
                        fWriteMessageBuffer(app, 'Compatible GPU = 0');
                        fWriteMessageBuffer(app, app.delemiter);
                    end
                    
                    %Evaluate up parallel processing
                    evalPCT(app)
                    
                    if ispc
                        evalCPUData(app);
                        
                        %get the
                        if app.GpuAvailable && strcmp(app.GPUSwitch.Value,'Enabled')
                            evalGPUData(app);
                            app.gpuEvaluationDone= true;
                        end
                    end
                    
                    %the evaluation is done
                    evalStartBF(app);
                    compAfterEval(app);
                    app.evaluateDone = true;
                    
                catch ME
                    Msg= ME.message;
                    fWriteMessageBuffer(app, 'An error occured with the following message:');
                    fWriteMessageBuffer(app, Msg);
                    fWriteMessageBuffer(app, app.delemiter);
                    app.evaluateDone= false;
                    app.EvaluateButton.Enable= 'on';
                end
            end
        end

        %evaluate if the 'Start BruteForce' Button can be enabled.
        function evalStartBF(app,varargin)
            %check if varargin is used
            if isempty(varargin)
                Input = app.InputEditField.Value;
            else
                Input= varargin{1};
            end
            

            if strcmp(app.ModeDropDown.Value,app.ModeDropDown.Items{1})
                %check if the input is between 0 and the maximum of the password
                %length
                if (0 < length(Input)) &&  (length(Input) < app.MaxPwLength+1)
                    InputValidity= true;
                else
                    InputValidity= false;
                end
            else %mode is hash
                if length(Input) == app.HashLength
                    InputValidity= true;
                else
                    InputValidity= false;
                end
            end
            
            %check if the chars in the inputbox are valid
            if evalChars(app,Input)
                CharValidity = true;
            else
                CharValidity= false;
            end
            
            if strcmp(app.GPUSwitch.Value,'Enabled')
                EvalDone= app.gpuEvaluationDone;
            else
                EvalDone= app.evaluateDone;
            end
            
            %check if an encryption algorithm is set
            EncryptValidity= ~strcmp(app.EncryptionDropDown.Value,'Select...');
            
            %check if the mode to decrypt is set
            ModeValidity= ~strcmp(app.ModeDropDown.Value,'Select...');
            
            %if all checks are true, the StartButton can be enabled.
            if app.ClusterIsValid && EvalDone && InputValidity &&...
                    ModeValidity && CharValidity && EncryptValidity
                app.StartButton.Enable = 'on';
            else
                app.StartButton.Enable = 'off';
            end
        end

        % Menu selected function: ExitMenu
        function ExitMenuSelected(app, event)
            if ~app.LogSaved && ~isempty(app.messageBuffer{end})
                Msg= 'Do you really want to exit without saving?';
            else
                Msg= 'Do you really want to exit?';
            end
            exitBox = questdlg(Msg,'Warning');
            switch exitBox
                case 'Yes'
                    app.CloseRequest();
                case 'No'
                    %do nothing
            end
        end
        
        %get the length of the hash which is set by the encryption dropdown.
        %This is done by encrypt the password '1234' with the given
        %options.
        function [Length] = getHashLength(app)
            
            if ~strcmp(app.EncryptionDropDown.Value,'Select...')
                Length= length(DataHash('1234',app.HashStruct));
            else
                Length= 40;
            end
            
        end

        % Value changed function: GPUSwitch
        function GPUSwitchValueChanged(app, event)
            value = app.GPUSwitch.Value;

            switch value
                case 'Enabled'
                    app.GpuEnabled = true;
                    
                    fWriteMessageBuffer(app, app.delemiter2);
                    fWriteMessageBuffer(app, 'New system evaluation required!');
                    fWriteMessageBuffer(app, app.delemiter2);

                    compBeforeEval(app,'part');
                    
                case 'Disabled'
                    app.GpuEnabled = false;
                    setAxisProps(app);                   
                    if app.evaluateDone
                        compAfterEval(app);
                    else
                        compBeforeEval(app,'part');
                    end
            end
            
            evalStartBF(app);
            
        end
                
        % Value changing function: InputEditField
        function InputEditFieldValueChanging(app, event)
            value = event.Value;
            strVal = convertCharsToStrings(value);
            valLength = strlength(strVal);

            evalStartBF(app,value);
            evalInputFieldWarningMsg(app);
            evalInputFieldWarningVisibility(app,valLength,value);

        end

        % Value changed function: ModeDropDown
        function ModeDropDownValueChanged(app, event)
            %Set items for Dropdown menu without select...
            app.ModeDropDown.Items = {'Password', 'Hash'};
            evalStartBF(app);
            evalInputFieldWarningMsg(app);
            evalInputFieldWarningVisibility(app);
        end

        % Menu selected function: NewrunMenu
        function NewrunMenuSelected(app, event)
            if app.LogSaved
                Msg= 'Do you really want to create a new run?';
            else
                Msg= 'Do you want to save Log data before creating a new run?';
            end
            NewRunBox = questdlg(Msg,'Warning');
            
            switch NewRunBox
                case 'Yes'
                    saveFile(app);
                    app.evaluateDone = false;
                    compBeforeEval(app,'full')
                case 'No'
                    app.evaluateDone = false;
                    compBeforeEval(app,'full')
            end
            
        end
        
        %Set the visibility and behaviour of the axes
        function setAxisProps(app)
            if app.GpuEnabled
                app.UIAxes_cpu.Position = [600 631 639 228];
                app.UIAxes_gpu.Position = [600 406 642 215];
                app.UIAxes_gpu.Visible = 'on';
                app.GpuTemperatureOutput.Visible = 'on';
                app.GPUTempCLabel.Visible = 'on';
                app.GpuLoadOutput.Visible = 'on';
                app.GPULoadLabel.Visible = 'on';
            else
                app.GpuTemperatureOutput.Visible = 'off';
                app.GPUTempCLabel.Visible = 'off';
                app.GpuLoadOutput.Visible = 'off';
                app.GPULoadLabel.Visible = 'off';
                app.UIAxes_gpu.Position = [1231 370 10 10];
                app.UIAxes_cpu.Position = [600 411 639 448];
                app.UIAxes_gpu.Visible = 'off';
                app.UIAxes_gpu.Position = [1231 370 10 10];
                app.UIAxes_cpu.Position = [600 411 639 448];
            end
        end
        
        % Code that executes after component creation
        function startupFcn(app)
            
            %Create directory for Log-files
            dirStatus = exist('Log-files');
            if dirStatus == 0
                mkdir('Log-files');
            end
            %call init function
            app = initApp(app);
            
            %set the object plot as children to the axis
            area(0,0,'Parent',app.UIAxes_cpu,'LineWidth', 0.75,...
                'FaceColor', 'red',...
                'FaceAlpha', 0.4,...
                'AlignVertexCenters', 'on');
            area(0,0,'Parent',app.UIAxes_gpu,'LineWidth', 0.75,...
                'FaceColor', 'red',...
                'FaceAlpha', 0.4,...
                'AlignVertexCenters', 'on');
            
            compBeforeEval(app,'full')
            
            app.InputEditField.FontAngle = 'italic';   
        end

        % Menu selected function: SaveMenu
        function SaveMenuSelected(app, event)
            if ~app.LogSaved
                saveFile(app);
                app.LogSaved= true;
                msgbox('File saved!');
            else
                msgbox('The file has already been saved.');
            end
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            app.ResultOutput.Value = '';
            app.StatusOutput.Value = 'Your current progress in BruteForcing is: 0%';
            
            %change the visibility of components while brute forcing
            compWhileBruteForce(app)            
            
            %check the parallel computing toolbox again partly because
            %meanwhile a pool could be opened.
            evalPCT(app,'part')
            
            
            %initialize the brute force
            initBruteForce(app);
            
            %execute the function to do the brute force
            doBruteForce(app);
            
            %change the visibility of the components
            compAfterEval(app);
            
            %evaluate if the start button can be active
            evalStartBF(app);
        end

    end %end of class private methods
%==========================================================================



%==========================================================================
%===========================class public methods===========================
%==========================================================================
    methods (Access = public)

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.BruteForceToolUIFigure)
        end

        %Message Buffer
        function fWriteMessageBuffer(app,message)
            app.messageBuffer{end + 1} = message;
            app.LogMonitorOutput.Value = app.messageBuffer;
            app.LogSaved= false;
        end
        
        function fWriteStatus(app,message)
            app.StatusOutput.Value= message;
        end
        
        % Construct app
        function [app] = userInterface_script
            
            %Check if there is allready an UI opened of the class userInterface
            if ~isempty(findall(0, 'HandleVisibility', 'off','Name','Brute-Force Tool'))
                msg = 'You can''t create more than one instance of the class userInterface!';
                uiwait(msgbox(msg,'Constructor Error','error'));
                msgID = '';
                ConstructorException = MException(msgID,msg);
                throw(ConstructorException);
            end

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.BruteForceToolUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end
        
    end %end of class public methods
%==========================================================================


end %end of class