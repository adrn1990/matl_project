classdef userInterface_script < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        BruteForceToolUIFigure     matlab.ui.Figure
        FileMenu                   matlab.ui.container.Menu
        NewrunMenu                 matlab.ui.container.Menu
        SaveMenu                   matlab.ui.container.Menu
        ExportMenu                 matlab.ui.container.Menu
        ExitMenu                   matlab.ui.container.Menu
        InfoMenu                   matlab.ui.container.Menu
        AboutMenu                  matlab.ui.container.Menu
        BruteforceToolLabel        matlab.ui.control.Label
        InputPasswordHashLabel     matlab.ui.control.Label
        InputEditField             matlab.ui.control.EditField
        StartButton                matlab.ui.control.Button
        LogMonitorTextAreaLabel    matlab.ui.control.Label
        LogMonitorOutput           matlab.ui.control.TextArea
        ModeTodecryptLabel         matlab.ui.control.Label
        ModeDropDown               matlab.ui.control.DropDown
        EncryptionAlgorithmDropDownLabel  matlab.ui.control.Label
        EncryptionDropDown         matlab.ui.control.DropDown
        RainbowtableDropDownLabel  matlab.ui.control.Label
        RainbowtableDropDown       matlab.ui.control.DropDown
        RessourceDropDownLabel     matlab.ui.control.Label
        RessourceDropDown          matlab.ui.control.DropDown
        CPUGPUTempCTextAreaLabel   matlab.ui.control.Label
        TemperatureOutput          matlab.ui.control.TextArea
        CPUGPULoadLabel            matlab.ui.control.Label
        LoadOutput                 matlab.ui.control.TextArea
        ResultTextAreaLabel        matlab.ui.control.Label
        ResultOutput               matlab.ui.control.TextArea
        CoresDropDownLabel         matlab.ui.control.Label
        CoresDropDown              matlab.ui.control.DropDown
        AdvancedsettingsLabel      matlab.ui.control.Label
        EvaluateButton             matlab.ui.control.Button
        TabGroup                   matlab.ui.container.TabGroup
        CPUTab                     matlab.ui.container.Tab
        UIAxes_cpu                 matlab.ui.control.UIAxes
        GPUTab                     matlab.ui.container.Tab
        UIAxes_gpu                 matlab.ui.control.UIAxes
        StatusTextAreaLabel        matlab.ui.control.Label
        StatusOutput               matlab.ui.control.TextArea
        WarningBox                 matlab.ui.control.TextArea
    end

    properties (Access = public)
        Property % Description
        delemiter = '---------------------------------------------------------------------------------------------------------------';
        messageBuffer = {''};
        evaluateDone = false;
        cpuInfo;
        cpuData;
        gpuInfo;
        gpuData;
        PrevTime = 0;
        
        %This property safes the allready found passwords and hashes.
        Improvements;
        
        %This property safes the name of the file with the allready found passwords and hashes
        FileName;
        
        %This property safes all folders of the path
        Folders;
        
        %This property safes the char slash/backslash
        Slash;
        
        %The maximum of the password length is set to 8
        MaxPwLength= 8;
        
        %This property safes the number of chars for the password
        %0-9, A-Z, a-z
        NbrOfChars= 62;
        
        %This property is to calculate the progress
        AmountOfCalls;
        
        %This property saves the amount of iterations the parfor loop has
        %to do
        Iterations;
        
        %This property safes the Hash of the given data
        Hash;
        
        %The following property saves the allowed chars for the password
        %To generate the following cell-array as specified us the commented part in
        %the command window.
        %Arr= {char(48:57),char(65:90),char(97:122)} %0-9, A-Z, a-z 48-57, 65-90, 97-122
        %horzcat(Arr{:})
        AllowedChars= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        
        %This struct safes the properties for the function DataHash
        HashStruct= struct('Method','','Format','HEX','Input','ascii');
    end
    
    methods (Access = public)
        %Message Buffer
        function fWriteMessageBuffer(app,message)
            app.messageBuffer{end + 1} = message;
            app.LogMonitorOutput.Value = app.messageBuffer;
        end
        
    end
    
    methods (Access = public)
        
        function fWriteStatus(app,message)
            app.StatusOutput.Value= message;
        end
        
    end
    
    methods (Access = private)
        %this function evaluates the used chars for the password or hash
        %and returns true if they are valid
        function IsValid = evalChars(app,Char)
            IsValid= isempty(regexp(Char,sprintf('[^%s]',app.AllowedChars), 'once'));
        end
        
        function results = evalStartBF(app)
            if app.evaluateDone
            end
        end
        
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
            %call init function
            app = initApp(app);
            
            app.InputEditField.FontAngle = 'italic';
            app.StartButton.Enable = 'off';
            app.NewrunMenu.Enable = 'off';
            app.RessourceDropDown.Enable = 'off';
            app.CoresDropDown.Enable = 'off';
            app.WarningBox.Visible = 'off';
        end

        % Button pushed function: EvaluateButton
        function EvaluateButtonPushed(app, event)
            
            if ~app.evaluateDone
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
                
                try
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
                    
                catch
                    app.StatusOutput.Value = 'Existing GPU is not compatible!';
                    fWriteMessageBuffer(app, 'Compatible GPU = 0');
                    fWriteMessageBuffer(app, app.delemiter);
                end
                
                %Get CPU data
                %FIXME: Write cpu data struct if RessourceDropDown = cpu
                if ispc
                    fWriteMessageBuffer(app, 'Getting CPU data...');
                    app.cpuData = getCpuData;
                    fWriteMessageBuffer(app, 'CPU data recieved');
                    fWriteMessageBuffer(app, app.delemiter);
                    
                    if gpuDeviceCount > 0
                        fWriteMessageBuffer(app, 'Getting GPU data...');
                        app.gpuData = getGpuData;
                        fWriteMessageBuffer(app, 'GPU data recieved');
                        fWriteMessageBuffer(app, app.delemiter);
                    end
                end
                
                %Set maximum cores (for better graph visuality)
                if app.cpuInfo.NumProcessors > 4
                    app.cpuInfo.NumProcessors = 4;
                end
                %Set value for "CPU cores" DropDown
                switch app.cpuInfo.NumProcessors
                    case 1
                        app.CoresDropDown.Items = {'1'};
                    case 2
                        app.CoresDropDown.Items = {'1', '2'};
                    case 3
                        app.CoresDropDown.Items = {'1', '2', '3'};
                    case 4
                        app.CoresDropDown.Items = {'1', '2', '3', '4'};
                end
                app.evaluateDone = true;
                app.NewrunMenu.Enable = 'on';
                app.RessourceDropDown.Enable = 'on';
                app.CoresDropDown.Enable = 'on';
                app.EvaluateButton.Enable = 'off';
                app.StartButton.Enable = 'on'; %FIXME: warning, this is only for testing
                
                %Setting up parallel processing
                try
                    fWriteMessageBuffer(app, 'Starting up parallel processing...');
                    %TODO: choose a cluster from dropdown.
                    pool =parpool('local');
                    
                    if pool.Connected == true
                        fWriteMessageBuffer(app, 'Parallel processing ready');
                        parWorkers = num2str(pool.NumWorkers);
                        strParWorkers = sprintf('NumWorkers: \t \t \t \t %s' , parWorkers);
                        fWriteMessageBuffer(app, strParWorkers);
                        
                        clusterProfile = sprintf('Cluster profile: \t \t \t %s' , pool.Cluster.Profile);
                        fWriteMessageBuffer(app, clusterProfile);
                        fWriteMessageBuffer(app, app.delemiter);
                    else %TODO exception handling
                        fWriteMessageBuffer(app, 'Something went wroooooong!');
                        fWriteMessageBuffer(app, app.delemiter);
                    end
                catch
                    fWriteMessageBuffer(app, 'No Parallel Toolbox found or an active session is running!');
                    
                end
                
                
                
                
            end
        end

        % Menu selected function: ExitMenu
        function ExitMenuSelected(app, event)
            exitBox = questdlg('Do you really want to exit?','Warning');
            %TODO: File saving should be implemented here as well
            switch exitBox
                case 'Yes'
                    app.delete;
                case 'No'
                    
            end
        end

        % Menu selected function: AboutMenu
        function AboutMenuSelected(app, event)
            msgbox({'Name: Brute-Force Tool' 'Version: 0.0.0' 'Designer: A.Gonzalez / B. Huerzeler'}, 'About...');
        end

        % Menu selected function: SaveMenu
        function SaveMenuSelected(app, event)
            
        end

        % Value changed function: RessourceDropDown
        function RessourceDropDownValueChanged(app, event)
            value = app.RessourceDropDown.Value;
            
            %Set items for Dropdown menu without select...
            app.RessourceDropDown.Items = {'CPU', 'GPU'};
            
            %Set items dynamically
            if value == 'CPU'
                switch app.cpuInfo.NumProcessors
                    case 1
                        app.CoresDropDown.Items = {'1'};
                    case 2
                        app.CoresDropDown.Items = {'1', '2'};
                    case 3
                        app.CoresDropDown.Items = {'1', '2', '3'};
                    case 4
                        app.CoresDropDown.Items = {'1', '2', '3', '4'};
                end
                app.CoresDropDown.Enable = 'on';
                app.UIAxes_gpu.Visible = 'off';
                app.UIAxes_cpu.Visible = 'on';
                app.TemperatureOutput.Value = app.cpuData.currCpuTemp;
                app.LoadOutput.Value = app.cpuData.avgCpuLoad;
                
                %FIXME: Test for data visualisation-------------------------
                
                %displayData(app);
                
                
                
            else
                app.CoresDropDown.Items = {'1'};
                app.CoresDropDown.Enable = 'off';
                app.UIAxes_gpu.Visible = 'on';
                app.UIAxes_cpu.Visible = 'off';
                app.TemperatureOutput.Value = app.gpuData.currGpuTemp;
                app.LoadOutput.Value = ''; %FIXME: Load value from gpu have to put in here!
            end
        end

        % Value changing function: InputEditField
        function InputEditFieldValueChanging(app, event)
            value = event.Value;
            strVal = convertCharsToStrings(value);
            valLenth = strlength(strVal);
            if valLenth > app.MaxPwLength || ~evalChars(app,value)
                app.WarningBox.Visible = 'on';
                app.InputEditField.BackgroundColor= 'red';
            else
                app.WarningBox.Visible = 'off';
                app.InputEditField.BackgroundColor= 'white';
            end
        end

        % Menu selected function: NewrunMenu
        function NewrunMenuSelected(app, event)
            exitBox = questdlg('Do you want to save all data?','Warning');
            
            switch exitBox
                case 'Yes'
                    filename = 'test.csv';
                    cell2csv(filename,app.messageBuffer);
                    app.EvaluateButton.Enable = 'on';
                    app.evaluateDone = false;
                    app.NewrunMenu.Enable = 'off';
                    app.messageBuffer = {''};
                    app.LogMonitorOutput.Value = '';
                case 'No'
                    app.EvaluateButton.Enable = 'on';
                    app.evaluateDone = false;
                    app.NewrunMenu.Enable = 'off';
                    app.messageBuffer = {''};
                    app.LogMonitorOutput.Value = '';
            end
        end

        % Value changed function: CoresDropDown
        function CoresDropDownValueChanged(app, event)
            value = app.CoresDropDown.Value;
            
        end

        % Value changed function: EncryptionDropDown
        function EncryptionDropDownValueChanged(app, event)
            value = app.EncryptionDropDown.Value;
            
            %Set items for Dropdown menu without select...
            app.EncryptionDropDown.Items = {'SHA-1', 'SHA-256', 'SHA-512', 'MD5', 'AES-256'};
            
            switch value
                case 'SHA-1'
                    app.HashStruct.Method= 'SHA-1';
                case 'SHA-256'
                    app.HashStruct.Method= 'SHA-256';
                case 'SHA-512'
                    app.HashStruct.Method= 'SHA-512';
                case 'MD5'
                    app.HashStruct.Method= 'MD5';
                case 'AES-256'
                    %TODO: this hashfunction has to be implemented.
            end
            
            
        end

        % Value changed function: RainbowtableDropDown
        function RainbowtableDropDownValueChanged(app, event)
            %Set items for Dropdown menu without select...
            app.RainbowtableDropDown.Items = {'Yes', 'No'};
            
        end

        % Value changed function: ModeDropDown
        function ModeDropDownValueChanged(app, event)
            %Set items for Dropdown menu without select...
            app.ModeDropDown.Items = {'Password', 'Hash'};
            app.ModeDropDown.Value;
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            app.ResultOutput.Value = '';
            app.StatusOutput.Value = 'Your current progress in BruteForcing is: 0%';
            initBruteForce(app);
        end

        % Close request function: BruteForceToolUIFigure
        function CloseRequest(app, event)
            
            %call function for delete procedure
            deleteApp(app);
            
            delete(app)
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create BruteForceToolUIFigure
            app.BruteForceToolUIFigure = uifigure;
            app.BruteForceToolUIFigure.Color = [0.9412 0.9412 0.9412];
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

            % Create ExportMenu
            app.ExportMenu = uimenu(app.FileMenu);
            app.ExportMenu.Text = 'Export to csv...';

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
            app.BruteforceToolLabel.FontSize = 20;
            app.BruteforceToolLabel.FontWeight = 'bold';
            app.BruteforceToolLabel.Position = [41 926 158 26];
            app.BruteforceToolLabel.Text = 'Brute force Tool';

            % Create InputPasswordHashLabel
            app.InputPasswordHashLabel = uilabel(app.BruteForceToolUIFigure);
            app.InputPasswordHashLabel.HorizontalAlignment = 'right';
            app.InputPasswordHashLabel.Position = [66 707 133 15];
            app.InputPasswordHashLabel.Text = 'Input [Password / Hash]';

            % Create InputEditField
            app.InputEditField = uieditfield(app.BruteForceToolUIFigure, 'text');
            app.InputEditField.ValueChangingFcn = createCallbackFcn(app, @InputEditFieldValueChanging, true);
            app.InputEditField.Position = [332 703 164 22];

            % Create StartButton
            app.StartButton = uibutton(app.BruteForceToolUIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.BackgroundColor = [0.302 0.749 0.9294];
            app.StartButton.FontName = 'Arial';
            app.StartButton.FontSize = 20;
            app.StartButton.FontWeight = 'bold';
            app.StartButton.Position = [65 353 431 54];
            app.StartButton.Text = 'START Brute force';

            % Create LogMonitorTextAreaLabel
            app.LogMonitorTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.LogMonitorTextAreaLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.LogMonitorTextAreaLabel.Position = [34 250 70 15];
            app.LogMonitorTextAreaLabel.Text = 'Log-Monitor';

            % Create LogMonitorOutput
            app.LogMonitorOutput = uitextarea(app.BruteForceToolUIFigure);
            app.LogMonitorOutput.Editable = 'off';
            app.LogMonitorOutput.BackgroundColor = [0.9412 0.9412 0.9412];
            app.LogMonitorOutput.Position = [31 21 570 224];

            % Create ModeTodecryptLabel
            app.ModeTodecryptLabel = uilabel(app.BruteForceToolUIFigure);
            app.ModeTodecryptLabel.HorizontalAlignment = 'right';
            app.ModeTodecryptLabel.Position = [66 747 101 15];
            app.ModeTodecryptLabel.Text = 'Mode [To decrypt]';

            % Create ModeDropDown
            app.ModeDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.ModeDropDown.Items = {'Select...', 'Password', 'Hash'};
            app.ModeDropDown.ValueChangedFcn = createCallbackFcn(app, @ModeDropDownValueChanged, true);
            app.ModeDropDown.Position = [332 743 164 22];
            app.ModeDropDown.Value = 'Select...';

            % Create EncryptionAlgorithmDropDownLabel
            app.EncryptionAlgorithmDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.EncryptionAlgorithmDropDownLabel.HorizontalAlignment = 'right';
            app.EncryptionAlgorithmDropDownLabel.Position = [66 578 123 15];
            app.EncryptionAlgorithmDropDownLabel.Text = 'Encryption [Algorithm]';

            % Create EncryptionDropDown
            app.EncryptionDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.EncryptionDropDown.Items = {'Select...', 'SHA-1', 'SHA-256', 'SHA-512', 'MD5', 'AES-256'};
            app.EncryptionDropDown.ValueChangedFcn = createCallbackFcn(app, @EncryptionDropDownValueChanged, true);
            app.EncryptionDropDown.Position = [332 574 164 22];
            app.EncryptionDropDown.Value = 'Select...';

            % Create RainbowtableDropDownLabel
            app.RainbowtableDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.RainbowtableDropDownLabel.HorizontalAlignment = 'right';
            app.RainbowtableDropDownLabel.Position = [66 525 78 15];
            app.RainbowtableDropDownLabel.Text = 'Rainbowtable';

            % Create RainbowtableDropDown
            app.RainbowtableDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.RainbowtableDropDown.Items = {'Select...', 'Yes', 'No'};
            app.RainbowtableDropDown.ValueChangedFcn = createCallbackFcn(app, @RainbowtableDropDownValueChanged, true);
            app.RainbowtableDropDown.Position = [332 521 164 22];
            app.RainbowtableDropDown.Value = 'Select...';

            % Create RessourceDropDownLabel
            app.RessourceDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.RessourceDropDownLabel.HorizontalAlignment = 'right';
            app.RessourceDropDownLabel.Position = [65 465 63 15];
            app.RessourceDropDownLabel.Text = 'Ressource';

            % Create RessourceDropDown
            app.RessourceDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.RessourceDropDown.Items = {'Select...', 'CPU', 'GPU'};
            app.RessourceDropDown.ValueChangedFcn = createCallbackFcn(app, @RessourceDropDownValueChanged, true);
            app.RessourceDropDown.Position = [221 461 76 22];
            app.RessourceDropDown.Value = 'Select...';

            % Create CPUGPUTempCTextAreaLabel
            app.CPUGPUTempCTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.CPUGPUTempCTextAreaLabel.HorizontalAlignment = 'right';
            app.CPUGPUTempCTextAreaLabel.Position = [963 345 126 15];
            app.CPUGPUTempCTextAreaLabel.Text = 'CPU / GPU Temp. [�C]';

            % Create TemperatureOutput
            app.TemperatureOutput = uitextarea(app.BruteForceToolUIFigure);
            app.TemperatureOutput.Editable = 'off';
            app.TemperatureOutput.HorizontalAlignment = 'center';
            app.TemperatureOutput.FontSize = 14;
            app.TemperatureOutput.Position = [1127 338 92 28];

            % Create CPUGPULoadLabel
            app.CPUGPULoadLabel = uilabel(app.BruteForceToolUIFigure);
            app.CPUGPULoadLabel.HorizontalAlignment = 'right';
            app.CPUGPULoadLabel.Position = [567 345 118 15];
            app.CPUGPULoadLabel.Text = 'CPU / GPU Load [%]';

            % Create LoadOutput
            app.LoadOutput = uitextarea(app.BruteForceToolUIFigure);
            app.LoadOutput.Editable = 'off';
            app.LoadOutput.HorizontalAlignment = 'center';
            app.LoadOutput.FontSize = 14;
            app.LoadOutput.Position = [731 338 92 28];

            % Create ResultTextAreaLabel
            app.ResultTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.ResultTextAreaLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ResultTextAreaLabel.HorizontalAlignment = 'right';
            app.ResultTextAreaLabel.Position = [645 250 40 15];
            app.ResultTextAreaLabel.Text = 'Result';

            % Create ResultOutput
            app.ResultOutput = uitextarea(app.BruteForceToolUIFigure);
            app.ResultOutput.Editable = 'off';
            app.ResultOutput.HorizontalAlignment = 'center';
            app.ResultOutput.FontSize = 48;
            app.ResultOutput.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ResultOutput.Position = [650 185 583 60];

            % Create CoresDropDownLabel
            app.CoresDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.CoresDropDownLabel.HorizontalAlignment = 'right';
            app.CoresDropDownLabel.Position = [332 465 38 15];
            app.CoresDropDownLabel.Text = 'Cores';

            % Create CoresDropDown
            app.CoresDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.CoresDropDown.Items = {};
            app.CoresDropDown.ValueChangedFcn = createCallbackFcn(app, @CoresDropDownValueChanged, true);
            app.CoresDropDown.Position = [412 461 84 22];
            app.CoresDropDown.Value = {};

            % Create AdvancedsettingsLabel
            app.AdvancedsettingsLabel = uilabel(app.BruteForceToolUIFigure);
            app.AdvancedsettingsLabel.VerticalAlignment = 'center';
            app.AdvancedsettingsLabel.FontSize = 16;
            app.AdvancedsettingsLabel.FontAngle = 'italic';
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

            % Create TabGroup
            app.TabGroup = uitabgroup(app.BruteForceToolUIFigure);
            app.TabGroup.Position = [567 431 700 430];

            % Create CPUTab
            app.CPUTab = uitab(app.TabGroup);
            app.CPUTab.Title = 'CPU';
            app.CPUTab.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create UIAxes_cpu
            app.UIAxes_cpu = uiaxes(app.CPUTab);
            title(app.UIAxes_cpu, 'CPU Average Load')
            ylabel(app.UIAxes_cpu, '%')
            app.UIAxes_cpu.XLim = [0 60];
            app.UIAxes_cpu.YLim = [0 100];
            app.UIAxes_cpu.XDir = 'reverse';
            app.UIAxes_cpu.Box = 'on';
            app.UIAxes_cpu.XTick = [0 20 40 60];
            app.UIAxes_cpu.YTick = [0 25 50 75 100];
            app.UIAxes_cpu.XGrid = 'on';
            app.UIAxes_cpu.YGrid = 'on';
            app.UIAxes_cpu.Position = [27 30 639 346];

            % Create GPUTab
            app.GPUTab = uitab(app.TabGroup);
            app.GPUTab.Title = 'GPU';
            app.GPUTab.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create UIAxes_gpu
            app.UIAxes_gpu = uiaxes(app.GPUTab);
            title(app.UIAxes_gpu, 'GPU Average Load')
            ylabel(app.UIAxes_gpu, '%')
            app.UIAxes_gpu.XLim = [0 60];
            app.UIAxes_gpu.YLim = [0 100];
            app.UIAxes_gpu.XDir = 'reverse';
            app.UIAxes_gpu.Box = 'on';
            app.UIAxes_gpu.XTick = [0 20 40 60];
            app.UIAxes_gpu.YTick = [0 25 50 75 100];
            app.UIAxes_gpu.XGrid = 'on';
            app.UIAxes_gpu.YGrid = 'on';
            app.UIAxes_gpu.Position = [24 30 642 341];

            % Create StatusTextAreaLabel
            app.StatusTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.StatusTextAreaLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.StatusTextAreaLabel.Position = [34 310 40 15];
            app.StatusTextAreaLabel.Text = 'Status';

            % Create StatusOutput
            app.StatusOutput = uitextarea(app.BruteForceToolUIFigure);
            app.StatusOutput.Editable = 'off';
            app.StatusOutput.BackgroundColor = [0.9412 0.9412 0.9412];
            app.StatusOutput.Position = [31 276 570 29];

            % Create WarningBox
            app.WarningBox = uitextarea(app.BruteForceToolUIFigure);
            app.WarningBox.Editable = 'off';
            app.WarningBox.FontSize = 9;
            app.WarningBox.FontColor = [1 0 0];
            app.WarningBox.BackgroundColor = [0.9412 0.9412 0.9412];
            app.WarningBox.Position = [332 669 164 35];
            app.WarningBox.Value = {'Password length  is limited to 8 and chars ''0-9'', ''A-Z'', ''a-z'' are allowed'};
        end
    end

    methods (Access = public)

        % Construct app
        function app = userInterface_script

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

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.BruteForceToolUIFigure)
        end
    end
end