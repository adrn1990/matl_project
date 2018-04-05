classdef userInterface < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        BruteforceToolLabel     matlab.ui.control.Label
        PasswordEditFieldLabel  matlab.ui.control.Label
        PasswordEditField       matlab.ui.control.EditField
        UIAxes                  matlab.ui.control.UIAxes
        STARTBruteforceButton   matlab.ui.control.Button
        TextAreaLabel           matlab.ui.control.Label
        TextArea                matlab.ui.control.TextArea
    end

    
    methods (Access = private)
    
        function results = BruteProgress(app)
            
        end
        
    end


    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.PasswordEditField.Value = '--Type a password--';
            app.PasswordEditField.FontAngle = 'italic';
            app.STARTBruteforceButton.Enable = 'off';
            state = 0;
        end

        % Button pushed function: STARTBruteforceButton
        function STARTBruteforceButtonPushed(app, event)
            app.PasswordEditField.Value = 'Button pressed!'
        end

        % Value changed function: PasswordEditField
        function PasswordEditFieldValueChanged(app, event)
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
                    app.TextArea.Value = 'initializing the application \n'
                    pause(5);
                    
                case waiting
                    
                case processing
            
                case aborting

            end
            
            
            if waitforbuttonpress == 0
                app.PasswordEditField.Value = '';
            end
            errordlg('Das Matlab regt mi sooo uf..!');
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create BruteforceToolLabel
            app.BruteforceToolLabel = uilabel(app.UIFigure);
            app.BruteforceToolLabel.FontSize = 20;
            app.BruteforceToolLabel.FontWeight = 'bold';
            app.BruteforceToolLabel.Position = [41 432 158 26];
            app.BruteforceToolLabel.Text = 'Brute force Tool';

            % Create PasswordEditFieldLabel
            app.PasswordEditFieldLabel = uilabel(app.UIFigure);
            app.PasswordEditFieldLabel.HorizontalAlignment = 'right';
            app.PasswordEditFieldLabel.Position = [34 351 58 15];
            app.PasswordEditFieldLabel.Text = 'Password';

            % Create PasswordEditField
            app.PasswordEditField = uieditfield(app.UIFigure, 'text');
            app.PasswordEditField.ValueChangedFcn = createCallbackFcn(app, @PasswordEditFieldValueChanged, true);
            app.PasswordEditField.Position = [107 347 156 22];

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'GPU')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Box = 'on';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [320 41 300 185];

            % Create STARTBruteforceButton
            app.STARTBruteforceButton = uibutton(app.UIFigure, 'push');
            app.STARTBruteforceButton.ButtonPushedFcn = createCallbackFcn(app, @STARTBruteforceButtonPushed, true);
            app.STARTBruteforceButton.Position = [328 347 116 22];
            app.STARTBruteforceButton.Text = 'START Brute force';

            % Create TextAreaLabel
            app.TextAreaLabel = uilabel(app.UIFigure);
            app.TextAreaLabel.HorizontalAlignment = 'right';
            app.TextAreaLabel.Position = [22 209 56 15];
            app.TextAreaLabel.Text = 'Text Area';

            % Create TextArea
            app.TextArea = uitextarea(app.UIFigure);
            app.TextArea.Position = [92 62 193 164];
        end
    end

    methods (Access = public)

        % Construct app
        function app = userInterface

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end