function info = displayData
time = 1;
value = 0;


obj= figure;
plot(time ,value);
obj.Children.YAxis.Limits = [0 100];
obj.Children.XAxis.Limits = [0 60];
obj.Children.YAxis.LimitsMode = 'manual';
obj.Children.XAxis.Direction = 'reverse';

for index = 1:60
    value(end+1) = index^1.5;
    time(end+1) = time(end)+1;
    obj.Children.Children.YData= value;
    obj.Children.Children.XData= time;
    pause(0.5)
end



end
