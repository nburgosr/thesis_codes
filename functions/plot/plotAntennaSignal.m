function plotAntennaSignal(currentFigure,nAntennas,antennaIndex,antennaSignal,timeArray)

figure(currentFigure)
subplot(nAntennas,1,antennaIndex)
plot(timeArray,antennaSignal)
xlim([timeArray(1) timeArray(end)])
ylim([min(antennaSignal) max(antennaSignal)])
ax = gca; % current axes
ax.FontSize = 13;
legend({sprintf('Señal de antena %d',antennaIndex)},...
    'FontSize',13,...
    'Location','northwest');
xlabel('Tiempo [s]')
ylabel('Amplitud')

end