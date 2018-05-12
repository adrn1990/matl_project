function info = displayData
time = 1:60;
value = zeros(1,60);
figure(1);


data = [time;value];

for index = 1:60
    data(2:index) = index+2;
    xlim([0 60]);
    plot(data(1,index),data(2,index));
    set(gca,'XDir','reverse');
    pause(0.5)
end



end