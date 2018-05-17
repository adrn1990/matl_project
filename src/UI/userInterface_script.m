classdef userInterface_script < matlab.apps.AppBase

    % Properties that correspond to app components
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
        %For displayData()
        CpuValue = 0;
        GpuValue = 0;
        time = 0;
        SizeReached = false;
        
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
        
        Abort= false;
        
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
        
        function evalStartBF(app,varargin)
            %check if varargin is used
            if isempty(varargin)
                Input = app.InputEditField.Value;
            else
                Input= varargin{1};
            end
            
            %check if the input is between 0 and 9
            if (0 < length(Input)) &&  (length(Input) < 9)
                InputValidity= true;
            else
                InputValidity= false;
            end
            
            %check if the chars in the inputbox are valid
            if evalChars(app,Input)
                CharValidity = true;
            else
                CharValidity= false;
            end
            
            %check if an encryption algorithm is set is set
            EncryptValidity= ~strcmp(app.EncryptionDropDown.Value,'Select...');
            
            %check if the mode to decrypt is set
            ModeValidity= ~strcmp(app.ModeDropDown.Value,'Select...');
            
            %TODO: add the functionality for the cluster dropdown
            %if all checks are true, the StartButton can be enabled.
            if app.evaluateDone && InputValidity && ModeValidity && CharValidity && EncryptValidity
                app.StartButton.Enable = 'on';
            else
                app.StartButton.Enable = 'off';
            end
        end
        
        %this function sets the components properties to the state before the system is evaluated
        function compBeforeEval(app)
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
            
            
            app.messageBuffer = {''};
            app.LogMonitorOutput.Value = '';
            app.InputEditField.Value = '';
            app.StatusOutput.Value = '';
            app.ResultOutput.Value = '';
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
            
        end
        
        %this function sets the component properties to the state while the brute forcing is in progress
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
            app.ExitMenu.Enable = 'off';
            
        end
        
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

        end
        
    end
    

    methods (Access = private)

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
            
            compBeforeEval(app);
            
            app.InputEditField.FontAngle = 'italic';   
        end

        % Button pushed function: EvaluateButton
        function EvaluateButtonPushed(app, event)
            %set the components to the visibility while evaluating
            compWhileEvaluate(app);
            
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
                if ispc
                    fWriteMessageBuffer(app, 'Getting CPU data...');
                    app.cpuData = getCpuData;
                    app.CpuLoadOutput.Value = app.cpuData.avgCpuLoad;
                    app.CpuTemperatureOutput.Value = app.cpuData.currCpuTemp;
                    fWriteMessageBuffer(app, 'CPU data recieved');
                    fWriteMessageBuffer(app, app.delemiter);
                    
                    if gpuDeviceCount > 0
                        fWriteMessageBuffer(app, 'Getting GPU data...');
                        app.gpuData = getGpuData;
                        app.GpuLoadOutput.Value = app.gpuData.avgGpuLoad;
                        app.GpuTemperatureOutput.Value = app.gpuData.currGpuTemp;
                        fWriteMessageBuffer(app, 'GPU data recieved');
                        fWriteMessageBuffer(app, app.delemiter);
                    end
                end
                
                %Setting up parallel processing
                try
                     fWriteMessageBuffer(app, 'Starting up parallel processing...');
                     fWriteMessageBuffer(app, 'Getting Clusters:');
                     fWriteMessageBuffer(app, ' ');
                     
                     %get available clusters and plot it to the buffer
%                      Clusters1= {'Select...'};
                     Clusters = parallel.clusterProfiles;
%                      app.Clusters= horzcat(Clusters1,app.Clusters);
                     for Increment=1:length(Clusters)
                       fWriteMessageBuffer(app, ['- "',Clusters{Increment},'"']);  
                     end
                     
                     %close the current pool if there is one running
                     p = gcp('nocreate'); % If no pool, do not create new one.
                     if ~isempty(p)
                         fWriteMessageBuffer(app, ' ');
                         fWriteMessageBuffer(app, 'The running pool has to be closed!');
                         delete(gcp('nocreate'));
                         fWriteMessageBuffer(app, 'The pool is closed.');
                     end
                     
                     
                     app.ClusterDropDown.Items= Clusters;
                     fWriteMessageBuffer(app, ' ');
                     fWriteMessageBuffer(app, 'Parallel processing ready.');
                     fWriteMessageBuffer(app, app.delemiter);
%                     %TODO: choose a cluster from dropdown.
%                     pool =parpool('local');
%                     
%                     if pool.Connected == true
%                         fWriteMessageBuffer(app, 'Parallel processing ready');
%                         parWorkers = num2str(pool.NumWorkers);
%                         strParWorkers = sprintf('NumWorkers: \t \t \t \t %s' , parWorkers);
%                         fWriteMessageBuffer(app, strParWorkers);
%                         
%                         clusterProfile = sprintf('Cluster profile: \t \t \t %s' , pool.Cluster.Profile);
%                         fWriteMessageBuffer(app, clusterProfile);
%                         fWriteMessageBuffer(app, app.delemiter);
%                     else %TODO exception handling
%                         fWriteMessageBuffer(app, 'Something went wroooooong!');
%                         fWriteMessageBuffer(app, app.delemiter);
%                     end
                catch
                    fWriteMessageBuffer(app, 'No Parallel Toolbox found or an active session is running!');
                    
                end
                
                %the evaluation is done
                app.evaluateDone = true;
                evalStartBF(app);
                compAfterEval(app);
            end
        end

        % Menu selected function: ExitMenu
        function ExitMenuSelected(app, event)
            exitBox = questdlg('Do you really want to exit without saving?','Warning');
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
            saveFile(app)
            msgbox('File saved!');
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
            evalStartBF(app,value);
        end

        % Menu selected function: NewrunMenu
        function NewrunMenuSelected(app, event)
            exitBox = questdlg('Do you want to save all data?','Warning');
            
            switch exitBox
                case 'Yes'
                    filename = 'test.csv';
                    cell2csv(filename,app.messageBuffer);
                case 'No'
                    %do nothing
            end
            
            app.evaluateDone = false;
            compBeforeEval(app)
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
            
            evalStartBF(app);
        end

        % Value changed function: ModeDropDown
        function ModeDropDownValueChanged(app, event)
            %Set items for Dropdown menu without select...
            app.ModeDropDown.Items = {'Password', 'Hash'};
            app.ModeDropDown.Value;
            evalStartBF(app);
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            app.ResultOutput.Value = '';
            app.StatusOutput.Value = 'Your current progress in BruteForcing is: 0%';
            
            %change the visibility of components while brute forcing
            compWhileBruteForce(app)
            
            %initialize the brute force
            initBruteForce(app);
            
            %execute the function to do the brute force
            doBruteForce2(app);
            
            %change the visibility of the components
            compAfterEval(app);
            
            %evaluate if the start button can be active
            evalStartBF(app)
        end

        % Close request function: BruteForceToolUIFigure
        function CloseRequest(app, event)
            
            %call function for delete procedure
            deleteApp(app);
            
            delete(app)
            
        end
        
        % Button pushed function: AbortButton
        function AbortButtonPushed(app, event)
            app.Abort = true;
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
            app.StartButton.BackgroundColor = [0.302 0.749 1];
            app.StartButton.FontName = 'Arial';
            app.StartButton.FontSize = 20;
            app.StartButton.FontWeight = 'bold';
            app.StartButton.FontColor = [1 1 1];
            app.StartButton.Position = [66 426 430 54];
            app.StartButton.Text = 'START';

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

            % Create CPUTempCLabel
            app.CPUTempCLabel = uilabel(app.BruteForceToolUIFigure);
            app.CPUTempCLabel.HorizontalAlignment = 'right';
            app.CPUTempCLabel.Position = [999 345 90 15];
            app.CPUTempCLabel.Text = 'CPU Temp. [�C]';

            % Create CpuTemperatureOutput
            app.CpuTemperatureOutput = uitextarea(app.BruteForceToolUIFigure);
            app.CpuTemperatureOutput.Editable = 'off';
            app.CpuTemperatureOutput.HorizontalAlignment = 'center';
            app.CpuTemperatureOutput.FontSize = 14;
            app.CpuTemperatureOutput.Position = [1127 338 92 28];

            % Create CPULoadLabel
            app.CPULoadLabel = uilabel(app.BruteForceToolUIFigure);
            app.CPULoadLabel.HorizontalAlignment = 'right';
            app.CPULoadLabel.Position = [661 345 82 15];
            app.CPULoadLabel.Text = 'CPU Load [%]';

            % Create CpuLoadOutput
            app.CpuLoadOutput = uitextarea(app.BruteForceToolUIFigure);
            app.CpuLoadOutput.Editable = 'off';
            app.CpuLoadOutput.HorizontalAlignment = 'center';
            app.CpuLoadOutput.FontSize = 14;
            app.CpuLoadOutput.Position = [789 338 92 28];

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

            % Create UIAxes_cpu
            app.UIAxes_cpu = uiaxes(app.BruteForceToolUIFigure);
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
            app.UIAxes_cpu.Position = [600 631 639 228];

            % Create UIAxes_gpu
            app.UIAxes_gpu = uiaxes(app.BruteForceToolUIFigure);
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
            app.UIAxes_gpu.Position = [599 406 642 226];

            % Create GPULoadLabel
            app.GPULoadLabel = uilabel(app.BruteForceToolUIFigure);
            app.GPULoadLabel.HorizontalAlignment = 'right';
            app.GPULoadLabel.Position = [661 304 82 15];
            app.GPULoadLabel.Text = 'GPU Load [%]';

            % Create GpuLoadOutput
            app.GpuLoadOutput = uitextarea(app.BruteForceToolUIFigure);
            app.GpuLoadOutput.Editable = 'off';
            app.GpuLoadOutput.HorizontalAlignment = 'center';
            app.GpuLoadOutput.FontSize = 14;
            app.GpuLoadOutput.Position = [789 297 92 28];

            % Create GPUTempCLabel
            app.GPUTempCLabel = uilabel(app.BruteForceToolUIFigure);
            app.GPUTempCLabel.HorizontalAlignment = 'right';
            app.GPUTempCLabel.Position = [998 304 91 15];
            app.GPUTempCLabel.Text = 'GPU Temp. [�C]';

            % Create GpuTemperatureOutput
            app.GpuTemperatureOutput = uitextarea(app.BruteForceToolUIFigure);
            app.GpuTemperatureOutput.Editable = 'off';
            app.GpuTemperatureOutput.HorizontalAlignment = 'center';
            app.GpuTemperatureOutput.FontSize = 14;
            app.GpuTemperatureOutput.Position = [1127 297 92 28];

            % Create ClusterDropDownLabel            
            app.ClusterDropDownLabel = uilabel(app.BruteForceToolUIFigure);
            app.ClusterDropDownLabel.Position = [73 529 55 15];
            app.ClusterDropDownLabel.Text = 'Cluster';
            

            % Create ClusterDropDown        
            app.ClusterDropDown = uidropdown(app.BruteForceToolUIFigure);
            app.ClusterDropDown.Items = {'Select...'};
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
        end
    end

    methods (Access = public)

        % Construct app
        function app = userInterface_script
            
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

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.BruteForceToolUIFigure)
        end
    end
end