function info = displayData
time = 1:0.1:60;
value = 3*time+5;

obj= figure;
plot(time ,value);
obj.Children.YAxis.Limits = [0 5000];
obj.Children.YAxis.LimitsMode = 'manual';
data = [time;value];

for index = 1:60
    obj.Children.Children.YData= value+index^2; 
    pause(0.5)
end



end
