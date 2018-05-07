classdef userInterface_script < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        BruteForceToolUIFigure        matlab.ui.Figure
        FileMenu                      matlab.ui.container.Menu
        NewrunMenu                    matlab.ui.container.Menu
        SaveMenu                      matlab.ui.container.Menu
        ExporttocsvMenu               matlab.ui.container.Menu
        ExitMenu                      matlab.ui.container.Menu
        Menu_4                        matlab.ui.container.Menu
        AboutMenu                     matlab.ui.container.Menu
        BruteforceToolLabel           matlab.ui.control.Label
        PasswordHashEditFieldLabel    matlab.ui.control.Label
        PasswordHashEditField         matlab.ui.control.EditField
        STARTBruteforceButton         matlab.ui.control.Button
        LogMonitorTextAreaLabel       matlab.ui.control.Label
        LogMonitorTextArea            matlab.ui.control.TextArea
        TodecryptDropDownLabel        matlab.ui.control.Label
        TodecryptDropDown             matlab.ui.control.DropDown
        EncryptionDropDownLabel       matlab.ui.control.Label
        EncryptionDropDown            matlab.ui.control.DropDown
        RainbowtableDropDownLabel     matlab.ui.control.Label
        RainbowtableDropDown          matlab.ui.control.DropDown
        ChooseRessourceDropDownLabel  matlab.ui.control.Label
        ChooseRessourceDropDown       matlab.ui.control.DropDown
        CPUGPUTempCTextAreaLabel      matlab.ui.control.Label
        CPUGPUTempCTextArea           matlab.ui.control.TextArea
        FanspeedrpmTextAreaLabel      matlab.ui.control.Label
        FanspeedrpmTextArea           matlab.ui.control.TextArea
        ResultTextAreaLabel           matlab.ui.control.Label
        ResultTextArea                matlab.ui.control.TextArea
        CPUCoresDropDownLabel         matlab.ui.control.Label
        CPUCoresDropDown              matlab.ui.control.DropDown
        AdvancedsettingsLabel         matlab.ui.control.Label
        EvaluateSystemButton          matlab.ui.control.Button
        TabGroup                      matlab.ui.container.TabGroup
        CPUTab                        matlab.ui.container.Tab
        UIAxes_cpu1                   matlab.ui.control.UIAxes
        UIAxes_cpu2                   matlab.ui.control.UIAxes
        UIAxes_cpu3                   matlab.ui.control.UIAxes
        UIAxes_cpu4                   matlab.ui.control.UIAxes
        GPUTab                        matlab.ui.container.Tab
        UIAxes_gpu                    matlab.ui.control.UIAxes
        StatusTextAreaLabel           matlab.ui.control.Label
        StatusTextArea                matlab.ui.control.TextArea
        PasswordCheck                 matlab.ui.control.TextArea
    end
    
    properties (Access = private)
        Property % Description
        messageBuffer = {''};
        PwLength= 8; %Maximum length of Pw
        NbrOfChars= 64; %Number of possible chars for password '0-9', 'A-Z', 'a-z'
        evaluateDone = false;
        cpuInfo;
        gpuInfo;
    end
    
    %Getters
    methods
        function [NbrOfChars]  = get.NbrOfChars(App)
            NbrOfChars = App.NbrOfChars;
        end
        
        function [PwLength]  = get.PwLength(App)
            PwLength = App.PwLength;
        end
    end
    
    methods (Access = private)
        %Message Buffer
        function fWriteMessageBuffer(app,message)
            app.messageBuffer{end + 1} = message;
            app.LogMonitorTextArea.Value = app.messageBuffer;
        end
        
        
        function results = getCpuTemp(app)
            command = 'wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature get CurrentTemperature';
            [status, cpuTemp] = system(command);
        end
        
        function results = getCpuLoad(app)
            command = 'wmic cpu get loadpercentage /format:value';
            [status,loadPercentage] = system(command);
        end
        
    end
    
    methods (Access = private)
        
        % Code that executes after component creation
        function startupFcn(app)
            app.PasswordHashEditField.FontAngle = 'italic';
            app.STARTBruteforceButton.Enable = 'off';
            %            app.NewrunMenu.Enable = 'off';
            app.ChooseRessourceDropDown.Enable = 'off';
            app.CPUCoresDropDown.Enable = 'off';
            app.PasswordCheck.Visible = 'off';
        end
        
        % Button pushed function: EvaluateSystemButton
        function EvaluateSystemButtonPushed(app, event)
            
            if ~app.evaluateDone
                %Start system evaluation
                fWriteMessageBuffer(app, 'System evaluation started...');
                
                %Get CPU information
                fWriteMessageBuffer(app, 'Get CPU information: ');
                fWriteMessageBuffer(app, '---------------------------------------');
                
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
                fWriteMessageBuffer(app, '---------------------------------------');
                
                try
                    
                    if gpuDeviceCount > 0
                        fWriteMessageBuffer(app, 'Compatible GPU detected...');
                        
                        % Get GPU information
                        fWriteMessageBuffer(app, 'Get GPUinformation: ');
                        fWriteMessageBuffer(app, '---------------------------------------');
                        
                        app.gpuInfo = gpuDevice;
                        
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
                        fWriteMessageBuffer(app, '---------------------------------------');
                    end
                catch
                    app.StatusTextArea.Value = 'Existing GPU is not compatible!';
                end
                
                
                %Set value for "CPU cores" DropDown
                switch app.cpuInfo.NumProcessors
                    case 1
                        app.CPUCoresDropDown.Items = {'1'};
                    case 2
                        app.CPUCoresDropDown.Items = {'1', '2'};
                    case 3
                        app.CPUCoresDropDown.Items = {'1', '2', '3'};
                    case 4
                        app.CPUCoresDropDown.Items = {'1', '2', '3', '4'};
                end
                app.evaluateDone = true;
                app.NewrunMenu.Enable = 'on';
                app.ChooseRessourceDropDown.Enable = 'on';
                app.CPUCoresDropDown.Enable = 'on';
                app.EvaluateSystemButton.Enable = 'off';
            end
        end
        
        % Menu selected function: ExitMenu
        function ExitMenuSelected(app, event)
            exitBox = questdlg('Do you really want to exit?','Warning');
            
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
        
        % Value changed function: ChooseRessourceDropDown
        function ChooseRessourceDropDownValueChanged(app, event)
            value = app.ChooseRessourceDropDown.Value;
            
            %Set items for Dropdown menu without select...
            app.ChooseRessourceDropDown.Items = {'CPU', 'GPU'};
            
            %Set items dynamically
            if value == 'CPU'
                switch app.cpuInfo.NumProcessors
                    case 1
                        app.CPUCoresDropDown.Items = {'1'};
                    case 2
                        app.CPUCoresDropDown.Items = {'1', '2'};
                    case 3
                        app.CPUCoresDropDown.Items = {'1', '2', '3'};
                    case 4
                        app.CPUCoresDropDown.Items = {'1', '2', '3', '4'};
                end
                app.CPUCoresDropDown.Enable = 'on';
                app.UIAxes_gpu.Visible = 'off';
            else
                app.CPUCoresDropDown.Items = {'1'};
                app.CPUCoresDropDown.Enable = 'off';
                app.UIAxes_gpu.Visible = 'on';
                app.UIAxes_cpu1.Visible = 'off';
                app.UIAxes_cpu2.Visible = 'off';
                app.UIAxes_cpu3.Visible = 'off';
                app.UIAxes_cpu4.Visible = 'off';
            end
        end
        
        % Value changing function: PasswordHashEditField
        function PasswordHashEditFieldValueChanging(app, event)
            value = app.PasswordHashEditField.Value;
            strVal = convertCharsToStrings(value);
            valLenth = strlength(strVal);
            
            if valLenth > this.PwLength
                app.PasswordCheck.Visible = 'on';
            else
                app.PasswordCheck.Visible = 'off';
            end
            
        end
        
        % Menu selected function: NewrunMenu
        function NewrunMenuSelected(app, event)
            exitBox = questdlg('Do you want to save all data?','Warning');
            
            switch exitBox
                case 'Yes'
                    filename = 'test.csv';
                    cell2csv(filename,app.messageBuffer);
                    app.EvaluateSystemButton.Enable = 'on';
                    app.evaluateDone = false;
                    app.NewrunMenu.Enable = 'off';
                    app.messageBuffer = {''};
                    app.LogMonitorTextArea.Value = '';
                case 'No'
                    app.EvaluateSystemButton.Enable = 'on';
                    app.evaluateDone = false;
                    app.NewrunMenu.Enable = 'off';
                    app.messageBuffer = {''};
                    app.LogMonitorTextArea.Value = '';
            end
        end
        
        % Value changed function: CPUCoresDropDown
        function CPUCoresDropDownValueChanged(app, event)
            value = app.CPUCoresDropDown.Value;
            switch value
                case '1'
                    app.UIAxes_cpu1.Visible = 'on';
                    app.UIAxes_cpu2.Visible = 'off';
                    app.UIAxes_cpu3.Visible = 'off';
                    app.UIAxes_cpu4.Visible = 'off';
                case '2'
                    app.UIAxes_cpu1.Visible = 'on';
                    app.UIAxes_cpu2.Visible = 'on';
                    app.UIAxes_cpu3.Visible = 'off';
                    app.UIAxes_cpu4.Visible = 'off';
                case '3'
                    app.UIAxes_cpu1.Visible = 'on';
                    app.UIAxes_cpu2.Visible = 'on';
                    app.UIAxes_cpu3.Visible = 'on';
                    app.UIAxes_cpu4.Visible = 'off';
                case '4'
                    app.UIAxes_cpu1.Visible = 'on';
                    app.UIAxes_cpu2.Visible = 'on';
                    app.UIAxes_cpu3.Visible = 'on';
                    app.UIAxes_cpu4.Visible = 'on';
            end
            
        end
        
        % Value changed function: EncryptionDropDown
        function EncryptionDropDownValueChanged(app, event)
            value = app.EncryptionDropDown.Value;
            
            %Set items for Dropdown menu without select...
            app.EncryptionDropDown.Items = {'SHA-1', 'SHA-256', 'SHA-512', 'MD5', 'AES-256'};
            
            switch value
                case 'SHA-1'
                    
                case 'SHA-256'
                    
                case 'SHA-512'
                    
                case 'MD5'
                    
                case 'AES-256'
            end
            
            
        end
        
        % Value changed function: RainbowtableDropDown
        function RainbowtableDropDownValueChanged(app, event)
            value = app.RainbowtableDropDown.Value;
            
            %Set items for Dropdown menu without select...
            app.RainbowtableDropDown.Items = {'Yes', 'No'};
            
            switch value
                case 'Yes'
                    
                case 'No'
                    
            end
        end
        
        % Value changed function: TodecryptDropDown
        function TodecryptDropDownValueChanged(app, event)
            value = app.TodecryptDropDown.Value;
            
            %Set items for Dropdown menu without select...
            app.TodecryptDropDown.Items = {'Password', 'Hash'};
            
        end
        
        % Button pushed function: STARTBruteforceButton
        function STARTBruteforceButtonPushed(app, event)
            
            
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
            
            %             % Create FileMenu
            %             app.FileMenu = uimenu(app.BruteForceToolUIFigure);
            %             app.FileMenu.Text = 'File';
            %
            %             % Create NewrunMenu
            %             app.NewrunMenu = uimenu(app.FileMenu);
            %             app.NewrunMenu.MenuSelectedFcn = createCallbackFcn(app, @NewrunMenuSelected, true);
            %             app.NewrunMenu.Accelerator = 'N';
            %             app.NewrunMenu.Text = 'New run...';
            %
            %             % Create SaveMenu
            %             app.SaveMenu = uimenu(app.FileMenu);
            %             app.SaveMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveMenuSelected, true);
            %             app.SaveMenu.Accelerator = 'S';
            %             app.SaveMenu.Text = 'Save';
            %
            %             % Create ExporttocsvMenu
            %             app.ExporttocsvMenu = uimenu(app.FileMenu);
            %             app.ExporttocsvMenu.Text = 'Export to csv...';
            %
            %             % Create ExitMenu
            %             app.ExitMenu = uimenu(app.FileMenu);
            %             app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            %             app.ExitMenu.Text = 'Exit';
            %
            %             % Create Menu_4
            %             app.Menu_4 = uimenu(app.BruteForceToolUIFigure);
            %             app.Menu_4.Text = '?';
            %
            %             % Create AboutMenu
            %             app.AboutMenu = uimenu(app.Menu_4);
            %             app.AboutMenu.MenuSelectedFcn = createCallbackFcn(app, @AboutMenuSelected, true);
            %             app.AboutMenu.Text = 'About...';
            
            % Create BruteforceToolLabel
            app.BruteforceToolLabel = uilabel(app.BruteForceToolUIFigure);
            app.BruteforceToolLabel.FontSize = 20;
            app.BruteforceToolLabel.FontWeight = 'bold';
            app.BruteforceToolLabel.Position = [41 926 158 26];
            app.BruteforceToolLabel.Text = 'Brute force Tool';
            
            % Create PasswordHashEditFieldLabel
            app.PasswordHashEditFieldLabel = uilabel(app.BruteForceToolUIFigure);
            app.PasswordHashEditFieldLabel.HorizontalAlignment = 'right';
            app.PasswordHashEditFieldLabel.Position = [66 707 96 15];
            app.PasswordHashEditFieldLabel.Text = 'Password / Hash';
            
            % Create PasswordHashEditField
            app.PasswordHashEditField = uieditfield(app.BruteForceToolUIFigure, 'text');
            app.PasswordHashEditField.ValueChangingFcn = createCallbackFcn(app, @PasswordHashEditFieldValueChanging, true);
            app.PasswordHashEditField.Position = [332 703 164 22];
            
            % Create STARTBruteforceButton
            app.STARTBruteforceButton = uibutton(app.BruteForceToolUIFigure, 'push');
            app.STARTBruteforceButton.ButtonPushedFcn = createCallbackFcn(app, @STARTBruteforceButtonPushed, true);
            app.STARTBruteforceButton.BackgroundColor = [0.302 0.749 0.9294];
            app.STARTBruteforceButton.FontName = 'Arial';
            app.STARTBruteforceButton.FontSize = 20;
            app.STARTBruteforceButton.FontWeight = 'bold';
            app.STARTBruteforceButton.Position = [65 353 431 54];
            app.STARTBruteforceButton.Text = 'START Brute force';
            
            % Create LogMonitorTextAreaLabel
            app.LogMonitorTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.LogMonitorTextAreaLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.LogMonitorTextAreaLabel.Position = [34 250 70 15];
            app.LogMonitorTextAreaLabel.Text = 'Log-Monitor';
            
            % Create LogMonitorTextArea
            app.LogMonitorTextArea = uitextarea(app.BruteForceToolUIFigure);
            app.LogMonitorTextArea.Editable = 'off';
            app.LogMonitorTextArea.BackgroundColor = [0.9412 0.9412 0.9412];
            app.LogMonitorTextArea.Position = [31 21 570 224];
            
            % Create TodecryptDropDownLabel
            app.TodecryptDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.TodecryptDropDownLabel.HorizontalAlignment = 'right';
            app.TodecryptDropDownLabel.Position = [66 747 61 15];
            app.TodecryptDropDownLabel.Text = 'To decrypt';
            
            % Create TodecryptDropDown
            app.TodecryptDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.TodecryptDropDown.Items = {'Select...', 'Password', 'Hash'};
            app.TodecryptDropDown.ValueChangedFcn = createCallbackFcn(app, @TodecryptDropDownValueChanged, true);
            app.TodecryptDropDown.Position = [332 743 164 22];
            app.TodecryptDropDown.Value = 'Select...';
            
            % Create EncryptionDropDownLabel
            app.EncryptionDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.EncryptionDropDownLabel.HorizontalAlignment = 'right';
            app.EncryptionDropDownLabel.Position = [66 578 62 15];
            app.EncryptionDropDownLabel.Text = 'Encryption';
            
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
            
            % Create ChooseRessourceDropDownLabel
            app.ChooseRessourceDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.ChooseRessourceDropDownLabel.HorizontalAlignment = 'right';
            app.ChooseRessourceDropDownLabel.Position = [66 465 108 15];
            app.ChooseRessourceDropDownLabel.Text = 'Choose Ressource';
            
            % Create ChooseRessourceDropDown
            app.ChooseRessourceDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.ChooseRessourceDropDown.Items = {'Select...', 'CPU', 'GPU'};
            app.ChooseRessourceDropDown.ValueChangedFcn = createCallbackFcn(app, @ChooseRessourceDropDownValueChanged, true);
            app.ChooseRessourceDropDown.Position = [221 461 76 22];
            app.ChooseRessourceDropDown.Value = 'Select...';
            
            % Create CPUGPUTempCTextAreaLabel
            app.CPUGPUTempCTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.CPUGPUTempCTextAreaLabel.HorizontalAlignment = 'right';
            app.CPUGPUTempCTextAreaLabel.Position = [963 349 126 15];
            app.CPUGPUTempCTextAreaLabel.Text = 'CPU / GPU Temp. [°C]';
            
            % Create CPUGPUTempCTextArea
            app.CPUGPUTempCTextArea = uitextarea(app.BruteForceToolUIFigure);
            app.CPUGPUTempCTextArea.Editable = 'off';
            app.CPUGPUTempCTextArea.Position = [1127 338 92 28];
            
            % Create FanspeedrpmTextAreaLabel
            app.FanspeedrpmTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.FanspeedrpmTextAreaLabel.HorizontalAlignment = 'right';
            app.FanspeedrpmTextAreaLabel.Position = [568 349 93 15];
            app.FanspeedrpmTextAreaLabel.Text = 'Fan speed [rpm]';
            
            % Create FanspeedrpmTextArea
            app.FanspeedrpmTextArea = uitextarea(app.BruteForceToolUIFigure);
            app.FanspeedrpmTextArea.Editable = 'off';
            app.FanspeedrpmTextArea.Position = [731 338 92 28];
            
            % Create ResultTextAreaLabel
            app.ResultTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.ResultTextAreaLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ResultTextAreaLabel.HorizontalAlignment = 'right';
            app.ResultTextAreaLabel.Position = [645 250 40 15];
            app.ResultTextAreaLabel.Text = 'Result';
            
            % Create ResultTextArea
            app.ResultTextArea = uitextarea(app.BruteForceToolUIFigure);
            app.ResultTextArea.Editable = 'off';
            app.ResultTextArea.HorizontalAlignment = 'center';
            app.ResultTextArea.FontSize = 48;
            app.ResultTextArea.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ResultTextArea.Position = [650 185 583 60];
            app.ResultTextArea.Value = {'01234567'};
            
            % Create CPUCoresDropDownLabel
            app.CPUCoresDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.CPUCoresDropDownLabel.HorizontalAlignment = 'right';
            app.CPUCoresDropDownLabel.Position = [332 465 66 15];
            app.CPUCoresDropDownLabel.Text = 'CPU Cores';
            
            % Create CPUCoresDropDown
            app.CPUCoresDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.CPUCoresDropDown.Items = {};
            app.CPUCoresDropDown.ValueChangedFcn = createCallbackFcn(app, @CPUCoresDropDownValueChanged, true);
            app.CPUCoresDropDown.Position = [412 461 84 22];
            app.CPUCoresDropDown.Value = {};
            
            % Create AdvancedsettingsLabel
            app.AdvancedsettingsLabel = uilabel(app.BruteForceToolUIFigure);
            app.AdvancedsettingsLabel.VerticalAlignment = 'center';
            app.AdvancedsettingsLabel.FontSize = 14;
            app.AdvancedsettingsLabel.FontAngle = 'italic';
            app.AdvancedsettingsLabel.Position = [65 631 338 20];
            app.AdvancedsettingsLabel.Text = 'Advanced settings';
            
            % Create EvaluateSystemButton
            app.EvaluateSystemButton = uibutton(app.BruteForceToolUIFigure, 'push');
            app.EvaluateSystemButton.ButtonPushedFcn = createCallbackFcn(app, @EvaluateSystemButtonPushed, true);
            app.EvaluateSystemButton.BackgroundColor = [1 0.9255 0.5451];
            app.EvaluateSystemButton.FontSize = 14;
            app.EvaluateSystemButton.FontWeight = 'bold';
            app.EvaluateSystemButton.Position = [73 816 423 45];
            app.EvaluateSystemButton.Text = 'Evaluate System';
            
            % Create TabGroup
            app.TabGroup = uitabgroup(app.BruteForceToolUIFigure);
            app.TabGroup.Position = [567 431 700 430];
            
            % Create CPUTab
            app.CPUTab = uitab(app.TabGroup);
            app.CPUTab.Title = 'CPU';
            app.CPUTab.BackgroundColor = [0.9412 0.9412 0.9412];
            
            % Create UIAxes_cpu1
            app.UIAxes_cpu1 = uiaxes(app.CPUTab);
            title(app.UIAxes_cpu1, 'CPU 1')
            ylabel(app.UIAxes_cpu1, 'Y')
            app.UIAxes_cpu1.XLim = [0 Inf];
            app.UIAxes_cpu1.YLim = [0 100];
            app.UIAxes_cpu1.Box = 'on';
            app.UIAxes_cpu1.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_cpu1.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_cpu1.XGrid = 'on';
            app.UIAxes_cpu1.YGrid = 'on';
            app.UIAxes_cpu1.Position = [27 222 320 170];
            
            % Create UIAxes_cpu2
            app.UIAxes_cpu2 = uiaxes(app.CPUTab);
            title(app.UIAxes_cpu2, 'CPU 2')
            ylabel(app.UIAxes_cpu2, 'Y')
            app.UIAxes_cpu2.XLim = [0 Inf];
            app.UIAxes_cpu2.YLim = [0 100];
            app.UIAxes_cpu2.Box = 'on';
            app.UIAxes_cpu2.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_cpu2.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_cpu2.XGrid = 'on';
            app.UIAxes_cpu2.YGrid = 'on';
            app.UIAxes_cpu2.Position = [346 222 320 170];
            
            % Create UIAxes_cpu3
            app.UIAxes_cpu3 = uiaxes(app.CPUTab);
            title(app.UIAxes_cpu3, 'CPU 3')
            ylabel(app.UIAxes_cpu3, 'Y')
            app.UIAxes_cpu3.XLim = [0 Inf];
            app.UIAxes_cpu3.YLim = [0 100];
            app.UIAxes_cpu3.Box = 'on';
            app.UIAxes_cpu3.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_cpu3.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_cpu3.XGrid = 'on';
            app.UIAxes_cpu3.YGrid = 'on';
            app.UIAxes_cpu3.Position = [27 25 320 170];
            
            % Create UIAxes_cpu4
            app.UIAxes_cpu4 = uiaxes(app.CPUTab);
            title(app.UIAxes_cpu4, 'CPU 4')
            ylabel(app.UIAxes_cpu4, 'Y')
            app.UIAxes_cpu4.XLim = [0 Inf];
            app.UIAxes_cpu4.YLim = [0 100];
            app.UIAxes_cpu4.Box = 'on';
            app.UIAxes_cpu4.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_cpu4.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_cpu4.XGrid = 'on';
            app.UIAxes_cpu4.YGrid = 'on';
            app.UIAxes_cpu4.Position = [346 25 320 170];
            
            % Create GPUTab
            app.GPUTab = uitab(app.TabGroup);
            app.GPUTab.Title = 'GPU';
            app.GPUTab.BackgroundColor = [0.9412 0.9412 0.9412];
            
            % Create UIAxes_gpu
            app.UIAxes_gpu = uiaxes(app.GPUTab);
            title(app.UIAxes_gpu, 'GPU')
            ylabel(app.UIAxes_gpu, 'Y')
            app.UIAxes_gpu.XLim = [0 Inf];
            app.UIAxes_gpu.YLim = [0 100];
            app.UIAxes_gpu.Box = 'on';
            app.UIAxes_gpu.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_gpu.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_gpu.XGrid = 'on';
            app.UIAxes_gpu.YGrid = 'on';
            app.UIAxes_gpu.Position = [24 30 642 341];
            
            % Create StatusTextAreaLabel
            app.StatusTextAreaLabel = uilabel(app.BruteForceToolUIFigure);
            app.StatusTextAreaLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.StatusTextAreaLabel.Position = [34 310 40 15];
            app.StatusTextAreaLabel.Text = 'Status';
            
            % Create StatusTextArea
            app.StatusTextArea = uitextarea(app.BruteForceToolUIFigure);
            app.StatusTextArea.Editable = 'off';
            app.StatusTextArea.BackgroundColor = [0.9412 0.9412 0.9412];
            app.StatusTextArea.Position = [31 276 570 29];
            
            % Create PasswordCheck
            app.PasswordCheck = uitextarea(app.BruteForceToolUIFigure);
            app.PasswordCheck.Editable = 'off';
            app.PasswordCheck.FontSize = 9;
            app.PasswordCheck.FontColor = [1 0 0];
            app.PasswordCheck.BackgroundColor = [0.9412 0.9412 0.9412];
            app.PasswordCheck.Position = [332 669 164 35];
            app.PasswordCheck.Value = {'Password length  is limited to 8 and chars ''0-9'', ''A-Z'', ''a-z'' are allowed'};
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