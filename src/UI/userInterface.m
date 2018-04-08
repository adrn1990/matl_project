classdef userInterface < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MainUIFigure                  matlab.ui.Figure
        FileMenu                      matlab.ui.container.Menu
        SaveMenu                      matlab.ui.container.Menu
        ExitMenu                      matlab.ui.container.Menu
        Menu_4                        matlab.ui.container.Menu
        AboutMenu                     matlab.ui.container.Menu
        Menu2_3                       matlab.ui.container.Menu
        BruteforceToolLabel           matlab.ui.control.Label
        PasswordHashEditFieldLabel    matlab.ui.control.Label
        PasswordHashEditField         matlab.ui.control.EditField
        UIAxes_gpu                    matlab.ui.control.UIAxes
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
        UIAxes_cpu1                   matlab.ui.control.UIAxes
        UIAxes_cpu2                   matlab.ui.control.UIAxes
        UIAxes_cpu3                   matlab.ui.control.UIAxes
        UIAxes_cpu4                   matlab.ui.control.UIAxes
    end

    
    methods (Access = private)
    
        function results = BruteProgress(app)
            
        end
        
    end


    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.PasswordHashEditField.Value = '--Type a password--';
            app.PasswordHashEditField.FontAngle = 'italic';
            app.STARTBruteforceButton.Enable = 'off';
            state = 0;
        end

        % Button pushed function: STARTBruteforceButton
        function STARTBruteforceButtonPushed(app, event)
            app.PasswordHashEditField.Value = 'Button pressed!'
        end

        % Value changed function: PasswordHashEditField
        function PasswordHashEditFieldValueChanged(app, event)
            undef = 0;
            initializing = 1;
            waiting = 2;
            processing = 3;
            aborting = 4;
            state;
            
            switch (state)
                case undef
                    pause(2);
                    state = initializing;
                    
                case initializing
                    app.LogMonitorTextArea.Value = 'initializing the application \n'
                    pause(5);
                    
                case waiting
                    
                case processing
            
                case aborting

            end
            
            
            if waitforbuttonpress == 0
                app.PasswordHashEditField.Value = '';
            end
            errordlg('Das Matlab regt mi sooo uf..!');
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MainUIFigure
            app.MainUIFigure = uifigure;
            app.MainUIFigure.Color = [0.8 0.8 0.8];
            app.MainUIFigure.Position = [100 100 1284 974];
            app.MainUIFigure.Name = 'Main';

            % Create FileMenu
            app.FileMenu = uimenu(app.MainUIFigure);
            app.FileMenu.Text = 'File';

            % Create SaveMenu
            app.SaveMenu = uimenu(app.FileMenu);
            app.SaveMenu.Accelerator = 'S';
            app.SaveMenu.Text = 'Save';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.FileMenu);
            app.ExitMenu.Text = 'Exit';

            % Create Menu_4
            app.Menu_4 = uimenu(app.MainUIFigure);
            app.Menu_4.Text = '?';

            % Create AboutMenu
            app.AboutMenu = uimenu(app.Menu_4);
            app.AboutMenu.Text = 'About...';

            % Create Menu2_3
            app.Menu2_3 = uimenu(app.Menu_4);
            app.Menu2_3.Text = 'Menu2';

            % Create BruteforceToolLabel
            app.BruteforceToolLabel = uilabel(app.MainUIFigure);
            app.BruteforceToolLabel.FontSize = 20;
            app.BruteforceToolLabel.FontWeight = 'bold';
            app.BruteforceToolLabel.Position = [41 926 158 26];
            app.BruteforceToolLabel.Text = 'Brute force Tool';

            % Create PasswordHashEditFieldLabel
            app.PasswordHashEditFieldLabel = uilabel(app.MainUIFigure);
            app.PasswordHashEditFieldLabel.HorizontalAlignment = 'right';
            app.PasswordHashEditFieldLabel.Position = [43 777 96 15];
            app.PasswordHashEditFieldLabel.Text = 'Password / Hash';

            % Create PasswordHashEditField
            app.PasswordHashEditField = uieditfield(app.MainUIFigure, 'text');
            app.PasswordHashEditField.ValueChangedFcn = createCallbackFcn(app, @PasswordHashEditFieldValueChanged, true);
            app.PasswordHashEditField.Position = [154 773 199 22];

            % Create UIAxes_gpu
            app.UIAxes_gpu = uiaxes(app.MainUIFigure);
            title(app.UIAxes_gpu, 'GPU')
            ylabel(app.UIAxes_gpu, 'Y')
            app.UIAxes_gpu.XLim = [0 Inf];
            app.UIAxes_gpu.YLim = [0 100];
            app.UIAxes_gpu.Box = 'on';
            app.UIAxes_gpu.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_gpu.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_gpu.XGrid = 'on';
            app.UIAxes_gpu.YGrid = 'on';
            app.UIAxes_gpu.Position = [751 245 450 210];

            % Create STARTBruteforceButton
            app.STARTBruteforceButton = uibutton(app.MainUIFigure, 'push');
            app.STARTBruteforceButton.ButtonPushedFcn = createCallbackFcn(app, @STARTBruteforceButtonPushed, true);
            app.STARTBruteforceButton.Position = [1111 903 116 22];
            app.STARTBruteforceButton.Text = 'START Brute force';

            % Create LogMonitorTextAreaLabel
            app.LogMonitorTextAreaLabel = uilabel(app.MainUIFigure);
            app.LogMonitorTextAreaLabel.BackgroundColor = [0.8 0.8 0.8];
            app.LogMonitorTextAreaLabel.Position = [34 190 70 15];
            app.LogMonitorTextAreaLabel.Text = 'Log-Monitor';

            % Create LogMonitorTextArea
            app.LogMonitorTextArea = uitextarea(app.MainUIFigure);
            app.LogMonitorTextArea.Editable = 'off';
            app.LogMonitorTextArea.BackgroundColor = [0.8 0.8 0.8];
            app.LogMonitorTextArea.Position = [31 21 570 164];

            % Create TodecryptDropDownLabel
            app.TodecryptDropDownLabel = uilabel(app.MainUIFigure);
            app.TodecryptDropDownLabel.HorizontalAlignment = 'right';
            app.TodecryptDropDownLabel.Position = [66 817 61 15];
            app.TodecryptDropDownLabel.Text = 'To decrypt';

            % Create TodecryptDropDown
            app.TodecryptDropDown = uidropdown(app.MainUIFigure);
            app.TodecryptDropDown.Items = {'Passwort', 'Hash'};
            app.TodecryptDropDown.Position = [142 813 213 22];
            app.TodecryptDropDown.Value = 'Passwort';

            % Create EncryptionDropDownLabel
            app.EncryptionDropDownLabel = uilabel(app.MainUIFigure);
            app.EncryptionDropDownLabel.HorizontalAlignment = 'right';
            app.EncryptionDropDownLabel.Position = [851 827 62 15];
            app.EncryptionDropDownLabel.Text = 'Encryption';

            % Create EncryptionDropDown
            app.EncryptionDropDown = uidropdown(app.MainUIFigure);
            app.EncryptionDropDown.Items = {'RSA', 'SHA', 'Option 3', 'Option 4'};
            app.EncryptionDropDown.Position = [928 823 203 22];
            app.EncryptionDropDown.Value = 'RSA';

            % Create RainbowtableDropDownLabel
            app.RainbowtableDropDownLabel = uilabel(app.MainUIFigure);
            app.RainbowtableDropDownLabel.HorizontalAlignment = 'right';
            app.RainbowtableDropDownLabel.Position = [841 777 78 15];
            app.RainbowtableDropDownLabel.Text = 'Rainbowtable';

            % Create RainbowtableDropDown
            app.RainbowtableDropDown = uidropdown(app.MainUIFigure);
            app.RainbowtableDropDown.Items = {'Yes', 'No'};
            app.RainbowtableDropDown.Position = [934 773 197 22];
            app.RainbowtableDropDown.Value = 'Yes';

            % Create ChooseRessourceDropDownLabel
            app.ChooseRessourceDropDownLabel = uilabel(app.MainUIFigure);
            app.ChooseRessourceDropDownLabel.HorizontalAlignment = 'right';
            app.ChooseRessourceDropDownLabel.Position = [801 727 108 15];
            app.ChooseRessourceDropDownLabel.Text = 'Choose Ressource';

            % Create ChooseRessourceDropDown
            app.ChooseRessourceDropDown = uidropdown(app.MainUIFigure);
            app.ChooseRessourceDropDown.Items = {'CPU', 'GPU', 'Option 3', 'Option 4'};
            app.ChooseRessourceDropDown.Position = [924 723 100 22];
            app.ChooseRessourceDropDown.Value = 'CPU';

            % Create CPUGPUTempCTextAreaLabel
            app.CPUGPUTempCTextAreaLabel = uilabel(app.MainUIFigure);
            app.CPUGPUTempCTextAreaLabel.HorizontalAlignment = 'right';
            app.CPUGPUTempCTextAreaLabel.Position = [908 598 126 15];
            app.CPUGPUTempCTextAreaLabel.Text = 'CPU / GPU Temp. [°C]';

            % Create CPUGPUTempCTextArea
            app.CPUGPUTempCTextArea = uitextarea(app.MainUIFigure);
            app.CPUGPUTempCTextArea.Editable = 'off';
            app.CPUGPUTempCTextArea.Position = [1049 587 55 28];

            % Create FanspeedrpmTextAreaLabel
            app.FanspeedrpmTextAreaLabel = uilabel(app.MainUIFigure);
            app.FanspeedrpmTextAreaLabel.HorizontalAlignment = 'right';
            app.FanspeedrpmTextAreaLabel.Position = [941 628 93 15];
            app.FanspeedrpmTextAreaLabel.Text = 'Fan speed [rpm]';

            % Create FanspeedrpmTextArea
            app.FanspeedrpmTextArea = uitextarea(app.MainUIFigure);
            app.FanspeedrpmTextArea.Editable = 'off';
            app.FanspeedrpmTextArea.Position = [1049 617 56 28];

            % Create ResultTextAreaLabel
            app.ResultTextAreaLabel = uilabel(app.MainUIFigure);
            app.ResultTextAreaLabel.HorizontalAlignment = 'right';
            app.ResultTextAreaLabel.Position = [744 110 40 15];
            app.ResultTextAreaLabel.Text = 'Result';

            % Create ResultTextArea
            app.ResultTextArea = uitextarea(app.MainUIFigure);
            app.ResultTextArea.Editable = 'off';
            app.ResultTextArea.HorizontalAlignment = 'center';
            app.ResultTextArea.FontSize = 48;
            app.ResultTextArea.BackgroundColor = [0.8 0.8 0.8];
            app.ResultTextArea.Position = [749 45 464 60];
            app.ResultTextArea.Value = {'01234567'};

            % Create CPUCoresDropDownLabel
            app.CPUCoresDropDownLabel = uilabel(app.MainUIFigure);
            app.CPUCoresDropDownLabel.HorizontalAlignment = 'right';
            app.CPUCoresDropDownLabel.Position = [1061 737 66 15];
            app.CPUCoresDropDownLabel.Text = 'CPU Cores';

            % Create CPUCoresDropDown
            app.CPUCoresDropDown = uidropdown(app.MainUIFigure);
            app.CPUCoresDropDown.Items = {'1', '2', '3', '4'};
            app.CPUCoresDropDown.Position = [1141 733 46 22];
            app.CPUCoresDropDown.Value = '1';

            % Create AdvancedsettingsLabel
            app.AdvancedsettingsLabel = uilabel(app.MainUIFigure);
            app.AdvancedsettingsLabel.VerticalAlignment = 'center';
            app.AdvancedsettingsLabel.Position = [761 895 190 20];
            app.AdvancedsettingsLabel.Text = 'Advanced settings';

            % Create UIAxes_cpu1
            app.UIAxes_cpu1 = uiaxes(app.MainUIFigure);
            title(app.UIAxes_cpu1, 'CPU 1')
            ylabel(app.UIAxes_cpu1, 'Y')
            app.UIAxes_cpu1.XLim = [0 Inf];
            app.UIAxes_cpu1.YLim = [0 100];
            app.UIAxes_cpu1.Box = 'on';
            app.UIAxes_cpu1.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_cpu1.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_cpu1.XGrid = 'on';
            app.UIAxes_cpu1.YGrid = 'on';
            app.UIAxes_cpu1.Position = [31 455 320 170];

            % Create UIAxes_cpu2
            app.UIAxes_cpu2 = uiaxes(app.MainUIFigure);
            title(app.UIAxes_cpu2, 'CPU 2')
            ylabel(app.UIAxes_cpu2, 'Y')
            app.UIAxes_cpu2.XLim = [0 Inf];
            app.UIAxes_cpu2.YLim = [0 100];
            app.UIAxes_cpu2.Box = 'on';
            app.UIAxes_cpu2.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_cpu2.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_cpu2.XGrid = 'on';
            app.UIAxes_cpu2.YGrid = 'on';
            app.UIAxes_cpu2.Position = [31 255 320 170];

            % Create UIAxes_cpu3
            app.UIAxes_cpu3 = uiaxes(app.MainUIFigure);
            title(app.UIAxes_cpu3, 'CPU 3')
            ylabel(app.UIAxes_cpu3, 'Y')
            app.UIAxes_cpu3.XLim = [0 Inf];
            app.UIAxes_cpu3.YLim = [0 100];
            app.UIAxes_cpu3.Box = 'on';
            app.UIAxes_cpu3.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_cpu3.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_cpu3.XGrid = 'on';
            app.UIAxes_cpu3.YGrid = 'on';
            app.UIAxes_cpu3.Position = [391 455 320 170];

            % Create UIAxes_cpu4
            app.UIAxes_cpu4 = uiaxes(app.MainUIFigure);
            title(app.UIAxes_cpu4, 'CPU 4')
            ylabel(app.UIAxes_cpu4, 'Y')
            app.UIAxes_cpu4.XLim = [0 Inf];
            app.UIAxes_cpu4.YLim = [0 100];
            app.UIAxes_cpu4.Box = 'on';
            app.UIAxes_cpu4.XTickLabel = {'0'; '0.2'; '0.4'; '0.6'; '0.8'; '1'};
            app.UIAxes_cpu4.YTick = [0 10 20 30 40 50 60 70 80 90 100];
            app.UIAxes_cpu4.XGrid = 'on';
            app.UIAxes_cpu4.YGrid = 'on';
            app.UIAxes_cpu4.Position = [391 255 320 170];
        end
    end

    methods (Access = public)

        % Construct app
        function app = userInterface

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MainUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MainUIFigure)
        end
    end
end