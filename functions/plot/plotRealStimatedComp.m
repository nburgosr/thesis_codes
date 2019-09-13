function plotRealStimatedComp(currentFigure,userIndex,userSignal,stimatedSignal,timeArray,varargin)

timeArray = timeArray*1e9;
figure(currentFigure)
subplot(3,1,1)
plot(timeArray,userSignal)
xlim([timeArray(1) timeArray(end)])
ylim([-2 2])
ax = gca; % current axes
ax.FontSize = 13;
title(sprintf('Señal deseada usuario %d',userIndex))
xlabel('Tiempo [ns]')
ylabel('Amplitud')

subplot(3,1,2)
plot(timeArray,stimatedSignal)
xlim([timeArray(1) timeArray(end)])
ylim([-2 2])
ax = gca; % current axes
ax.FontSize = 13;
title(sprintf('Señal estimada recibida usuario %d',userIndex))
xlabel('Tiempo [ns]')
ylabel('Amplitud')

error = userSignal-stimatedSignal;
subplot(3,1,3)
plot(timeArray,error)
xlim([timeArray(1) timeArray(end)])
ylim([-2 2])
% ylim([min(error) max(error)])
ax = gca; % current axes
ax.FontSize = 13;
title(sprintf('Error entre señales usuario %d',userIndex))
xlabel('Tiempo [ns]')
ylabel('Amplitud')

end