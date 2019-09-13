function plotAntennaSignalV2(currentFigure,nAntennas,antennaIndex,antennaSignal,timeArray,varargin)

timeArray = timeArray*1e9;
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
xlabel('Tiempo [ns]')
ylabel('Amplitud')

p = inputParser;
addOptional(p,'Title','NULL');
parse(p,varargin{:});

if ~strcmp(p.Results.Title,'NULL')
    title(p.Results.Title);
end

end